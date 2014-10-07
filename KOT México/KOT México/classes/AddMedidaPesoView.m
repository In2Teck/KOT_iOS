//
//  AddMedidaPesoView.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 07/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "AddMedidaPesoView.h"

@implementation AddMedidaPesoView
@synthesize titulo;
@synthesize medida;
@synthesize type;
@synthesize idUsuario;
@synthesize semana;
@synthesize myProgresoSelf;
@synthesize isPeso;

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
    if(isPeso){
        [self.titulo setText:@"Registra un nuevo Peso"];
        [medida setPlaceholder:@"kg"];
    }else{
        [self.titulo setText:@"Registra una nueva Medida"];
        [medida setPlaceholder:@"cm"];
    }
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
/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// UITwxtField Methods ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
    [self sendPesoMedida];
    
	[theTextField resignFirstResponder];
	return YES;
}

-(void)sendPesoMedida{
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotRegistroMedidasPeso.php?idUserKot=%@&type=%@&data=%@&semana=%@",idUsuario, type, medida.text,semana] autorelease];
    
    NSURL *url = [[[NSURL alloc] initWithString:urlConnection] autorelease];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *jsonData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *contentJSON = [json objectWithString:jsonData error:&jsonError];
    if (contentJSON==nil) {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", [error localizedDescription]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        NSString *messageError = [contentJSON objectForKey:@"mensaje_error"];
        NSDictionary *usuarioLogin;
        if([messageError length]==0){
            // create a filtered list that will contain products for the search results table.
            usuarioLogin = [[[[contentJSON objectForKey:@"usuario"] JSONRepresentation] JSONValue]retain];
            
            myProgresoSelf.pesoList     = [[contentJSON mutableArrayValueForKey:@"kilos"]retain];
            myProgresoSelf.medidaList   = [[contentJSON mutableArrayValueForKey:@"medidas"]retain];
            myProgresoSelf.updateViews = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
    myProgresoSelf.updateViews = NO;
}

-(void)viewWillAppear:(BOOL)animated{
}
@end
