//
//  MenuConoceViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 27/12/13.
//  Copyright (c) 2013 Naranya. All rights reserved.
//

#import "MenuConoceViewController.h"
#import "CollapsableTableViewViewController.h"
#import "NutriologosViewController.h"
#import "IMCViewController.h"
#import "VideoMenuViewController.h"

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
    self.title = @"Conoce KOT";
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
    NutriologosViewController *contactos = [[[NutriologosViewController alloc]initWithNibName:@"NutriologosViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:contactos animated:YES];
}

- (IBAction)especialistaKOT:(id)sender {
    CollapsableTableViewViewController *control = [[[CollapsableTableViewViewController alloc]initWithNibName:@"CollapsableTableViewViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:control animated:YES];
}

- (IBAction)imc:(id)sender {
    IMCViewController *imc = [[[IMCViewController alloc]initWithNibName:@"IMCViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:imc animated:YES];
}

- (IBAction)videosTestimoniales:(id)sender {
    VideoMenuViewController *videos = [[[VideoMenuViewController alloc]initWithNibName:@"VideoMenuViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:videos animated:YES];
}

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
