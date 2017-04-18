#import <UIKit/UIKit.h>
#import "NARange.h"
#import "WSView.h"


@class WSData;
@protocol WSDataDelegate;
@class WSPlotController;
@class WSPlotAxis;


///
///  WSChart.h
///  PowerPlot
///
///  This class provides the root view for a single chart in
///  PowerPlot. The chart consists of several WSPlotController
///  objects. Each WSPlotController acts as a delegate for both the
///  coordinate system, the data and the views that represent their
///  particular part of the data. Each WSPlotController has one view
///  and at most one data set. It is possible that it has no data set
///  at all, but each visual entity in a chart must have an associated
///  WSPlotController.
///
///  A common design pattern is to have a single data set and a single
///  coordinate system and have the WSPlotController all delegate to
///  that same information, thus allowing access from all available
///  plots in the chart.
///
///  The WSPlotController-objects are stored in a NSMutableArray and
///  can thus be added, removed and reordered by the regular means;
///  convenience methods for this purpose are provided and their use
///  is encouraged over direct access to the array of plots.
///
///  This class can be used directly using the default init method. An
///  alternative is to define categories with custom initialization
///  and/or factory methods that configure specific types of
///  charts. The latter design pattern has been used to introduce
///  default types of charts with a wide variety of designs.
///
///  A convenient way to generate charts with multiple data sets is to
///  use the "generateControllerWithData:withPlotClass:" method which
///  sets up and configures the sub-plots automatically.
///
///  @note It is possible to have plots with different coordinate axis
///        since each WSPlotController has its own delegate for a
///        coordinate system which is usually handled by instances of
///        WSCoordinate. This feature can be used if one wants to plot
///        data with different units in a single chart. However, the
///        user is ultimately responsible for ensuring consistency and
///        integrity of coordinate axis labels and data when using
///        this feature. For all other use cases, methods for checking
///        and enforcing coordinate axis integrity are provided.
///
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSChart : WSView {

@public
    NSMutableArray *_plotSet;

@protected
    NSString *_chartTitleText, *_subTitleText;
    UIFont *_chartTitleFont, *_subTitleFont;
    UIColor *_chartTitleColor, *_subTitleColor;
    id _customData;
}

@property (nonatomic, copy) NSString *chartTitle; ///< Title of the chart.
@property (nonatomic, copy) NSString *subTitle;   ///< Subtitle of the chart.
@property (retain) UIFont *chartTitleFont;        ///< Font of the chart title.
@property (retain) UIFont *subTitleFont;          ///< Font of the subtitle.
@property (copy) UIColor *chartTitleColor;        ///< Color of the chart title.
@property (copy) UIColor *subTitleColor;          ///< Color of the subtitle.
@property (retain) id<NSObject> customData;       ///< Slot for custom data.
@property (retain) NSMutableArray *plotSet;       ///< An array of WSPlotController which will be plotted.

/** Reset the chart, discarding any old data. */
- (void)resetChart;

/** Insert a label with the chart title.

    @param newTitle Chart title (NSString).
 */
- (void)setChartTitle:(NSString *)newTitle;

/** Insert a label with a footer title.

    @param newTitle Chart bottom label (NSString).
 */
- (void)setSubTitle:(NSString *)newTitle;

/** Add all plots from another chart.
 
    @param chart The chart from which to add all plots.
 */
- (void)addPlotsFromChart:(WSChart *)chart;

/** @brief Create and add a new controller and view to the chart.
 
    This method creates and initializes and new plot controller of
    class WSPlotController and its view of class aClass (which usually
    will be a subclass of WSPlot). The controller is added to this
    WSChart instance. The delegates are set automatically and the
    coordinate system delegates are set to the delegates of the first
    plot in this chart instance. If there is none in this instance,
    the coordinate delegates will be allocated and initialized with
    default values. The newly created controller can also be accessed
    as the last element in the "plotSet" of this instance.
 
    @note This method offers a convenient way to add plots to the
          chart without having to handle the details of delegates and
          the MVC paradigm adopted in PowerPlot.
    
    @param dataD The data set to be graphed.
    @param aClass The view class associated with the WSPlotController.
    @param frame The frame for the view class.
 */
- (void)generateControllerWithData:(WSData *)dataD
                     withPlotClass:(Class<NSObject, WSDataDelegate>)aClass
                         withFrame:(CGRect)frame;

/** Add a new plot.

    @param aPlot The WSPlotController instance to be added.
 */
- (void)addPlot:(WSPlotController *)aPlot;

/** Add a new plot at a given index.

    @param aPlot The WSPlotController to be inserted.
    @param index Position (layer) in the plot.
 */
- (void)insertPlot:(WSPlotController *)aPlot
           atIndex:(NSUInteger)index;

/** Replace a plot at a given index.

    @param index Position (layer) in the plot.
    @param aPlot The new WSPlotController.
 */
- (void)replacePlotAtIndex:(NSUInteger)index
                  withPlot:(WSPlotController *)aPlot;

/** Remove all plots from current chart. */
- (void)removeAllPlots;

/** Remove a single plot at a given index.
  
    @param index Index of the plot that will be removed.
 */
- (void)removePlotAtIndex:(NSUInteger)index;

/** Exchange two plots at given indices.
 
    @param idx1 Index of the first plot.
    @param idx2 Index of the second plot.
 */
- (void)exchangePlotAtIndex:(NSUInteger)idx1
            withPlotAtIndex:(NSUInteger)idx2;

/** Return a specific plot at a given index.

    @param index Index of the plot that will be returned.
    @return The WSPlotController object.
 */
- (WSPlotController *)plotAtIndex:(NSUInteger)index;

/** Return the last plot in the chart.
 
    @return The last WSPlotController object.
 */
- (WSPlotController *)lastPlot;

/** Return the number of plots (curves) in the chart.

    @return The current number of plots in the chart.
 */
- (NSUInteger)count;

/** Return the first view of a given class type.
 
    @param aClass Class of the requested plot view.
    @return The plot view or nil if there is none.
 */
- (id)getFirstPlotOfClass:(Class)aClass;

/** Return the first WSPlotAxis view or nil if there is none. */
- (WSPlotAxis *)getPlotAxis;

/** Return if all plots have identical X-axis scales. 

    @return Result of a scan of all X-axis scales.
 */
- (BOOL)isAxisConsistentX;

/** Return if all plots have identical Y-axis scales.

    @return Result of a scan of all Y-axis scales.
 */
- (BOOL)isAxisConsistentY;

/** Set the coordinate axis X range in all plots.

    @param aRangeD The new range (in data coordinates).
 */
- (void)scaleAllAxisXD:(NARange)aRangeD;

/** Set the coordinate axis Y range in all plots.

    @param aRangeD The new range (in data coordinates).
 */
- (void)scaleAllAxisYD:(NARange)aRangeD;

/** @brief Set (guess) the coordinate axis X based on the data
    provided.
 
    @note This method will examine the data in *ALL* plots in the
          current chart that have data associated with them and then
          set them all to the new scale!
 */
- (void)autoscaleAllAxisX;

/** @brief Set the coordinate axis Y based on the data provided.
 
    @note This method will examine the data in *ALL* plots in the
          current chart that have data associated with them and then
          set them all to the new scale!
 */
- (void)autoscaleAllAxisY;

/** @brief Set the X-axis location of all plots to a new value.
 
    @return Return YES if successful. Return NO if the plots are
            inconsistent (i.e., have different scales) or if the new
            location is outside the bounds coordinates. If NO is
            returned, no change has been made at all.
 */
- (BOOL)setAllAxisLocationX:(NAFloat)aLocation;

/** @brief Set the Y-axis location of all plots to a new value.
 
    @return Return YES if successful. Return NO if the plots are
            inconsistent (i.e., have different scales) or if the new
            location is outside the bounds coordinates. If NO is
            returned, no change has been made at all.
 */
- (BOOL)setAllAxisLocationY:(NAFloat)aLocation;

/** @brief Set X-axis location of all plots in data coordinates.
 
    @note This will set the aLocX property of all plots in the chart.
          Thus, this setting will override the previous one in
          setAllAxisLocationX: if both are set. No consistency checks
          are performed.
 */
- (void)setAllAxisLocationXD:(NAFloat)locationD;

/** @brief Set Y-axis location of all plots in data coordinates.
 
    @note This will set the aLocY property of all plots in the chart.
          Thus, this setting will override the previous one in
          setAllAxisLocationY: if both are set. No consistency checks
          are performed.
 */
- (void)setAllAxisLocationYD:(NAFloat)locationD;


/** Unset the X-axis location of all plots in data coordinates.
 
    Once unset, any previously set value by setAllAxisLocationX: is
    used.
 */
- (void)unsetAllAxisLocationXD;

/** Unset the Y-axis location of all plots in data coordinates.
 
    Once unset, any previously set value by setAllAxisLocationY: is
    used.
 */
- (void)unsetAllAxisLocationYD;

/** Set the X-axis location of all plots to the data coordinate origin. */
- (void)setAllAxisLocationToOriginXD;

/** Set the Y-axis location of all plots to the data coordinate origin. */
- (void)setAllAxisLocationToOriginYD;

/** Return the maximum range of the data in all plots.

    The method can be applied to different information contained in
    plot controller objects. The requested piece of information is
    extracted from a WSPlotController object using the given selector.

    @note If a WSPlotController does not respond to the selector, the
          plot is ignored. This may happen if the chart contains plots
          with custom subclasses of WSPlotController, some of which do
          and others which do not respond to the selector. It is also
          possible to develop categories to WSPlotController to
          implement new behavior.

    @param dataExtract The selector applied to a WSPlotController.
    @return The resulting range is returned.
 */
- (NARange)dataRangeD:(SEL)dataExtract;

/** Return the maximum X-range of the data in all plots.

    @return The resulting maximum range.
 */
- (NARange)dataRangeXD;

/** Return the maximum Y-range of the data in all plots.

    @return The resulting maximum range.
 */
- (NARange)dataRangeYD;

/** Return a string with a description of the chart.

    @return A string with the description.
 */
- (NSString *)description;


#ifdef __IPHONE_4_0

@property (nonatomic, assign) NSTimer *animationTimer; ///< Timer for running animation (or nil).

/** This method will abort a running animation.
 
    The completion handler (if defined) will be called with NO. */
- (void)abortAnimation;

#endif ///__IPHONE_4_0

@end
