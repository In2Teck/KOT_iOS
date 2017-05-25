#import <Foundation/Foundation.h>
#import "WSData.h"


@class WSDatum;


///
///  @file
///  WSDataOperations.h
///  PowerPlot
///
///  A collection of operations on WSData objects.
///
///  @note: These operations require the use of Objective-C blocks and
///         are thus available only in Objective-C 2.0 and iOS 4.0 and
///         later. Do not use this category in earlier versions.
///
///
///  Created by Wolfram Schroers on 06.08.11.
///  Copyright 2011 Numerik & Analyse Schroers. All rights reserved.
///


#ifdef __IPHONE_4_0


/// Define the blocks used in the operations.
typedef WSDatum* (^mapBlock_t)(const id);
typedef NSComparisonResult (^sortBlock_t)(WSDatum *, WSDatum *);
typedef BOOL (^filterBlock_t)(WSDatum *);


@interface WSData (WSDataOperations)

/** @brief Map a function on a single data set (non-destructive).
 
    The input data object can either be a WSData object or an NSArray
    of WSData objects, each of which must have the same number of
    elements.  In the former case (if data is of class WSData),
    mapBlock is called with WSDatum objects. In the latter case (if
    data is of class NSArray), mapBlock is called with an NSArray of
    WSDatum objects, taken from the respective index of each WSData
    objects, i.e., the array is resorted for operation by mapBlock.
 
    @param data Input data object, not modified on return.
    @param mapBlock The function to be applied to each WSDatum object.
    @return An autoreleased WSData object with mapBlock mapped on data.
 */
+ (WSData *)data:(id)data
             map:(mapBlock_t)mapBlock;

/** @brief Map a function on the current data set (destructively).
 
    The function mapBlock is applied to each element of the current
    data set.  The function must take and return WSDatum objects.
 
    @param mapBlock The function to be applied to each WSDatum object.
 */
- (void)map:(mapBlock_t)mapBlock;


/** @brief Apply reduction operation 'average' on current data set.
 
    A reduction operation is applied to the current data set,
    returning a WSDatum object that contains the averaged X- and
    Y-values of the original set.
 
    @note Errors and correlations are ignored.
 
    @return A WSDatum object containing the averaging result.
 */
- (WSDatum *)reduceAverage;

/** @brief Apply reduction operation 'sum' on current data set.
 
    A reduction operation is applied to the current data set,
    returning a WSDatum object that contains the averaged X- and
    Y-values of the original set.
 
    @note Errors and correlations are ignored.
 
    @return A WSDatum object containing the sum result.
 */
- (WSDatum *)reduceSum;


/** Return a new WSData set, sorted with a custom comparator.
 
    @param comparator Block comparing two instances of WSDatum.
    @result An autoreleased new WSData set, sorted according to the comparator.
 */
- (WSData *)sortedDataUsingComparator:(sortBlock_t)comparator;


/** Return a new WSData set, filtered with a custom filter.
 
    @param filter Block returning a BOOL if this object should be used.
    @return An autoreleased new WSData set, filtered according to the block.
 */
- (WSData *)filteredDataUsingFilter:(filterBlock_t)filter;


/** Return an array of floats with the X-values extracted from data set.
 
    @note The recipient needs to free the array after use. The length
          of the array needs to be taken from the count method.
 */
- (NAFloat *)floatsFromDataX;

/** Return an array of floats with the Y-values extracted from data set.
 
    @note The recipient needs to free the array after use. The length
          of the array needs to be taken from the count method.
 */
- (NAFloat *)floatsFromDataY;

@end

#endif ///__IPHONE_4_0
