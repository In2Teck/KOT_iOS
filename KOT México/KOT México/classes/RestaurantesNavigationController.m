//
//  RestaurantesNavigationController.m
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 23/12/11.
//  Copyright (c) 2011 Naranya. All rights reserved.
//

#import "RestaurantesNavigationController.h"

@implementation RestaurantesNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"restaurant_icon.png"];
        [self.navigationController.view setBounds:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
        //        self.view.bounds.size.width;
        [self.view addSubview:self.navigationController.view];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view removeFromSuperview];
    [self.view addSubview:navigationController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
