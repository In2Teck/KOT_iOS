//
//  MetodoKotViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "MetodoKotViewController.h"
#import "MetodoEjemploViewController.h"
#import "CollapsableTableViewViewController.h"
#import "Flurry.h"

@implementation MetodoKotViewController
@synthesize infoCell;
@synthesize ejemKotCell;

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
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Nota";
    [Flurry logEvent:@"Mi Método KOT" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"No",@"Login", nil] timed:YES];
    [Flurry setEventLoggingEnabled:YES];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return 65;
    if(indexPath.row == 2)
        return 270.0;

    return 44.0;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell...
    if(indexPath.row == 0)
        return infoCell;
    
    if(indexPath.row == 2)
        return ejemKotCell;
    
    if(indexPath.row == 1){
        [cell setBackgroundColor: [UIColor colorWithRed:0.0f/255.0f green:93.0f/255.0f blue:163.0f/255.0f alpha:1.0f]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setText:@"Especialistas KOT"];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        //[cell.contentView setBackgroundColor:[UIColor clearColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    NSLog(@"select item : %i", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        CollapsableTableViewViewController *ntvc = [[CollapsableTableViewViewController alloc] initWithNibName:@"CollapsableTableViewViewController" bundle:nil];
        [self.navigationController pushViewController:ntvc animated:YES];
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(IBAction)ejemploMujerIntensa:(id)sender{
    sqlite = [[CommonDAO alloc] init];
    
    MetodoEjemploViewController *ejemplo = [[[MetodoEjemploViewController alloc]initWithNibName:@"MetodoEjemploViewController" bundle:nil]autorelease];
    
    ejemplo.miMetodo = [sqlite select:@"SELECT descripcion, desayuno, comida, colacion, cena FROM mi_metodo WHERE id_mi_metodo = 1;" keys:[[NSArray alloc] initWithObjects:@"descripcion",@"desayuno",@"comida",@"colacion",@"cena", nil]];
    [ejemplo setType:1];
    
    [self.navigationController pushViewController:ejemplo animated:YES];
    
}

-(IBAction)ejemploMujerProgresiva:(id)sender{
    sqlite = [[CommonDAO alloc] init];
    
    MetodoEjemploViewController *ejemplo = [[[MetodoEjemploViewController alloc]initWithNibName:@"MetodoEjemploViewController" bundle:nil]autorelease];
    
    ejemplo.miMetodo = [sqlite select:@"SELECT descripcion, desayuno, comida, colacion, cena FROM mi_metodo WHERE id_mi_metodo = 2;" keys:[[NSArray alloc] initWithObjects:@"descripcion",@"desayuno",@"comida",@"colacion",@"cena", nil]];
    [ejemplo setType:2];
    
    [self.navigationController pushViewController:ejemplo animated:YES];
}

-(IBAction)ejemploHombreIntenso:(id)sender{
    sqlite = [[CommonDAO alloc] init];
    
    MetodoEjemploViewController *ejemplo = [[[MetodoEjemploViewController alloc]initWithNibName:@"MetodoEjemploViewController" bundle:nil]autorelease];
    
    ejemplo.miMetodo = [sqlite select:@"SELECT descripcion, desayuno, comida, colacion, cena FROM mi_metodo WHERE id_mi_metodo = 3;" keys:[[NSArray alloc] initWithObjects:@"descripcion",@"desayuno",@"comida",@"colacion",@"cena", nil]];
    [ejemplo setType:3];
    
    [self.navigationController pushViewController:ejemplo animated:YES];
}
-(IBAction)ejemploHombreProgresivo:(id)sender{
    sqlite = [[CommonDAO alloc] init];
    
    MetodoEjemploViewController *ejemplo = [[[MetodoEjemploViewController alloc]initWithNibName:@"MetodoEjemploViewController" bundle:nil]autorelease];
    
    ejemplo.miMetodo = [sqlite select:@"SELECT descripcion, desayuno, comida, colacion, cena FROM mi_metodo WHERE id_mi_metodo = 4;" keys:[[NSArray alloc] initWithObjects:@"descripcion",@"desayuno",@"comida",@"colacion",@"cena", nil]];
    
    [ejemplo setType:4];
    
    [self.navigationController pushViewController:ejemplo animated:YES];
}
@end
