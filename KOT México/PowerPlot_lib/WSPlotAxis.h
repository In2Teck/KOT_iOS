#import <Foundation/Foundation.h>
#import "WSPlot.h"


@class WSData;
@class WSTicks;


/** Configuration of default axis appearance (in bounds coordinates). */
#define kAPaddingX 30.0
#define kAPaddingY 40.0
#define kAOverhangX 5.0
#define kAOverhangY 10.0
#define kAArrowLength 14.4
#define kAStrokeWidth 3.0
#define kDefaultTicksDistance 75.0
#define kALabelFont [UIFont systemFontOfSize:12.0]

/** Styles a coordinate axis can be plotted. */
typedef enum _WSAxisStyle {
    kAxisNone = -1,             ///< Do not show the axis.
    kAxisPlain,                 ///< Plain line for axis.
    kAxisArrow,                 ///< Line with axis arrow.
    kAxisArrowFilledHead,       ///< Line with axis arrow that has a solid arrowhead.
    kAxisArrowInverse,          ///< Line with axis arrow pointing at the other direction.
    kAxisArrowFilledHeadInverse ///< Line with solid arrowhead pointing at the other direction.
} WSAxisStyle;

/** Styles a grid can be drawn. */
typedef enum _WSGridStyle {
    kGridNone = -1, ///< No grid.
    kGridPlain,     ///< Solid grid lines at major axis ticks.
    kGridDotted     ///< Dotted grid lines at major axis ticks.
} WSGridStyle;

/** Location of an axis label. */
typedef enum _WSLabelStyle {
    kLabelNone = -1, ///< Do not show axis label.
    kLabelCenter,    ///< Axis label at center (will be rotated on Y-axis).
    kLabelEnd,       ///< Axis label at end of axis.
    kLabelInside     ///< Axis label on the reverse side (data side).
} WSLabelStyle;


///
///  WSPlotAxis.h
///  PowerPlot
///
///  This class plots the coordinate axis, usually consisting of the
///  axis lines with ticks, labels and (possibly) an enclosing box.
///  The appearance can be adjusted with a wide range of options.
///
///
///  Created by Wolfram Schroers on 25.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSPlotAxis : WSPlot {

    WSAxisStyle axisStyleX, axisStyleY;
    UIColor *axisColor;
    NAFloat axisOverhangX, axisOverhangY,
            axisPaddingX, axisPaddingY,
            axisArrowLength, axisStrokeWidth;
    BOOL drawBoxed;
    WSTicks *ticksX, *ticksY;
    WSGridStyle gridStyleX, gridStyleY;
    NAFloat gridStrokeWidth;
    UIColor *gridColor;
    WSLabelStyle labelStyleX, labelStyleY;
    NSString *axisLabelX, *axisLabelY;
    UIFont *labelFontX, *labelFontY;
    UIColor *labelColorX, *labelColorY;
}

@property WSAxisStyle axisStyleX;          ///< Style of X-axis.
@property WSAxisStyle axisStyleY;          ///< Style of Y-axis.
@property (copy) UIColor *axisColor;       ///< Color of both axis.
@property NAFloat axisOverhangX;           ///< Additional axis extend beyond the end (X-axis).
@property NAFloat axisOverhangY;           ///< Additional axis extend beyond the end (Y-axis).
@property NAFloat axisPaddingX;            ///< X-axis starting offset from bounds rectangle.
@property NAFloat axisPaddingY;            ///< Y-axis starting offset from bounds rectangle.
@property NAFloat axisArrowLength;         ///< Length of arrow on all axis.
@property NAFloat axisStrokeWidth;         ///< Stroke width of all axis.
@property BOOL drawBoxed;                  ///< Should the axis form a box.
@property (retain) WSTicks *ticksX;        ///< Style and location of tick marks on X-axis.
@property (retain) WSTicks *ticksY;        ///< Style and location of tick marks on Y-axis.
@property WSGridStyle gridStyleX;          ///< X-direction style of coordinate grid.
@property WSGridStyle gridStyleY;          ///< Y-direction style of coordinate grid.
@property NAFloat gridStrokeWidth;         ///< Stroke width of grid bars.
@property (copy) UIColor *gridColor;       ///< Colors of grid bars.
@property WSLabelStyle labelStyleX;        ///< Location of the X-axis label.
@property WSLabelStyle labelStyleY;        ///< Location of the Y-axis label.
@property (copy) NSString *axisLabelX;     ///< Text of label on X-axis.
@property (copy) NSString *axisLabelY;     ///< Text of label on Y-axis.
@property (retain) UIFont *labelFontX;     ///< Font of X-axis text label.
@property (retain) UIFont *labelFontY;     ///< Font of Y-axis text label.
@property (copy) UIColor *labelColorX;     ///< Color of X-axis text label.
@property (copy) UIColor *labelColorY;     ///< Color of Y-axis text label.

/** @brief Set the X-axis major ticks using a given data set.
 
    The X-values will be used to set the ticks. If this instance's
    data delegate is set to the same data set used in a data plot in
    the chart, this method can simply be called with [&lt;instance&gt;
    dataD] as a parameter. Otherwise, the data (possibly form another
    data source) has to be supplied. This method does not use the
    plot's own delegate on purpose.
  
    @param data WSData input data from which to take the X-values.
 */
- (void)setTicksXDWithData:(WSData *)data;

/** @brief Set the major ticks and labels using a given data set.
 
    The X-values and the annotations in the input data will be used to
    set the ticks. If this instance's data delegate is set to the same
    data set used in a data plot in the chart, this method can simply
    be called with [&lt;instance&gt; dataD] as a parameter. Otherwise,
    the data (possibly form another data source) has to be
    supplied. This method does not use the plot's own delegate on
    purpose.
  
    @param data WSData input data from which to take the information.
 */
- (void)setTicksXDAndLabelsWithData:(WSData *)data;

/** @brief Set the major ticks and labels using a given data set.
 
    The X-values and the annotations in the input data will be used to
    set the ticks. However, it will only use those labels that are at
    least "distance" points in bounds coordinates away. Hence this
    method - unlike the previous one - will not clutter the axis of a
    plot if too many X-values are available.

    If this instance's data delegate is set to the same data set used
    in a data plot in the chart, this method can simply be called with
    [&lt;instance&gt; dataD] as a parameter. Otherwise, the data
    (possibly from another data source) has to be supplied as the
    parameter. This method does not use the plot's own delegate on
    purpose.
    
    @param data WSData input data from which to take the information.
    @param distance Minimum distance in bounds coordinates.
 */
- (void)setTicksXDAndLabelsWithData:(WSData *)data
                        minDistance:(NAFloat)distance;

/** @brief Set the X-axis major ticks automatically.
 
    This method needs an appropriately setup coordinate system to
    work.  One way to make sure it works well is to set the data
    delegate to the same one that handles the plots with data in the
    chart. Another one is to use the methods in WSChart to keep the
    coordinate systems in all plots synchronized. This is the setting
    in all default charts, but the user has the choice to use
    different coordinate systems and even different axis in a chart if
    she so wishes.

    @note Unlike previous methods, this method will use the plot's own
          WSDataDelegate!
 */
- (void)autoTicksXD;

/** @brief Set the Y-axis major ticks automatically.
 
    This method needs an appropriately setup coordinate system to
    work.  One way to make sure it works well is to set the data
    delegate to the same one that handles the plots with data in the
    chart. Another one is to use the methods in WSChart to keep the
    coordinate systems in all plots synchronized. This is the setting
    in all default charts, but the user has the choice to use
    different coordinate systems and even different axis in a chart if
    she so wishes.

    @note Unlike previous methods, this method will use the plot's own
          WSDataDelegate!
 */
- (void)autoTicksYD;

/** @brief Set the X-tick label strings.
 
    This method uses the existing major tick positions and generates a
    label at each point using a default decimal style formatter.
 */
- (void)setTickLabelsX;

/** @brief Set the Y-tick label strings.

    This method uses the existing major tick positions and generates a
    label at each point using a default decimal style formatter.
 */
- (void)setTickLabelsY;

/** Set the X-tick labels using a default NSNumberFormatter style. */
- (void)setTickLabelsXWithStyle:(NSNumberFormatterStyle)style;

/** Set the Y-tick labels using a default NSNumberFormatter style. */
- (void)setTickLabelsYWithStyle:(NSNumberFormatterStyle)style;

/** Set the X-tick labels using a custom formatter. */
- (void)setTickLabelsXWithFormatter:(NSNumberFormatter *)formatter;

/** Set the Y-tick labels using a custom formatter. */
- (void)setTickLabelsYWithFormatter:(NSNumberFormatter *)formatter;

@end
