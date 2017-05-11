//
//  AlimentoDetailViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "AlimentoDetailViewController.h"

#define TITLE_LABEL 1
#define DESC_LABEL  2

@implementation AlimentoDetailViewController

@synthesize alimentoDetail;
@synthesize myTableView,type, isMujerIntensivo;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.isMujerIntensivo) {
        descripcion = [sqlite
                       select: [[NSString alloc] initWithFormat:
                                @"SELECT id_alimento, id_cat_alimento, alimento, descripcion FROM alimentos WHERE id_cat_alimento = %@ AND mujer_intensiva = 1 ORDER BY alimento ASC;", [alimentoDetail objectAtIndex:0]]
                       keys:[[NSArray alloc] initWithObjects:@"id_alimento",@"id_cat_alimento",@"alimento",@"descripcion", nil]];
        
    } else {
        descripcion = [sqlite
                       select: [[NSString alloc] initWithFormat:
                                @"SELECT id_alimento, id_cat_alimento, alimento, descripcion FROM alimentos WHERE id_cat_alimento = %@ ORDER BY alimento ASC;", [alimentoDetail objectAtIndex:0]]
                       keys:[[NSArray alloc] initWithObjects:@"id_alimento",@"id_cat_alimento",@"alimento",@"descripcion", nil]];
    }
    
    //self.title = [alimentoDetail objectAtIndex:1];
    
    [super viewDidLoad];
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

/*-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //return @"Los alimentos que tenga * no se permiten en la fase de mujer intensivo";
   return [alimentoDetail objectAtIndex:1];
}*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [descripcion count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *title, *description;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        title = [[UILabel alloc] initWithFrame:CGRectMake(7.0, 0.0, 230.0, 44.0)];
        title.tag = TITLE_LABEL;
        title.numberOfLines = 3;
        title.font = [UIFont systemFontOfSize:12.0];
        title.textAlignment = UITextAlignmentLeft;
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:title];
        
        description = [[UILabel alloc] initWithFrame:CGRectMake(210.0, 0.0, 109.0, 44.0)];
        description.tag = DESC_LABEL;
        description.numberOfLines = 3;
        description.font = [UIFont systemFontOfSize:12.0];
        description.textAlignment = UITextAlignmentLeft;
        description.textColor = [UIColor blackColor];
        description.backgroundColor = [UIColor clearColor];
        description.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:description];
    }else{
        title = (UILabel *)[cell viewWithTag:TITLE_LABEL];
        description = (UILabel*) [cell viewWithTag:DESC_LABEL];
    }
    
    // Configure the cell...
    if(indexPath.row%2==0)
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0 ];
    else
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0 ];
    
    
    [title setText:[[descripcion objectAtIndex:indexPath.row] objectAtIndex:2]];
    [description setText:[[descripcion objectAtIndex:indexPath.row] objectAtIndex:3]];    
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
    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellEditingStyleNone];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
