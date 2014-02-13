//
//  VideosKOTViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 03/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "VideosKOTViewController.h"
#import "../../rs-SDWebImage-b207dcc/UIImageView+WebCache.h"
#import "VideoDetailViewController.h"
#import "Flurry.h"

#define LBL_TITULO      1
#define LBL_SUBTITULO   2
#define IMG_TAG         3

@implementation VideosKOTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if(!sqlite)
            sqlite = [[CommonDAO alloc] init];
        
        items = [sqlite select:@"SELECT id_video, url_video, recetario, titulo, descripcion, key_video, img FROM videos;" keys:[[NSArray alloc]initWithObjects:@"id_video",@"url_video",@"recetario",@"titulo",@"descripcion",@"key_video", @"img", nil]];
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
    
    [Flurry logEvent:@"Videos de los Productos" withParameters:nil timed:YES];
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


/************************************************************************/
/************************************************************************/
/************************** TABLE DELEGATE ******************************/
/************************************************************************/
/************************************************************************/

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
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
    return [items count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"¿Comó preparar productos KOT?";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *tituloLabel;//, *subTituloLabel;
        UIImageView *imageYoutube;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        tituloLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, (cell.frame.size.width*0.7), 57)];
        [tituloLabel setTag:LBL_TITULO];
        [tituloLabel setFont:[UIFont systemFontOfSize:20.0]];
        [tituloLabel setNumberOfLines:2];
        [tituloLabel setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:tituloLabel];
        
//        subTituloLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 52.0, (cell.frame.size.width*0.7), 35)];
//        [subTituloLabel setFont:[UIFont systemFontOfSize:13.0]];
//        [subTituloLabel setNumberOfLines:2];
//        [subTituloLabel setTag:LBL_SUBTITULO];
//        [subTituloLabel setTextColor:[UIColor grayColor]];
//        [cell.contentView addSubview:subTituloLabel];
        
        imageYoutube = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width*0.75), 0.0, (cell.frame.size.width*0.28),(cell.frame.size.width*0.28))];
        [imageYoutube setTag:IMG_TAG];
        [cell.contentView addSubview:imageYoutube];
        
    }else{
        tituloLabel = (UILabel *) [cell viewWithTag:LBL_TITULO];
//        subTituloLabel = (UILabel *) [cell viewWithTag:LBL_SUBTITULO];
        imageYoutube = (UIImageView *) [cell viewWithTag:IMG_TAG];
    }
    
    
    [tituloLabel setText:[[items objectAtIndex:indexPath.row]objectAtIndex:3]];
//    [subTituloLabel setText:[[items objectAtIndex:indexPath.row]objectAtIndex:4]];
    
    
    [imageYoutube setImage:[UIImage imageNamed:[[items objectAtIndex:indexPath.row]objectAtIndex:6]]];
    /*[imageYoutube setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",[[items objectAtIndex:indexPath.row]objectAtIndex:5]]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];*/
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
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
 - (void)tableView:(UITableView *)tax   bleView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoDetailViewController *vdvc = [[VideoDetailViewController alloc] initWithNibName:@"VideoDetailViewController" bundle:nil];
    vdvc.videoDetail = [items objectAtIndex:indexPath.row];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Regresar";
    
    self.navigationItem.backBarButtonItem = barButton;
    
    vdvc.title = [[items objectAtIndex:indexPath.row]objectAtIndex:3];
    
    
    [self.navigationController pushViewController:vdvc animated:YES];

}


@end
