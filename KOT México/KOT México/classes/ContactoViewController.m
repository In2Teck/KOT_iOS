//
//  ContactoViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 18/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ContactoViewController.h"
//#import "ListNutriologosViewController.h"
#import "CollapsableTableViewViewController.h"


#define IMG_TAG 1

@implementation ContactoViewController

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
    // Do any additional setup after loading the view from its nib.

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

////***************************************************************************////
////***************************************************************************////
////************************ Table View Delegate ******************************////
////***************************************************************************////
////***************************************************************************////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *facebook;
    UIImageView *twitter;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if(indexPath.row==2){
            facebook = [[UIImageView alloc]initWithFrame:CGRectMake(70.0, 5.0, 30.0, 30.0)];
            facebook.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [facebook setImage:[UIImage imageNamed:@"facebook_icon.png"]];
            [facebook setTag:IMG_TAG];
            [cell.contentView addSubview:facebook];
        }
        if(indexPath.row==3){
            twitter = [[UIImageView alloc]initWithFrame:CGRectMake(70.0, 5.0, 30.0, 30.0)];
            twitter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [twitter setTag:IMG_TAG];
            [twitter setImage:[UIImage imageNamed:@"twitter_icon.png"]];
            [cell.contentView addSubview:twitter];
        }
    }else{
        if(indexPath.row==2)
            facebook = (UIImageView *) [cell viewWithTag:IMG_TAG];
        if(indexPath.row==3)
            twitter = (UIImageView *) [cell viewWithTag:IMG_TAG];
    }
    
    // Configure the cell...
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Element-04.png"]]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if(indexPath.row ==0)
        [cell.textLabel setText:@"Lista de Especialistas KOT"];
    
    if(indexPath.row ==1)
        [cell.textLabel setText:@"www.kot.mx"];
    
    if(indexPath.row ==2)
        [cell.textLabel setText:@"Facebook"];
    
    if(indexPath.row ==3)
        [cell.textLabel setText:@"Twitter"];
    
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
    if(indexPath.row == 0){
//        ListNutriologosViewController *nutriologos = [[[ListNutriologosViewController alloc]initWithNibName:@"ListNutriologosViewController" bundle:nil]autorelease];
//        
//        [self.navigationController pushViewController:nutriologos animated:YES];
        CollapsableTableViewViewController *control = [[[CollapsableTableViewViewController alloc]initWithNibName:@"CollapsableTableViewViewController" bundle:nil]autorelease];
        
        [self.navigationController pushViewController:control animated:YES];
    }
    
    if(indexPath.row==1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kot.mx"]];
    if(indexPath.row==2)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
    if(indexPath.row==3)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/KOT_Mexico"]];
    
//    [[tableView cellForRowAtIndexPath:indexPath] setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}



@end
