///
///  @file
///  WSDatum.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 28.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSDatum.h"


/// Manual KVO notifications for the 'datum' property.
#define KVO_DATUM @"datum"


@implementation WSDatum

@synthesize datum = _datum;
@synthesize customDatum = _customDatum;
@synthesize delegate = _delegate;


+ (id)datum {
    return [[[self alloc] init] autorelease];
}

+ (id)datumWithValue:(NAFloat)aValue {
    return [[[self alloc] initWithValue:aValue]
            autorelease];
}

+ (id)datumWithValue:(NAFloat)aValue
      withAnnotation:(NSString *)anno {
    return [[[self alloc] initWithValue:aValue
                         withAnnotation:anno]
            autorelease];
}

+ (id)datumWithValue:(NAFloat)aValue
          withValueX:(NAFloat)aValueX {
    return [[[self alloc] initWithValue:aValue
                             withValueX:aValueX]
            autorelease];
}

+ (id)datumWithValue:(NAFloat)aValue
          withValueX:(NAFloat)aValueX
      withAnnotation:(NSString *)anno {
    return [[[self alloc] initWithValue:aValue
                             withValueX:aValueX
                         withAnnotation:anno]
            autorelease];
}

- (id)init {

    self = [super init];
    if (self) {
        _datum = [NSMutableDictionary dictionaryWithCapacity:0];
        [_datum retain];
        _customDatum = nil;
        _delegate = nil;
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue {

    self = [self init];
    if (self) {
        [self setValueY:aValue];
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue
     withAnnotation:(NSString *)anno {

    self = [self initWithValue:aValue];
    if (self) {
        [self setAnnotation:anno];
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue
         withValueX:(NAFloat)aValueX {

    self = [self initWithValue:aValue];
    if (self) {
        [self setValueX:aValueX];
    }
    return self;
}

- (id)initWithValue:(NAFloat)aValue
         withValueX:(NAFloat)aValueX
     withAnnotation:(NSString *)anno {
    
    self = [self initWithValue:aValue
                    withValueX:aValueX];
    if (self) {
        [self setAnnotation:anno];
    }
    return self;
}


#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[self datum] forKey:@"datum"];
    [encoder encodeObject:[self customDatum] forKey:@"custom"];
}

- initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _datum = [[decoder decodeObjectForKey:@"datum"]
                  mutableCopy];
        [self setCustomDatum:[decoder decodeObjectForKey:@"custom"]];
        [self setDelegate:nil];
    }
    return self;
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WSDatum *copy = [[[self class] allocWithZone:zone] init];
    id datumCopy = [[NSMutableDictionary alloc] initWithDictionary:[self datum]
                                                         copyItems:YES];
    [copy setDatum:datumCopy];
    id customCopy = [[self customDatum] copyWithZone:zone];
    [copy setCustomDatum:customCopy];
    [datumCopy release];
    [customCopy release];
    [copy setDelegate:[self delegate]];
    return copy;
}


#pragma mark -
#pragma mark KVO

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    BOOL automatic = NO;
    
    if ([theKey isEqualToString:KVO_DATUM]) {
        automatic = NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}


#pragma mark -

- (NAFloat)valueY {
    return [[[self datum] objectForKey:@"value"] floatValue];
}

- (NAFloat)value {
    return [self valueY];
}

- (void)setValueY:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"value"];
    [self didChangeValueForKey:KVO_DATUM];
}

- (void)setValue:(NAFloat)aValue {
    [self setValueY:aValue];
}

- (NAFloat)valueX {
    return [[[self datum] objectForKey:@"valueX"] floatValue];
}

- (void)setValueX:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"valueX"];
    [self didChangeValueForKey:KVO_DATUM];
}

- (NSString *)annotation {
    return [[self datum] objectForKey:@"annotation"];
}

- (void)setAnnotation:(NSString *)anno {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:anno
                     forKey:@"annotation"];
    [self didChangeValueForKey:KVO_DATUM];
}

- (NAFloat)errorMinX {
    return [[[self datum] objectForKey:@"errorMinX"]
            floatValue];
}

- (void)setErrorMinX:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"errorMinX"];
    [self didChangeValueForKey:KVO_DATUM];
}

- (NAFloat)errorMaxX {
    return [[[self datum] objectForKey:@"errorMaxX"]
            floatValue];
}

- (void)setErrorMaxX:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"errorMaxX"];
    [self didChangeValueForKey:KVO_DATUM];
}

- (NAFloat)errorMinY {
    return [[[self datum] objectForKey:@"errorMinY"]
            floatValue];
}

- (void)setErrorMinY:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"errorMinY"];
    [self didChangeValueForKey:KVO_DATUM];
}
          
- (NAFloat)errorMaxY {
    return [[[self datum] objectForKey:@"errorMaxY"]
            floatValue];
}

- (void)setErrorMaxY:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"errorMaxY"];
    [self didChangeValueForKey:KVO_DATUM];
}

- (BOOL)hasErrorX {
    if ([[self datum] objectForKey:@"errorMinX"]) {
        return YES;
    }
    return NO;
}

- (BOOL)hasErrorY {
    if ([[self datum] objectForKey:@"errorMinY"]) {
        return YES;
    }
    return NO;
}

- (NAFloat)errorCorr {
    return [[[self datum] objectForKey:@"errorCorr"]
            floatValue];
}

- (void)setErrorCorr:(NAFloat)aValue {
    [self willChangeValueForKey:KVO_DATUM];
    [[self datum] setObject:[NSNumber numberWithFloat:aValue]
                     forKey:@"errorCorr"];
    [self didChangeValueForKey:KVO_DATUM];
}


- (NSComparisonResult)valueXCompare:(id)aDatum {
    if ([self valueX] < [aDatum valueX]) {
        return NSOrderedAscending;
    } else {
        if ([self valueX] > [aDatum valueX]) {
            return NSOrderedDescending;
        }
    }
    return NSOrderedSame;
}


#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"WSDatum: %@",
            [[self datum] description]];
}


- (void)dealloc {
    [_datum release];
    [_customDatum release];
    _datum = nil;
    _customDatum = nil;
    _delegate = nil;
    
    [super dealloc];
}

@end
