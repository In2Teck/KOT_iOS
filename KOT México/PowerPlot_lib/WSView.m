///
///  @file
///  WSView.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSView.h"


@implementation WSView

@synthesize thisVersion = _thisVersion;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _thisVersion = [[WSVersion alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSString *)version {
    return [[self thisVersion] version];
}

- (void)dealloc {
    [_thisVersion release];
    _thisVersion = nil;
    
    [super dealloc];
}

@end
