///
///  @file
///  WSPlotData.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 26.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotData.h"
#import "WSDatum.h"
#import "WSData.h"
#import "WSBarProperties.h"


@implementation WSPlotData

@synthesize symbolStyle, symbolSize, symbolColor,
            errorStyle, errorBarColor, errorBarLen, errorBarWidth,
            lineWidth, lineColor, fillColor,
            lineStyle, dashStyle, intStyle, fillGradient,
            hasShadow, shadowScale, shadowColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Setup reasonable default values.
        symbolStyle = kSymbolDisk;
        symbolSize = kSymbolSize;
        symbolColor = [[UIColor blackColor] retain];
        errorStyle = kErrorNone;
        errorBarColor = [[UIColor blackColor] retain];
        errorBarLen = kErrorBarLen;
        errorBarWidth = kErrorBarWdith;
        lineStyle = kLineRegular;
        dashStyle = kDashingSolid;
        intStyle = kInterpolationStraight;
        lineWidth = kLineWidth;
        lineColor = [[UIColor blueColor] retain];
        fillColor = [[UIColor grayColor] retain];
        NAFloat locs[2];
        CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
        NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];
        UIColor *aColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
        [myColors addObject:(id)[aColor CGColor]];
        locs[0] = 0.0;
        aColor = [UIColor colorWithRed:0.7 green:0.85 blue:0.7 alpha:1.0];
        [myColors addObject:(id)[aColor CGColor]];
        locs[1] = 1.0;
        fillGradient = CGGradientCreateWithColors(mySpace, (CFArrayRef)myColors, locs);
        CGColorSpaceRelease(mySpace);
        hasShadow = NO;
        shadowScale = kShadowScale;
        shadowColor = [[UIColor blackColor] retain];
    }
    return self;
}

- (BOOL)hasData {
    // Return YES if a subclass can plot (or otherwise handle) data.
    return YES;
}


#pragma mark -
#pragma mark Plot handling

- (void)setAllDisplaysOff {
    // Override this method if a plots presents something on the canvas.
    // Reset the chart to use only no-display parameters in all customizable values.
    [self setSymbolStyle:kSymbolNone];
    [self setErrorStyle:kErrorNone];
    [self setLineStyle:kLineNone];
    [self setIntStyle:kInterpolationStraight];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    NAFloat centerX, centerY,
            errorMinX, errorMaxX, errorMinY, errorMaxY;
    NSInteger cpNum = 0;
    CGPoint *interpol1,
            *interpol2;
    WSDatum *extrPointD;
    

    // Order matters for x-values. 
    WSData *sortedD = [[self dataD] sortedDataUsingValueX];
    [sortedD retain];
    
    // Compute Bezier spline interpolation points if necessary.
    switch (self.intStyle) {
        case kInterpolationNone:
        case kInterpolationStraight:
            cpNum = 0;
            break;

        case kInterpolationSpline: {
            CGPoint *source;
            NSInteger len = [sortedD count];
            
            source = (CGPoint *)malloc(len * sizeof(CGPoint));
            interpol1 = (CGPoint *)malloc(len * sizeof(CGPoint));
            interpol2 = (CGPoint *)malloc(len * sizeof(CGPoint));
            NSAssert(source != NULL, @"Severe allocation error!");
            NSAssert(interpol1 != NULL, @"Severe allocation error!");
            NSAssert(interpol2 != NULL, @"Severe allocation error!");
            for (NSUInteger i=0; i<len; i++) {
                source[i] = CGPointMake([self boundsWithDataX:[[sortedD dataAtIndex:i]
                                                               valueX]], 
                                        [self boundsWithDataY:[[sortedD dataAtIndex:i]
                                                               valueY]]);
            }
            cpNum = NABezierControlPoints(len, source, &interpol1, &interpol2);
            free(source);
        }
        
        default:
            break;
    }
    
    // First, draw the filling below the line connecting the data.
    CGContextSaveGState(myContext);
    [[self fillColor] set];
    if (([self lineStyle] == kLineFilledColor) ||
        ([self lineStyle] == kLineFilledGradient)) {
        // Close the line to draw a polygon that can be filled with
        // a color or a gradient.
        if ([sortedD count] > 0) {
            CGContextBeginPath(myContext);
            extrPointD = [sortedD rightMostData];
            centerX = [self boundsWithDataX:[extrPointD valueX]];
            centerY = [self boundsWithDataY:[extrPointD valueY]];
            NAFloat aLocY;
            if ([self aLocYD]) {
                aLocY = [self boundsWithDataY:[[self aLocYD] floatValue]];
            } else {
                aLocY = [self axisLocationY];
            }
            CGContextMoveToPoint(myContext, centerX, centerY);
            CGContextAddLineToPoint(myContext,
                                    centerX,
                                    aLocY);
            extrPointD = [sortedD leftMostData];
            centerX = [self boundsWithDataX:[extrPointD valueX]];
            centerY = [self boundsWithDataY:[extrPointD valueY]];
            CGContextAddLineToPoint(myContext,
                                    centerX,
                                    aLocY);
            CGContextAddLineToPoint(myContext, centerX, centerY);
            WSDatum *pointD;
            for (NSUInteger i=1; i<[sortedD count]; i++) {
                pointD = [sortedD dataAtIndex:i];
                centerX = [self boundsWithDataX:[pointD valueX]];
                centerY = [self boundsWithDataY:[pointD value]];
                switch (self.intStyle) {
                    case kInterpolationNone:
                    case kInterpolationStraight:
                        CGContextAddLineToPoint(myContext, centerX, centerY);
                        break;
                        
                    case kInterpolationSpline:
                        CGContextAddCurveToPoint(myContext, 
                                                 interpol1[i-1].x, 
                                                 interpol1[i-1].y, 
                                                 interpol2[i-1].x, 
                                                 interpol2[i-1].y, 
                                                 centerX, 
                                                 centerY);
    
                    default:
                        break;
                }
            }
            switch ([self lineStyle]) {
                case kLineFilledColor:
                    CGContextDrawPath(myContext, kCGPathFillStroke);
                    break;            
                case kLineFilledGradient:
                    CGContextClip(myContext);
                    CGContextDrawLinearGradient(myContext,
                                                fillGradient,
                                                CGPointMake([self bounds].origin.x +
                                                            [self bounds].size.width/2,
                                                            [self bounds].origin.y),
                                                CGPointMake([self bounds].origin.x +
                                                            [self bounds].size.width/2,
                                                            [self bounds].origin.y +
                                                            [self bounds].size.height),
                                                0);
                    break;
                default:
                    break;
            }
        }
    }
    
    // Next, draw the line connecting the data itself.
    if ([self hasShadow]) {
        NAFloat scale = [self shadowScale];
        CGContextSetShadowWithColor(myContext,
                                    CGSizeMake(scale, scale),
                                    scale,
                                    [[self shadowColor] CGColor]);
    }
    if ([self lineStyle] != kLineNone) {
        // First, configure the path.
        [[self lineColor] set];
        CGContextSetLineWidth(myContext, [self lineWidth]);
        CGContextSetLineJoin(myContext, kCGLineJoinRound);
        NAContextSetLineDash(myContext, [self dashStyle]);
        if ([self hasShadow]) {
            NAFloat scale = [self shadowScale];
            CGContextSetShadowWithColor(myContext,
                                        CGSizeMake(scale, scale),
                                        scale,
                                        [[self shadowColor] CGColor]);
        }

        // Draw the line connecting the data.
        CGContextBeginPath(myContext);
        if ([sortedD count] > 0) {
            centerX = [self boundsWithDataX:[sortedD valueXAtIndex:0]];
            centerY = [self boundsWithDataY:[sortedD valueAtIndex:0]];
            CGContextMoveToPoint(myContext, centerX, centerY);
        }
        WSDatum *pointD;
        for (NSUInteger i=1; i<[sortedD count]; i++) {
            pointD = [sortedD dataAtIndex:i];
            centerX = [self boundsWithDataX:[pointD valueX]];
            centerY = [self boundsWithDataY:[pointD value]];
            switch (self.intStyle) {
                case kInterpolationNone:
                case kInterpolationStraight:
                    CGContextAddLineToPoint(myContext, centerX, centerY);
                    break;
                    
                case kInterpolationSpline:
                    CGContextAddCurveToPoint(myContext, 
                                             interpol1[i-1].x, 
                                             interpol1[i-1].y, 
                                             interpol2[i-1].x, 
                                             interpol2[i-1].y, 
                                             centerX, 
                                             centerY);
                    
                default:
                    break;
            }
        }
        CGContextDrawPath(myContext, kCGPathStroke);
    }
    [sortedD release];
    sortedD = nil;
    
    // Next, draw the error bars.
    [[self errorBarColor] set];
    CGContextSetLineWidth(myContext, [self errorBarWidth]);
    NAContextSetLineDash(myContext, kDashingSolid);
    if ([self hasShadow]) {
        NAFloat scale = [self shadowScale];
        CGContextSetShadowWithColor(myContext,
                                    CGSizeMake(scale, scale),
                                    scale,
                                    [[self shadowColor] CGColor]);
    }
    CGContextBeginPath(myContext);
    for (WSDatum *pointD in [self dataD]) {
        // Compute the central values and error bars in bounds coordinates.
        centerX = [self boundsWithDataX:[pointD valueX]];
        centerY = [self boundsWithDataY:[pointD value]];
        errorMinX = -1.0;
        errorMaxX = -1.0;
        errorMinY = -1.0;
        errorMaxY = -1.0;
        if ([pointD hasErrorX]) {
            // Note: By convention, if "errorMinX" exists, so will "errorMaxX".
            errorMinX = [self boundsWithDataX:([pointD valueX] - [pointD errorMinX])];
            errorMaxX = [self boundsWithDataX:([pointD valueX] + [pointD errorMaxX])];
        }
        if ([pointD hasErrorY]) {
            // Note: By convention, if "errorMinY" exists, so will "errorMaxY".
            errorMinY = [self boundsWithDataY:([pointD value] - [pointD errorMinY])];
            errorMaxY = [self boundsWithDataY:([pointD value] + [pointD errorMaxY])];
        }

        // Accumulate the different error bar features.
        switch ([self errorStyle]) {
            case kErrorNone:
                break;
            case kErrorXYCapped:
                // This draws the caps for X error bars.
                if (errorMinX > 0) {
                    CGContextMoveToPoint(myContext, errorMinX, centerY-[self errorBarLen]);
                    CGContextAddLineToPoint(myContext, errorMinX, centerY+[self errorBarLen]);
                    CGContextMoveToPoint(myContext, errorMaxX, centerY-[self errorBarLen]);
                    CGContextAddLineToPoint(myContext, errorMaxX, centerY+[self errorBarLen]);
                }
            case kErrorYCapped:
                // This draws the caps for the Y error bars.
                if (errorMinY > 0) {
                    CGContextMoveToPoint(myContext, centerX-[self errorBarLen], errorMinY);
                    CGContextAddLineToPoint(myContext, centerX+[self errorBarLen], errorMinY);
                    CGContextMoveToPoint(myContext, centerX-[self errorBarLen], errorMaxY);
                    CGContextAddLineToPoint(myContext, centerX+[self errorBarLen], errorMaxY);
                }
            case kErrorXYFlat:
                // This draws the X error bar.
                if (errorMinX > 0) {
                    CGContextMoveToPoint(myContext, errorMinX, centerY);
                    CGContextAddLineToPoint(myContext, errorMaxX, centerY);
                }
            case kErrorYFlat:
                // This draws the Y error bar.
                if (errorMinY > 0) {
                    CGContextMoveToPoint(myContext, centerX, errorMinY);
                    CGContextAddLineToPoint(myContext, centerX, errorMaxY);
                }
            default:
                break;
        }
    }
    CGContextDrawPath(myContext, kCGPathStroke);

    // Finally, draw the symbols at the data points.
    [[self symbolColor] set];
    for (WSDatum *pointD in [self dataD]) {
        centerX = [self boundsWithDataX:[pointD valueX]];
        centerY = [self boundsWithDataY:[pointD value]];
        NAContextAddSymbol(myContext,
                           [self symbolStyle],
                           CGPointMake(centerX, centerY),
                           [self symbolSize]);
    }
    CGContextRestoreGState(myContext);
    
    // Free interpolation if needed.
    if (cpNum > 0) {
        free(interpol1);
        free(interpol2);
    }
}
    

#pragma mark Plot configuration

- (void)setFillGradientFromColor:(UIColor *)color1
                         toColor:(UIColor *)color2 {
    NAFloat locs[2];
    CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];

    CGGradientRelease(fillGradient);
    [myColors addObject:(id)[color1 CGColor]];
    locs[0] = 0.0;
    [myColors addObject:(id)[color2 CGColor]];
    locs[1] = 1.0;
    fillGradient = CGGradientCreateWithColors(mySpace, (CFArrayRef)myColors, locs);
    CGColorSpaceRelease(mySpace);
}


#pragma mark -

- (void)dealloc {
    CGGradientRelease(fillGradient);
    [symbolColor release];
    [errorBarColor release];
    [lineColor release];
    [fillColor release];
    symbolColor = nil;
    errorBarColor = nil;
    lineColor = nil;
    fillColor = nil;
    
    [super dealloc];
}

@end
