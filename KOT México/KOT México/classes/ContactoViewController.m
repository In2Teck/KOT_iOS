//
//  ContactoViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 18/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ContactoViewController.h"
//#import "ListNutriologosViewController.h"
#import "CollapsableTableViewViewController.h"


#define IMG_TAG 1

@implementation ContactoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)paginaKot:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kot.mx"]];
}

- (IBAction)telefonoDF:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:63894219"]];
}

- (IBAction)telefonoProvincia:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:018002634664"]];
}

- (IBAction)correoKOT:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:info@kot.mx"]];
}

- (IBAction)facebookKOT:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/KOTMexico"]];
}

- (IBAction)twitterKOT:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/KOTMexico"]];
}
- (void)dealloc {
    [super dealloc];
}
@end
