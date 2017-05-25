///
///  @file
///  WSTicks.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 12.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSTicks.h"


@implementation WSTicks

@synthesize ticksStyle = _ticksStyle;
@synthesize ticksDir = _ticksDir;
@synthesize minorTicksNum = _minorTicksNum;
@synthesize ticksPosD = _ticksPosD;
@synthesize minorTicksPosD = _minorTicksPosD;
@synthesize labelString = _labelString;
@synthesize majorTicksLen = _majorTicksLen;
@synthesize minorTicksLen = _minorTicksLen;
@synthesize labelOffset = _labelOffset;


- (id)init {
    self = [super init];
    if (self) {
        _ticksStyle = kTicksNone;
        _ticksDir = kTDirectionIn;
        _minorTicksNum = 1;
        _ticksPosD = [NSMutableArray arrayWithCapacity:0];
        _minorTicksPosD = [NSMutableArray arrayWithCapacity:0];
        _labelString = [NSMutableArray arrayWithCapacity:0];
        [_ticksPosD retain];
        [_minorTicksPosD retain];
        [_labelString retain];
        _majorTicksLen = kMajorTicksLen;
        _minorTicksLen = kMinorTicksLen;       
        _labelOffset = kLabelOffset;
    }
    return self;
}


#pragma mark -

- (NSUInteger)count {
    return [[self ticksPosD] count];
}

- (NSUInteger)countMinor {
    return [[self minorTicksPosD] count];
}

- (NAFloat)tickAtIndex:(NSUInteger)i {
    return [[[self ticksPosD] objectAtIndex:i] floatValue];
}

- (NAFloat)minorTickAtIndex:(NSUInteger)i {
    return [[[self minorTicksPosD] objectAtIndex:i] floatValue];
}

- (NSString *)labelAtIndex:(NSUInteger)i {
    return [[self labelString] objectAtIndex:i];
}

- (void)autoTicksWithRange:(NARange)aRange withNumber:(NAFloat)labelNum {
    NSParameterAssert([self minorTicksNum] >= 0);
    NSParameterAssert(NARangeLen(aRange) > 0.0);
    NSParameterAssert(labelNum > 0.0);
    
    NSUInteger i, j;
    NSUInteger iLNum = (NSUInteger)floor(labelNum);
    NAFloat majorTickIncrD = NARangeLen(aRange) / labelNum;
    NAFloat majorTickStartD = aRange.rMin + majorTickIncrD;
    NAFloat minorTickIncrD = majorTickIncrD / (NAFloat)([self minorTicksNum]+1);

    /* Reset the current tick information. */
    [[self ticksPosD] removeAllObjects];
    [[self minorTicksPosD] removeAllObjects];
    [[self labelString] removeAllObjects];
    
    NAFloat posD = majorTickStartD;
    for (i=0; i<iLNum; i++) {

        /* Fill in the information for the major ticks. */
        [[self ticksPosD] addObject:[NSNumber numberWithFloat:posD]];
        [[self labelString] addObject:@""];

        /* Now fill in minor ticks between the major ones.
           (Do not go beyond the last entry.) */
        if (i < (iLNum-1)) {
            for (j=0; j<[self minorTicksNum]; j++) {
                posD += minorTickIncrD;
                [[self minorTicksPosD] addObject:[NSNumber numberWithFloat:posD]];
            }
        }
        posD += minorTickIncrD;
    }    
}

- (void)ticksWithNumbers:(NSArray *)positions {
    NSUInteger i, j;

    /* Assign major tick positions. */
    [[self minorTicksPosD] removeAllObjects];
    [[self ticksPosD] removeAllObjects];
    [[self ticksPosD] addObjectsFromArray:positions];
    
    /* Assign appropriate tick labels. */
    [[self labelString] removeAllObjects];
    for (i=0; i<[self count]; i++) {
        [[self labelString] addObject:@""];
    }
    
    /* Finally fill in appropriate minor ticks. */
    if ([self count] > 1) {
        for (i=0; i<([self count]-1); i++) {
            NAFloat pos = [[positions objectAtIndex:i] floatValue];
            NAFloat dist = (([[positions objectAtIndex:(i+1)] floatValue] - pos) /
                            ((NAFloat)[self minorTicksNum] + 1));
            for (j=0; j<[self minorTicksNum]; j++) {
                pos += dist;
                [[self minorTicksPosD] addObject:[NSNumber numberWithFloat:pos]];
            }
        }
    }
}

- (void)ticksWithNumbers:(NSArray *)positions
              withLabels:(NSArray *)labels {
    NSParameterAssert([positions count] == [labels count]);

    [self ticksWithNumbers:positions];
    [[self labelString] removeAllObjects];
    [[self labelString] addObjectsFromArray:labels];
}


- (void)setTickLabels {
    [self setTickLabelsWithStyle:NSNumberFormatterDecimalStyle];
}

- (void)setTickLabelsWithStyle:(NSNumberFormatterStyle)style {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:style];
    [self setTickLabelsWithFormatter:formatter];
    [formatter release];
    formatter = nil;
}

- (void)setTickLabelsWithFormatter:(NSNumberFormatter *)formatter {
    NSUInteger i;
    
    /* Set major ticks labels using a given formatter. */
    for (i=0; i<[self count]; i++) {
        [[self labelString] 
         replaceObjectAtIndex:i
         withObject:[formatter
                     stringFromNumber:[NSNumber
                                       numberWithFloat:[self tickAtIndex:i]]]];
    }
}

- (void)setTickLabelsWithStrings:(NSArray *)strings {
    NSUInteger i;
    NSMutableArray *positions = [NSMutableArray array];
    
    for (i=0; i<[strings count]; i++) {
        [positions addObject:[NSNumber numberWithInt:i]];
    }
    [self ticksWithNumbers:positions withLabels:strings];
}


#pragma mark -

- (NSString *)description {
    NSMutableString *prtCont = [NSMutableString
                                stringWithFormat:@"%@, %d major and %d minor.",
                                [self class],
                                [self count],
                                [self countMinor]];
    
    return [NSString stringWithString:prtCont]; 
}

- (void)dealloc {
    [_ticksPosD release];
    [_minorTicksPosD release];
    [_labelString release];
    _ticksPosD = nil;
    _minorTicksPosD = nil;
    _labelString = nil;
    
    [super dealloc];
}

@end
