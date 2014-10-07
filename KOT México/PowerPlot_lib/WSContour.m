///
///  @file
///  WSContour.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 24.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSContour.h"
#import "WSDatum.h"


@implementation WSData (WSContour)

- (WSData *)contourWithData:(WSData *)lowerEnvelope {
    
    WSData *result = [self sortedDataUsingValueX];
    for (WSDatum *datum in [[[lowerEnvelope sortedDataUsingValueX]
                             values] reverseObjectEnumerator]) {
        [result addData:datum];
    }
    
    return result;
}

- (WSData *)contourWithError {
    WSData *upper = [WSData data];
    WSData *lower = [WSData data];
    
    for (WSDatum *datum in [self values]) {
        [upper addData:[WSDatum datumWithValue:([datum valueY] + [datum errorMaxY])
                                    withValueX:[datum valueX]]];
        [lower addData:[WSDatum datumWithValue:([datum valueY] - [datum errorMinY])
                                    withValueX:[datum valueX]]];
    }
    
    return [upper contourWithData:lower];
}

@end
