///
///  @file
///  WSPlotBar.m
///  WSplot
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotBar.h"
#import "WSBarProperties.h"
#import "WSData.h"
#import "WSDatum.h"


@implementation WSPlotBar

@synthesize style = _style;
@synthesize barDefault = _barDefault;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _style = kBarPlotUnified;
        _barDefault = [[WSBarProperties alloc] init];
    }
    return self;
}

// Return YES if a subclass can plot (or otherwise handle) data.
// Otherwise, WSPlot returns NO.
- (BOOL)hasData {
    return YES;
}


#pragma mark -
#pragma mark Plot handling

- (void)setAllDisplaysOff {
    [self setStyle:kBarPlotNone];
    [[self barDefault] setStyle:kBarNone];
}

/*
 // Override this method if a subclass plots something to provide a
 // sample. (E.g. something that is inserted in legends etc.)
 - (void)plotSample:(CGPoint)aPoint {
 // Drawing code
 }
 */


- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    WSBarProperties *current = [self barDefault];
    NAFloat centerX, topY;
    NAFloat aLocY;
    NAFloat locs[2];
    locs[0] = 0.0;
    locs[1] = 1.0;

    
    if ([self style] == kBarPlotNone) {
        return;
    }

    // Set the axis location.
    if ([self aLocYD]) {
        aLocY = [self boundsWithDataY:[[self aLocYD] floatValue]];
    } else {
        aLocY = [self axisLocationY];
    }

    // Remove previous labels (if any).
    for (UIView* label in [self subviews]) {
        [label removeFromSuperview];
    }
        
    // Loop over all data points.
    for (WSDatum *item in [self dataD]) {
        centerX = [self boundsWithDataX:[item valueX]];
        topY = [self boundsWithDataY:[item valueY]];
        switch ([self style]) {
            case kBarPlotNone:
            case kBarPlotUnified:
                break;
            case kBarPlotIndividual:
                if ([[item customDatum] isKindOfClass:[[self barDefault] class]]) {
                    current = [item customDatum];
                } else {
                    current = [self barDefault];
                }
                break;
            default:
                break;
        }
        
        // Draw the bar solid/gradient fill (if needed).
        switch ([current style]) {
            case kBarOutline:
                break;
            case kBarFilled:
                CGContextSaveGState(myContext);
                if ([current hasShadow]) {
                    NAFloat scale = [current shadowScale];
                    CGContextSetShadowWithColor(myContext,
                                                CGSizeMake(scale, scale),
                                                scale,
                                                [[current shadowColor] CGColor]);
                }
                CGContextBeginPath(myContext);
                [[current barColor] set];
                CGContextSetLineWidth(myContext, [current outlineStroke]);
                CGContextMoveToPoint(myContext,
                                     centerX - ([current barWidth]/2.0),
                                     aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        topY);
                CGContextAddLineToPoint(myContext, 
                                        centerX + ([current barWidth]/2.0), 
                                        topY);
                CGContextAddLineToPoint(myContext,
                                        centerX + ([current barWidth]/2.0),
                                        aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        aLocY);
                CGContextDrawPath(myContext, kCGPathFill);
                CGContextRestoreGState(myContext);
                break;
            case kBarGradient:
                CGContextSaveGState(myContext);
                CGColorSpaceRef mySpace = CGColorSpaceCreateDeviceRGB();
                NSMutableArray *myColors = [NSMutableArray arrayWithCapacity:2];
                [myColors addObject:(id)[[current barColor] CGColor]];
                [myColors addObject:(id)[[current barColor2] CGColor]];
                CGGradientRef fillGradient = CGGradientCreateWithColors(mySpace,
                                                                        (CFArrayRef)myColors,
                                                                        locs);
                CGContextBeginPath(myContext);
                CGContextSetLineWidth(myContext, [current outlineStroke]);
                CGContextMoveToPoint(myContext,
                                     centerX - ([current barWidth]/2.0),
                                     aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        topY);
                CGContextAddLineToPoint(myContext, 
                                        centerX + ([current barWidth]/2.0), 
                                        topY);
                CGContextAddLineToPoint(myContext,
                                        centerX + ([current barWidth]/2.0),
                                        aLocY);
                CGContextAddLineToPoint(myContext,
                                        centerX - ([current barWidth]/2.0),
                                        aLocY);
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
                CGGradientRelease(fillGradient);   
                CGColorSpaceRelease(mySpace);
                CGContextRestoreGState(myContext);
                break;
            default:
                break;
        }
        
        // Draw the bar outline.
        CGContextBeginPath(myContext);
        [[current outlineColor] set];
        CGContextSetLineWidth(myContext, [current outlineStroke]);
        CGContextMoveToPoint(myContext,
                             centerX - ([current barWidth]/2.0),
                             aLocY);
        CGContextAddLineToPoint(myContext,
                                centerX - ([current barWidth]/2.0),
                                topY);
        CGContextAddLineToPoint(myContext, 
                                centerX + ([current barWidth]/2.0), 
                                topY);
        CGContextAddLineToPoint(myContext,
                                centerX + ([current barWidth]/2.0),
                                aLocY);
        CGContextDrawPath(myContext, kCGPathStroke);
    }
}


#pragma mark Bars configuration

- (void)setAllBarsToDefault {
    for (WSDatum *item in [self dataD]) {
        [item setCustomDatum:[[[self barDefault] copy] autorelease]];
    }
}

- (BOOL)isDistanceConsistent {
    NSUInteger i;
    NAFloat distD;
    
    if ([[self dataD] count] > 2) {
        distD = ([[self dataD] valueXAtIndex:1] -
                 [[self dataD] valueXAtIndex:0]);
        for (i=0; i<([[self dataD] count] - 1); i++) {
            NAFloat thisDistD = ([[self dataD] valueXAtIndex:i+1] -
                                 [[self dataD] valueXAtIndex:i]);
            if (!(IS_EPSILON((distD - thisDistD)/distD))) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)widthTouchingBars {
    NAFloat dist;
    
    if ([self isDistanceConsistent]) {
        if ([[self dataD] count] > 1) {
            dist = ([self boundsWithDataX:[[self dataD] valueXAtIndex:1]] -
                    [self boundsWithDataX:[[self dataD] valueXAtIndex:0]]);
        }
        else {
            dist = [self bounds].size.width / 2.0;
        }
        [[self barDefault] setBarWidth:(dist / 2.0)];
    }
}


#pragma mark -

- (void)dealloc {
    [_barDefault release];
    _barDefault = nil;
    
    [super dealloc];
}

@end
