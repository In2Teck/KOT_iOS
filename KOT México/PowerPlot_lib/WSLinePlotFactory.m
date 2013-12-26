///
///  @file
///  WSLinePlotFactory.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 15.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSLinePlotFactory.h"
#import "WSColorScheme.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSPlot.h"
#import "WSPlotAxis.h"
#import "WSPlotController.h"
#import "WSPlotData.h"
#import "WSTicks.h"


@implementation WSChart (WSLinePlotFactory)

+ (id)linePlotWithFrame:(CGRect)frame
               withData:(WSData *)data
              withStyle:(LPStyle)style
          withAxisStyle:(CSStyle)axis
        withColorScheme:(LPColorScheme)colors
             withLabelX:(NSString *)labelX
             withLabelY:(NSString *)labelY {

    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];

    // Configure the chart.
    [chart configureWithData:data
                   withStyle:style
               withAxisStyle:axis
             withColorScheme:colors
                  withLabelX:labelX
                  withLabelY:labelY];
     
    // And return it.
    return [chart autorelease];
}

- (void)configureWithData:(WSData *)data
                withStyle:(LPStyle)style
            withAxisStyle:(CSStyle)axis
          withColorScheme:(LPColorScheme)colors
               withLabelX:(NSString *)labelX
               withLabelY:(NSString *)labelY {
    
    // Remove all previous data.
    [self removeAllPlots];
    
    
    // Create three controllers: One for the coordinate system, one
    // for a (possible) grid system and one for the plot.
    WSPlotController *myAxisController = [[WSPlotController alloc] init];
    WSPlotController *myGridController = [[WSPlotController alloc] init];
    WSPlotController *myPlotController = [[WSPlotController alloc] init];
    
    // Setup the plots for the controllers (the grid is configured,
    // but only added if needed).
    WSPlotAxis *myAxis = [[WSPlotAxis alloc] initWithFrame:[self bounds]];
    WSPlotAxis *myGrid = [[WSPlotAxis alloc] initWithFrame:[self bounds]];
    WSPlotData *myPlot = [[WSPlotData alloc] initWithFrame:[self bounds]];
    [myAxisController setView:myAxis];
    [myGridController setView:myGrid];
    [myPlotController setView:myPlot];
    [myPlotController setDataD:data];
    [myGrid setAllDisplaysOff];
    
    // Only one coordinate system is needed, sync the others from the
    // axis controller.
    [myAxisController setCoordX:[myPlotController coordX]];
    [myAxisController setCoordY:[myPlotController coordY]];
    [myGridController setCoordX:[myPlotController coordX]];
    [myGridController setCoordY:[myPlotController coordY]];
    
    
    // Configure the plots (there is the coordinate axis system and
    // the data plot).
    
    // First, configure the color scheme.
    WSColorScheme *cs = [[WSColorScheme alloc] initWithScheme:colors];
    
    // Set colors for the axis.
    [myAxis setLabelColorX:[cs foreground]];
    [myAxis setLabelColorY:[cs foreground]];
    [myAxis setAxisColor:[cs foreground]];
    [myGrid setGridColor:[cs receded]];
    
    // Set colors for the plot.
    [myPlot setSymbolColor:[cs spotlight]];
    [myPlot setErrorBarColor:[cs foreground]];
    [myPlot setLineColor:[cs spotlight]];
    [myPlot setFillColor:[cs highlight]];
    
    // Set own background color.
    [self setBackgroundColor:[cs background]];
    
    
    // Configure the coordinate axis.
    [[myAxis ticksX] setTicksStyle:kTicksNone];
    [[myAxis ticksY] setTicksStyle:kTicksNone];
    [[myAxis ticksX] setTicksDir:kTDirectionNone];
    [[myAxis ticksY] setTicksDir:kTDirectionNone];
    [[myAxis ticksX] setMinorTicksNum:2];
    [[myAxis ticksY] setMinorTicksNum:2];
    [[myAxisController coordY] setInverted:YES];
    [myAxis setDrawBoxed:NO];
    [myAxis setGridStyleX:kGridNone];
    [myAxis setGridStyleY:kGridNone];
    [myAxis setLabelStyleX:kLabelInside];
    [myAxis setLabelStyleY:kLabelInside];
    [myAxis setAxisLabelX:labelX];
    [myAxis setAxisLabelY:labelY];    
    [myAxis setLabelFontX:[UIFont systemFontOfSize:12.0]];
    [myAxis setLabelFontY:[UIFont systemFontOfSize:12.0]];
    switch (axis) {
        case kCSNone:
            [myAxis setAxisStyleX:kAxisNone];
            [myAxis setAxisStyleY:kAxisNone];
            break;
        case kCSBoxed:
            [myAxis setDrawBoxed:YES];
            [myAxis setAxisOverhangX:0.0];
            [myAxis setAxisOverhangY:0.0];
            [myAxis setAxisPaddingX:0.0];
            [myAxis setAxisPaddingY:0.0];
            [myAxis setLabelStyleX:kLabelInside];
            [myAxis setLabelStyleY:kLabelInside];
        case kCSPlain:
            [[myAxis ticksX] setTicksDir:kTDirectionIn];
            [[myAxis ticksY] setTicksDir:kTDirectionIn];
            [myAxis setAxisStyleX:kAxisPlain];
            [myAxis setAxisStyleY:kAxisPlain];
            break;
        case kCSGrid:
            [myGrid setGridStyleX:kGridDotted];
            [myGrid setGridStyleY:kGridDotted];
            [myGrid setGridStrokeWidth:([myAxis gridStrokeWidth] / 3.0)];
            [[myAxis ticksX] setTicksStyle:kTicksLabelsSlanted];
            [[myAxis ticksY] setTicksStyle:kTicksLabelsSlanted];
            [[myAxis ticksX] setTicksDir:kTDirectionInOut];
            [[myAxis ticksY] setTicksDir:kTDirectionInOut];
            [myAxis setAxisStyleX:kAxisArrowFilledHead];
            [myAxis setAxisStyleY:kAxisArrowFilledHead];
            break;
        case kCSArrows:
            [[myAxis ticksX] setTicksStyle:kTicksLabelsSlanted];
            [[myAxis ticksY] setTicksStyle:kTicksLabels];
            [[myAxis ticksX] setTicksDir:kTDirectionInOut];
            [[myAxis ticksY] setTicksDir:kTDirectionInOut];
            [myAxis setAxisStyleX:kAxisArrowFilledHead];
            [myAxis setAxisStyleY:kAxisArrowFilledHead];
            break;
        default:
            break;
    }


    // Finally configure the plot.
    [myPlot setSymbolSize:15.0];
    [myPlot setSymbolStyle:kSymbolNone];
    [myPlot setErrorStyle:kErrorNone];
    [myPlot setDashStyle:kDashingSolid];
    switch (style) {
        case kChartLineEmpty:
            [myPlot setLineStyle:kLineNone];
            break;
        case kChartLinePlain:
            [myPlot setLineStyle:kLineRegular];
            break;
        case kChartLineFilled:
            [myPlot setLineWidth:3.0];
            [myPlot setLineStyle:kLineFilledColor];
            break;
        case kChartLineGradient:
            [myPlot setFillGradientFromColor:[myPlot fillColor]
                                     toColor:[UIColor clearColor]];
            [myPlot setLineStyle:kLineFilledGradient];
            break;
        case kChartLineScientific:
            [myPlot setErrorStyle:kErrorXYCapped];
            [myPlot setLineStyle:kLineRegular];
            [myPlot setSymbolStyle:kSymbolDisk];
            break;
        default:
            break;
    }
    
    
    // Add the controllers to the chart.
    if (axis == kCSGrid) {
        [self addPlot:myGridController];
    }
    [self addPlot:myPlotController];
    [self addPlot:myAxisController];
    
    // Do the axis scaling & tick labelling of the finished graph.
    [self autoscaleAllAxisX];
    [self autoscaleAllAxisY];
    [self setAllAxisLocationXD:[self dataRangeXD].rMin];
    [self setAllAxisLocationYD:[self dataRangeYD].rMin];
    [myAxis autoTicksXD];
    [myAxis autoTicksYD];
    [myAxis setTickLabelsX];
    [myAxis setTickLabelsY];
    [myGrid autoTicksXD];
    [myGrid autoTicksYD];
        
    // Release the objects (they are retained by the respective
    // NSMutableArray objects).
    [myPlot release];
    [myGrid release];
    [myAxis release];
    [myPlotController release];
    [myGridController release];
    [myAxisController release];
    [cs release];
}

@end
