//
//  RestauranteMenuViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 01/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "RestauranteMenuViewController.h"
#import "PlatilloViewController.h"
#import "Flurry.h"

#define LABEL_MENU_TAG 1
#define VIEW_IMAGE_TAG 2
#define MAX_RATING     5

@implementation RestauranteMenuViewController
@synthesize listOfItems;
@synthesize direccion;
@synthesize itemMenu;

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
    // Do any additional setup after loading the view from its nib.

//    [self loadJSONContent];
    if ([listOfItems count]>0){
        urlImage = [listOfItems objectAtIndex:([listOfItems count]-1)];
        [listOfItems removeObjectAtIndex:([listOfItems count]-1)];
        [self loadImageView];
    }
    
    [direccion setText:[itemMenu objectForKey:@"direccion"]];
    
    self.title = [itemMenu objectForKey:@"nombre"];
    [Flurry logEvent:[NSString stringWithFormat:@"Restaurante: %@",self.title] withParameters:nil timed:YES];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Regresar";
    
    self.navigationItem.backBarButtonItem = barButton; 
    
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
//    return NO;
}
/************************************************************************/
/************************************************************************/
/************************ IBActions *************************************/
/************************************************************************/
/************************************************************************/

-(IBAction)callContact:(id)sender{
    NSString *asd = [[NSString alloc]initWithFormat:@"¿Llamar a %@ ?",[itemMenu objectForKey:@"nombre"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"KOT México" message:asd
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Llamar", nil];
    [alert show];
    [alert release];

}
-(IBAction)showMap:(id)sender{
    NSString *latitude = [itemMenu objectForKey:@"latitud"];
    NSString *longitude = [itemMenu objectForKey:@"longitud"];
    
    if ([latitude length] >0 && [longitude length]>0) {
        
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        mapView.mapType = MKMapTypeStandard;
        
        CLLocationCoordinate2D coord = {.latitude =  [latitude floatValue], .longitude =  [longitude floatValue]};
        MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
        MKCoordinateRegion region = {coord, span};
        
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = coord;
        annotationPoint.title = [itemMenu objectForKey:@"nombre"];
        annotationPoint.subtitle = [itemMenu objectForKey:@"direccion"];
        [mapView addAnnotation:annotationPoint]; 
        
        [mapView setRegion:region];
        
        UIViewController  *mapViewController = [[[UIViewController alloc]init]autorelease];
        [mapViewController.view addSubview:mapView];
        
        [self.navigationController pushViewController:mapViewController animated:YES];
    }else{
        
        NSString *stringMessage = [[NSString alloc] initWithFormat:@"Ubicación no disponible."];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:stringMessage delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [message show];
        [message release];
        message = nil;
    }   

}
-(IBAction)addToContacts:(id)sender{
    NSString *asd = [[NSString alloc]initWithFormat:@"Agregar %@ a la lista de contactos?",[itemMenu objectForKey:@"nombre"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"KOT México" message:asd
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSLog(@"title button: %@", [alertView buttonTitleAtIndex:buttonIndex]);
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add"]){
        
        CFErrorRef *anError;
        ABAddressBookRef addressBook = ABAddressBookCreate(); // create address book record 
        ABRecordRef person = ABPersonCreate(); // create a person  
        
        NSString *phone = [[NSString alloc]initWithFormat:@"%@",[itemMenu objectForKey:@"telefono"]]; // the phone number to add  
        
        //Phone number is a list of phone number, so create a multivalue  
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty); 
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,phone,kABPersonPhoneMobileLabel, NULL);
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, [itemMenu objectForKey:@"nombre"] , nil); // first name of the new person 
        ABRecordSetValue(person, kABPersonLastNameProperty, @"", nil); // his last name 
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, &anError); // set the phone number property 
        ABAddressBookAddRecord(addressBook, person, nil); //add the new person to the record
        ABAddressBookSave(addressBook, nil); //save the record  
        
        CFRelease(person); // relase the ABRecordRef  variable
    }
    
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Llamar"]){
        NSString *url = [[NSString alloc] initWithFormat:@"tel://%@",[itemMenu objectForKey:@"telefono"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) { 
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]; }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KOT México" message:@"Tu dispositivo no puede hacer llamadas." delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        [url release];
        url = nil;
    }
}
/************************************************************************/
/************************************************************************/
/************************* Methods *************************************/
/************************************************************************/
/************************************************************************/

-(void)showLoadingView{
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.navigationController.view];
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}
-(void)loadImageView{
    bannerView.frame = CGRectMake(0.0, 0.0, 320.0, 220.0);
    
    LoadingView *splashLoading = [LoadingView loadingViewInView:bannerView];
    
    UIImage *img = [[UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:urlImage]]]retain];
    
//    img.size = CGSizeMake(320.0, 113.0);
	if (img != nil) { // Image was loaded successfully.
        [bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		bannerView.image = img;
		[bannerView setUserInteractionEnabled:YES];
        [bannerView setAutoresizesSubviews:YES];
		[img release]; // Release the image now that we have a UIImageView that contains it.
        [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
	}
    
    
}
-(void)loadJSONContent{
    [self showLoadingView];
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotMenuRestaurantes.php?idRestaurante=%@",idRestaurante] autorelease];
    
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
        // create a filtered list that will contain products for the search results table.
        NSMutableArray *restaurante= [[contentJSON mutableArrayValueForKey:@"menu"]retain];
        
        //Initialize the array.
        listOfItems = [[NSMutableArray alloc] init];
        
        //        [listOfItems addObject:countriesToLiveInDict];
        urlImage = [contentJSON objectForKey:@"img"];
        
        for(int i = 0; i< [restaurante count]; i++){
            NSDictionary *itemJSon = [[[restaurante objectAtIndex:i] JSONRepresentation] JSONValue];
            NSMutableArray *objRestaurant = [[[itemJSon objectForKey:@"items"] JSONRepresentation] JSONValue];
            if([objRestaurant count]>0){
                for (int b = 0; b<[objRestaurant count]; b++) {
                    NSDictionary *tempJsonDetail = [[[objRestaurant objectAtIndex:b] JSONRepresentation] JSONValue];
                    [listOfItems addObject:tempJsonDetail];
                }
            }
        }
    }
}

-(NSDictionary*)loadJSONDetail:(NSString*)idMenu{
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotDetalleMenuRestaurantes.php?idMenu=%@",idMenu] autorelease];
    
    NSLog(@"url: %@", urlConnection);
    
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
        NSDictionary *menuDescription;
        if([messageError length]==0){
            // create a filtered list that will contain products for the search results table.
            menuDescription = [[[[contentJSON objectForKey:@"menu"] JSONRepresentation] JSONValue]retain];
            return menuDescription;
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
    return [[NSDictionary alloc] init];
}
/************************************************************************/
/************************************************************************/
/*********************** Delegate Table *********************************/
/************************************************************************/
/************************************************************************/

-(UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0)]autorelease];
    
    UILabel *title, *votos;
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, (tableView.frame.size.width * 0.7), 40.0)];
    votos = [[UILabel alloc] initWithFrame:CGRectMake((tableView.frame.size.width * 0.7), 5.0, (tableView.frame.size.width * 0.3), 40.0)];
    
    [title setText:@"Platillos permitidos"];
    [title setNumberOfLines:3];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setFont:[UIFont systemFontOfSize:13.0]];
    
    [votos setText:@"Votos de los Usuarios"];
    [votos setNumberOfLines:2];
    [votos setBackgroundColor:[UIColor clearColor]];
    [votos setFont:[UIFont systemFontOfSize:13.0]];
    
    [header addSubview:title];
    [header addSubview:votos];
//    tableView.tableHeaderView = header;
    
    return header;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [listOfItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UILabel *menu;
    RateView  *rating;
    NSDictionary *tempMenu = [listOfItems objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        menu = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 0.0, (cell.frame.size.width * 0.6), cell.frame.size.height)];
        [menu setFont:[UIFont systemFontOfSize:14.0]];
        [menu setNumberOfLines:2];
        [menu setBackgroundColor:[UIColor clearColor]];
        [menu setTag:LABEL_MENU_TAG];
        [cell addSubview:menu];
        
        
        rating = [[RateView alloc] initWithFrame:CGRectMake((cell.frame.size.width * 0.65), 0.0, (cell.frame.size.width * 0.35), cell.frame.size.height)];
        [rating setTag:VIEW_IMAGE_TAG];
        [cell addSubview:rating];
        
    }else{
        menu =   (UILabel *) [cell viewWithTag:LABEL_MENU_TAG];
        rating = (RateView *) [cell viewWithTag:VIEW_IMAGE_TAG];
    }
    
    [menu setText:[tempMenu objectForKey:@"nombre"]];
    [menu setTextColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////
    ///////////////////////////////////////////////////

    rating.notSelectedImage = [UIImage imageNamed:@"Rating_-46.png"];
    rating.halfSelectedImage = [UIImage imageNamed:@"Rating_-45.png"];
    rating.fullSelectedImage = [UIImage imageNamed:@"Rating_-44.png"];
    rating.rating = [[tempMenu objectForKey:@"rating"] floatValue];
    rating.editable = NO;
    rating.maxRating = MAX_RATING;
    rating.delegate = self;
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showLoadingView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tempMenu = [listOfItems objectAtIndex:indexPath.row];
    PlatilloViewController *detail = [[PlatilloViewController alloc] initWithNibName:@"PlatilloViewController" bundle:nil];
    detail.menu = [self loadJSONDetail:[tempMenu objectForKey:@"id"]];
    detail.restaurantName = [itemMenu objectForKey:@"nombre"];
    [self.navigationController pushViewController:detail animated:YES];

}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

-(CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    NSLog(@"Rating: %.2f", rating);
}
@end
