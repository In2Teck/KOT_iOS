#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"


/** Configuration of default bar appearance (in bounds coordinates). */
#define kBarWidth 20.0
#define kOutlineStroke 2.0
#define kShadowScale 5.0

/** Styles the bar can be drawn. */
typedef enum _WSBarStyle {
    kBarNone = -1, ///< Turn the display off.
    kBarOutline,   ///< Online draw the outline.
    kBarFilled,    ///< Bar with outline and (separate) solid fill.
    kBarGradient   ///< Bar with outline, filled with gradient.
} WSBarStyle;


///
///  WSBarProperties.h
///  PowerPlot
///
///  This class describes the properties of a bar in a WSPlotBar plot.
///  Instances can be stored inside a WSDatum object for use of
///  individual bars or used as a generic object describing all bars
///  in WSPlotBar.
///
///  @note The shadow property only applies to bars with a solid fill,
///        not bars with gradients.
///
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSBarProperties : WSObject <NSCopying, NSCoding> {

    NAFloat _barWidth, _outlineStroke, _shadowScale;   
    WSBarStyle _style;      
    BOOL _hasShadow;        
    UIColor *_outlineColor, *_barColor, *_barColor2, *_shadowColor;  
}

@property NAFloat barWidth;             ///< Width of bar in bounds coordinates.
@property NAFloat outlineStroke;        ///< Width of outline stroke.
@property NAFloat shadowScale;          ///< Offset and blur of shadow.
@property WSBarStyle style;             ///< Style of the bar.
@property BOOL hasShadow;               ///< Does the bar have a shadow?
@property (copy) UIColor *outlineColor; ///< Color of bar outline.
@property (copy) UIColor *barColor;     ///< Color of bar filling.
@property (copy) UIColor *barColor2;    ///< Color of bar filling if there is a gradient.
@property (copy) UIColor *shadowColor;  ///< Color of bar shadow.

@end
