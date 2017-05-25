#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"


///
///  WSDatum.h
///  PowerPlot
///
///  This class describes a single datum point in a data set. The
///  point always has a value (Y-value) and may have an annotation, an
///  X-value and (asymmetric) errors in X and Y.
///
///  A point has a couple of properties which are stored in a
///  dictionary.  If a property is available, the key exists and the
///  value will be an NSNumber whose floatValue corresponds to the
///  datum.
///
///  In the dictionary the following keys and value types are defined:
///    @"value"      -> NSNumber
///    @"annotation" -> NSString
///    @"valueX"     -> NSNumber
///    @"errorMinY"  -> NSNumber
///    @"errorMaxY"  -> NSNumber
///    @"errorMinX"  -> NSNumber
///    @"errorMaxX"  -> NSNumber
///    @"errorCorr"  -> NSNumber
///
///  This class has two more slots whose use is optional. The first
///  one is called "customDatum" and can be any Cocoa object that
///  implements the NSCopying and NSCoding protocols. It is accessed
///  with standard getter and setter methods and is intended to be
///  used for storage of additional information not covered by the
///  default implementation. Typically, the customDatum slot is used
///  for "style" information that configure the view and possibly are
///  chosen by the program's user. These might include colors, fonts
///  and similar data.
///
///  The other is a delegate slot that can be used by categories or by
///  subclasses to provide an optional data source or a delegate.
///  While the customDatum property should implement both NSCoding and
///  NSCopying, the delegate property is never copied, but merely set
///  to the new destination in case of a copy operation and ignored
///  during serialization and deserialization.
///
///  Starting with PowerPlot v1.3 this class supports KVO notifications
///  for the 'datum' property if it is changed using any of the 'set...'
///  methods listed below.
///
///  @note The convention for uncertainties is that whenever
///        errorMin[X|Y] exists, so will errorMax[X|Y] and vice versa.
///
///  @note The convention that data coordinates are prepended with a
///        capital "D" does not apply here since everything WSDatum
///        handles is done in data coordinates, anyway!
///
///
///  Created by Wolfram Schroers on 28.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSDatum : WSObject <NSCopying, NSCoding> {

    NSMutableDictionary *_datum;
    id <NSCoding, NSCopying, NSObject> _customDatum;
    id <NSObject> _delegate;
}

@property (retain) NSMutableDictionary *datum;                     ///< The dictionary containing the properties.
@property (retain) id <NSCoding, NSCopying, NSObject> customDatum; ///< Custom information.
@property (assign) id <NSObject> delegate;                         ///< Custom delegate.


/** Return an autoreleased empty datum (factory method). */
+ (id)datum;

/** Return an autoreleased datum with a Y-value (factory method). */
+ (id)datumWithValue:(NAFloat)aValue;

/** Return an autoreleased datum with an annotated Y-value (factory method). */
+ (id)datumWithValue:(NAFloat)aValue
      withAnnotation:(NSString *)anno;

/** Return an autoreleased datum of a X,Y-pairs (factory method). */
+ (id)datumWithValue:(NAFloat)aValue
          withValueX:(NAFloat)aValueX;

/** Return an autoreleased datum of an annotated X,Y-pairs (factory method). */
+ (id)datumWithValue:(NAFloat)aValue
          withValueX:(NAFloat)aValueX
      withAnnotation:(NSString *)anno;

/** Initialize an empty datum. */
- (id)init;

/** @brief Initialize the datum with a Y-value.
 
    After initialization, the datum will only consist of a Y-value.
 */
- (id)initWithValue:(NAFloat)aValue;

/** Initialize the datum with an annotated Y-value. */
- (id)initWithValue:(NAFloat)aValue
     withAnnotation:(NSString *)anno;

/** Initialize the datum with an X,Y-pair. */
- (id)initWithValue:(NAFloat)aValue
         withValueX:(NAFloat)aValueX;

/** Initialize the datum with an annotated X,Y-pair. */
- (id)initWithValue:(NAFloat)aValue
         withValueX:(NAFloat)aValueX
     withAnnotation:(NSString *)anno;

/** Return the Y-value. */
- (NAFloat)valueY;
- (NAFloat)value;

/** Return the Y-value. */
- (void)setValueY:(NAFloat)aValue;
- (void)setValue:(NAFloat)aValue;

/** Return the X-value. */
- (NAFloat)valueX;

/** Return the X-value. */
- (void)setValueX:(NAFloat)aValue;

/** Return the annotation. */
- (NSString *)annotation;

/** Set the annotation. */
- (void)setAnnotation:(NSString *)anno;

/** Return the uncertainty in X - lower end. */
- (NAFloat)errorMinX;

/** Set the uncertainty in X - lower end. */
- (void)setErrorMinX:(NAFloat)aValue;

/** Return the uncertainty in X - upper end. */
- (NAFloat)errorMaxX;

/** Set the uncertainty in X - upper end. */
- (void)setErrorMaxX:(NAFloat)aValue;

/** Return the uncertainty in Y - lower end. */
- (NAFloat)errorMinY;

/** Set the uncertainty in Y - lower end. */
- (void)setErrorMinY:(NAFloat)aValue;

/** Return the uncertainty in Y - upper end. */
- (NAFloat)errorMaxY;

/** Return the uncertainty in Y - upper end. */
- (void)setErrorMaxY:(NAFloat)aValue;

/** Does the data set have uncertainties in X-direction? */
- (BOOL)hasErrorX;

/** Does the data set have uncertainties in Y-direction? */
- (BOOL)hasErrorY;

/** Return the correlation of uncertainties in X- and Y-direction. */
- (NAFloat)errorCorr;

/** Set the correlation of uncertainties in X- and Y-direction. */
- (void)setErrorCorr:(NAFloat)aValue;

/** @brief Compare the X-value of this datum with another X-value.

    This method is needed for all operations that require comparison,
    e.g. the sorting capabilities of WSData.

    @param aDatum WSDatum with which we compare the instance's properties.
    @return The result of the comparison of type NSComparisonResult.
 */
- (NSComparisonResult)valueXCompare:(id)aDatum;

/** Return a string with a description of this datum. */
- (NSString *)description;

@end
