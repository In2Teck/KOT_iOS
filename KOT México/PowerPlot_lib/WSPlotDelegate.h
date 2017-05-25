#import <UIKit/UIKit.h>
#import "NARange.h"
#import "WSCoordinate.h"


///
///  WSPlotDelegate.h
///  PowerPlot
///
///  This protocol defines methods that deal with coordinate
///  transformations between data coordinates (used by all Data Model
///  objects and all View and Controller objects (and their respective
///  variables) whose names end with a capital "D") and bounds
///  (screen) coordinates that are used for drawing to the current
///  view.
///
///  These methods must be implemented by a controller class that
///  knows about the views - and hence the bounds coordinates - and
///  the coordinate system used - and thus also the data coordinates.
///
///  @note The access to values in the data model is always done in
///        the data coordinates since some classes may need this
///        information, e.g.  coordinate axis etc. This requirements
///        explains the need for a mediator class that can utilize
///        both kinds of information.
///
///
///  Created by Wolfram Schroers on 23.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@protocol WSPlotDelegate <NSObject>

@required

/** Return the X-coordinate axis range. */
- (NARange)rangeXD;

/** Return the Y-coordinate axis range. */
- (NARange)rangeYD;

/** Set the X-coordinate axis range. */
- (void)setRangeXD:(NARange)rangeXD;

/** Set the Y-coordinate axis range. */
- (void)setRangeYD:(NARange)rangeYD;

/** Set the X- and Y-coordinate axis scale methods. */
- (void)setCoordinateScaleX:(WSCoordinateScale)scaleX
                     scaleY:(WSCoordinateScale)scaleY;

/** Return the X-coordinate inverted flag. */
- (BOOL)invertedX;

/** Return the Y-coordinate inverted flag. */
- (BOOL)invertedY;

/** Return the X bound coordinate of a given data coordinate. */
- (NAFloat)boundsWithDataX:(NAFloat)aDatumD;

/** Return the Y bound coordinate of a given data coordinate. */
- (NAFloat)boundsWithDataY:(NAFloat)aDatumD;


@optional

/** Return the X-data coordinate of a given bounds coordinate. */
- (NAFloat)dataWithBoundsX:(NAFloat)aDatum;

/** Return the Y-data coordinate of a given bounds coordinate. */
- (NAFloat)dataWithBoundsY:(NAFloat)aDatum;

@end
