#import <Foundation/Foundation.h>
#import "NARange.h"
#import "WSObject.h"
#import "WSCoordinateTransform.h"


/** The possible styles a direction can be scaled. */
typedef enum _WSCoordinateScale {
    kCoordinateScaleNone = -1,   ///< No coordinate scale transformation.
    kCoordinateScaleLinear,      ///< Linear coordinate scale transformation.
    kCoordinateScaleLogarithmic, ///< Logarithmic scale.
    kCoordinateScaleCustom       ///< Custom transformation, provided by user
                                 ///< via WSCoordinateTransform protocol.
} WSCoordinateScale;


///
///  WSCoordinate.h
///  PowerPlot
///
///  This class implements a coordinate scale model. It basically
///  defines a map between the coordinate system of the data model and
///  a linear model which usually corresponds to the bounds on screen.
///  It defines the origin, scale function and associated parameters
///  needed to transform from the data model to screen coordinates. A
///  single WSCoordinate class describes just one axis, so typically
///  any WSPlotController class needs two WSCoordinate to describe
///  both X- and Y-dependencies.
///
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSCoordinate : WSObject {

    WSCoordinateScale _coordScale;
    NARange _coordRangeD;
    NAFloat _coordOrigin;
    BOOL _inverted;
    id <WSCoordinateTransform> _customCoord;
}

@property WSCoordinateScale coordScale;  ///< Scaling method of the current axis.
@property NARange coordRangeD;           ///< Range of the current axis (in data coordinates).
@property NAFloat coordOrigin;           ///< Origin (offset) of the axis (starting point in bounds coordinates).
@property BOOL inverted;                 ///< Is the current axis inverted?
@property (assign, nonatomic) id <WSCoordinateTransform> customCoord; ///< Custom coordinate transformation.

/** Return an autoreleased axis with default parameters (factory method). */
+ (id)coordinate;

/** Return an autoreleased axis with custom parameters (factory method). */
+ (id)coordinateWithScale:(WSCoordinateScale)cdScale
                 axisMinD:(NAFloat)axMinD
                 axisMaxD:(NAFloat)axMaxD
                 inverted:(BOOL)invert;

/** Initialize the axis with default parameters. */
- (id)init;

/** Initialize the axis with custom parameters. */
- (id)initWithScale:(WSCoordinateScale)cdScale
           axisMinD:(NAFloat)axMinD
           axisMaxD:(NAFloat)axMaxD
           inverted:(BOOL)invert;

/** @brief Transform a data point from data coordinates to bounds coordinates.

    This method is of key importance for all plots since the data can
    be in an arbitrary unit system and coordinate scale, but the
    bounds coordinates are given by the view as it appears on the
    device. This transformation handles the details of going from the
    former to the latter. The WSCoordinateTransform protocol for
    custom coordinate transformations also has an optional method for
    the reverse transformation.

    @param dataD Input coordinate in data coordinate system.
    @param size Bounds of UIView screen (typically either width or height).
    @return Coordinate in bounds coordinate system.
 */
- (NAFloat)transformData:(NAFloat)dataD
                withSize:(NAFloat)size;

/** @brief Reverse the above transformation.
 
    This method transforms from bounds coordinates to data
    coordinates.  If the resulting data coordinate cannot be obtained
    it will return NAN. The coordinate may be unobtainable for several
    reasons - the range of validity is not correct (e.g. negative
    arguments for logarithmic scales) or we have a custom
    transformation which does not implement the optional coordinate
    reversal.
 
    This method is typically needed for interactive touches. Thus, in
    most cases the linear coordinate system transformation is all that
    is needed.
 
    @param bound Input coordinate in bounds coordinate system.
    @param size Bounds of UIView screen (typically either width or height).
    @return Coordinate in data coordinate system.
 */
- (NAFloat)transformBounds:(NAFloat)bound
                  withSize:(NAFloat)size;

/** Return a string with a description of the class. */
- (NSString *)description;

@end
