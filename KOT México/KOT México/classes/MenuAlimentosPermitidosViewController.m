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
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"isVegetariano"] != nil) {
        if ([defaults boolForKey:@"isVegetariano"]) {
            [self.isVegetariano setOn:YES animated:YES];
        } else {
            [self.isVegetariano setOn:NO animated:YES];
        }
    } else {
        [defaults setBool:NO forKey:@"isVegetariano"];
        [defaults synchronize];
        [self.isVegetariano setOn:NO animated:YES];
    }
    // Do any additional setup after loading the view from its nib.
    self.title = @"Alimentos";
}

- (void) viewDidUnload
{
    [self setIsVegetariano:nil];
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
    alimentos.isMujerIntensivo = true;
    alimentos.isVegetariano = self.isVegetariano.on;
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)hombreIntensivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Hombre Intensivo";
    alimentos.isMujerIntensivo = false;
    alimentos.isVegetariano = self.isVegetariano.on;
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)mujerProgresivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Mujer Progresivo";
    alimentos.isMujerIntensivo = false;
    alimentos.isVegetariano = self.isVegetariano.on;
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)hombreProgresivo:(id)sender {
    AlimentosViewController *alimentos = [[[AlimentosViewController alloc] initWithNibName:@"AlimentosViewController" bundle:nil]autorelease];
    alimentos.title = @"Hombre Progresivo";
    alimentos.isMujerIntensivo = false;
    alimentos.isVegetariano = self.isVegetariano.on;
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

- (IBAction)vegetariano:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:![defaults boolForKey:@"isVegetariano"] forKey:@"isVegetariano"];
    [defaults synchronize];
}

- (void)dealloc {
    [_isVegetariano release];
    [super dealloc];
}
@end
