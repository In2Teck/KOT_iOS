//
//  VideoMenuViewController.m
//  KOT México
//
//  Created by Benjamín Hernández on 17/03/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import "VideoMenuViewController.h"
#import "VideoDetailViewController.h"

#define LBL_TITULO      1
#define LBL_SUBTITULO   2
#define IMG_TAG         3

@interface VideoMenuViewController ()

@end

@implementation VideoMenuViewController

@synthesize items_especialistas, items_pacientes, myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    items_pacientes =[[NSMutableArray alloc] init];
    items_especialistas =[[NSMutableArray alloc] init];
    [self loadVideos];
    [[self myTableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                
                if ([[video objectForKey:@"id_categoria"] integerValue] == 1 ){
                    [items_pacientes addObject:videoArray];
                }else if ([[video objectForKey:@"id_categoria"] integerValue] == 2 ){
                    [items_especialistas addObject:videoArray];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return [items_pacientes count];
    }
    else{
        return [items_especialistas count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0)
    {
        return @"Testimoniales de Pacientes";
    }
    else{
        return @"Testimoniales de Especialistas";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *tituloLabel;//, *subTituloLabel;
    UIImageView *imageYoutube;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        tituloLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, (cell.frame.size.width*0.4), 100)];
        [tituloLabel setTag:LBL_TITULO];
        [tituloLabel setFont:[UIFont systemFontOfSize:14.0]];
        [tituloLabel setNumberOfLines:4];
        [tituloLabel setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:tituloLabel];
        
        imageYoutube = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width*0.45), 0.0, (cell.frame.size.width*0.55),(cell.frame.size.width*0.31))];
        [imageYoutube setTag:IMG_TAG];
        [cell.contentView addSubview:imageYoutube];
        
    }else{
        tituloLabel = (UILabel *) [cell viewWithTag:LBL_TITULO];
        //        subTituloLabel = (UILabel *) [cell viewWithTag:LBL_SUBTITULO];
        imageYoutube = (UIImageView *) [cell viewWithTag:IMG_TAG];
    }
    
     if (indexPath.section==0) {
         [tituloLabel setText:[[items_pacientes objectAtIndex:indexPath.row]objectAtIndex:3]];
         
         NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[items_pacientes objectAtIndex:indexPath.row]objectAtIndex:6]]];
         [imageYoutube setImage: [UIImage imageWithData:imageData]];
     } else {
         [tituloLabel setText:[[items_especialistas objectAtIndex:indexPath.row]objectAtIndex:3]];
         
         NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[items_especialistas objectAtIndex:indexPath.row]objectAtIndex:6]]];
         [imageYoutube setImage: [UIImage imageWithData:imageData]];
     }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VideoDetailViewController *vdvc = [[VideoDetailViewController alloc] initWithNibName:@"VideoDetailViewController" bundle:nil];
    if (indexPath.section==0) {
        vdvc.videoDetail = [items_pacientes objectAtIndex:indexPath.row];
        vdvc.title = [[items_pacientes objectAtIndex:indexPath.row]objectAtIndex:3];
    }else {
        vdvc.videoDetail = [items_especialistas objectAtIndex:indexPath.row];
        vdvc.title = [[items_especialistas objectAtIndex:indexPath.row]objectAtIndex:3];
    }    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Regresar";
    
    self.navigationItem.backBarButtonItem = barButton;
    
    [self.navigationController pushViewController:vdvc animated:YES];
    
}

- (void)dealloc {
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
