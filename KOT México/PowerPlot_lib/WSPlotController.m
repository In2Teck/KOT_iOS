///
///  @file
///  WSPlotController.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 06.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotController.h"
#import "WSCoordinate.h"
#import "WSPlotDelegate.h"
#import "WSDataDelegate.h"
#import "WSPlot.h"
#import "WSData.h"


/// Manual KVO notifications for the 'dataD.values' property.
#define KVO_VALUES @"values"


@implementation WSPlotController


@synthesize view = _view;
@synthesize coordX = _coordX;
@synthesize coordY = _coordY;
@synthesize dataD = _dataD;

@synthesize bindings = _bindings;


- (id)init {
    self = [super init];
    if (self) {
        _coordX = [[WSCoordinate alloc] init];
        _coordY = [[WSCoordinate alloc] init];
        _dataD = [[WSData alloc] init];
        [[self coordY] setInverted:YES];
        _bindings = NO;
    }
    return self;
}

- (void)setView:(id)aPlot {
    [aPlot setCoordDelegate:self];
    [aPlot setDataDelegate:self];
    AtomicRetainedSetToFrom(_view, aPlot);
}


#pragma mark -

- (void)setBindings:(BOOL)bindings {
    if (bindings == _bindings) {
        return;
    } else {
        _bindings = bindings;
        
        if (bindings == YES) {
            [[self dataD] addObserver:self
                           forKeyPath:KVO_VALUES
                              options:0
                              context:NULL];
        } else {
            [[self dataD] removeObserver:self
                              forKeyPath:KVO_VALUES
                                 context:NULL];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self dataDidUpdate];
}


#pragma mark -
#pragma mark WSPlotDelegate

- (NARange)rangeXD {
    return [[self coordX] coordRangeD];
}

- (NARange)rangeYD {
    return [[self coordY] coordRangeD];
}

- (void)setRangeXD:(NARange)rangeXD {
    [[self coordX] setCoordRangeD:rangeXD];    
}

- (void)setRangeYD:(NARange)rangeYD {
    [[self coordY] setCoordRangeD:rangeYD];    
}

- (void)setCoordinateScaleX:(WSCoordinateScale)scaleX
                     scaleY:(WSCoordinateScale)scaleY {
    [[self coordX] setCoordScale:scaleX];
    [[self coordY] setCoordScale:scaleY];
}

- (BOOL)invertedX {
    return [[self coordX] inverted];
}

- (BOOL)invertedY {
    return [[self coordY] inverted];
}


- (CGFloat)boundsWithDataX:(CGFloat)aDatumD {
    return [[self coordX] transformData:aDatumD
                               withSize:[[self view] bounds].size.width];
}

- (CGFloat)boundsWithDataY:(CGFloat)aDatumD {
    return [[self coordY] transformData:aDatumD
                               withSize:[[self view] bounds].size.height];    
}

- (NAFloat)dataWithBoundsX:(NAFloat)aDatum {
    return [[self coordX] transformBounds:aDatum
                                 withSize:[[self view] bounds].size.width];
}

- (NAFloat)dataWithBoundsY:(NAFloat)aDatum {
    return [[self coordY] transformBounds:aDatum
                                 withSize:[[self view] bounds].size.height];
}


#pragma mark WSDataDelegate

- (NARange)dataRangeXD {
    if ([[self view] hasData])
        return NARangeMake([[self dataD] minimumValueX],
                           [[self dataD] maximumValueX]);
    else
        return NARANGE_INVALID;
}

- (NARange)dataRangeYD {
    if ([[self view] hasData])
        return NARangeMake([[self dataD] minimumValue],
                           [[self dataD] maximumValue]);
    else
        return NARANGE_INVALID;
}

- (void)dataDidUpdate {
    if ([[self view] respondsToSelector:@selector(chartSetNeedsDisplay)]) {
        [[self view] chartSetNeedsDisplay];
    }
}


#pragma mark -

- (NSString *)description {
    
    return [NSString
            stringWithFormat:@"%@<%@>, coordX: (%@), "
                @"coordY: (%@), data set: (%@)",
            [self class],
            [[self view] class],
            [[self coordX] description],
            [[self coordY] description],
            [[self dataD] description]];
}

- (void)dealloc {
    if (self.bindings == YES) {
        [[self dataD] removeObserver:self
                          forKeyPath:KVO_VALUES
                             context:NULL];
    }

    [_coordX release];
    [_coordY release];
    [_dataD release];
    _coordX = nil;
    _coordY = nil;
    _dataD = nil;
    
    [super dealloc];
}

@end
