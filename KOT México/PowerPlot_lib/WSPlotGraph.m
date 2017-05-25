///
///  @file
///  WSPlotGraph.m
///  PowerPlot
///
///  Created by Wolfram Schroers on 19.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///

#import "WSPlotGraph.h"
#import "WSConnection.h"
#import "WSConnectionDelegate.h"
#import "WSData.h"
#import "WSDatum.h"
#import "WSGraph.h"
#import "WSGraphConnections.h"
#import "WSNode.h"
#import "WSNodeProperties.h"


@implementation WSPlotGraph

@synthesize style = _style;
@synthesize nodeDefault = _nodeDefault;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _style = kGraphPlotUnified;
        _nodeDefault = [[WSNodeProperties alloc] init];
    }
    return self;
}

// Return YES if a subclass can plot (or otherwise handle) data.
// Otherwise, WSPlot returns NO.
- (BOOL)hasData {
    return YES;
}


#pragma mark -
#pragma mark Plot handling

- (void)setAllDisplaysOff {
    [self setStyle:kGraphPlotNone];
    [[dataDelegate connections] removeAllConnections];
}

/*
 // Override this method if a subclass plots something to provide a
 // sample. (E.g. something that is inserted in legends etc.)
 - (void)plotSample:(CGPoint)aPoint {
 // Drawing code
 }
 */


- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    WSNodeProperties *current = [self nodeDefault];
    CGRect nodeRect;
    
    
    if ([self style] == kGraphPlotNone) {
        return;
    }
    
    // Remove previous labels (if any).
    for (UIView* label in [self subviews]) {
        [label removeFromSuperview];
    }
    
    // Loop over all connections.
    for (WSConnection *item in [(WSGraph *)[self dataD] connections]) {
        
        // Get the involved node properties.
        WSDatum *datumTo = [[self dataD] dataAtIndex:[item to]];
        WSDatum *datumFrom = [[self dataD] dataAtIndex:[item from]];
        WSNodeProperties *nodeTo = [datumTo customDatum];
        WSNodeProperties *nodeFrom = [datumFrom customDatum];
        switch ([self style]) {
            case kGraphPlotNone:
            case kGraphPlotIndividual:
                break;
            case kGraphPlotUnified:
                nodeTo = [self nodeDefault];
                nodeFrom = nodeTo;
                break;
            default:
                break;
        }
        
        // Get the center points for the arrows.
        CGPoint start = CGPointMake([self boundsWithDataX:[datumFrom valueX]], 
                                    [self boundsWithDataY:[datumFrom valueY]]);
        CGPoint end = CGPointMake([self boundsWithDataX:[datumTo valueX]], 
                                  [self boundsWithDataY:[datumTo valueY]]);
        
        // Get the actual starting- and end-points clipped by the rectangles.
        CGRect startRect = CGRectMake(([self boundsWithDataX:[datumFrom valueX]] -
                                       ([nodeFrom size].width/2.0)), 
                                      ([self boundsWithDataY:[datumFrom valueY]] -
                                       ([nodeFrom size].height/2.0)),
                                      [nodeFrom size].width,
                                      [nodeFrom size].height);
        CGRect endRect = CGRectMake(([self boundsWithDataX:[datumTo valueX]] -
                                     ([nodeTo size].width/2.0)), 
                                    ([self boundsWithDataY:[datumTo valueY]] -
                                     ([nodeTo size].height/2.0)),
                                    [nodeTo size].width,
                                    [nodeTo size].height);
        CGPoint startCrd = NALineInternalRectangleIntersection(start,
                                                               end,
                                                               startRect);
        CGPoint endCrd = NALineInternalRectangleIntersection(start,
                                                             end,
                                                             endRect);
        
        // Finally, draw the connecting arrow.
        [[item color] set];
        switch ([item direction]) {
            case kGConnectionNone:
                break;
            case kGDirectionNone:
                CGContextSetLineWidth(myContext, [item strength]);
                CGContextSetStrokeColorWithColor(myContext,
                                                 [[item color] CGColor]);
                CGContextMoveToPoint(myContext, startCrd.x, startCrd.y);
                CGContextAddLineToPoint(myContext, endCrd.x, endCrd.y);
                CGContextStrokePath(myContext);
                break;
            case kGDirection:
                NAContextAddLineArrow(myContext, kArrowLineFilledHead,
                                      startCrd, endCrd, kCArrowLength,
                                      [item strength]);
                break;
            case kGDirectionBoth:
                NAContextAddLineDoubleArrow(myContext, kArrowLineFilledHead,
                                            startCrd, endCrd, kCArrowLength,
                                            [item strength]);
                break;
            case kGDirectionInverse:
                NAContextAddLineArrow(myContext, kArrowLineFilledHead,
                                      endCrd, startCrd, kCArrowLength,
                                      [item strength]);
                break;
            default:
                break;
        }
    }
    
    // Loop over all data points for plotting the nodes.
    for (WSDatum *item in [self dataD]) {
        switch ([self style]) {
            case kGraphPlotNone:
            case kGraphPlotUnified:
                break;
            case kGraphPlotIndividual:
                if ([[item customDatum] isKindOfClass:[[self nodeDefault] class]]) {
                    current = [item customDatum];
                } else {
                    current = [self nodeDefault];
                }
                break;
            default:
                break;
        }

        // Setup the node rectangle.
        nodeRect = [self nodeRect:item
                         withSize:[current size]];
                               
        // Draw the node solid fill, with shadow if necessary.
        if ([current hasShadow]) {
            CGContextSaveGState(myContext);
            NAFloat scale = [current shadowScale];
            CGContextSetShadowWithColor(myContext,
                                        CGSizeMake(scale, scale),
                                        scale,
                                        [[current shadowColor] CGColor]);
        }
        CGContextSetFillColorWithColor(myContext,
                                       [[current nodeColor] CGColor]);
        CGContextFillRect(myContext, nodeRect);
        if ([current hasShadow]) {
            CGContextRestoreGState(myContext);            
        }
        
        // Draw the box node outline.
        CGContextSetLineWidth(myContext, [current outlineStroke]);
        CGContextSetStrokeColorWithColor(myContext,
                                         [[current outlineColor] CGColor]);
        CGContextAddRect(myContext, nodeRect);
        CGContextStrokePath(myContext);

        // Draw a label (if the data has annotations).
        NSString *anno = [item annotation];
        if (anno) {
            NAFloat padding = [current labelPadding];
            UILabel *label = [[UILabel alloc]
                              initWithFrame:CGRectMake((nodeRect.origin.x +
                                                        padding), 
                                                       (nodeRect.origin.y +
                                                        padding), 
                                                       (nodeRect.size.width -
                                                        2.0*padding),
                                                       (nodeRect.size.height -
                                                        2.0*padding))];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setFont:[current labelFont]];
            [label setTextColor:[current labelColor]];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:anno];
            [self addSubview:label];
            
            [label release];
        }
    }
}



- (void)setAllNodesToDefault {
    [(WSGraph *)[self dataD] setAllNodesTo:[self nodeDefault]];
}

- (CGRect)nodeRect:(WSDatum *)node
          withSize:(CGSize)size {
    return CGRectMake(([self boundsWithDataX:[node valueX]] - (size.width/2.0)),
                      ([self boundsWithDataY:[node valueY]] - (size.height/2.0)),
                      size.width,
                      size.height);
}

- (NSInteger)nodeForPoint:(CGPoint)location {
    for (WSDatum *node in [self dataD]) {
        if (CGRectContainsPoint([self nodeRect:node
                                      withSize:[node size]],
                                location) ) {
            return [(WSGraph *)[self dataD] indexOfNode:node];
        }
    }
    return -1;
}


#pragma mark -

- (void)dealloc {
    [_nodeDefault release];
    _nodeDefault = nil;
    
    [super dealloc];
}

@end
