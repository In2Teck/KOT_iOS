//
//  MenuAyudaViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 06/01/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "MenuAyudaViewController.h"
#import "NutriologosViewController.h"
#import "PreferencesViewController.h"
#import "FaqMenuViewController.h"

@interface MenuAyudaViewController ()

@end

@implementation MenuAyudaViewController

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

- (void)dealloc {
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)ajustes:(id)sender {
    PreferencesViewController *preferences = [[[PreferencesViewController alloc]initWithNibName:@"PreferencesViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:preferences animated:YES];
}

- (IBAction)contacto:(id)sender {
    NutriologosViewController *contactos = [[[NutriologosViewController alloc]initWithNibName:@"NutriologosViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:contactos animated:YES];
}

- (IBAction)faq:(id)sender {
    FaqMenuViewController *faq = [[[FaqMenuViewController alloc]initWithNibName:@"FaqMenuViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:faq animated:YES];
}


@end
