///
///  @file
///  WSDataOperations.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 06.08.11.
///  Copyright 2011 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSDataOperations.h"
#import "WSDatum.h"


#ifdef __IPHONE_4_0

@implementation WSData (WSDataOperations)

+ (WSData *)data:(id)data
             map:(mapBlock_t)mapBlock {
    WSData *result = [WSData data];
    
    // Verify the type of the argument.
    if ([data isKindOfClass:[WSData class]]) {
        
        // Perform simple one-argument map.
        for (WSDatum *datum in data) {
            [result addData:mapBlock(datum)];
        }
    } else if ([data isKindOfClass:[NSArray class]]) {
        
        // Perform multi-argument map.
        NSUInteger len = [[data objectAtIndex:0] count];
        NSUInteger numargs = [data count];
        for (WSData *oneSet in data) {
            if ([oneSet count] != len) {
                NSException *countExcpt = [NSException
                                           exceptionWithName:[NSString
                                                              stringWithFormat:@"MAP ERROR <%@>",
                                                              [self class]]
                                           reason:@"data-length conflict"
                                           userInfo:[NSDictionary
                                                     dictionaryWithObjectsAndKeys:[NSNumber
                                                                                   numberWithInt:len],
                                                     @"canonical_len",
                                                     [NSNumber numberWithInt:[oneSet count]],
                                                     @"mismatch_len",
                                                     nil]];
                @throw countExcpt;
            }
        }
        
        NSMutableArray *par = [NSMutableArray arrayWithCapacity:len];
        [par insertObjects:[WSData arrayOfZerosWithLen:len]
                 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, len)]];
        for (NSUInteger i=0; i<len; i++) {
            for (NSUInteger j=0; j<numargs; j++) {
                [par replaceObjectAtIndex:j
                               withObject:[(WSData *)[data objectAtIndex:j]
                                           dataAtIndex:i]];
            }
            [result addData:mapBlock(par)];
        }
    } else {
        
        // Throw an inconsistency exception.
        NSException *countExcpt = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"MAP ERROR <%@>",
                                                      [self class]]
                                   reason:@"data-type conflict"
                                   userInfo:[NSDictionary
                                             dictionaryWithObject:NSStringFromClass([data
                                                                                     class])
                                             forKey:@"data_class"]];
        @throw countExcpt;
    }
    
    return result;
}

- (void)map:(mapBlock_t)mapBlock {
    WSDatum *tmp = nil;
    
    for (NSUInteger i=0; i<[self count]; i++) {
        tmp = mapBlock([self dataAtIndex:i]);
        [self replaceDataAtIndex:i
                        withData:tmp];
    }
}


- (WSDatum *)reduceAverage {
    WSDatum *result = [self reduceSum];
    NAFloat len = (NAFloat)[self count];
    
    [result setValue:([result value] / len)];
    [result setValueX:([result valueX] / len)];

    return result;
}

- (WSDatum *)reduceSum {
    WSDatum *result = [WSDatum datum];
    double sumX = 0.0,
           sumY = 0.0;

    for (WSDatum *datum in self) {
        sumX += (double)[datum valueX];
        sumY += (double)[datum value];
    }
    [result setValueX:(NAFloat)sumX];
    [result setValueY:(NAFloat)sumY];
    
    return result;
}


- (WSData *)sortedDataUsingComparator:(sortBlock_t)comparator {
    WSData *result = [self copy];
    [[result values] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return comparator((WSDatum *)obj1, (WSDatum *)obj2);
    }];
    
    return [result autorelease];
}

- (WSData *)filteredDataUsingFilter:(filterBlock_t)filter {
    WSData *result = [WSData data];
    
    for (WSDatum *datum in self) {
        if (filter(datum)) {
            [result addData:datum];
        }
    }
    
    return result;
}


- (NAFloat *)floatsFromDataX {
    NAFloat *result = NULL;
    
    result = (NAFloat *)malloc([self count] * sizeof(NAFloat));
    for (NSUInteger i=0; i<[self count]; i++) {
        result[i] = [[self dataAtIndex:i] valueX];
    }
    
    return result;
}

- (NAFloat *)floatsFromDataY {
    NAFloat *result = NULL;
    
    result = (NAFloat *)malloc([self count] * sizeof(NAFloat));
    for (NSUInteger i=0; i<[self count]; i++) {
        result[i] = [[self dataAtIndex:i] value];
    }
    
    return result;
}

@end

#endif ///__IPHONE_4_0

