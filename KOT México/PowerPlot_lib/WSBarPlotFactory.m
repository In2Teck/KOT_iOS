///
///  @file
///  WSBarPlotFactory.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 20.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSBarPlotFactory.h"
#import "WSBarProperties.h"
#import "WSColorScheme.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSPlot.h"
#import "WSPlotAxis.h"
#import "WSPlotBar.h"
#import "WSPlotController.h"
#import "WSTicks.h"


@implementation WSChart (WSBarPlotFactory)

+ (id)barPlotWithFrame:(CGRect)frame
              withData:(WSData *)data
             withStyle:(BPStyle)style
       withColorScheme:(LPColorScheme)colors {
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithData:[NSArray arrayWithObject:data]
                   withStyle:style
             withColorScheme:colors];
    [[chart plotAtIndex:0] setCoordX:[[chart plotAtIndex:1] coordX]];
    [[chart plotAtIndex:0] setCoordY:[[chart plotAtIndex:1] coordY]];
    
    // And return it.
    return [chart autorelease];
}

+ (id)multiBarPlotWithFrame:(CGRect)frame
                   withData:(NSArray *)data
                  withStyle:(BPStyle)style
            withColorScheme:(LPColorScheme)colors {
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithData:data
                   withStyle:style
             withColorScheme:colors];
    
    // And return it.
    return [chart autorelease];    
}

+ (id)barPlotWithFrame:(CGRect)frame
              withData:(WSData *)data
         withBarColors:(NSArray *)barCols
             withStyle:(BPStyle)style
       withColorScheme:(LPColorScheme)colors {
    
    NSParameterAssert([data count] == [barCols count]);
    
    
    // Instantiate the chart.
    WSChart *chart = [[self alloc] initWithFrame:frame];
    
    // Configure the chart.
    [chart configureWithData:[NSArray arrayWithObject:data]
                   withStyle:style
             withColorScheme:colors];
    [[chart plotAtIndex:0] setCoordX:[[chart plotAtIndex:1] coordX]];
    [[chart plotAtIndex:0] setCoordY:[[chart plotAtIndex:1] coordY]];
    
    // Set appropriate individual colors.
    NSUInteger i = 0;
    WSPlotBar *barPlot = (WSPlotBar *)[[chart plotAtIndex:0] view];
    [barPlot setAllBarsToDefault];
    [barPlot setStyle:kBarPlotIndividual];
    for (WSDatum *datum in [barPlot dataD]) {
        WSBarProperties *prop = (WSBarProperties *)[datum customDatum];
        if ([prop respondsToSelector:@selector(setBarColor:)]) {
             [prop setBarColor:(UIColor *)[barCols objectAtIndex:i]];
        }
        i++;
    }
    
    // And return it.
    return [chart autorelease];
}

- (void)configureWithData:(NSArray *)data
                withStyle:(BPStyle)style
          withColorScheme:(LPColorScheme)colors {

    NSUInteger i;
    NSUInteger num = [data count];

    
    // Remove all previous data.
    [self removeAllPlots];
    if (style == kChartBarEmpty) {
        return;
    }

    // Initialize the plots.
    WSPlotAxis *axis = [[WSPlotAxis alloc] initWithFrame:[self bounds]];
    NSMutableArray *barPlots = [[NSMutableArray alloc]
                                initWithCapacity:num];
    for (i=0; i<num; i++) {
        [barPlots addObject:(WSPlotBar *)[[[WSPlotBar alloc]
                                            initWithFrame:[self bounds]]
                                          autorelease]];
    }
    
    // Initialize the controllers.
    WSPlotController *axisController = [[WSPlotController alloc] init];
    NSMutableArray *barControllers = [[NSMutableArray alloc]
                                      initWithCapacity:num];
    [axisController setView:axis];
    [[axisController coordY] setInverted:YES];
    for (i=0; i<num; i++) {
        WSPlotController *ctl = [[WSPlotController alloc] init];
        [ctl setView:[barPlots objectAtIndex:i]];
        [ctl setDataD:[data objectAtIndex:i]];
        [[ctl coordY] setInverted:YES];
        [barControllers addObject:ctl];
        [ctl release];
    }
    
    // Add plot controllers.
    for (WSPlotController *ctl in barControllers) {
        [self addPlot:ctl];
    }
    [self addPlot:axisController];
    [axisController release];
    [axis release];

    // Scale axis and adjust coordinate systems.
    [self autoscaleAllAxisX];
    [self autoscaleAllAxisY];
    [self setAllAxisLocationXD:[self dataRangeXD].rMin];
    [self setAllAxisLocationYD:[self dataRangeYD].rMin];

    
    // Configure the axis.
    [[axis ticksX] setMinorTicksNum:0];
    [[axis ticksY] setMinorTicksNum:1];
    [[axis ticksX] setTicksStyle:kTicksLabelsSlanted];
    [[axis ticksX] setTicksDir:kTDirectionOut];
    [[axis ticksY] setTicksStyle:kTicksLabelsSlanted];
    [[axis ticksY] setTicksDir:kTDirectionInOut];
    [axis setTicksXDAndLabelsWithData:[data objectAtIndex:0]];
    [[axis ticksY] autoTicksWithRange:[self dataRangeYD]
                           withNumber:5];
    [[axis ticksY] setTickLabels];
    [axis setAxisStyleX:kAxisPlain];
    [axis setAxisStyleY:kAxisArrow];

    
    // Configure the color scheme.
    WSColorScheme *cs = [[WSColorScheme alloc] initWithScheme:colors];
    
    // Set colors for the axis.
    [axis setLabelColorX:[cs foreground]];
    [axis setLabelColorY:[cs foreground]];
    [axis setAxisColor:[cs foreground]];
    
    // Configure and set colors for the bar plot(s).
    NARange datRangeD = [self dataRangeXD];
    NARange datRange = NARangeMake([axis boundsWithDataX:datRangeD.rMin],
                                   [axis boundsWithDataX:datRangeD.rMax]);
    NAFloat barWidth = [self bounds].size.width / 2.0;
    NSUInteger colIndex = 0;
    NSArray *barCols = [cs highlightArray];
    for (WSPlotBar *bar in barPlots) {
        [bar setStyle:kBarPlotUnified];
        NAFloat thisWidth = (NARangeLen(datRange) /
                             ([[bar dataD] count] * 2.0));
        barWidth = fmin(thisWidth, barWidth);
        WSBarProperties *defaults = [bar barDefault];
        [defaults setStyle:kBarFilled];
        [defaults setHasShadow:NO];
        [defaults setShadowColor:[cs shadow]];
        [defaults setOutlineColor:[cs spotlight]];
        [defaults setBarColor:[barCols objectAtIndex:colIndex]];
        colIndex++;
        if (colIndex == [barCols count]) {
            colIndex = 0;
        }
    }
    switch (style) {
        case kChartBarPlain:
            break;
        case kChartBarTouch:
            barWidth /= num;
            break;
        case kChartBarDisplaced:
            if (num > 1) {
                barWidth /= (num / 2);
            }
            break;
        default:
            break;
    }
    for (WSPlotBar *bar in barPlots) {
        [[bar barDefault] setBarWidth:barWidth];
    }
    if (num == 1) {
        [[[barPlots objectAtIndex:0] barDefault] setHasShadow:YES];
    }
    
    // Correct Y-axis location based on bar width.
    NAFloat shift = fmax(2.0*[[axis ticksY] majorTicksLen], 1.5*barWidth);
    [self setAllAxisLocationX:[axis axisLocationX] - shift];
    [self setAllAxisLocationXD:[[axisController coordX] transformBounds:[axis axisLocationX]
                                                               withSize:[self bounds].size.width]];
    
    
    // Set own background color.
    [self setBackgroundColor:[cs background]];


    // Bar displacement.
    NAFloat displaced = 0.0;
    NAFloat current;
    switch (style) {
        case kChartBarPlain:
            break;
        case kChartBarTouch:
            for (i=0; i<num; i++) {
                current = [[[barControllers objectAtIndex:i] coordX] coordOrigin];
                [[[barControllers objectAtIndex:i] coordX] setCoordOrigin:(current + displaced)];
                displaced += barWidth;
            }
            break;
        case kChartBarDisplaced:
            for (i=0; i<num; i++) {
                current = [[[barControllers objectAtIndex:i] coordX] coordOrigin];
                [[[barControllers objectAtIndex:i] coordX] setCoordOrigin:(current + displaced)];
                displaced += barWidth / num;
            }
            break;
        default:
            break;
    }
    
    // Release the objects (they are retained by the container objects).
    [barPlots release];
    [barControllers release];
    [cs release];
}

@end
