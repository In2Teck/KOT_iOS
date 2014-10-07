#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"


/** Configuration of default ticks appearance (in bounds coordinates). */
#define kMajorTicksLen 10.0
#define kMinorTicksLen 5.0
#define kLabelOffset 3.0

/** Styles a coordinate axis tick label can be drawn. */
typedef enum _WSTicksStyle {
    kTicksNone = -1,           ///< Do not show tick labels.
    kTicksLabels,              ///< Show tick labels at standard location.
    kTicksLabelsInverse,       ///< Show tick labels at reverse side.
    kTicksLabelsSlanted,       ///< Show tick labels slanted at standard location.
    kTicksLabelsSlantedInverse ///< Show tick labels slanted at reverse side.
} WSTicksStyle;

/** Styles a coordinate axis ticks can be drawn. */
typedef enum _WSTicksDirection {
    kTDirectionNone = -1, ///< Do not show axis ticks.
    kTDirectionIn,        ///< Ticks point inwards.
    kTDirectionOut,       ///< Ticks point outwards.
    kTDirectionInOut      ///< Ticks point both ways.
} WSTicksDirection;


///
///  WSTicks.h
///  PowerPlot
///
///  This class implements the functionality of axis ticks. It handles
///  their locations (in data coordinates), labeling and
///  configuration.  It also provides automated algorithms to set some
///  of those parameters.
///
///
///  Created by Wolfram Schroers on 12.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSTicks : WSObject {

    WSTicksStyle _ticksStyle;
    WSTicksDirection _ticksDir;
    NSUInteger _minorTicksNum;
    NSMutableArray *_ticksPosD, *_minorTicksPosD, *_labelString;
    NAFloat _majorTicksLen, _minorTicksLen;
    NAFloat _labelOffset;
}

@property WSTicksStyle ticksStyle;                 ///< Styles of tick labels on X- and Y-axis.
@property WSTicksDirection ticksDir;               ///< Direction of tick marks on X- and Y-axis.
@property NSUInteger minorTicksNum;                ///< Number of minor ticks between major ones.
@property (retain) NSMutableArray *ticksPosD;      ///< Major ticks positions (in data coords).
@property (retain) NSMutableArray *minorTicksPosD; ///< Minor ticks positions (in data coords).
@property (retain) NSMutableArray *labelString;    ///< Tick label strings.
@property NAFloat majorTicksLen;                   ///< Length of major ticks.
@property NAFloat minorTicksLen;                   ///< Length of minor ticks.
@property NAFloat labelOffset;                     ///< Distance between tick end and label start.

/** Return the number of major ticks. */
- (NSUInteger)count;

/** Return the number of minor ticks. */
- (NSUInteger)countMinor;

/** Return the major tick position (in data coords) at index i. */
- (NAFloat)tickAtIndex:(NSUInteger)i;

/** Return the label string at index i. */
- (NSString *)labelAtIndex:(NSUInteger)i;

/** Return the minor tick position (in data coords) at index i. */
- (NAFloat)minorTickAtIndex:(NSUInteger)i;

/** Set the major and minor tick positions, set the labels to empty strings. */
- (void)autoTicksWithRange:(NARange)aRange withNumber:(NAFloat)labelNum;

/** @brief Set ticks using an array of major tick positions.
 
    Set the major tick positions from the array provided, then compute
    the minor tick positions, set the labels to empty strings.

    @param positions The positions in bounds coordinates.
 */
- (void)ticksWithNumbers:(NSArray *)positions;

/** @brief Set major tick mark positions and labels.
 
    Set ticks and labels using arrays of major tick positions and
    labels. Then compute the minor tick positions and insert
    them. Both arrays need to have the same sizes.

    @param positions The positions in bounds coordinates.
    @param labels The corresponding labels.
 */
- (void)ticksWithNumbers:(NSArray *)positions
              withLabels:(NSArray *)labels;

/** Set the tick labels using a default scientific formatter. */
- (void)setTickLabels;

/** Set the tick labels using a default NSNumberFormatter style. */
- (void)setTickLabelsWithStyle:(NSNumberFormatterStyle)style;

/** Set the tick labels using a custom formatter. */
- (void)setTickLabelsWithFormatter:(NSNumberFormatter *)formatter;

/** Set the tick labels to strings, and the positions to indexed data points. */
- (void)setTickLabelsWithStrings:(NSArray *)strings;

/** Return a string with a description of the class. */
- (NSString *)description;

@end
