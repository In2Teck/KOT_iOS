//
//  MultiLines.m
//  PowerPlot
//
//  Created by Wolfram Schroers on 04.08.11.
//  Copyright 2011 Numerik & Analyse Schroers. All rights reserved.
//

#import "MultiLines.h"
#import "DemoData.h"
#import "PowerPlot.h"


@implementation MultiLines

@synthesize chart;


- (void)dealloc
{
    self.chart = nil;
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Create a few line plots with their controllers.
    WSPlotAxis *axis = [[WSPlotAxis alloc] initWithFrame:self.chart.frame];
    
//    WSPlotData *line1 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
//    WSPlotData *line2 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
    WSPlotData *line3 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
//    WSPlotData *line4 = [[WSPlotData alloc] initWithFrame:self.chart.frame];
    WSPlotController *ctrlA = [WSPlotController new];
//    WSPlotController *ctrl1 = [WSPlotController new];
//    WSPlotController *ctrl2 = [WSPlotController new];
    WSPlotController *ctrl3 = [WSPlotController new];
//    WSPlotController *ctrl4 = [WSPlotController new];
    ctrlA.view = axis;
//    ctrl1.view = line1;
//    ctrl2.view = line2;
    ctrl3.view = line3;
//    ctrl4.view = line4;
//    ctrl1.dataD = [DemoData stocks1];
//    ctrl2.dataD = [DemoData stocks2];
    ctrl3.dataD = [DemoData stocks3];
//    ctrl4.dataD = [DemoData stocks4];
    
    // Configure the appearance of the plots.

    axis.axisStyleX = kAxisPlain;//kAxisPlain
    axis.gridStyleX = kGridDotted;//Delete line
    axis.axisStyleY = kAxisPlain;//kAxisNone
    axis.gridStyleY = kGridDotted;//kGridDotted
    [axis.ticksX setTickLabelsWithStrings:[NSArray arrayWithObjects:@"", @"F", @"M",
                                           @"A", @"M", @"J", @"J", @"A", @"S", @"O",
                                           @"N", @"D", nil]];
    axis.ticksX.ticksStyle = kTicksLabels;
    
    
    axis.axisStrokeWidth = 0.5;
    [axis.ticksY autoTicksWithRange:NARangeMake(0.0, 200.0) withNumber:10];

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [axis.ticksY setTickLabelsWithFormatter:formatter];
     axis.ticksY.ticksStyle = kTicksLabels;
    
    axis.gridStrokeWidth = 1.0;
//    line1.lineColor = [UIColor redColor];
//    line2.lineColor = [UIColor blueColor];
    line3.lineColor = [UIColor greenColor];
//    line4.lineColor = [UIColor blackColor];
//    line1.symbolStyle = kSymbolEmptySquare;
//    line2.symbolStyle = kSymbolTriangleUp;
    line3.symbolStyle = kSymbolDisk;
//    line4.symbolStyle = kSymbolSquare;
//    line1.symbolColor = line1.lineColor;
//    line2.symbolColor = line2.lineColor;
    line3.symbolColor = line3.lineColor;
//    line4.symbolColor = line4.lineColor;
    line3.symbolSize = 8.0;
//    line2.hasShadow = YES;
    line3.hasShadow = YES;
//    line4.hasShadow = YES;
//    line2.shadowScale = 2.0;
//    line4.shadowScale = 10.0;
//    line1.intStyle = kInterpolationSpline;
//    line2.intStyle = kInterpolationSpline;
    line3.intStyle = kInterpolationSpline;
    
    // Finally, add them to the chart.
    [self.chart addPlot:ctrlA];
//    [self.chart addPlot:ctrl1];
//    [self.chart addPlot:ctrl2];
    [self.chart addPlot:ctrl3];
//    [self.chart addPlot:ctrl4];
    [self.chart autoscaleAllAxisX];
    [self.chart autoscaleAllAxisY];
    [self.chart setAllAxisLocationXD:0.0];
    [self.chart setAllAxisLocationYD:0.0];
    [self.chart setChartTitle:@"Multiple stocks"];
    
    [axis release];
//    [line1 release];
//    [line2 release];
    [line3 release];
//    [line4 release];
    [ctrlA release];
//    [ctrl1 release];
//    [ctrl2 release];
    [ctrl3 release];
//    [ctrl4 release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.chart = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation | (UIInterfaceOrientationLandscapeLeft &
                                    UIInterfaceOrientationLandscapeRight &
                                    UIInterfaceOrientationPortrait));
}

@end
