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
    self.title = @"Mi Método";
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

-(void)cargaMetodo:(BOOL)isProgresivo{
    NSString *urlConnection = [NSString stringWithFormat:@"http://desarrollo.sysop26.com/kot/nuevo/WS/kotMiMetodo.php?idUserKot=%@", [[user objectAtIndex:0]objectAtIndex:0]];
    NSURL *url = [[[NSURL alloc] initWithString:urlConnection] autorelease];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
    // Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
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
            
            if(!isProgresivo){
             
                intensivo  = [[[contentJSON objectForKey:@"intensivo"]JSONRepresentation]JSONValue];
                NSArray *keys = [intensivo allKeys];
                
                for (int position=0; position < keys.count; position++){
                    id aKey = [keys objectAtIndex:position];
                    NSMutableDictionary *anObject = [intensivo objectForKey:aKey];
                    NSArray *internal_keys = [anObject allKeys];
                    
                    NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", aKey, @"intensivo"]];
                    NSMutableArray *intensivoArray = [[NSMutableArray alloc] init];
                    int progressive_position = 0;
                    for (int internal_position = 0; internal_position < internal_keys.count; internal_position++){
                        id internal_aKey = [internal_keys objectAtIndex:internal_position];
                        
                        if([[anObject objectForKey:internal_aKey] isEqualToString:@"0"]){
                            [anObject removeObjectForKey:internal_aKey];
                        }else if([[anObject objectForKey:internal_aKey] integerValue] >= 1){
                            if([defaultsArray count] > 0){
                                @try{
                                    for (int num=0; num < [[anObject objectForKey:internal_aKey] integerValue];     num++){
                                        NSMutableDictionary *dict = [defaultsArray objectAtIndex:progressive_position];
                                        [intensivoArray addObject:dict];
                                        progressive_position++;
                                    }
                                }@catch (NSException *exception) {
                                    // BORRAMOS ANTERIOR
                                    [self resetMetodo:NO];
                                    return;
                                }
                                
                            }else{
                                //iteramos por numero de elementos en el json
                                for (int num=0; num < [[anObject objectForKey:internal_aKey] integerValue];     num++){
                                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                    [dict setObject:[NSString stringWithFormat:@"NO_%i", progressive_position] forKey:internal_aKey];
                                    
                                    [intensivoArray addObject:dict];
                                    progressive_position++;
                                }
                            }
                        }
                    }
                    
                    [intensivo setObject:intensivoArray forKey:aKey];
                    [defaults setObject:intensivoArray forKey:[NSString stringWithFormat:@"%@_%@", aKey, @"intensivo"]];
                }
            } else {
                progresivo = [[[contentJSON objectForKey:@"progresivo"]JSONRepresentation]JSONValue];
                NSArray *keys = [progresivo allKeys];
                
                for (int position=0; position < keys.count; position++){
                    id aKey = [keys objectAtIndex:position];
                    NSMutableDictionary *anObject = [progresivo objectForKey:aKey];
                    NSArray *internal_keys = [anObject allKeys];
                    
                    NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", aKey, @"progresivo"]];
                    NSMutableArray *progresivoArray = [[NSMutableArray alloc] init];
                    int progressive_position = 0;
                    for (int internal_position=0; internal_position < internal_keys.count; internal_position++){
                        id internal_aKey = [internal_keys objectAtIndex:internal_position];
                        
                        if([[anObject objectForKey:internal_aKey] isEqualToString:@"0"]){
                            [anObject removeObjectForKey:internal_aKey];
                        }else if([[anObject objectForKey:internal_aKey] integerValue] >= 1){
                            if([defaultsArray count] > 0){
                                @try {
                                    for (int num=0; num < [[anObject objectForKey:internal_aKey] integerValue];     num++){
                                        NSMutableDictionary *dict = [defaultsArray objectAtIndex:progressive_position];
                                        [progresivoArray addObject:dict];
                                        progressive_position++;
                                    }
                                } @catch (NSException *exception) {
                                    [self resetMetodo:YES];
                                    return;
                                }
                            }else{
                                //iteramos por numero de elementos en el json
                                for (int num=0; num < [[anObject objectForKey:internal_aKey] integerValue];     num++){
                                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                    [dict setObject:[NSString stringWithFormat:@"NO_%i", progressive_position] forKey:internal_aKey];
                                    
                                    [progresivoArray addObject:dict];
                                    progressive_position++;
                                }
                            }
                        }
                        
                    }
                    
                    [progresivo setObject:progresivoArray forKey:aKey];
                    [defaults setObject:progresivoArray forKey:[NSString stringWithFormat:@"%@_%@", aKey, @"progresivo"]];
                }
            }
            
            [defaults synchronize];
            
            semanas = [contentJSON objectForKey:@"semana"];
            NSLog(@"Semana %@", semanas);
            //NSDictionary *data = [[[intensivo objectForKey:@"desayuno"]JSONRepresentation]JSONValue];
            NSNull *null = [[NSNull alloc] init];
            if([intensivo objectForKey:@"desayuno"] == null){
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

-(void)resetMetodo:(BOOL)isProgresivo{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *urlConnection = [NSString stringWithFormat:@"http://desarrollo.sysop26.com/kot/nuevo/WS/kotMiMetodo.php?idUserKot=%@", [[user objectAtIndex:0]objectAtIndex:0]];
    NSURL *url = [[[NSURL alloc] initWithString:urlConnection] autorelease];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
    // Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
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
            
            if (!isProgresivo) {
                
                [defaults removeObjectForKey:@"desayuno_intensivo"];
                [defaults removeObjectForKey:@"comida_intensivo"];
                [defaults removeObjectForKey:@"colacion_1_intensivo"];
                [defaults removeObjectForKey:@"colacion_2_intensivo"];
                [defaults removeObjectForKey:@"cena_intensivo"];
            
                intensivo  = [[[contentJSON objectForKey:@"intensivo"]JSONRepresentation]JSONValue];
                NSArray *keys = [intensivo allKeys];
            
                for (int position=0; position < keys.count; position++){
                    id aKey = [keys objectAtIndex:position];
                    NSMutableDictionary *anObject = [intensivo objectForKey:aKey];
                    NSArray *internal_keys = [anObject allKeys];
                
                    NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", aKey, @"intensivo"]];
                    NSMutableArray *intensivoArray = [[NSMutableArray alloc] init];
                    int progressive_position = 0;
                    for (int internal_position = 0; internal_position < internal_keys.count; internal_position++){
                        id internal_aKey = [internal_keys objectAtIndex:internal_position];
                    
                        if([[anObject objectForKey:internal_aKey] isEqualToString:@"0"]){
                            [anObject removeObjectForKey:internal_aKey];
                        }else if([[anObject objectForKey:internal_aKey] integerValue] >= 1){
                            //iteramos por numero de elementos en el json
                            for (int num=0; num < [[anObject objectForKey:internal_aKey] integerValue];     num++){
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                [dict setObject:[NSString stringWithFormat:@"NO_%i", progressive_position] forKey:internal_aKey];
                                
                                [intensivoArray addObject:dict];
                                progressive_position++;
                            }
                        }
                    }
                
                    [intensivo setObject:intensivoArray forKey:aKey];
                    [defaults setObject:intensivoArray forKey:[NSString stringWithFormat:@"%@_%@", aKey, @"intensivo"]];
                }
                
            }else{
                
                [defaults removeObjectForKey:@"desayuno_progresivo"];
                [defaults removeObjectForKey:@"comida_progresivo"];
                [defaults removeObjectForKey:@"colacion_1_progresivo"];
                [defaults removeObjectForKey:@"colacion_2_progresivo"];
                [defaults removeObjectForKey:@"cena_progresivo"];
            
                progresivo = [[[contentJSON objectForKey:@"progresivo"]JSONRepresentation]JSONValue];
                NSArray *keys = [progresivo allKeys];
            
                for (int position=0; position < keys.count; position++){
                    id aKey = [keys objectAtIndex:position];
                    NSMutableDictionary *anObject = [progresivo objectForKey:aKey];
                    NSArray *internal_keys = [anObject allKeys];
                
                    NSMutableArray *defaultsArray = [defaults mutableArrayValueForKey:[NSString stringWithFormat:@"%@_%@", aKey, @"progresivo"]];
                    NSMutableArray *progresivoArray = [[NSMutableArray alloc] init];
                    int progressive_position = 0;
                    for (int internal_position=0; internal_position < internal_keys.count; internal_position++){
                        id internal_aKey = [internal_keys objectAtIndex:internal_position];
                    
                        if([[anObject objectForKey:internal_aKey] isEqualToString:@"0"]){
                            [anObject removeObjectForKey:internal_aKey];
                        }else if([[anObject objectForKey:internal_aKey] integerValue] >= 1){
                            //iteramos por numero de elementos en el json
                            for (int num=0; num < [[anObject objectForKey:internal_aKey] integerValue];     num++){
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                [dict setObject:[NSString stringWithFormat:@"NO_%i", progressive_position] forKey:internal_aKey];
                                
                                [progresivoArray addObject:dict];
                                progressive_position++;
                            }
                        
                        }
                    }
                    [progresivo setObject:progresivoArray forKey:aKey];
                    [defaults setObject:progresivoArray forKey:[NSString stringWithFormat:@"%@_%@", aKey, @"progresivo"]];
                }
                
            }
            [defaults synchronize];
            
            semanas = [contentJSON objectForKey:@"semana"];
            NSLog(@"Semana %@", semanas);
            //NSDictionary *data = [[[intensivo objectForKey:@"desayuno"]JSONRepresentation]JSONValue];
            NSNull *null = [[NSNull alloc] init];
            if([intensivo objectForKey:@"desayuno"] == null){
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

-(void)loadMiMetodoKot{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [components setHour:3];
    
    if ([defaults floatForKey:@"miMetodoTimestamp"]){
        float interval = [defaults floatForKey:@"miMetodoTimestamp"];
        float diff = [now timeIntervalSince1970] - interval;
        //NSLog(@"diff %f, interval %f", diff, interval );
        if (diff >= 86400) {
            float next3am = interval + 86400;
            [defaults setFloat:next3am forKey:@"miMetodoTimestamp"];
            [defaults removeObjectForKey:@"desayuno_intensivo"];
            [defaults removeObjectForKey:@"comida_intensivo"];
            [defaults removeObjectForKey:@"colacion_1_intensivo"];
            [defaults removeObjectForKey:@"colacion_2_intensivo"];
            [defaults removeObjectForKey:@"cena_intensivo"];
            [defaults removeObjectForKey:@"desayuno_progresivo"];
            [defaults removeObjectForKey:@"comida_progresivo"];
            [defaults removeObjectForKey:@"colacion_1_progresivo"];
            [defaults removeObjectForKey:@"colacion_2_progresivo"];
            [defaults removeObjectForKey:@"cena_progresivo"];
        }
    } else {
        NSDate *today3am = [calendar dateFromComponents:components];
        [defaults setFloat:[today3am timeIntervalSince1970] forKey:@"miMetodoTimestamp"];
    }
    
    [self cargaMetodo:NO];
    [self cargaMetodo:YES];
    
}

@end
