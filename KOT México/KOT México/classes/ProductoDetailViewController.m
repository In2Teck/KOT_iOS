//
//  ProductoDetailViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ProductoDetailViewController.h"
#import "ProductoViewCell.h"

#define COMMENT_LABEL_WIDTH 200
#define COMMENT_LABEL_MIN_HEIGHT 115
#define COMMENT_LABEL_PADDING 10

@implementation ProductoDetailViewController
@synthesize productoDetail;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(!sqlite)
            sqlite = [[CommonDAO alloc]init];
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
    selectedIndex = -1;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *stringProducto = [NSString stringWithFormat:@"Productos Kot %@",[productoDetail objectAtIndex:1]];
    
    producto =  [sqlite 
                 select:[[NSString alloc] initWithFormat:@"SELECT id_producto, id_cat_productos, titulo, descripcion, img FROM productos WHERE id_cat_productos = %@;",[productoDetail objectAtIndex:0]] 
                 keys:[[NSArray alloc]initWithObjects:@"id_producto",@"id_cat_productos",@"titulo",@"descripcion",@"img", nil]];
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

//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
    CGSize labelHeighSize = [[[producto objectAtIndex:index] objectAtIndex:3] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:14.0f]
                                                                         constrainedToSize:maximumSize
                                                                             lineBreakMode:UILineBreakModeWordWrap];
    return labelHeighSize.height;
    
}



#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[producto objectAtIndex:section] objectAtIndex:2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return [producto count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCell";
    
    ProductoViewCell *cell = (ProductoViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductoViewCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (ProductoViewCell *)currentObject;
                break;
            }
        }        
    }
    
    if(selectedIndex == indexPath.row && selectedSection == indexPath.section)
    {
        CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.section];
        
        cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x, 
                                                 cell.commentTextLabel.frame.origin.y, 
                                                 cell.commentTextLabel.frame.size.width, 
                                                 labelHeight);
    }
    else {
        
        //Otherwise just return the minimum height for the label.
        cell.commentTextLabel.frame = CGRectMake(cell.commentTextLabel.frame.origin.x, 
                                                 cell.commentTextLabel.frame.origin.y, 
                                                 cell.commentTextLabel.frame.size.width, 
                                                 COMMENT_LABEL_MIN_HEIGHT);
    }
    
    cell.myTableViewController = self;
    
    cell.commentTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    if([[[producto objectAtIndex:indexPath.section]objectAtIndex:3] length]>0)
        cell.commentTextLabel.text = [[producto objectAtIndex:indexPath.section]objectAtIndex:3];
    else
        cell.commentTextLabel.text =  [[producto objectAtIndex:indexPath.section] objectAtIndex:2];
    
    [cell.img setImage:[UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@.png", [[producto objectAtIndex:indexPath.section]objectAtIndex:4]]]];
    
    cell.producto = [producto objectAtIndex:indexPath.section];
    
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If this is the selected index we need to return the height of the cell
    //in relation to the label height otherwise we just return the minimum label height with padding
    if(selectedIndex == indexPath.row && selectedSection == indexPath.section)
    {
        return [self getLabelHeightForIndex:indexPath.section] + COMMENT_LABEL_PADDING * 2;
    }
    else {
        return COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2;
    }
}



-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //We only don't want to allow selection on any cells which cannot be expanded
    if([self getLabelHeightForIndex:indexPath.section] > COMMENT_LABEL_MIN_HEIGHT)
    {
        return indexPath;
    }
    else {
        return nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //The user is selecting the cell which is currently expanded
    //we want to minimize it back
    selectedSection = indexPath.section;
    
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:indexPath.section];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];  
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
