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

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"back-26.png"]];
    
    [Flurry logEvent:@"Productos Kot Home" withParameters:nil timed:YES];
    
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
    return [items count ]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
//    UILabel *mainLabel;
//    UIImageView *background;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        /*
        if(indexPath.row != 3){
            
            background = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
            [background setTag:IMAGE_TAG];
            background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if (indexPath.row!=5) {
                [cell.contentView addSubview:background];
            }else{
                cell.contentView.backgroundColor = [UIColor yellowColor];
            }
            
            mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
            [mainLabel setTag:TITLE_LABEL];
            mainLabel.font = [UIFont systemFontOfSize:20.0];
            mainLabel.textAlignment = UITextAlignmentCenter;
            if(indexPath.row!=5)
                mainLabel.textColor = [UIColor whiteColor];
            else
                mainLabel.textColor = [UIColor blackColor];
            mainLabel.backgroundColor = [UIColor clearColor];
            mainLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [cell.contentView addSubview:mainLabel];
         */
        }
    /*else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else{
        if(indexPath.row != 3 || indexPath.row == 3){
            mainLabel =  (UILabel *)[cell viewWithTag:TITLE_LABEL];
            background = (UIImageView *) [cell viewWithTag:IMAGE_TAG];
        }
    }
    
    // Configure the cell...
    if(indexPath.row<3){
        [mainLabel setText:[[items objectAtIndex:indexPath.row]objectAtIndex:1]];
        [background setImage:[UIImage imageNamed:@"Element-05.png"]];
    }
    else
        [mainLabel setText:[[items objectAtIndex:(indexPath.row -1)]objectAtIndex:1]];
    */
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    if(indexPath.row < 3){
        [cell.textLabel setText:[[items objectAtIndex:indexPath.row]objectAtIndex:1]];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Element-05.png"]]];
    }
    if(indexPath.row == 3)
        cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.row > 3){
        
        if(indexPath.row == 4){
            [cell.textLabel setText:[[items objectAtIndex:indexPath.row-1]objectAtIndex:1]];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Element-05.png"]]];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }else{
            [cell.textLabel setText:[[items objectAtIndex:indexPath.row -1]objectAtIndex:1]];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barra amarilla.png"]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.textLabel setTextColor:[UIColor grayColor]];
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
    
    if(indexPath.row == 3)
        [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];

    if(indexPath.row<3){
        
        ProductoDetailViewController *prod = [[ProductoDetailViewController alloc] initWithNibName:@"ProductoDetailViewController" bundle:nil];
        prod.productoDetail = [items objectAtIndex:indexPath.row];
        
        prod.title = [[items objectAtIndex:indexPath.row]objectAtIndex:1];
        
        [self.navigationController pushViewController:prod animated:YES];
    }
    if(indexPath.row==4){
        VideosKOTViewController *videos = [[VideosKOTViewController alloc]initWithNibName:@"VideosKOTViewController" bundle:nil];
        videos.title = [[items objectAtIndex:indexPath.row-1]objectAtIndex:1];
        [self.navigationController pushViewController:videos animated:YES];
    }
    if(indexPath.row==5){
        CollapsableTableViewViewController *control = [[[CollapsableTableViewViewController alloc]initWithNibName:@"CollapsableTableViewViewController" bundle:nil]autorelease];
        [self.navigationController pushViewController:control animated:YES];
    }
}

@end
