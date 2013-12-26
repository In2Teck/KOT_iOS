#import <Foundation/Foundation.h>
#import "WSPlot.h"


/** Configuration of default plot appearance. */
#define kSymbolSize 5.0
#define kErrorBarLen 10.0
#define kLineWidth 1.0
#define kErrorBarWdith 1.5

/** Styles the error bars can be drawn. */
typedef enum _WSErrorStyle {
    kErrorNone = -1, ///< Do not draw error bars.
    kErrorYFlat,     ///< Draw Y error bars with no delimiter bars.
    kErrorYCapped,   ///< Draw Y error bars with delimiter bars (caps).
    kErrorXYFlat,    ///< Draw X, Y error bars with no delimiter bars.
    kErrorXYCapped   ///< Draw X, Y error bars with delimiter bars (caps).
} WSErrorStyle;

/** Styles the lines can be drawn on the canvas. */
typedef enum _WSLineStyle {
    kLineNone = -1,     ///< Do not connect data points.
    kLineRegular,       ///< Connect data points with a line.
    kLineFilledColor,   ///< Connect with line and solid fill to abscissa axis.
    kLineFilledGradient ///< Connect with line and gradient fill to abscissa axis.
} WSLineStyle;

/** How to interpolate lines between subsequent data points. */
typedef enum _WSInterpolationStyle {
    kInterpolationNone = -1, ///< Do not connect data points.
    kInterpolationStraight,  ///< Interpolation with straight lines.
    kInterpolationSpline     ///< Interpolation with Bezier splines.
} WSInterpolationStyle;


///
///  WSPlotData.h
///  PowerPlot
///
///  This class plots a data set consisting of X- and Y-values and
///  possibly also error bars. The data can be displayed as points
///  (with a symbol the user can choose) and can be connected by a
///  line with a color, width and dashing the user can
///  choose. Furthermore, the data can be filled down to the
///  coordinate axis; the filling color and gradient can also be
///  chosen by the user.
///
///  Since version 1.2.2 shadows for the line and symbols are
///  supported as well as different connection styles: straight lines
///  (the default) and Bezier curves which smoothly interpolate
///  between the available data points.
///
///  @note This class does not take the error correlation slot of
///        WSDatum into account, but will properly display the
///        uncertainties in X- and Y-direction if requested.
///
///
///  Created by Wolfram Schroers on 26.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSPlotData : WSPlot {

    NASymbolStyle symbolStyle;
    NAFloat symbolSize;
    UIColor *symbolColor;
    WSErrorStyle errorStyle;
    UIColor *errorBarColor;
    NAFloat errorBarLen,
            errorBarWidth;
    WSLineStyle lineStyle;
    NADashingStyle dashStyle;
    NAFloat lineWidth;
    UIColor *lineColor;
    UIColor *fillColor;
    CGGradientRef fillGradient;
}

@property NASymbolStyle symbolStyle;     ///< Symbol for data points.
@property NAFloat symbolSize;            ///< Size of data point symbol.
@property NAFloat lineWidth;             ///< Width of line connecting data points.
@property NAFloat errorBarLen;           ///< Length of the error bar delimiter.
@property NAFloat errorBarWidth;         ///< Width of the error bar lines.
@property (copy) UIColor *symbolColor;   ///< Symbol color.
@property (copy) UIColor *errorBarColor; ///< Color of error bars.
@property (copy) UIColor *lineColor;     ///< Color of line.
@property (copy) UIColor *fillColor;     ///< Filling color from line to axis.
@property WSErrorStyle errorStyle;       ///< Error bars-style.
@property WSLineStyle lineStyle;         ///< Style of the line connecting the data.
@property NADashingStyle dashStyle;      ///< Dashing of the line.
@property WSInterpolationStyle intStyle; ///< How to interpolate between points.
@property CGGradientRef fillGradient;    ///< Gradient from line to axis.

@property BOOL hasShadow;                ///< Do line and symbols have a shadow?
@property NAFloat shadowScale;           ///< Offset and blur of shadow.
@property (copy) UIColor *shadowColor;   ///< Color of line and symbol shadow.


/** @brief Set the colors of a fillGradient with two colors.
 
    @note This method is a shortcut for using custom gradients. It
          allows to choose the gradient running from one color to
          another. If still more functionality is required, the user
          has to directly use setFillGradient with a custom gradient.

    @param color1 Gradient from top color.
    @param color2 Gradient to this bottom color.
 */
- (void)setFillGradientFromColor:(UIColor *)color1
                         toColor:(UIColor *)color2;

@end
