#import <Foundation/Foundation.h>
#import "WSObject.h"
#import "WSDataDelegate.h"
#import "WSPlotDelegate.h"


@class WSPlot;
@class WSCoordinate;
@class WSData;


///
///  WSPlotController.h
///  PowerPlot
///
///  This class is a controller class that manages both a data model
///  object and a view object in PowerPlot. The data object contains
///  information in data coordinates (which is whatever the user
///  decides to use) and the view object is a subplot (data curve,
///  bar/pie charts, coordinate axis and related properties etc.) of
///  the chart.
///
///  Each controller handles one PowerPlot view object (which is
///  typically a subclass of WSPlot), the two coordinate axis (class
///  WSCoordinate) and optionally an instance of WSData. In the latter
///  case it must implement the WSDataDelegate formal protocol that
///  defines methods for accessing the data.
///
///  This controller also implements the WSPlotDelegate formal
///  protocol that provides methods for conversion of screen/bounds
///  and data coordinates.
///
///  @note An instance of WSPlotController is <strong>not</strong> a
///        user interface view controller, but rather an abstraction
///        to combine data model objects and view objects. Although
///        its view is accessed only indirectly via [instVar view],
///        from the users' point of view it is a view which is
///        internally split up according to the MVC paradigm.  This is
///        the reason why WSPlotController inherits directly from
///        WSObject rather from a UIController or a UIView.
///
///  @note It is, of course, possible to also use other view objects
///        (like UILabel instances etc.) in this controller. That is a
///        mechanism to add more customization to a plot.
///
///  @note Each WSPlotController in the chart retains each own
///        coordinate system. Thus, charts containing multiple plots -
///        which is the norm as coordinate axis count as one type of
///        plot, curves with data as another and users typically want
///        at least a copy of each one of those in their chart - can
///        have different coordinate systems. This may not always be
///        the best choice and may also not be what a user expects;
///        for the purpose of flexibility (like the ability to combine
///        data sets with different units) this flexibility is still
///        allowed.
///
///
///  Created by Wolfram Schroers on 06.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSPlotController : WSObject <WSPlotDelegate, WSDataDelegate> {

    WSPlot *_view;
    WSCoordinate *_coordX,
                 *_coordY;
    WSData *_dataD;
}

@property (retain, nonatomic) WSPlot *view; ///< View handled by this controller.
@property (retain) WSCoordinate *coordX;    ///< Abscissa axis.
@property (retain) WSCoordinate *coordY;    ///< Ordinate axis.
@property (retain) WSData *dataD;           ///< Data in this plot.

/** @brief Activate data bindings for this specific plot instance.
 
    When the data set associated with a particular instance of a subclass
    of WSPlot is changed and this flag is turned on, then the graph will
    automatically be redrawn.
 
    The default value is NO, i.e., the graph is not updated.
 */
@property (nonatomic) BOOL bindings;

@end
