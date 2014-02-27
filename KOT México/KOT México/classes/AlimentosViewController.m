//
//  AlimentosViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "AlimentosViewController.h"
#import "AlimentoDetailViewController.h"
#import "Flurry.h"

@implementation AlimentosViewController
@synthesize myTableViewController, isMujerIntensivo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(!sqlite)
            sqlite = [[CommonDAO alloc] init];
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
    // self.myTableViewController.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*if (isVegetariano){
        alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos WHERE vegetariano IN (1,3) ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    } else {
        alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos WHERE vegetariano IN (0,3) ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    }
 
    alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];*/
    
    alimentosList = [sqlite select:@"SELECT id_cat_alimento, cat_alimento FROM cat_alimentos WHERE vegetariano IN (0,3) ORDER BY cat_alimento ASC" keys:[[NSMutableArray alloc]initWithObjects:@"idAlimento",@"name", nil]];
    
    [Flurry logEvent:@"Alimentos Permitidos" timed:YES];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [alimentosList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Element-04.png"]]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    NSString *textoCelda = [[alimentosList objectAtIndex:indexPath.row] objectAtIndex:1];
    
    if (isMujerIntensivo && [@"Pan/Cereales/Leguminosas" isEqualToString:textoCelda]){
        [cell.textLabel setText:@"Pan/Cereales"];
    } else {
        [cell.textLabel setText:textoCelda];
    }
    //[cell.textLabel setBackgroundColor:[UIColor redColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    
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
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AlimentoDetailViewController *detailViewController = [[AlimentoDetailViewController alloc] initWithNibName:@"AlimentoDetailViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.alimentoDetail = [alimentosList objectAtIndex:indexPath.row];
    
    NSString *textoCelda = [[alimentosList objectAtIndex:indexPath.row] objectAtIndex:1];
    
    if (isMujerIntensivo && [@"Pan/Cereales/Leguminosas" isEqualToString:textoCelda]){
        detailViewController.title = @"Pan/Cereales";
    } else {
        if([@"Pan/Cereales/Leguminosas" isEqualToString:textoCelda]) {
            NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15<=12],UITextAttributeFont, nil];
            self.navigationController.navigationBar.titleTextAttributes = size;
        }
        detailViewController.title = textoCelda;
    }
    
    detailViewController.isMujerIntensivo = self.isMujerIntensivo;
    
    UIBarButtonItem *barButton = [[[UIBarButtonItem alloc] init]autorelease];
    barButton.title = @"Regresar";
    
    self.navigationItem.backBarButtonItem = barButton;
    
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}

@end
