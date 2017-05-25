#import <Foundation/Foundation.h>
#import "WSView.h"
#import "WSDataDelegate.h"
#import "WSPlotDelegate.h"


/** Configuration of default axis orgin (in bounds coordinates). */
#define kALocationX 70.0
#define kALocationY 80.0


///
///  WSPlot.h
///  PowerPlot
///  @file
///
///  This is the base class for all objects that deal with plotting
///  entities to the chart. In general they will require delegates to
///  the coordinate systems and to a data set. However, the data set
///  is optional - the coordinate axis, for example, do not require a
///  data set to plot themselves, but they need a set of coordinates.
///
///  @note Some quantities are in data coordinates (as stored in and
///        provided by the WSData object). Other quantities are in
///        bounds coordinates (as provided by the UIView). To
///        distinguish the latter from the former, a capital "D" is
///        appended to all quantities in data
///        coordinates. Consequently, all data values with no capital
///        "D" appended are in bounds coordinates. Before plotting all
///        "D" quantities and must be converted. Note how the
///        transformation methods boundsWithData[X|Y] follows this
///        convention!
///
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSPlot : WSView <WSDataDelegate> {

    NAFloat _axisLocationX,
            _axisLocationY;
    id <WSPlotDelegate> coordDelegate;
    id <WSDataDelegate> dataDelegate;
}

@property NAFloat axisLocationX;                ///< Origin of X-axis in bounds coordinates.
@property NAFloat axisLocationY;                ///< Origin of Y-axis in bounds coordinates.
@property (assign, nonatomic) id coordDelegate; ///< Delegate object for coordinate transformation.
@property (assign, nonatomic) id dataDelegate;  ///< Delegate object which provides a data source.

/** @brief Store custom axis location in data coordinates.
 
    The convenience accessors for these properties are actually
    setAxisLocationXD:, setAxisLocationYD: and unsetAxisLocationXD and
    unsetAxisLocationYD which do not require NSNumber!
 
    @note Classes that support axis locations (like e.g. the WSPlotBar
          and WSPlotAxis classes) must evaluate this property in their
          drawRect: implementations!
 */
@property (retain) NSNumber *aLocXD;
@property (retain) NSNumber *aLocYD;

/** Does this type of plot support data (even if currently empty)? */
@property (readonly) BOOL hasData;


/** Return the name of the data set. */
- (NSString *)dataName;

/** Set the name of the data set. */
- (void)setDataName:(NSString *)aName;

/** Return the X-axis range covered by the current data set. */
- (NARange)dataRangeXD;

/** Return the Y-axis range covered by the current data set. */
- (NARange)dataRangeYD;

/** Return the X-bounds coordinate of a given data coordinate (via delegate). */
- (NAFloat)boundsWithDataX:(NAFloat)aDatumD;

/** Return the Y-bounds coordinate of a given data coordinate (via delegate). */
- (NAFloat)boundsWithDataY:(NAFloat)aDatumD;

/** Return the X-bounds coordinate of a given data coordinate (via delegate). */
- (NAFloat)dataWithBoundsX:(NAFloat)aDatum;

/** Return the Y-bounds coordinate of a given data coordinate (via delegate). */
- (NAFloat)dataWithBoundsY:(NAFloat)aDatum;

/** Return the X-coordinate axis range. */
- (NARange)rangeXD;

/** Return the Y-coordinate axis range. */
- (NARange)rangeYD;

/** Return the X-coordinate inverted flag. */
- (BOOL)invertedX;

/** Return the Y-coordinate inverted flag. */
- (BOOL)invertedY;

/** @brief Set the X-axis location in data coordinates.
 
    @note This function stores the X-axis location in data coordinates
          which may change when the bounds of the parent view changes.
          Therefore, using this setting will OVERRIDE any value stored
          in axisLocationX when the plot is drawn!
 */
- (void)setAxisLocationXD:(NAFloat)datum;

/** @brief Set the Y-axis location in data coordinates.
 
    @note This function stores the Y-axis location in data coordinates
          which may change when the bounds of the parent view changes.
          Therefore, using this setting will OVERRIDE any value stored
          in axisLocationY when the plot is drawn!
 */
- (void)setAxisLocationYD:(NAFloat)datum;

/** @brief Unset the X-axis location in data coordinates.
 
    @note If needed, the value will default to axisLocationX.
 */
- (void)unsetAxisLocationXD;

/** @brief Unset the Y-axis location in data coordinates.
 
    @note If needed, the value will default to axisLocationY.
 */
- (void)unsetAxisLocationYD;

/** Plot a sample data point at the given CGPoint (e.g. for legends etc.). */
- (void)plotSample:(CGPoint)aPoint;

/** Switch off all elements in the current plot. */
- (void)setAllDisplaysOff;

/** Force redraw of entire chart (this instance's superview). */
- (void)chartSetNeedsDisplay;

@end
