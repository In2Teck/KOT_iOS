//
//  VideoDetailViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 05/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "VideoDetailViewController.h"
#import "../../rs-SDWebImage-b207dcc/UIImageView+WebCache.h"
#import "YouTubeView.h"
#import "UIButton+WebCache.h"
#import "Flurry.h"
#import "CustomMPMoviePlayerViewController.h"

@implementation VideoDetailViewController
@synthesize videoDetail,descripcion,myTableViewCell;

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
    NSString *video = [NSString stringWithFormat:@"Video: %@",[videoDetail objectAtIndex:3]];
    [Flurry logEvent:video withParameters:nil timed:YES];
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 260.0)];
    /*
    UIButton *headerImageView = [[UIButton alloc] init];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",[videoDetail objectAtIndex:5]]]
                    placeholderImage:[UIImage imageNamed:@"0.png"]];
    
    headerImageView.frame = CGRectMake(10.0, 10.0, header.frame.size.width - 20, header.frame.size.height-20);
    
    [headerImageView addTarget:self action:@selector(watchVideo:) forControlEvents:UIControlEventTouchUpInside];
*/
    
    
    YouTubeView *video = [[YouTubeView alloc] initWithStringAsURL:[videoDetail objectAtIndex:5] frame:CGRectMake(10.0, 10.0, header.frame.size.width - 20, header.frame.size.height-20)];
     
    [header addSubview:video];
    
    
//    [header addSubview:headerImageView];
    return header;
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 260.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 226.0;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
//    [cell.textLabel setText:[videoDetail objectAtIndex:2]];
//    [cell.textLabel setNumberOfLines:15];
//    [cell.textLabel setFont:[UIFont systemFontOfSize:10.0]];
//    
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    
//    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [self.descripcion setText:[videoDetail objectAtIndex:2]];
    
    return myTableViewCell;
    
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
    
}

-(IBAction)watchVideo:(id)sender{
    
    NSLog(@"Segun entra al play %@", [videoDetail objectAtIndex:1]);
    
    /*
    UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    CustomMPMoviePlayerViewController* moviePlayer =
    [[CustomMPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString: //[videoDetail objectAtIndex:1]
                                                                   //@"http://staging.mepaparazzo.com/media/original/deau5drxmx.mp4"
                                                                   //@"http://apphouse.naranya.com/log/apphouse/kot/instalador/example.mov"
                                                                   //@"http://pandablog.s3.amazonaws.com/videos/site/panda.mp4"
                                                                   @"http://showbox-tr.dropbox.com/transcode_video/t/jlf8v1yd6gkxobp/1.mp4"
                                                                   ]];
    
    [moviePlayer showAndPlayOver:backgroundWindow.rootViewController];
    */
    
    /*
    UIViewController *videoViewController = [[UIViewController alloc] init];
    
//    [videoViewController setTitle:@""];
    
    MPMoviePlayerController *player =[[MPMoviePlayerController alloc] initWithContentURL:
                                      //[NSURL URLWithString:[videoDetail objectAtIndex:2]]
                                      [NSURL URLWithString:
                                      @"http://apphouse.naranya.com/log/apphouse/kot/instalador/1.mov"]];
    [player setControlStyle:MPMovieControlModeDefault];
    [[player view] setFrame: self.view.frame];  // frame must match parent view
    [videoViewController.view addSubview: [player view]];
    [player play];
    
    [self.navigationController pushViewController:videoViewController animated:YES];
        */
    
    
    YouTubeView *video = [[YouTubeView alloc] initWithStringAsURL:
                                @"https://showbox-tr.dropbox.com/transcode_video/t/jlf8v1yd6gkxobp/1.mp4"
                                                            frame:self.view.frame];
    [self.view addSubview:video];
    
/*
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=NUtrAxtaHsE"]];
    */
}

-(void)moviePlayerPlaybackDidFinish:(NSNotification*)notification 
{ 
    NSLog(@"Playback Finished!\n %@", [notification debugDescription]);
}
@end
