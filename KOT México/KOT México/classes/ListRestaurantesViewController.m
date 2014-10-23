//
//  ListRestaurantesViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 01/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ListRestaurantesViewController.h"
#import "OverlayViewController.h"
#import "RestauranteMenuViewController.h"
#import "Flurry.h"


@implementation ListRestaurantesViewController

@synthesize comboButton, segmentedControl, locationManager, indexStr, locationPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Restaurantes";
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
    [Flurry logEvent:@"Guia de Restaurantes" withParameters:nil timed:YES];
//    [self performSelectorInBackground:@selector(loadJSONService) withObject:nil];
    
    [self.comboButton setEnabled:NO];
    [self.segmentedControl setEnabled:NO];
    
    locationPicker.delegate = self;
    locationPicker.dataSource = self;
    [locationPicker setShowsSelectionIndicator:YES];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated{
    [self loadPicker];
}

- (void) loadPicker {
    [self loadJSONService];
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:0]JSONRepresentation]JSONValue];
    self.indexStr = [ciudadDictionary valueForKey:@"id_area"];
    [self cargarRestaurantes:[ciudadDictionary valueForKey:@"id_area"]];
    [locationPicker reloadAllComponents];
    [self.tableView reloadData];
    [self.segmentedControl setEnabled:YES];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    //label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    //    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [self pickerView:locationPicker titleForRow:row forComponent:component];
    label.font = [UIFont systemFontOfSize:14];
    return label;
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
/********************************************************/
/********************************************************/
/******************* Methods ****************************/
/********************************************************/
/********************************************************/
#pragma mark Table view methods

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	if (searching)
		return 1;
	else if (segmentedControl.selectedSegmentIndex == 0) {
        if ([listOfItems count]>0)
            return [listOfItems count] - 1;
        else
            return 0;
    } else {
        return 1;
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (searching)
		return [copyListOfItems count];
	else {
		if (segmentedControl.selectedSegmentIndex == 0){
            //Number of rows it should expect should be based on the section
            NSDictionary *dictionary = [listOfItems objectAtIndex:section];
            NSArray *array = [dictionary objectForKey:@"Names"];
            return [array count];
        } else {
            return [listOfItems count];
        }
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(searching)
		return @"Resultados de Búsqueda:";
	if ([listOfItems count]>0 && segmentedControl.selectedSegmentIndex == 0) {
        NSDictionary *tempLetters = [listOfItems objectAtIndex:([listOfItems count] -1 )];
        NSArray *letters = [tempLetters objectForKey:@"letters"];
        return [letters objectAtIndex:section];
    }
    return @"Restaurantes";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSDictionary *tempDictionary;
	if(searching) {
        tempDictionary = [copyListOfItems objectAtIndex:indexPath.row];
		cell.text = [tempDictionary objectForKey:@"nombre"];
    }else {
		//First get the dictionary object
        NSArray *array;
        if (segmentedControl.selectedSegmentIndex == 0){
            NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
            //NSLog(@"SECTION %i ROW %i", indexPath.section, indexPath.row );
            array = [dictionary objectForKey:@"Names"];
        } else {
            array = listOfItems;
        }
        
        tempDictionary = [array objectAtIndex:indexPath.row];
        NSString *cellValue = [tempDictionary objectForKey:@"nombre"];
        cell.text = cellValue;
	}
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
    //[cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Element-05.png"]]];
    //cell.backgroundView.alpha = 0.3;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    [self showSplashScrean];
    
	//Get the selected country
	
	NSString *selectedCountry = nil;
	NSDictionary *tempDictionary;
	if(searching){
        tempDictionary = [copyListOfItems objectAtIndex:indexPath.row];
		selectedCountry = [tempDictionary objectForKey:@"nombre"];
    }else {
        NSArray *array;
        if (segmentedControl.selectedSegmentIndex == 0){
            NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
            array = [dictionary objectForKey:@"Names"];
        } else {
            array = listOfItems;
        }
        tempDictionary = [array objectAtIndex:indexPath.row];
		selectedCountry = [tempDictionary objectForKey:@"nombre"];
	}
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    RestauranteMenuViewController *detail = [[RestauranteMenuViewController alloc] initWithNibName:@"RestauranteMenuViewController" bundle:nil];
    detail.listOfItems = [self loadJSONDetail:[tempDictionary objectForKey:@"id"]];
    detail.itemMenu = tempDictionary;
    [detail.itemMenu retain];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Regresar";
    
    self.navigationItem.backBarButtonItem = barButton; 
    
    [self.navigationController pushViewController:detail animated:YES];
    [barButton release];
    barButton = nil;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
//	
//	//return UITableViewCellAccessoryDetailDisclosureButton;
//	return UITableViewCellAccessoryDisclosureIndicator;
//}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark Search Bar 

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor blackColor];
	ovController.view.alpha = 0.8;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictionary in listOfItems)
	{
		NSArray *array = [dictionary objectForKey:@"Names"];
		[searchArray addObjectsFromArray:array];
	}
	
	for (NSDictionary *dictionaryTemp in searchArray)
	{
        NSString *sTemp = [dictionaryTemp objectForKey:@"nombre"];
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyListOfItems addObject:dictionaryTemp];
	}
	
	[searchArray release];
	searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
}

-(void)loadJSONService{
    
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotRestaurantes.php"] autorelease];
    
    NSURL *url = [[NSURL alloc] initWithString:urlConnection];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0];
    // Fetch the JSON response
	NSData *urlData = [NSData data];
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *jsonData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
    NSError *jsonError;
    SBJSON *json = [SBJSON new];
    jsonData = [jsonData stringByTrimmingCharactersInSet:[NSCharacterSet illegalCharacterSet]];
    NSLog(@"%@", jsonData);
    NSDictionary *contentJSON = [json objectWithString:jsonData error:&jsonError];
    if (contentJSON==nil) {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", [jsonError localizedDescription]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        // create a filtered list that will contain products for the search results table.
        dataSourceList = [[contentJSON mutableArrayValueForKey:@"restaurante"]retain];
        ciudades = [[contentJSON mutableArrayValueForKey:@"areas_metropolitanas"]retain];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"area" ascending:YES];
        [ciudades sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        [dataSourceList retain];
        [ciudades retain];
        
        if([ciudades count]>0 && [dataSourceList count]>0){
            [self.comboButton setEnabled:YES];
            //NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"area"]];
            //[comboButton setTitle:titelString forState:UIControlStateNormal];
            self.tableView.tableHeaderView = selectCity;
            [self.tableView reloadData];
        }else{
            [self.comboButton setEnabled:NO];
        }
    }
}

-(NSMutableArray *)loadJSONDetail:(NSString *)idRestaurante{
    
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotMenuRestaurantes.php?idRestaurante=%@",idRestaurante] autorelease];
    
    NSLog(@"%@",urlConnection);
    
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
    NSError *jsonError;
    SBJSON *json = [[SBJSON new] autorelease];
    NSDictionary *contentJSON = [json objectWithString:jsonData error:&jsonError];
    if (contentJSON==nil) {
        //NSString *text = [[NSString alloc] initWithFormat:@"%@", [error localizedDescription]];
        NSString *text = @"Prueba otro restaurante";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        // create a filtered list that will contain products for the search results table.
        NSMutableArray *restaurante= [[contentJSON mutableArrayValueForKey:@"menu"]retain];
        
        //Initialize the array.
       NSMutableArray *myListOfItems = [[NSMutableArray alloc] init];
        
        //        [myListOfItems addObject:countriesToLiveInDict];

        for(int i = 0; i< [restaurante count]; i++){
            NSDictionary *itemJSon = [[[restaurante objectAtIndex:i] JSONRepresentation] JSONValue];
            NSMutableArray *objRestaurant = [[[itemJSon objectForKey:@"items"] JSONRepresentation] JSONValue];
            if([objRestaurant count]>0){
                for (int b = 0; b<[objRestaurant count]; b++) {
                    NSDictionary *tempJsonDetail = [[[objRestaurant objectAtIndex:b] JSONRepresentation] JSONValue];
                    [myListOfItems addObject:tempJsonDetail];
                }
            }
        }
        [myListOfItems addObject:[contentJSON objectForKey:@"img"]];
        return myListOfItems;
    }
    return [[NSMutableArray alloc] init];
}


-(void) showSplashScrean{
    
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.navigationController.view];
    
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
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
    NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"area"]];
    [self.comboButton setTitle:titelString forState:UIControlStateNormal];
    self.indexStr = [ciudadDictionary valueForKey:@"id_area"];
    [self cargarRestaurantes:[ciudadDictionary valueForKey:@"id_area"]];
    
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    
    CGRect menuRect = menu.frame;
    menuRect.origin.y -= 197;
    menuRect.size.height = 360;
    menu.frame = menuRect;
    [menu setAutoresizesSubviews:NO];
    
    
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
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:row]JSONRepresentation]JSONValue];
    return [ciudadDictionary valueForKey:@"area"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *ciudadDictionary = [[[ciudades objectAtIndex:row]JSONRepresentation]JSONValue];
    NSString *titelString = [NSString stringWithFormat:@"  %@",[ciudadDictionary valueForKey:@"area"]];
    [self.comboButton setTitle:titelString forState:UIControlStateNormal];
    self.indexStr = [ciudadDictionary valueForKey:@"id_area"];
    [self cargarRestaurantes:[ciudadDictionary valueForKey:@"id_area"]];
}

-(void)cargarRestaurantes:(NSString *)idCiudad{
    [self.segmentedControl setEnabled:YES];
    [listOfItems release];
    listOfItems = nil;
    [copyListOfItems release];
    copyListOfItems = nil;
    
    listOfItems = [[NSMutableArray alloc] init];
    if (segmentedControl.selectedSegmentIndex == 0){
        NSDictionary *countriesLivedInDict;
        NSMutableArray *letters = [[NSMutableArray alloc] init];
        for(int i = 0; i< [dataSourceList count]; i++){
            NSDictionary *itemJSon = [[[dataSourceList objectAtIndex:i] JSONRepresentation] JSONValue];
            NSMutableArray *objRestaurant = [[[itemJSon objectForKey:@"items"] JSONRepresentation] JSONValue];
            if([objRestaurant count]>0){
                NSMutableArray *tempRestaurant = [[[NSMutableArray alloc] init]retain];
                if([objRestaurant count])
                    [letters addObject:[itemJSon objectForKey:@"letra"]];
                for (int b = 0; b<[objRestaurant count]; b++) {
                    NSDictionary *tempJsonDetail = [[[objRestaurant objectAtIndex:b] JSONRepresentation] JSONValue];
                    NSString *idArea = [tempJsonDetail valueForKey:@"id_area"];
                    if([idCiudad intValue] == [idArea intValue])
                        [tempRestaurant addObject:tempJsonDetail];
                }
                NSDictionary *tempDictionary = [NSDictionary dictionaryWithObject:tempRestaurant forKey:@"Names"];
                [listOfItems addObject:tempDictionary];
            }
        }
        countriesLivedInDict = [NSDictionary dictionaryWithObject:letters forKey:@"letters"];
        
        [listOfItems addObject:countriesLivedInDict];
        
    } else {
        // ORDER BY GPS
        
        for(int i = 0; i< [dataSourceList count]; i++){
            NSDictionary *itemJSon = [[[dataSourceList objectAtIndex:i] JSONRepresentation] JSONValue];
            NSMutableArray *objRestaurant = [[[itemJSon objectForKey:@"items"] JSONRepresentation] JSONValue];
            if([objRestaurant count]>0){
                for (int b = 0; b<[objRestaurant count]; b++) {
                    NSDictionary *tempJsonDetail = [[[objRestaurant objectAtIndex:b] JSONRepresentation] JSONValue];
                    NSString *idArea = [tempJsonDetail valueForKey:@"id_area"];
                    if([idCiudad intValue] == [idArea intValue]) {
                        NSMutableDictionary *restaurante = [[[objRestaurant objectAtIndex:b] JSONRepresentation] JSONValue];
                        CLLocation *tmpLocation = [[CLLocation alloc] initWithLatitude:[[restaurante objectForKey:@"latitud"] floatValue]  longitude:[[restaurante objectForKey:@"longitud"] floatValue]];
                        NSNumber *loc = [[NSNumber alloc] initWithFloat:[self getDistance:tmpLocation]];
                        [restaurante setObject:loc forKey:@"loc"];
                        [listOfItems addObject:restaurante];
                    }
                }
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"loc" ascending:YES];
        [listOfItems sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    //Initialize the copy array.
    copyListOfItems = [[NSMutableArray alloc] init];
    
    //Set the title
    //	self.navigationItem.title = @"Restaurantes";
    
    //Add the search bar
    self.tableView.tableHeaderView = selectCity;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searching = NO;
    letUserSelectRow = YES;
    
    [self.tableView reloadData];
}

-(CGFloat)getDistance:(CLLocation *)lManager{
    /******************************************************/
    /******************************************************/
    /**************** Config Localitation *****************/
    /******************************************************/
    /******************************************************/
    return [[self.locationManager location] distanceFromLocation:lManager]/1000.0;
}
 
- (void)dealloc {
    [locationPicker release];
    [super dealloc];
}
- (IBAction)segmentedControlChanged:(id)sender {
    [self cargarRestaurantes:self.indexStr];
}
@end
