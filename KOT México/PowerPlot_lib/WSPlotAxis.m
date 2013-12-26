///
///  @file
///  WSPlotAxis.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 25.09.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotAxis.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSTicks.h"
#import <math.h>


@implementation WSPlotAxis

@synthesize axisStyleX, axisStyleY, axisColor,
            axisOverhangX, axisOverhangY, axisPaddingX, axisPaddingY,
            axisArrowLength, axisStrokeWidth, drawBoxed,
            ticksX, ticksY,
            gridStyleX, gridStyleY, gridStrokeWidth, gridColor,
            labelStyleX, labelStyleY,
            axisLabelX, axisLabelY, labelFontX, labelFontY,
            labelColorX, labelColorY;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Reset the axis to default values.
        axisStyleX = kAxisPlain;
        axisStyleY = kAxisPlain;
        axisColor = [[UIColor blackColor] retain];
        ticksX = [[WSTicks alloc] init];
        ticksY = [[WSTicks alloc] init];
        drawBoxed = NO;//NO
        axisOverhangX = kAOverhangX;
        axisOverhangY = kAOverhangY;
        axisPaddingX = kAPaddingX;
        axisPaddingY = kAPaddingY;
        axisArrowLength = kAArrowLength;
        axisStrokeWidth = kAStrokeWidth;
        gridStyleX = kGridPlain;//kGridNone
        gridStyleY = kGridDotted;//kGridNone
        gridStrokeWidth = kAStrokeWidth;
        gridColor = [[UIColor grayColor] retain];
        axisLabelX = @""; //@""
        axisLabelY = @"";//@""
        [axisLabelX retain];
        [axisLabelY retain];
        labelFontX = kALabelFont;
        labelFontY = kALabelFont;
        labelColorX = [[UIColor blackColor] retain];
        labelColorY = [[UIColor blackColor] retain];
    }
    return self;
}


- (BOOL)hasData {
    return NO;
}


#pragma mark -
#pragma mark Plot handling

- (void)setAllDisplaysOff {
    // Override this method if a plots presents something on the canvas.
    // Reset the plot to use only no-display parameters in all customizable values.
    [self setAxisStyleX:kAxisPlain];//kAxisNone
    [self setAxisStyleY:kAxisPlain];//kAxisNone
    [[self ticksX] setTicksStyle:kTicksLabels];//kTicksNone
    [[self ticksY] setTicksStyle:kTicksLabels];//kTicksNone
    [[self ticksX] setTicksDir:kTDirectionNone];//kTDirectionNone
    [[self ticksY] setTicksDir:kTDirectionNone];//kTDirectionNone
    [self setDrawBoxed:YES];//NO
    [self setGridStyleX:kGridDotted];//kGridNone
    [self setGridStyleY:kGridDotted];//kGridNone
    [self setAxisLabelX:@""];
    [self setAxisLabelY:@""];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    NSUInteger i;
    NAFloat pos;
    NAFloat aLocX, aLocY;
    
    
    // Set the axis location.
    if ([self aLocXD]) {
        aLocX = [self boundsWithDataX:[[self aLocXD] floatValue]];
    } else {
        aLocX = [self axisLocationX];
    }
    if ([self aLocYD]) {
        aLocY = [self boundsWithDataY:[[self aLocYD] floatValue]];
    } else {
        aLocY = [self axisLocationY];
    }
    
    // Remove previous labels (if any).
    for (UIView* label in [self subviews]) {
        [label removeFromSuperview];
    }
        
    // First, plot the grid bars (if any). These are always below the
    // other objects and thus are drawn first.

    // First, do the X-grid.
    if ([self gridStyleX] != kGridNone) {
        CGContextBeginPath(myContext);
        [[self gridColor] set];
        CGContextSetLineWidth(myContext, [self gridStrokeWidth]);
        if ([self gridStyleX] == kGridPlain) {
            NAContextSetLineDash(myContext, kDashingSolid);
        } else if ([self gridStyleX] == kGridDotted) {
            NAContextSetLineDash(myContext, kDashingDotted);
        }
        for (i=0; i<[[self ticksX] count]; i++) {
            pos = [self boundsWithDataX:[[self ticksX] tickAtIndex:i]];
            if ((pos > ([self axisPaddingX] - [self axisOverhangX])) &&
                (pos < ([self bounds].size.width - [self axisPaddingX]))) {
                // Place a grid bar at the current location.
                CGContextMoveToPoint(myContext,
                                     pos, 
                                     ([self bounds].size.height - 
                                      [self axisPaddingY]));
                CGContextAddLineToPoint(myContext, 
                                        pos, 
                                        [self axisPaddingY]);                
            }
        }
        CGContextDrawPath(myContext, kCGPathStroke);
    }
    
    // Then, draw the Y-grid.
    if ([self gridStyleY] != kGridNone) {
        CGContextBeginPath(myContext);
        [[self gridColor] set];
        CGContextSetLineWidth(myContext, [self gridStrokeWidth]);
        if ([self gridStyleY] == kGridPlain) {
            NAContextSetLineDash(myContext, kDashingSolid);
        } else if ([self gridStyleY] == kGridDotted) {
            NAContextSetLineDash(myContext, kDashingDotted);
        }
        for (i=0; i<[[self ticksY] count]; i++) {
            pos = [self boundsWithDataY:[[self ticksY] tickAtIndex:i]];
            if ((pos > [self axisPaddingY]) &&
                (pos < ([self bounds].size.height - [self axisPaddingY]))) {
                // Place a grid bar at the current location.
                CGContextMoveToPoint(myContext,
                                     ([self bounds].size.width -
                                      [self axisPaddingX]),
                                     pos);
                CGContextAddLineToPoint(myContext, 
                                        [self axisPaddingX],
                                        pos);
            }
        }
        CGContextDrawPath(myContext, kCGPathStroke);
    }

    // Plot the coordinate axis.

    // First, plot the X-axis.
    [[self axisColor] set];
    NAContextSetLineDash(myContext, kDashingSolid);
    NAArrowStyle aStyle = kArrowLineArrow; //kArrowLineNone
    NAFloat startX = [self axisPaddingX] - [self axisOverhangX];
    NAFloat endX = [self bounds].size.width - [self axisPaddingX];
    NAFloat startY = aLocY;
    NAFloat endY = startY;
    BOOL xPointsRight = YES;
    if ([self invertedX]) {
        NAFloat tmp = startX;
        startX = endX;
        endX = tmp;
        xPointsRight = !xPointsRight;
    }
    if (([self axisStyleX] == kAxisArrowInverse) ||
        ([self axisStyleX] == kAxisArrowFilledHeadInverse)) {
        NAFloat tmp = startX;
        startX = endX;
        endX = tmp;
        xPointsRight = !xPointsRight;
    }
    switch ([self axisStyleX]) {
        case kAxisArrowFilledHead:
        case kAxisArrowFilledHeadInverse:
            aStyle = kArrowLineFilledHead;
            break;
        case kAxisArrow:
        case kAxisArrowInverse:
            aStyle = kArrowLineArrow;
            break;
        case kAxisPlain:
            aStyle = kArrowLinePlain;
            break;
        case kAxisNone:
        default:
            aStyle = kArrowLineNone;
            break;
    }
    NAContextAddLineArrow(myContext,
                          aStyle,
                          CGPointMake(startX, startY),
                          CGPointMake(endX, endY),
                          [self axisArrowLength],
                          [self axisStrokeWidth]);
    
    // Then plot the Y-axis.
    startX = aLocX;
    endX = startX;
    startY = [self axisPaddingY];
    endY = ([self bounds].size.height -
            [self axisPaddingY] +
            [self axisOverhangY]);
    BOOL yPointsUp = YES;
    if ([self invertedY]) {
        NAFloat tmp = startY;
        startY = endY;
        endY = tmp;
        yPointsUp = !yPointsUp;
    }        
    if (([self axisStyleY] == kAxisArrowInverse) ||
        ([self axisStyleY] == kAxisArrowFilledHeadInverse)) {
        NAFloat tmp = startY;
        startY = endY;
        endY = tmp;
        yPointsUp = !yPointsUp;
    }
    switch ([self axisStyleY]) {
        case kAxisArrowFilledHead:
        case kAxisArrowFilledHeadInverse:
            aStyle = kArrowLineFilledHead;            
            break;
        case kAxisArrow:
        case kAxisArrowInverse:
            aStyle = kArrowLineArrow;            
            break;
        case kAxisPlain:
            aStyle = kArrowLinePlain;
            break;
        case kAxisNone:
        default:
            aStyle = kArrowLineNone;
            break;
    }
    NAContextAddLineArrow(myContext,
                          aStyle,
                          CGPointMake(startX, startY),
                          CGPointMake(endX, endY),
                          [self axisArrowLength],
                          [self axisStrokeWidth]);    

    // Now plot the box.
    if ([self drawBoxed]) {
        [[self axisColor] set];
        CGContextMoveToPoint(myContext,
                             [self axisPaddingX],
                             [self bounds].size.height -
                             [self axisPaddingY]);
        CGContextAddLineToPoint(myContext,
                                [self bounds].size.width -
                                [self axisPaddingX],
                                [self bounds].size.height -
                                [self axisPaddingY]);
        CGContextAddLineToPoint(myContext, 
                                [self bounds].size.width -
                                [self axisPaddingX], 
                                [self axisPaddingY]);
        CGContextAddLineToPoint(myContext, 
                                [self axisPaddingX], 
                                [self axisPaddingY]);
        CGContextAddLineToPoint(myContext, 
                                [self axisPaddingX], 
                                [self bounds].size.height -
                                [self axisPaddingY]);
    }
    
    // Now plot the axis ticks and the axis tick labels.
    
    // First, do the X-axis.
    CGContextSetLineWidth(myContext, [self axisStrokeWidth]);
        
    // Move along the X-axis until the end.
    startX = [self axisPaddingX] - [self axisOverhangX];
    endX = [self bounds].size.width - [self axisPaddingX];
    if (xPointsRight) {
        endX -= [self axisArrowLength];
    } else {
        startX += [self axisArrowLength];
    }
    for (i=0; i<[[self ticksX] count]; i++) {
        pos = [self boundsWithDataX:[[self ticksX] tickAtIndex:i]];
        if ((pos > startX) && (pos < endX)) {
            
            // Place a major tick mark at the current location.
            switch ([[self ticksX] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         pos, 
                                         (aLocY +
                                          [[self ticksX] majorTicksLen]));
                    CGContextAddLineToPoint(myContext, 
                                            pos, 
                                            (aLocY -
                                             [[self ticksX] majorTicksLen]));
                    break;
                case kTDirectionIn:
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY -
                                             [[self ticksX] majorTicksLen]));
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));
                    CGContextAddLineToPoint(myContext, 
                                            pos, 
                                            (aLocY +
                                             [[self ticksX] majorTicksLen]));
                    break;
                default:
                    break;
            }

            // Add a label to the tick mark.
            if ([[self ticksX] ticksStyle] != kTicksNone) {
                NAFloat angle = 0.25*M_PI;
                NSString *labelString = [[self ticksX] labelAtIndex:i];
                UILabel *cLabel = [[UILabel alloc] init];
                CGSize labelSize = [labelString
                                    sizeWithFont:[self labelFontX]
                                    constrainedToSize:CGSizeMake(10000.0,10000.0)
                                    lineBreakMode:[cLabel lineBreakMode]];            
                [cLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth |
                                             UIViewAutoresizingFlexibleHeight)];
                [cLabel setTextAlignment:UITextAlignmentCenter];
                [cLabel setFont:[self labelFontX]];
                [cLabel setTextColor:[self labelColorX]];
                [cLabel setBackgroundColor:[UIColor clearColor]];
                [cLabel setText:labelString];
                CGRect newFrame = [cLabel frame];
                newFrame.size = labelSize;
                
                switch ([[self ticksX] ticksStyle]) {
                    case kTicksNone:
                        break;
                    case kTicksLabels:
                        newFrame.origin.x = pos - (labelSize.width / 2.0);
                        newFrame.origin.y = (aLocY +
                                             [[self ticksX] majorTicksLen] +
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsInverse:
                        newFrame.origin.x = pos - (labelSize.width / 2.0);
                        newFrame.origin.y = (aLocY -
                                             labelSize.height -
                                             [[self ticksX] majorTicksLen] -
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsSlanted:
                        newFrame.origin.x = pos;
                        newFrame.origin.y = (aLocY +
                                             [[self ticksX] majorTicksLen] +
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(angle)];
                        break;
                    case kTicksLabelsSlantedInverse:
                        newFrame.origin.x = pos;
                        newFrame.origin.y = (aLocY -
                                             newFrame.size.height -
                                             [[self ticksX] majorTicksLen] -
                                             [[self ticksX] labelOffset]);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(-angle)];                    
                        break;                    
                    default:
                        break;
                }
                [self addSubview:cLabel];
                [cLabel release];
                cLabel = nil;            
            }                
        }
    }
    
    // Next, do the Y-axis.
    CGContextSetLineWidth(myContext, [self axisStrokeWidth]);
    
    // Move along the Y-axis until the end.
    startY = [self axisPaddingY] - [self axisOverhangY];
    endY = [self bounds].size.height - [self axisPaddingY];
    if (yPointsUp) {
        endY -= [self axisArrowLength];
    } else {
        startY += [self axisArrowLength];
    }
    for (i=0; i<[[self ticksY] count]; i++) {
        pos = [self boundsWithDataY:[[self ticksY] tickAtIndex:i]];
        if ((pos > startY) && (pos < endY)) {
        
            // Place a major tick mark at the current location.
            switch ([[self ticksY] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         (aLocX +
                                          [[self ticksY] majorTicksLen]),
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] majorTicksLen]),
                                            pos);
                    break;
                case kTDirectionIn:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext,
                                            (aLocX +
                                             [[self ticksY] majorTicksLen]),
                                            pos);
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] majorTicksLen]),
                                            pos);
                    break;
                default:
                    break;
            }

            // Add a label to the tick mark.
            if ([[self ticksY] ticksStyle] != kTicksNone) {
                NAFloat angle = 0.25*M_PI;
                NSString *labelString = [[self ticksY] labelAtIndex:i];
                UILabel *cLabel = [[UILabel alloc] initWithFrame:[self bounds]];
                [cLabel setTextAlignment:UITextAlignmentCenter];
                [cLabel setFont:[self labelFontY]];
                [cLabel setTextColor:[self labelColorY]];
                [cLabel setBackgroundColor:[UIColor clearColor]];
                [cLabel setText:labelString];
                CGRect newFrame = [cLabel frame];
                CGSize labelSize = [labelString
                                    sizeWithFont:[cLabel font]
                                    constrainedToSize:CGSizeMake(10000.0,10000.0)
                                    lineBreakMode:[cLabel lineBreakMode]];
                newFrame.size = labelSize;
                
                switch ([[self ticksY] ticksStyle]) {
                    case kTicksNone:
                        break;
                    case kTicksLabels:
                        newFrame.origin.x = (aLocX -
                                             labelSize.width -
                                             [[self ticksY] majorTicksLen] -
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsInverse:
                        newFrame.origin.x = (aLocX +
                                             [[self ticksY] majorTicksLen] +
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        break;
                    case kTicksLabelsSlanted:
                        newFrame.origin.x = (aLocX -
                                             labelSize.width -
                                             [[self ticksY] majorTicksLen] -
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(angle)];
                        break;
                    case kTicksLabelsSlantedInverse:
                        newFrame.origin.x = (aLocX +
                                             [[self ticksY] majorTicksLen] +
                                             [[self ticksY] labelOffset]);
                        newFrame.origin.y = pos - (labelSize.height / 2.0);
                        [cLabel setFrame:newFrame];
                        [cLabel setTransform:CGAffineTransformMakeRotation(-angle)];                        
                    default:
                        break;
                }
                [self addSubview:cLabel];
                [cLabel release];
                cLabel = nil;            
            }                
        }
    }
    
    // Commit the path so far.
    CGContextDrawPath(myContext, kCGPathStroke);
    
    // Fill in minor tick marks between the major ones on the X-axis.
    CGContextBeginPath(myContext);
    CGContextSetLineWidth(myContext, [self axisStrokeWidth]/2.0);
    for (i=0; i<[[self ticksX] countMinor]; i++) {
        pos = [self boundsWithDataX:[[self ticksX] minorTickAtIndex:i]];
        if ((pos > startX) && (pos < endX)) {

            // Place a minor tick mark at the current location.
            switch ([[self ticksX] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         pos,
                                         (aLocY +
                                          [[self ticksX] minorTicksLen]));                        
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY -
                                             [[self ticksX] minorTicksLen]));                                                   
                    break;
                case kTDirectionIn:
                    break;
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY -
                                             [[self ticksX] minorTicksLen]));
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         pos, 
                                         (aLocY));                           
                    CGContextAddLineToPoint(myContext,
                                            pos,
                                            (aLocY +
                                             [[self ticksX] minorTicksLen]));
                    break;
                default:
                    break;
            }
        }
    }
    
    // Fill in minor tick marks between the major ones on the Y-axis.
    for (i=0; i<[[self ticksY] countMinor]; i++) {
        pos = [self boundsWithDataY:[[self ticksY] minorTickAtIndex:i]];
        if ((pos > startY) && (pos < endY)) {
            
            // Place a minor tick mark at the current location.
            switch ([[self ticksY] ticksDir]) {
                case kTDirectionNone:
                    break;
                case kTDirectionInOut:
                    CGContextMoveToPoint(myContext,
                                         (aLocX +
                                          [[self ticksY] minorTicksLen]),
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] minorTicksLen]),
                                            pos);
                    break;
                case kTDirectionIn:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext,
                                            (aLocX +
                                             [[self ticksY] minorTicksLen]),
                                            pos);
                    break;
                case kTDirectionOut:
                    CGContextMoveToPoint(myContext, 
                                         aLocX,
                                         pos);
                    CGContextAddLineToPoint(myContext, 
                                            (aLocX -
                                             [[self ticksY] minorTicksLen]),
                                            pos);
                    break;
                default:
                    break;
            }
        }
    }

    // Commit the path so far.
    CGContextDrawPath(myContext, kCGPathStroke);

    // Finally, add the axis labels.
    
    // First, the X-axis label.
    if ([self labelStyleX] != kLabelNone) {
        
        // Configure the label, compute its size and position it as
        // requested.
        UILabel *labelX = [[UILabel alloc] initWithFrame:[self bounds]];
        [labelX setTextAlignment:UITextAlignmentCenter];
        [labelX setFont:[self labelFontX]];
        [labelX setTextColor:[self labelColorX]];
        [labelX setBackgroundColor:[UIColor clearColor]];
        [labelX setText:[self axisLabelX]];
        CGRect newFrame = [labelX frame];
        CGSize labelSize = [[self axisLabelX]
                            sizeWithFont:[labelX font]
                            constrainedToSize:CGSizeMake(10000.0,10000.0)
                            lineBreakMode:[labelX lineBreakMode]];
        newFrame.size = labelSize;
        switch ([self labelStyleX]) {
            case kLabelNone:
                break;
            case kLabelCenter:
                newFrame.origin.x = 0.5*([self bounds].size.width -
                                         newFrame.size.width);
                newFrame.origin.y = (aLocY +
                                     [self axisOverhangY]);
                break;
            case kLabelEnd:
                newFrame.origin.x = ([self bounds].size.width -
                                     [self axisPaddingX] -
                                     labelSize.width);
                newFrame.origin.y = (aLocY +
                                     [self axisOverhangY]);
                break;
            case kLabelInside:
                newFrame.origin.x = ([self bounds].size.width -
                                     [self axisPaddingX] -
                                     labelSize.width);
                newFrame.origin.y = (aLocY -
                                     [self axisOverhangY] -
                                     labelSize.height);
                break;
            default:
                break;
        }
        [labelX setFrame:newFrame];
        [self addSubview:labelX];
        [labelX release];
        labelX = nil;
    }

    // Next, the Y-axis label.
    if ([self labelStyleY] != kLabelNone) {
        
        // Configure the label, compute its size and position it as
        // requested.
        UILabel *labelY = [[UILabel alloc] initWithFrame:[self bounds]];
        [labelY setTextAlignment:UITextAlignmentCenter];
        [labelY setFont:[self labelFontY]];
        [labelY setTextColor:[self labelColorY]];
        [labelY setBackgroundColor:[UIColor clearColor]];
        [labelY setText:[self axisLabelY]];
        CGRect newFrame = [labelY frame];
        CGSize labelSize = [[self axisLabelY]
                            sizeWithFont:[labelY font]
                            constrainedToSize:CGSizeMake(10000.0,10000.0)
                            lineBreakMode:[labelY lineBreakMode]];        
        newFrame.size = labelSize;
        switch ([self labelStyleY]) {
            case kLabelCenter:
                [labelY setTransform:CGAffineTransformMakeRotation(1.5*M_PI)];
                labelSize = [[self axisLabelY]
                             sizeWithFont:[labelY font]
                             constrainedToSize:CGSizeMake(10000.0,10000.0)
                             lineBreakMode:[labelY lineBreakMode]];
                newFrame.origin.x = (aLocX -
                                     [[self ticksY] majorTicksLen] -
                                     [self axisOverhangX] -
                                     labelSize.height);
                newFrame.origin.y = 0.5*([self bounds].size.height -
                                         labelSize.width);
                newFrame.size.width = labelSize.height;
                newFrame.size.height = labelSize.width;
                break;
            case kLabelEnd:
                newFrame.origin.x = (aLocX -
                                     0.5*labelSize.width);
                newFrame.origin.y = ([self axisPaddingY] -
                                     [self axisOverhangY] -
                                     labelSize.height);
                break;
            case kLabelInside:
                newFrame.origin.x = (aLocX +
                                     [self axisOverhangX]);
                newFrame.origin.y = ([self axisPaddingY] -
                                     0.5*labelSize.height);
                break;
            default:
                break;
        }
        [labelY setFrame:newFrame];
        [self addSubview:labelY];
        [labelY release];
        labelY = nil;
    }    
}


#pragma mark Ticks configuration

- (void)setTicksXDWithData:(WSData *)data {
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:[data count]];
    
    for (WSDatum *item in data) {
        NAFloat valX = [item valueX];
        if (isnan(valX)) {
            NSException *dataEx = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"setTicksXDWithData::X-value error"
                                   userInfo:nil];
            @throw dataEx;
        }
        [positions addObject:[NSNumber numberWithFloat:valX]];
    }
    [[self ticksX] ticksWithNumbers:positions];    
}

- (void)setTicksXDAndLabelsWithData:(WSData *)data {
    NSMutableArray *positions = [NSMutableArray arrayWithCapacity:[data count]];
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:[data count]];
    
    for (WSDatum *item in data) {
        NAFloat valX = [item valueX];
        if (isnan(valX)) {
            NSException *dataEx = [NSException
                                   exceptionWithName:[NSString
                                                      stringWithFormat:@"USER ERROR <%@>",
                                                      [self class]]
                                   reason:@"setTicksXDAndLabelsWithData::X-value error"
                                   userInfo:nil];
            @throw dataEx;
        }
        [positions addObject:[NSNumber
                              numberWithFloat:valX]];
        NSString *anno = [item annotation];
        if (!anno) {
            anno = @"";
        }
        [labels addObject:anno];
    }
    [[self ticksX] ticksWithNumbers:positions withLabels:labels];    
}

- (void)setTicksXDAndLabelsWithData:(WSData *)data
                        minDistance:(NAFloat)distance {
    
    WSData *tmp = [data sortedDataUsingValueX];
    WSData *result = [WSData data];
    [result addData:[tmp dataAtIndex:0]];
    
    NAFloat pos = [self boundsWithDataX:[[result dataAtIndex:0] valueX]];
    NAFloat newPos;
    
    for (WSDatum *datum in tmp) {
        newPos = [self boundsWithDataX:[datum valueX]];
        if (newPos == pos) {
            continue;
        }
        if (fabs(newPos - pos) >= distance) {
            [result addData:datum];
        }
    }
    
    [self setTicksXDAndLabelsWithData:result];
}

- (void)autoTicksXD {
    [[self ticksX] autoTicksWithRange:[self rangeXD]
                           withNumber:([self bounds].size.width/kDefaultTicksDistance)];
}

- (void)autoTicksYD {
    [[self ticksY] autoTicksWithRange:[self rangeYD]
                           withNumber:([self bounds].size.height/kDefaultTicksDistance)];
}

- (void)setTickLabelsX {
    [[self ticksX] setTickLabels];
}

- (void)setTickLabelsY {
    [[self ticksY] setTickLabels];
}

- (void)setTickLabelsXWithStyle:(NSNumberFormatterStyle)style {
    [[self ticksX] setTickLabelsWithStyle:style];
}

- (void)setTickLabelsYWithStyle:(NSNumberFormatterStyle)style {
    [[self ticksY] setTickLabelsWithStyle:style];
}

- (void)setTickLabelsXWithFormatter:(NSNumberFormatter *)formatter {
    [[self ticksX] setTickLabelsWithFormatter:formatter];
}

- (void)setTickLabelsYWithFormatter:(NSNumberFormatter *)formatter {
    [[self ticksY] setTickLabelsWithFormatter:formatter];
}


#pragma mark -

- (void)dealloc {
    [axisLabelX release];
    [axisLabelY release];
    [labelFontX release];
    [labelFontY release];
    [ticksX release];
    [ticksY release];
    [axisColor release];
    [gridColor release];
    [labelColorX release];
    [labelColorY release];
    axisLabelX = nil;
    axisLabelY = nil;
    labelFontX = nil;
    labelFontY = nil;
    ticksX = nil;
    ticksY = nil;
    axisColor = nil;
    gridColor = nil;
    labelColorX = nil;
    labelColorY = nil;
    
    [super dealloc];
}

@end
