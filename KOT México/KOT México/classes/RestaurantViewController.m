//
//  RestaurantViewController.m
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/12/11.
//  Copyright (c) 2011 Naranya. All rights reserved.
//

#import "RestaurantViewController.h"
#import "Restaurant.h"
@implementation RestaurantViewController

#define BACKGROUND_TAG 1
#define TITLE_LABEL_TAG 2

@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 
#pragma mark Lifecycle methods

- (void)viewDidLoad
{	
	
    [self loadJSONService];
    
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
    self.searchDisplayController.searchBar.scopeButtonTitles = [[NSArray alloc]initWithObjects:@"All",nil];//,@"Monterrey",@"San Pedro", nil];
}

- (void)viewDidUnload
{
	self.filteredListContent = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

#pragma mark -
#pragma mark UITableView data source and delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
     NSDictionary *itemJSon = [[[restaurante objectAtIndex:section] JSONRepresentation] JSONValue];
    return @"A";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
   // UILabel *title;
    UIImageView *background_img;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        /*
        title=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.origin.x, cell.frame.origin.y)];
        [title setBackgroundColor:[UIColor clearColor]];
        title.tag = TITLE_LABEL_TAG;
        */
        
        background_img = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.origin.x, cell.frame.origin.y)];
        background_img.tag = BACKGROUND_TAG;
        
        
        [cell.contentView addSubview:background_img];
        //[cell.contentView addSubview:title];
        
	}else{
        //title = (UILabel *)[cell viewWithTag:TITLE_LABEL_TAG];
        background_img = (UIImageView *) [cell viewWithTag:BACKGROUND_TAG];
    }
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	Restaurant *restaurant = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView){
        restaurant = [self.filteredListContent objectAtIndex:indexPath.row];
    }else{
        restaurant = [self.listContent objectAtIndex:indexPath.row];
    }
    
    
    
    [background_img setImage:[UIImage imageNamed:@"Element-05.png"]];
   // [title setText:restaurant.name];
	[cell setBackgroundView:background_img];
//    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
	cell.textLabel.text = restaurant.name;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	Restaurant *restaurant = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        restaurant = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        restaurant = [self.listContent objectAtIndex:indexPath.row];
    }
	detailsViewController.title = restaurant.name;
    
    [[self navigationController] pushViewController:detailsViewController animated:YES];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (Restaurant *restaurant in listContent)
	{
		if ([scope isEqualToString:@"All"] || [restaurant.type isEqualToString:scope])
		{
			NSComparisonResult result = [restaurant.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.filteredListContent addObject:restaurant];
            }
		}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)loadJSONService{
    [self showSplashScrean];
    
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotRestaurantes.php"] autorelease];
    
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
        NSString *text = [[NSString alloc] initWithFormat:@"JSON Parsing failed: %@", [error localizedDescription]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:text delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }else{
        // create a filtered list that will contain products for the search results table.
         restaurante= [[contentJSON mutableArrayValueForKey:@"restaurante"]retain];
         NSMutableArray *tempRestaurant = [[[NSMutableArray alloc] init]retain];
        for(int i = 0; i< [restaurante count]; i++){
            NSDictionary *itemJSon = [[[restaurante objectAtIndex:i] JSONRepresentation] JSONValue];
            NSMutableArray *objRestaurant = [[[itemJSon objectForKey:@"items"] JSONRepresentation] JSONValue];
            for (int b = 0; b<[objRestaurant count]; b++) {
                NSDictionary *tempJsonDetail = [[[objRestaurant objectAtIndex:b] JSONRepresentation] JSONValue];
                [tempRestaurant addObject:[Restaurant restaurantWithType:@"All" name:[tempJsonDetail objectForKey:@"nombre"] idrestaurant:[tempJsonDetail objectForKey:@"id"]]];
            }
        }
        listContent = [[NSArray alloc] initWithArray:tempRestaurant];
    }
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
}

-(void) showSplashScrean{

   splashLoading = [LoadingView loadingViewInView:self.navigationController.view];
    
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}

@end
