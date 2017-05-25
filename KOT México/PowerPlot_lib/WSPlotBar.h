#import <Foundation/Foundation.h>
#import "WSPlot.h"


@class WSBarProperties;


/** Styles the bar plot can be drawn. */
typedef enum _WSBarPlotStyle {
    kBarPlotNone = -1, ///< Do not show a plot.
    kBarPlotUnified,   ///< Use a single default style.
    kBarPlotIndividual ///< Use data-specific custom style (if provided).
} WSBarPlotStyle;


 ///
///  WSPlotBar.h
///  PowerPlot
///
///  This class plots a data set consisting of X- and Y-values as a
///  bar plot. The appearance of the bars is either unified, i.e.,
///  every bar looks the same, or customized, i.e., every bar has
///  individually different properties which are stored in the custom
///  slot of each WSDatum in the dataD property. In either case the
///  appearance of bars is described by instances of the
///  WSBarProperties class.
///
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSPlotBar : WSPlot {
    
    WSBarPlotStyle _style;
    WSBarProperties *_barDefault;
}

@property WSBarPlotStyle style;                 ///< Style for bars in this plot.
@property (retain) WSBarProperties *barDefault; ///< Style for bars without individual configuration.

/** Copy new instance of current barDefault style to all data points. */
- (void)setAllBarsToDefault;

/** Are distances of X-values equal?

    Return a BOOL indicating if the distances of X-values for all data
    points are identical. The check is done in data coordinates, thus
    for nonlinear coordinate scales this is not a meaningful method to
    use.

    @return Result of checking distances.
 */
- (BOOL)isDistanceConsistent;

/** @brief Set the width of the default bar such that bars touch.
 
    Do nothing if the data is not consistent as determined by
    "isDataConsistent" method.
 */
- (void)widthTouchingBars;

@end
