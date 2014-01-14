//
//  MenuAlimentosPermitidosViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 13/01/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "MenuAlimentosPermitidosViewController.h"
#import "AlimentosViewController.h"

@interface MenuAlimentosPermitidosViewController ()

@end

@implementation MenuAlimentosPermitidosViewController

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
    self.title = @"Alimentos";
}

- (void) viewDidUnload
{
    [super viewDidUnload];
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

- (IBAction)mujerIntensivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Mujer Intensivo";
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)hombreIntensivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Hombre Intensivo";
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)mujerProgresivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Mujer Progresivo";
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)hombreProgresivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Hombre Progresivo";
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

@end
