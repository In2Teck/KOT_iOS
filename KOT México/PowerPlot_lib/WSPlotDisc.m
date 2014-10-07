///
///  @file
///  WSPlotDisc.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotDisc.h"
#import "WSData.h"
#import "WSDatum.h"


@implementation WSPlotDisc

@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;
@synthesize fillColor = _fillColor;
@synthesize style = _style;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 1.0;
        _lineColor = [[UIColor blackColor] retain];
        _fillColor = [[UIColor blueColor] retain];
        _style = kDiscPlotAll;
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
    // Override this method if a plots presents something on the canvas.
    // Reset the chart to use only no-display parameters in all customizable values.
    [self setStyle:kDiscPlotNone];
}


/*
 // Override this method if a subclass plots something to provide a
 // sample. (E.g. something that is inserted in legends etc.)
 - (void)plotSample:(CGPoint)aPoint {
 // Drawing code
 }
 */


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    
    // Plot the discs with the data from the data source delegate.
    if (([[self dataD] count] > 0) && ([self style] != kDiscPlotNone)) {
        CGContextSaveGState(myContext);
        [[self lineColor] set];
        [[self fillColor] setFill];
        for (WSDatum *pointD in [self dataD]) {
            NAFloat centerXD = [pointD valueX];
            NAFloat centerYD = [pointD valueY];
            NAFloat errorXD = fmax([pointD errorMinX], [pointD errorMaxX]);
            NAFloat errorYD = fmax([pointD errorMinY], [pointD errorMaxY]);
            if ((errorXD == 0) || (errorYD == 0)) {
                continue;
            }
            NAFloat centerX = [self boundsWithDataX:centerXD];
            NAFloat centerY = [self boundsWithDataY:centerYD];
            CGRect embed = CGRectMake(([self boundsWithDataX:(centerXD-errorXD)] -
                                       centerX),
                                      ([self boundsWithDataY:(centerYD-errorYD)] -
                                       centerY),
                                      ([self boundsWithDataX:(centerXD + errorXD)] -
                                       [self boundsWithDataX:(centerXD - errorXD)]),
                                      ([self boundsWithDataY:(centerYD + errorYD)] -
                                       [self boundsWithDataY:(centerYD - errorYD)]));
            NAFloat angle = -[pointD errorCorr]*M_PI/4.0;
            CGContextRotateCTM(myContext, angle);
            CGContextTranslateCTM(myContext,
                                  (centerX*cos(angle) + centerY*sin(angle)),
                                  (centerY*cos(angle) - centerX*sin(angle)));
            CGContextAddEllipseInRect(myContext, embed);
            CGContextDrawPath(myContext, kCGPathFillStroke);
            CGContextTranslateCTM(myContext,
                                  -(centerX*cos(angle) + centerY*sin(angle)),
                                  -(centerY*cos(angle) - centerX*sin(angle)));
            CGContextRotateCTM(myContext, -angle);
        }
        CGContextRestoreGState(myContext);
    }
}


#pragma mark -

- (void)dealloc {
    [_lineColor release];
    [_fillColor release];
    _lineColor = nil;
    _fillColor = nil;
    
    [super dealloc];
}

@end
