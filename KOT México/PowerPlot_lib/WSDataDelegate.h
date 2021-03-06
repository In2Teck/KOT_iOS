#import <UIKit/UIKit.h>
#import "NARange.h"


@class WSData;
@class WSGraphConnections;


///
///  WSDataDelegate.h
///  PowerPlot
///
///  This protocol defines methods that must be implemented by a class
///  that provides access to a data model controller class WSData. The
///  methods cover the minimum access methods any class that can
///  handle data is required to implement.
///
///  If the data source is not of type WSData, but of type WSGraph
///  then the optional method to return the set of WSGraphConnections
///  should be implemented, too.
///
///
///  Created by Wolfram Schroers on 07.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@protocol WSDataDelegate <NSObject>

@required

/** Return the associated data from the data source (via delegate). */
- (WSData *)dataD;

/** Return the X-axis range covered by the current data set. */
- (NARange)dataRangeXD;

/** Return the Y-axis range covered by the current data set. */
- (NARange)dataRangeYD;


@optional

/** Return the associated connections from the data source (via delegate). */
- (WSGraphConnections *)connections;

/** Inform the delegate that the data has been updated. */
- (void)dataDidUpdate;

@end
