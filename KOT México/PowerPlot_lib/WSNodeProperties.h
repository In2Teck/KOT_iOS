#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"


/** Configuration of default node appearance (in bounds coordinates). */
#define kNodeWidth 80.0
#define kNodeHeight 30.0
#define kOutlineStroke 2.0
#define kShadowScale 5.0
#define kLabelPadding 2.0
#define kCArrowLength 10.0


///
///  WSNodeProperties.h
///  PowerPlot
///
///  This class describes the style properties of a node in a
///  WSPlotGraph plot.  Instances can be stored inside a WSDatum
///  object (in the customData slot) for use of individual node styles
///  or used as a generic object describing all nodes in a
///  WSPlotGraph.
///
///  The CGRect of a node is determined by the origin based on the
///  valueX and valueY properties after an appropriate coordinate
///  transformation and the size as given by the size property of this
///  class.
///
///  @note In a given graph, a node may not have an individual style
///        by default.
///
///
///  Created by Wolfram Schroers on 19.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSNodeProperties : WSObject <NSCopying, NSCoding> {

    CGSize _size;
    NAFloat _outlineStroke,
            _shadowScale,
            _labelPadding;
    BOOL _hasShadow;
    UIColor *_outlineColor,
            *_nodeColor,
            *_shadowColor,
            *_labelColor;
    UIFont  *_labelFont;
}

@property CGSize size;                  ///< Size of the node in bounds coordinates.
@property NAFloat outlineStroke;        ///< Width of outline stroke.
@property NAFloat shadowScale;          ///< Offset and blur of shadow.
@property NAFloat labelPadding;         ///< Padding of node label (all directions).
@property BOOL hasShadow;               ///< Does the node have a shadow?
@property (copy) UIColor *outlineColor; ///< Color of node outline.
@property (copy) UIColor *nodeColor;    ///< Color of node filling.
@property (copy) UIColor *shadowColor;  ///< Color of node shadow.
@property (copy) UIColor *labelColor;   ///< Color of the node label text.
@property (copy) UIFont *labelFont;     ///< Font of the node label text.

@end
