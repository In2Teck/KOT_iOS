//
//  CollapsableTableViewViewController.m
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollapsableTableViewViewController.h"
#import "CollapsableTableView.h"
#import "Flurry.h"

#define LABEL_DIR 1
#define BTN_CALL  2
#define BTN_MAP   3
#define BTN_DIR   4
#define LBL_DST   5

@implementation CollapsableTableViewViewController
@synthesize segmented;
@synthesize myTableView;
@synthesize selectPicker, locationManager, segmentedControl, locationPicker, loadingIndicator;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    self.title = @"Especialistas KOT";
    [Flurry logEvent:self.title withParameters:nil timed:YES];
    
    isMonterrey = YES;
    
    //[selectPicker setEnabled:NO];
    
    dataSourseList = [[[NSMutableArray alloc]init]retain];
    
    //[self performSelectorInBackground:@selector(loadingJSONNutriologos) withObject:nil];
    
    [self.segmentedControl setEnabled:NO];
    self.indexStr = [[NSString alloc] initWithString:@"0"];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    locationPicker.delegate = self;
    locationPicker.dataSource = self;
    [locationPicker setShowsSelectionIndicator:YES];
    
    //NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"nombre"]];
    
//    [self.selectPicker setTitle:titelString forState:UIControlStateNormal];
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [self loadPicker];
}

- (void) loadPicker {
    [self loadingJSONNutriologos];
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:0]JSONRepresentation]JSONValue];
    self.indexStr = [ciudadDictionary valueForKey:@"id"];
    [self cargarNutriologos:[ciudadDictionary valueForKey:@"id"]];
    [locationPicker reloadAllComponents];
    [self.myTableView reloadData];
    [loadingIndicator stopAnimating];
    [self.segmentedControl setEnabled:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
    //(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataSourseList count];
}


+ (NSString*) titleForHeaderForSection:(int) section
{
    
    //    NSDictionary *itemJSon = [[[listNutriologos objectAtIndex:section] JSONRepresentation] JSONValue];
    //    return [itemJSon objectForKey:@"nombre"];
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(0, 0, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:12];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return [CollapsableTableViewViewController titleForHeaderForSection:section];
    
    NSDictionary *itemJSon = [[[dataSourseList objectAtIndex:section] JSONRepresentation] JSONValue];
    
    return [itemJSon objectForKey:@"nombre"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemJSon = [[[dataSourseList objectAtIndex:indexPath.section] JSONRepresentation] JSONValue];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *direccion, *myDistancia;
    UIButton *call,*map;//,*dir;
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        direccion = [[[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 200.0, 50.0)]autorelease];
        [direccion setTag:LABEL_DIR];
        [direccion setBackgroundColor:[UIColor clearColor]];
        [direccion setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [direccion setNumberOfLines:4];
        [direccion setFont:[UIFont systemFontOfSize:12.0]];
        [direccion setTextAlignment:UITextAlignmentCenter];
        [direccion setTextColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
        [cell.contentView addSubview:direccion];
        
        
        call = [[[UIButton alloc] initWithFrame:CGRectMake(215.0, 15.0, 40.0, 40.0)]retain];
        [call setImage:[UIImage imageNamed:@"telefono_2.png"] forState:UIControlStateNormal];
        [call setTag:BTN_CALL];
        [call setBackgroundColor:[UIColor clearColor]];
        
        //        [call setTitle:[[NSString alloc] initWithFormat:@"%i",indexPath.section] forState:UIControlStateNormal];
        [call addTarget:self action:@selector(callNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell.contentView addSubview:call];
        
        map = [[[UIButton alloc] initWithFrame:CGRectMake(252.0, 15.0, 40.0, 40.0)]retain];
        [map setTag:BTN_MAP];
        [map setImage:[UIImage imageNamed:@"localizador_2.png"] forState:UIControlStateNormal];
        [map setBackgroundColor:[UIColor clearColor]];
        
        [map addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:map];
        
        //dir = [[[UIButton alloc] initWithFrame:CGRectMake(280.0, 20.0, 40.0, 40.0)]retain];
        //[dir setTag:BTN_DIR];
        //[dir setImage:[UIImage imageNamed:@"ElementsKOT-13.png"] forState:UIControlStateNormal];
        //[dir setBackgroundColor:[UIColor clearColor]];
        
        //[dir addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
        
        //[cell.contentView addSubview:dir];
        
        myDistancia = [[[UILabel alloc] initWithFrame:CGRectMake(180.0, 55.0, 150.0, 20.0)]retain];
        [myDistancia setTag:LBL_DST];
        //        [myDistancia setTextColor:[UIColor lightGrayColor]];
        //        [myDistancia setFont:[UIFont systemFontOfSize:11.0]];
        [myDistancia setTextAlignment:UITextAlignmentCenter];
        [myDistancia setBackgroundColor:[UIColor clearColor]];
        [myDistancia setTextColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
        [cell.contentView addSubview:myDistancia];
        [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }else{
        direccion = (UILabel*)[cell viewWithTag:LABEL_DIR];
        call = (UIButton*)[cell viewWithTag:BTN_CALL];
        map = (UIButton*)[cell viewWithTag:BTN_MAP];
        //dir = (UIButton*)[cell viewWithTag:BTN_DIR];
        myDistancia = (UILabel *) [cell viewWithTag:LBL_DST];
    }
    
	// Configure the cell.
    
    
    
    [direccion setText:[[NSString alloc]initWithFormat:@"%@\nTel: %@",[itemJSon objectForKey:@"direccion"],[itemJSon objectForKey:@"telefono"]]];
    
    [call.titleLabel setText:[[NSString alloc]initWithFormat:@"%@",[itemJSon objectForKey:@"telefono"]]];
    //[dir.titleLabel setText:[[NSString alloc]initWithFormat:@"%i",indexPath.section]];
    [map.titleLabel setText:[[NSString alloc]initWithFormat:@"%i",indexPath.section]];
    
    /*NSString *latitude = [itemJSon objectForKey:@"latitud"];
     NSString *longitude = [itemJSon objectForKey:@"longitud"];
     CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:[latitude floatValue]  longitude:[longitude floatValue]];*/
    [myDistancia setText:[NSString stringWithFormat:@"GPS:%.1f km", [[itemJSon objectForKey:@"loc"] floatValue] ]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

//- (IBAction) toggleSection2
//{
//    NSString* sectionTitle = //[NSString stringWithFormat:@"Tag %i",1];
//        [CollapsableTableViewViewController titleForHeaderForSection:1];
//    CollapsableTableView* collapsableTableView = (CollapsableTableView*) myTableView;
//    BOOL isCollapsed = [[collapsableTableView.headerTitleToIsCollapsedMap objectForKey:sectionTitle] boolValue];
//    [collapsableTableView setIsCollapsed:! isCollapsed forHeaderWithTitle:sectionTitle];
//}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
//    [locationPicker release];
    [locationPicker release];
    [loadingIndicator release];
    [super dealloc];
}


-(void)showLoadingView{
    LoadingView *loadingView = [LoadingView loadingViewInView:self.navigationController.view];
    
    [loadingView performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}

-(CGFloat)getDistance:(CLLocation *)lManager{
    /******************************************************/
    /******************************************************/
    /**************** Config Localitation *****************/
    /******************************************************/
    /******************************************************/
    return [[self.locationManager location] distanceFromLocation:lManager]/1000.0;
}

-(void)loadingJSONNutriologos{
    
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotNutriologos.php"] autorelease];
    
    NSURL *url = [[[NSURL alloc] initWithString:urlConnection] autorelease];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
    // Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *jsonData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    jsonData = [jsonData stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    
    NSLog(@"JSON: %@", jsonData);
    
    NSError *jsonError;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *contentJSON = [json objectWithString:jsonData error:&jsonError];
    if (contentJSON==nil) {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", [jsonError description]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        //listNutriologos = [[[NSMutableArray alloc] init]retain];
        ciudades = [[NSMutableArray alloc] init];
        
        listNutriologos = [[contentJSON mutableArrayValueForKey:@"nutriologos"]retain];
        [listNutriologos retain];
        ciudades = [[contentJSON mutableArrayValueForKey:@"municipios"]retain];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES];
        [ciudades sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        [ciudades retain];
        
        if([listNutriologos count]>0 && [ciudades count]>0){
            [selectPicker setEnabled:YES];
            /*NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:0]JSONRepresentation]JSONValue];
             NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"nombre"]];
             [self.selectPicker setTitle:titelString forState:UIControlStateNormal];
             [self cargarNutriologos:[ciudadDictionary valueForKey:@"id"]];
             [self.myTableView reloadData];*/
        }else{
            [self.selectPicker setEnabled:NO];
        }
        
    }
    
    
}



- (void)locationUpdate:(CLLocation *)location {
	//locationLabel.text = [location description];
}


- (void)locationError:(NSError *)error {
	//locationLabel.text = [error description];
}

-(IBAction)callNumber:(id)sender{
    UIButton *myButton = (UIButton*) sender;
    numberPhone = [[NSString alloc] initWithFormat:@"tel://%@",myButton.titleLabel.text];
    
    NSString *asd = [[NSString alloc]initWithFormat:@"¿Desea realizar la llamada?"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"KOT México" message:asd
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Llamar", nil];
    [alert show];
    [alert release];
    
}

-(IBAction)addContact:(id)sender{
    
    UIButton *myButton = (UIButton*) sender;
    selectContact = [myButton.titleLabel.text intValue];
    
    NSDictionary *itemJSon = [[[dataSourseList objectAtIndex:selectContact] JSONRepresentation] JSONValue];
    
    NSString *asd = [[NSString alloc]initWithFormat:@"Agregar %@ a la lista de contactos?",[itemJSon objectForKey:@"nombre"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"KOT México" message:asd
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSLog(@"title button: %@", [alertView buttonTitleAtIndex:buttonIndex]);
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add"]){
        NSDictionary *itemJSon = [[[dataSourseList objectAtIndex:selectContact] JSONRepresentation] JSONValue];
        
        CFErrorRef *anError;
        ABAddressBookRef addressBook = ABAddressBookCreate(); // create address book record
        ABRecordRef person = ABPersonCreate(); // create a person
        
        NSString *phone = [[NSString alloc]initWithFormat:@"%@",[itemJSon objectForKey:@"telefono"]]; // the phone number to add
        
        //Phone number is a list of phone number, so create a multivalue
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,phone,kABPersonPhoneMobileLabel, NULL);
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, [itemJSon objectForKey:@"nombre"] , nil); // first name of the new person
        ABRecordSetValue(person, kABPersonLastNameProperty, @"", nil); // his last name
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, &anError); // set the phone number property
        ABAddressBookAddRecord(addressBook, person, nil); //add the new person to the record
        ABAddressBookSave(addressBook, nil); //save the record
        
        CFRelease(person); // relase the ABRecordRef  variable
    }
    
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Llamar"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numberPhone]];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:numberPhone]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numberPhone]]; }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KOT México" message:@"Tu dispositivo no puede hacer llamadas." delegate:nil cancelButtonTitle:@"Cancelar" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}
-(IBAction)showMap:(id)sender{
    UIButton *myButton = (UIButton*) sender;
    NSDictionary *itemJSon = [[[dataSourseList objectAtIndex:[myButton.titleLabel.text intValue]] JSONRepresentation] JSONValue];
    NSString *latitude = [itemJSon objectForKey:@"latitud"];
    NSString *longitude = [itemJSon objectForKey:@"longitud"];
    //
    //    NSLog(@"%@, %@", latitude, longitude);
    //
    if ([latitude length] >0 && [longitude length]>0) {
        //
        MKMapView *mapView = [[[MKMapView alloc] initWithFrame:self.view.bounds]autorelease];
        mapView.mapType = MKMapTypeStandard;
        
        CLLocationCoordinate2D coord = {.latitude =  [latitude floatValue], .longitude =  [longitude floatValue]};
        MKCoordinateSpan span = {.latitudeDelta =  0.01, .longitudeDelta =  0.01};
        MKCoordinateRegion region = {coord, span};
        
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        //        annotationPoint.coordinate = coord;
        annotationPoint.title = [itemJSon objectForKey:@"nombre"];
        annotationPoint.subtitle = [itemJSon objectForKey:@"direccion"];
        [annotationPoint setCoordinate:coord];
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

-(IBAction)showPicker:(id)sender{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Selecciona tu región"
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"OK",nil];
    // Add the picker
    pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView setShowsSelectionIndicator:YES];
    
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:0]JSONRepresentation]JSONValue];
    NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"nombre"]];
    [self.selectPicker setTitle:titelString forState:UIControlStateNormal];
    self.indexStr = [ciudadDictionary valueForKey:@"id"];
    [self cargarNutriologos:[ciudadDictionary valueForKey:@"id"]];
    [self.myTableView reloadData];
    
    //    [pickerView selectRow:0 inComponent:0 animated:YES];
    
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    
//    CGRect menuRect = menu.frame;
//    menuRect.origin.y -= 197;
//    menuRect.size.height = 360;
//    menu.frame = menuRect;
//    [menu setAutoresizesSubviews:NO];
    
    CGRect pickerRect = pickerView.frame;
    pickerRect.origin.y = 90;
    pickerView.frame = pickerRect;
    [pickerView setAutoresizesSubviews:NO];
    [pickerView release];
    [menu release];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // Near-infinite number of rows.
    return [ciudades count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [ciudades count] ? 1:0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // Row n is same as row (n modulo numberItems).
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:row] JSONRepresentation] JSONValue];
    return [ciudadDictionary valueForKey:@"nombre"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //UILabel *label = (id)view;
    /*if (!label) {
        label = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
    }*/
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    //label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [self pickerView:locationPicker titleForRow:row forComponent:component];
    //label.font = [UIFont systemFontOfSize:14];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:row]JSONRepresentation]JSONValue];
    NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"nombre"]];
    //[self.selectPicker setTitle:titelString forState:UIControlStateNormal];
    self.indexStr = [ciudadDictionary valueForKey:@"id"];
    [self cargarNutriologos:[ciudadDictionary valueForKey:@"id"]];
}

-(void)cargarNutriologos:(NSString *)idCiudad{
    [self.segmentedControl setHidden:NO];
    if(!dataSourseList)
        dataSourseList = [[NSMutableArray alloc] init];
    else{
        [dataSourseList release];
        dataSourseList = nil;
        
        dataSourseList = [[NSMutableArray alloc] init];
    }
    
    for(int i = 0; i< [listNutriologos count]; i++){
        NSDictionary *itemJSon = [[[listNutriologos objectAtIndex:i] JSONRepresentation] JSONValue];
        NSMutableArray *objNutriologos = [[[itemJSon objectForKey:@"items"] JSONRepresentation] JSONValue];
        for (int b = 0; b<[objNutriologos count]; b++) {
            NSMutableDictionary *description = [[[objNutriologos objectAtIndex:b] JSONRepresentation]JSONValue];
            
            if([[description objectForKey:@"id_municipio"]intValue]== [idCiudad intValue]){
                CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:[[description objectForKey:@"latitud"] floatValue]  longitude:[[description objectForKey:@"longitud"] floatValue]];
                NSLog(@"LAT %.2f LONG %.2f",[[description objectForKey:@"latitud"] floatValue] , [[description objectForKey:@"longitud"] floatValue]  );
                NSNumber *loc = [[NSNumber alloc] initWithFloat:[self getDistance:tmpLocation]];
                [description setObject:loc forKey:@"loc"];
                [dataSourseList addObject:description];
            }
            
        }
    }
    
    if (segmentedControl.selectedSegmentIndex == 1){
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"loc" ascending:YES];
        [dataSourseList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    [self.myTableView reloadData];
}
- (IBAction)segmentedControlChanged:(id)sender {
    [self cargarNutriologos:self.indexStr];
}
@end