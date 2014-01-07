//
//  AyudaViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 27/12/13.
//  Copyright (c) 2013 Naranya. All rights reserved.
//

#import "AyudaViewController.h"

@interface AyudaViewController ()

@end

@implementation AyudaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"home_icon.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.navigationController.view];
}

- (void)viewDidUnload
{
    [self setNavigationController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //    return YES;
}

- (void)dealloc {
    [_navigationController release];
    [super dealloc];
}
@end
