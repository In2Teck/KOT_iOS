//
//  MiMetodoCellViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 08/04/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "MiMetodoCellViewController.h"
#import "AlimentoDetailViewController.h"
#import "MiMetodoKOTViewController.h"

@interface MiMetodoCellViewController ()

@end

@implementation MiMetodoCellViewController

@synthesize checkSwitch = _checkSwitch;
@synthesize buttonLabel = _buttonLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_checkSwitch release];
    [_buttonLabel release];
    [super dealloc];
}

@end
