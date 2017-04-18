///
///  @file
///  WSPlot.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlot.h"
#import "WSData.h"
#import "WSPlotDelegate.h"
#import "WSDataDelegate.h"


@implementation WSPlot

@synthesize axisLocationX = _axisLocationX;
@synthesize axisLocationY = _axisLocationY;
@synthesize coordDelegate;
@synthesize dataDelegate;

@synthesize aLocXD = _aLocXD;
@synthesize aLocYD = _aLocYD;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _axisLocationX = kALocationX;
        _axisLocationY = kALocationY;
        [self setBackgroundColor:[UIColor clearColor]];
        
        _aLocXD = nil;
        _aLocYD = nil;
    }
    return self;
}


#pragma mark -
#pragma mark WSData delegate

- (BOOL)hasData {
    // Return YES if a subclass can plot (or otherwise handle) data.
    return NO;
}

- (NSString *)dataName {
    return [[self dataD] nameTag];
}

- (void)setDataName:(NSString *)aName {
    [[self dataD] setNameTag:aName];
}

- (WSData *)dataD {
    if ([[self dataDelegate] respondsToSelector:@selector(dataD)]) {
        return [[self dataDelegate] dataD];
    }
    return nil;
}

- (NARange)dataRangeXD {
    if ([[self dataDelegate] respondsToSelector:@selector(dataRangeXD)]) {
        return [[self dataDelegate] dataRangeXD];
    }
    return NARANGE_INVALID;
}

- (NARange)dataRangeYD {
    if ([[self dataDelegate] respondsToSelector:@selector(dataRangeYD)]) {
        return [[self dataDelegate] dataRangeYD];
    }
    return NARANGE_INVALID;
}


#pragma mark WSCoordinate delegate

- (NAFloat)boundsWithDataX:(NAFloat)aDatumD {
    if ([[self coordDelegate] respondsToSelector:@selector(boundsWithDataX:)]) {
        return [[self coordDelegate] boundsWithDataX:aDatumD];
    }
    return NAN;
}

- (NAFloat)boundsWithDataY:(NAFloat)aDatumD {
    if ([[self coordDelegate] respondsToSelector:@selector(boundsWithDataY:)]) {
        return [[self coordDelegate] boundsWithDataY:aDatumD];
    }
    return NAN;
}

- (NAFloat)dataWithBoundsX:(NAFloat)aDatum {
    if ([[self coordDelegate] respondsToSelector:@selector(dataWithBoundsX:)]) {
        return [[self coordDelegate] dataWithBoundsX:aDatum];
    }
    return NAN;    
}

- (NAFloat)dataWithBoundsY:(NAFloat)aDatum {
    if ([[self coordDelegate] respondsToSelector:@selector(dataWithBoundsY:)]) {
        return [[self coordDelegate] dataWithBoundsY:aDatum];
    }
    return NAN;    
}

- (NARange)rangeXD {
    if ([[self coordDelegate] respondsToSelector:@selector(rangeXD)]) {
        return [[self coordDelegate] rangeXD];
    }
    return NARANGE_INVALID;
}

- (NARange)rangeYD {
    if ([[self coordDelegate] respondsToSelector:@selector(rangeYD)]) {
        return [[self coordDelegate] rangeYD];
    }
    return NARANGE_INVALID;    
}

- (BOOL)invertedX {
    if ([[self dataDelegate] respondsToSelector:@selector(invertedX)]) {
        return [[self dataDelegate] invertedX];
    }
    return NO;
}

- (BOOL)invertedY {
    if ([[self dataDelegate] respondsToSelector:@selector(invertedY)]) {
        return [[self dataDelegate] invertedY];
    }
    return NO;    
}


#pragma mark -

- (void)setAxisLocationXD:(NAFloat)datum {
    [self setALocXD:[NSNumber numberWithFloat:datum]];
}

- (void)setAxisLocationYD:(NAFloat)datum {
    [self setALocYD:[NSNumber numberWithFloat:datum]];
}

- (void)unsetAxisLocationXD {
    [self setALocXD:nil];
}

- (void)unsetAxisLocationYD {
    [self setALocYD:nil];
}


#pragma mark -
#pragma mark Plotting information on screen

- (void)plotSample:(CGPoint)aPoint {
    // Override this method if a subclass plots something to provide a
    // sample. (E.g. something that is inserted in legends etc.)
}

- (void)setAllDisplaysOff {
    // Override this method if a plots presents something on the canvas.
    // Reset the chart to use only no-display parameters in all customizable values.
}  

- (void)chartSetNeedsDisplay {
    [[self superview] setNeedsDisplay];
}
    
/*
 // Only override drawRect: if you perform custom drawing.  An empty
 // implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark -

- (void)dealloc {
    [_aLocXD release];
    [_aLocYD release];
    _aLocXD = nil;
    _aLocYD = nil;
    coordDelegate = nil;
    dataDelegate = nil;
    
    [super dealloc];
}

@end
