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
#import <FacebookSDK/FacebookSDK.h>

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
    
    if ([[videoDetail objectAtIndex:2] length] == 0){
        //[cell setHidden:YES];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        // set the frame and title you want
        [button setFrame:CGRectMake(40, 0, 250, 50)];
        [button setTitle:@"Compartir en Facebook" forState:UIControlStateNormal];
        // set action/target you want
        caption = @"KOT México";
        link = [videoDetail objectAtIndex:1];
        //NSLog(@"LINK %@", link);
        [button addTarget:self action:@selector(publishFacebook) forControlEvents:UIControlEventTouchDown];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:button];
        return cell;
    }else{
        return myTableViewCell;
    }
    
}

-(void)publishFacebook {
    // Check if the Facebook app is installed and we can present the share dialog
    
    /*FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:link];
    params.caption = caption;
    //params.description = description;
    //params.name = name;
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present the share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publicando : %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        
    } else {*/
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       caption, @"caption",
                                       link, @"link",
                                       @"[{ name: 'KOT México', link: 'http://kot.mx' }]", @"actions",
                                       //@"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    //}
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)moviePlayerPlaybackDidFinish:(NSNotification*)notification 
{ 
    NSLog(@"Playback Finished!\n %@", [notification debugDescription]);
}
@end
