//
//  ProductosViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ProductosViewController.h"
#import "ProductoDetailViewController.h"
#import "VideosKOTViewController.h"
#import "CollapsableTableViewViewController.h"
#import "Flurry.h"
#import "VideoDetailViewController.h"

@implementation ProductosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        self.title =@"Productos KOT";
        if(!sqlite)
            sqlite = [[CommonDAO alloc] init];
        
        items = [sqlite select:@"SELECT id_cat_productos, productos FROM cat_productos;" keys:[[NSArray alloc]initWithObjects:@"id_cat_productos",@"productos", nil]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    video_items = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"back-26.png"]];
    
    [Flurry logEvent:@"Productos Kot Home" withParameters:nil timed:YES];
    
    [self loadVideos];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [items count ]+3;
}

-(void)loadVideos{
    NSString *urlConnection = @"http://desarrollo.sysop26.com/kot/nuevo/WS/kotVideos.php";
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
            NSArray *videos  = [[[contentJSON objectForKey:@"videos"]JSONRepresentation]JSONValue];
            
            for(NSDictionary *video in videos){
                
                NSArray *videoArray = [NSArray arrayWithObjects:[video objectForKey:@"Id"], [video objectForKey:@"Url"],@"", [video objectForKey:@"Nombre"], [video objectForKey:@"Nombre"], [[[video objectForKey:@"Url"] componentsSeparatedByString:@"?v="] lastObject], [video objectForKey:@"thumbnail"], nil];
                
                if ([[video objectForKey:@"id_categoria"] integerValue] == 3 ){
                    [video_items addObject:videoArray];
                     NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[video objectForKey:@"thumbnail"]]];
                    [video_thumb addObject: imageData];
                    
                }
            }
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
//    UILabel *mainLabel;
//    UIImageView *background;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    if (indexPath.row == 0){
        [cell.textLabel setText:@"El Método KOT"];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setBackgroundColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
        //[cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Element-05.png"]]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.row==1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setBackgroundColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
    } else if ( indexPath.row < 5){
        [cell.textLabel setText:[[items objectAtIndex:indexPath.row-2]objectAtIndex:1]];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 2){
            [cell setBackgroundColor: [UIColor colorWithRed:171.0f/255.0f green:33.0f/255.0f blue:142.0f/255.0f alpha:1.0f]];
        }else if(indexPath.row == 3){
            [cell setBackgroundColor: [UIColor colorWithRed:92.0f/255.0f green:45.0f/255.0f blue:145.0f/255.0f alpha:1.0f]];
        }else if(indexPath.row == 4){
            [cell setBackgroundColor: [UIColor colorWithRed:0.0f/255.0f green:93.0f/255.0f blue:163.0f/255.0f alpha:1.0f]];
        }
        //[cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Element-05.png"]]];
    } else if(indexPath.row == 5){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setBackgroundColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
            cell.accessoryType = UITableViewCellAccessoryNone;
    } else if(indexPath.row > 5){
        
        if(indexPath.row == 6){
            [cell.textLabel setText:[[items objectAtIndex:indexPath.row-3]objectAtIndex:1]];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
            //[cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Element-05.png"]]];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            [cell.textLabel setText:[[items objectAtIndex:indexPath.row -3]objectAtIndex:1]];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor: [UIColor colorWithRed:92.0f/255.0f green:193.0f/255.0f blue:166.0f/255.0f alpha:1.0f]];
            //[cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barra amarilla.png"]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            //[cell.textLabel setTextColor:[UIColor grayColor]];
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] init]autorelease];
    barButton.title = @"Regresar";
    
    self.navigationItem.backBarButtonItem = barButton;
    
    if (indexPath.row == 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        VideoDetailViewController *vdvc = [[VideoDetailViewController alloc] initWithNibName:@"VideoDetailViewController" bundle:nil];
        vdvc.videoDetail = [video_items objectAtIndex:0];
        vdvc.title = [[video_items objectAtIndex:0]objectAtIndex:3];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
        barButton.title = @"Regresar";
        
        self.navigationItem.backBarButtonItem = barButton;
        
        [self.navigationController pushViewController:vdvc animated:YES];
    } else if (indexPath.row  == 1){
        // ESTÁ EN BLANCO?
    } else if(indexPath.row == 5){
        [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if(indexPath.row<5){
        
        ProductoDetailViewController *prod = [[ProductoDetailViewController alloc] initWithNibName:@"ProductoDetailViewController" bundle:nil];
        prod.productoDetail = [items objectAtIndex:indexPath.row-2];
        
        prod.title = [[items objectAtIndex:indexPath.row-2]objectAtIndex:1];
        
        [self.navigationController pushViewController:prod animated:YES];
    } else if(indexPath.row==6){
        VideosKOTViewController *videos = [[VideosKOTViewController alloc]initWithNibName:@"VideosKOTViewController" bundle:nil];
        videos.title = [[items objectAtIndex:indexPath.row-3]objectAtIndex:1];
        [self.navigationController pushViewController:videos animated:YES];
    } else if(indexPath.row==7){
        CollapsableTableViewViewController *control = [[[CollapsableTableViewViewController alloc]initWithNibName:@"CollapsableTableViewViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:control animated:YES];
    }
}

@end
