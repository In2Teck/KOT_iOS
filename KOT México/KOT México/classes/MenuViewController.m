//
//  MenuViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuAlimentosPermitidosViewController.h"
#import "ListRestaurantesViewController.h"
#import "MetodoKotViewController.h"
#import "ProgresoViewController.h"
#import "CommonDAO.h"
#import "MiMetodoKOTViewController.h"

@implementation MenuViewController

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
    // Do any additional setup after loading the view from its nib.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(IBAction)alimentosKOT:(id)sender{
    MenuAlimentosPermitidosViewController *alimentos = [[[MenuAlimentosPermitidosViewController alloc] initWithNibName:@"MenuAlimentosPermitidosViewController" bundle:nil]autorelease];
    
    [self.navigationController pushViewController:alimentos animated:YES];
}

-(IBAction)productosKOT:(id)sender{
/*    ProductosViewController *productos = [[[ProductosViewController alloc]initWithNibName:@"ProductosViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:productos animated:YES];
 */
}

- (IBAction)restaurantesKOT:(id)sender {
    ListRestaurantesViewController *restaurantes = [[[ListRestaurantesViewController alloc]initWithNibName:@"ListRestaurantesViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:restaurantes animated:YES];
}

-(IBAction)metodoKot:(id)sender{
    CommonDAO *sqlite = [[CommonDAO alloc] init];
    // Release any cached data, images, etc that aren't in use.
    
    user = [[sqlite select:@"SELECT id_usuario, nombre, apellidos, correo, genero, edad, altura, nutriologo FROM usuario;" keys:[NSArray arrayWithObjects:@"id_usuario",@"nombre",@"apellidos",@"correo",@"genero",@"edad",@"altura",@"nutriologo", nil]]retain];
    [sqlite release];
    sqlite = nil;
    [user retain];
    
    if([user count]==0){
            MetodoKotViewController *metodo = [[[MetodoKotViewController alloc] initWithNibName:@"MetodoKotViewController" bundle:nil]autorelease];
            [self.navigationController pushViewController:metodo animated:YES];
    }else{
        [self loadMiMetodoKot];
        if(intensivo != nil && progresivo != nil){
            MiMetodoKOTViewController *mk = [[MiMetodoKOTViewController alloc] initWithNibName:@"MiMetodoKOTViewController" bundle:nil];
            mk.intensivo = intensivo;
            mk.progresivo = progresivo;
            mk.semanasUsuario = semanas;
            [self.navigationController pushViewController:mk animated:YES];
        }else{
            MetodoKotViewController *metodo = [[[MetodoKotViewController alloc] initWithNibName:@"MetodoKotViewController" bundle:nil]autorelease];
            [self.navigationController pushViewController:metodo animated:YES];
        }
    }  
}
-(IBAction)progresoKot:(id)sender{
        ProgresoViewController *progreso = [[[ProgresoViewController alloc]initWithNibName:@"ProgresoViewController" bundle:nil]autorelease];
        
        [self.navigationController pushViewController:progreso animated:YES];
    
}
-(void)loadMiMetodoKot{
    NSString *urlConnection = [NSString stringWithFormat:@"http://kot.mx/nuevo/WS/kotMiMetodo.php?idUserKot=%@", [[user objectAtIndex:0]objectAtIndex:0]];
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
        if([messageError length]==0){
            intensivo  = [[[contentJSON objectForKey:@"intensivo"]JSONRepresentation]JSONValue];
            progresivo = [[[contentJSON objectForKey:@"progresivo"]JSONRepresentation]JSONValue];
            semanas = [contentJSON objectForKey:@"semana"];
            NSLog(@"Semana %@", semanas);
            NSDictionary *data = [[[intensivo objectForKey:@"desayuno"]JSONRepresentation]JSONValue];
            NSNull *null = [[NSNull alloc] init];
            if([data objectForKey:@"cereal"] == null){
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"Aún no tienes un método asignado, acude con uno de nuestros especialistas KOT." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
                [message show];
                [message release];
                message = nil;
                intensivo = nil;
                progresivo = nil;
            }
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
}

@end
