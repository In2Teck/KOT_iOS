#import <Foundation/Foundation.h>
#import "WSPlot.h"


/** Styles the discs can be drawn. */
typedef enum _WSDiscStyle {
    kDiscPlotNone = -1, ///< Do not draw any discs.
    kDiscPlotContour,   ///< Show the outline only.
    kDiscPlotFilled,    ///< Show only the filled disc.
    kDiscPlotAll        ///< Show the filling plus outline.
} WSDiscStyle;


///
///  WSPlotDisc.h
///  PowerPlot
///
///  This class draws ellipses at the data points with sizes and tilt
///  based on the uncertainty entries of the data points. The ellipses
///  can be filled with a color and optionally have a line around
///  them.  If a data point has no uncertainty or if it is zero in one
///  direction, no symbol is drawn for that point. If a non-zero value
///  for "errorCorr" is specified, the disc for that point will be
///  tilted; the tilt corresponds to 45 degrees * errorCorr - thus,
///  meaningful values for "errorCorr" are from the interval [-1, 1].
///
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSPlotDisc : WSPlot {

    NAFloat _lineWidth;
    UIColor *_lineColor;
    UIColor *_fillColor;    
    WSDiscStyle _style;
}

@property NAFloat lineWidth;         ///< Width of outline.
@property (copy) UIColor *lineColor; ///< Color of outline.
@property (copy) UIColor *fillColor; ///< Filling color.
@property WSDiscStyle style;         ///< Style for drawing the discs.

@end
