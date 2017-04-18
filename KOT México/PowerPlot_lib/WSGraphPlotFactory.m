///
///  @file
///  WSGraphPlotFactory.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 20.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSGraphPlotFactory.h"
#import "WSColorScheme.h"
#import "WSConnection.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSGraph.h"
#import "WSGraphConnections.h"
#import "WSNodeProperties.h"
#import "WSPlot.h"
#import "WSPlotController.h"
#import "WSPlotGraph.h"


@implementation WSChart (WSGraphPlotFactory)


+ (id)graphPlotWithFrame:(CGRect)frame
               withGraph:(WSGraph *)data
         withColorScheme:(LPColorScheme)colors {
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithGraph:data
              withColorScheme:colors];
    
    // And return it.
    return [chart autorelease];
}

- (void)configureWithGraph:(WSGraph *)data
           withColorScheme:(LPColorScheme)colors {
    
    // Remove all previous data.
    [self removeAllPlots];
    
    
    // Create a controller for the plot.
    WSPlotController *graphController = [[WSPlotController alloc] init];
    [self addPlot:graphController];
    
    // Setup the plots for the controllers.
    WSPlotGraph *graph = [[WSPlotGraph alloc] initWithFrame:[self bounds]];
    [graphController setView:graph];
    [graphController setDataD:data];
    
    
    // Configure the plot.
    
    // First, configure the color scheme.
    WSColorScheme *cs = [[WSColorScheme alloc] initWithScheme:colors];
    
    // Set colors for the graph.
    [graph setStyle:kGraphPlotUnified];
    [data colorAllConnections:[cs foreground]];
    [[graph nodeDefault] setOutlineColor:[cs spotlight]];
    [[graph nodeDefault] setNodeColor:[cs highlight]];
    [[graph nodeDefault] setShadowColor:[cs shadow]];
    [[graph nodeDefault] setLabelColor:[cs foreground]];
    
    // Set own background color.
    [self setBackgroundColor:[cs background]];
    
    
    // Automatic axis scaling.
    [self autoscaleAllAxisX];
    [self autoscaleAllAxisY];
    
    
    // Release the objects (they are retained by the container objects).
    [graph release];
    [graphController release];
    [cs release];
}

@end
