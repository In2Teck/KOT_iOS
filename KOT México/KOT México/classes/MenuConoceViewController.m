//
//  MenuConoceViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 27/12/13.
//  Copyright (c) 2013 Naranya. All rights reserved.
//

#import "MenuConoceViewController.h"
#import "NutriologosViewController.h"
#import "ProductosViewController.h"

@interface MenuConoceViewController ()

@end

@implementation MenuConoceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
}

-(IBAction)productosKOT:(id)sender{
    ProductosViewController *productos = [[[ProductosViewController alloc]initWithNibName:@"ProductosViewController" bundle:nil]autorelease];
     [self.navigationController pushViewController:productos animated:YES];
}

- (IBAction)especialistaKOT:(id)sender {
    NutriologosViewController *nutriologos = [[[NutriologosViewController alloc]initWithNibName:@"NutriologosViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:nutriologos animated:YES];
}


- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
