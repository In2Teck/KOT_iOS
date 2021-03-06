#import <Foundation/Foundation.h>
#import "WSChart.h"
#import "WSPlotFactoryDefaults.h"


/** Styles a line chart can be generated by this category. */
typedef enum _LPStyle {
    kChartLineEmpty = -1, ///< Do not draw anything.
    kChartLinePlain,      ///< Chart with a single line.
    kChartLineFilled,     ///< Chart with a line and solid fill it up/down to the abscissa.
    kChartLineGradient,   ///< Chart with a line and gradient fill it up/down to the abscissa.
    kChartLineScientific  ///< Chart with a single line, error bars and symbols.
} LPStyle;


///
///  WSLinePlotFactory.h
///  PowerPlot
///
///  This category defines a series of factory methods providing
///  common designs of charts with line plots. The user can choose
///  several default styles and methods to display the data. Note that
///  it is still possible to configure all properties of charts
///  generated this way and that it is similarly possible to add
///  custom plots, too. An important point to be aware of is that an
///  autogenerated chart usually employs the design pattern that each
///  plot in the chart delegates to a single data set and coordinate
///  system only!  When adding custom plots the user may or may not
///  adhere to this convention.
///
///
///  Created by Wolfram Schroers on 15.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSChart (WSLinePlotFactory)

/** Return an autoreleased chart with a coordinate system and a line plot. */
+ (id)linePlotWithFrame:(CGRect)frame
               withData:(WSData *)data
              withStyle:(LPStyle)style
          withAxisStyle:(CSStyle)axis
        withColorScheme:(LPColorScheme)colors
             withLabelX:(NSString *)labelX
             withLabelY:(NSString *)labelY;

/** @brief Configure the current chart instance.
 
    The instance will have all previous data removed and contain a
    line plot and an axis plot with appropriate configuration.

    @param data Input data set.
    @param style Style of the resulting chart.
    @param axis Style of the coordinate axis in the result chart.
    @param colors Resulting color scheme.
    @param labelX X-axis label.
    @param labelY Y-axis label.
 */
- (void)configureWithData:(WSData *)data
                withStyle:(LPStyle)style
            withAxisStyle:(CSStyle)axis
          withColorScheme:(LPColorScheme)colors
               withLabelX:(NSString *)labelX
               withLabelY:(NSString *)labelY;

@end
