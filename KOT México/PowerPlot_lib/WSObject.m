///
///  @file
///  WSObject.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSObject.h"


@implementation WSObject

@synthesize thisVersion = _thisVersion;


- (id)init {
    self = [super init];
    if (self) {
        _thisVersion = [[WSVersion alloc] init];
    }
    return self;
}

- (NSString *)version {
    return [[self thisVersion] version];
}

- (void)dealloc {
    [_thisVersion release];
    _thisVersion = nil;
    [super dealloc];
}

@end
