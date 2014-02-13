//
//  PlatilloViewController.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 02/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "PlatilloViewController.h"

@implementation PlatilloViewController
@synthesize header;
@synthesize proteinas;
@synthesize cereales;
@synthesize v_crudas;
@synthesize v_cosidas;
@synthesize recomendaciones;
@synthesize proteinasLabel;
@synthesize cerealesLabel;
@synthesize v_cosidasLabel;
@synthesize v_crudasLabel;
@synthesize bannerHeader;
@synthesize menu;
@synthesize descripcion;
@synthesize facebook;
@synthesize restaurantName;

@synthesize proteinaLabel, proteinasCell, frutasCell, frutasLabel, lacteosCell, lacteosLabel;

//@synthesize session = _session;
//@synthesize loginDialog = _loginDialog;
//@synthesize facebookName = _facebookName;
//@synthesize posting = _posting;

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
    rateView = [[RateView alloc] initWithFrame:CGRectMake(200.0, 0.0, 100.0, 25.0)];
    rateView.notSelectedImage = [UIImage imageNamed:@"Rating_-46.png"];
    rateView.halfSelectedImage = [UIImage imageNamed:@"Rating_-45.png"];
    rateView.fullSelectedImage = [UIImage imageNamed:@"Rating_-44.png"];
    rateView.rating = [[menu objectForKey:@"rating"]floatValue];
    rateView.editable = YES;
    rateView.maxRating = 5;
    rateView.delegate = self;
    [proteinasLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"proteinas"]]];
    [cerealesLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"cereales"]]];
    [v_crudasLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"verduras_crudas"]]];
    [proteinaLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"proteina_vegetal"]]];
    [frutasLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"frutas"]]];
    [lacteosLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"lacteos"]]];
    
    [v_cosidasLabel setText:[NSString stringWithFormat:@"%@",[menu objectForKey:@"verduras_cocidas"]]];
    
    if ([menu objectForKey:@"recomendacion"] != NULL)
        [descripcion setText:[menu objectForKey:@"recomendacion"]];
    else
        [descripcion setText:@""];
    LoadingView *splashLoading = [LoadingView loadingViewInView:bannerHeader];
    
    [self performSelector:@selector(loadBannerHeader) withObject:nil afterDelay:2.0];
    
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:2];
    
    self.title = [menu objectForKey:@"nombre"];
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


-(void)showLoadingView{
    LoadingView *splashLoading = [LoadingView loadingViewInView:self.navigationController.view];
    [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
}
-(void)loadBannerHeader{
    NSString *urlImageSample = [NSString stringWithFormat:@"%@",[menu objectForKey:@"img_url"]];
    
    bannerHeader.frame = CGRectMake(0.0, 0.0, 320.0, 178.0);
    
    LoadingView *splashLoading = [LoadingView loadingViewInView:bannerHeader];
    UIImage *img = [[UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:urlImageSample]]]retain];
    
    //    img.size = CGSizeMake(320.0, 113.0);
	if (img != nil) { // Image was loaded successfully.
        [bannerHeader setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		bannerHeader.image = img;
		[bannerHeader setUserInteractionEnabled:YES];
        [bannerHeader setAutoresizesSubviews:YES];
		[img release]; // Release the image now that we have a UIImageView that contains it.
        [splashLoading performSelector:@selector(removeView) withObject:nil afterDelay:1.0];
	}

}


/************************************************************************/
/************************************************************************/
/*********************** Delegate Table *********************************/
/************************************************************************/
/************************************************************************/

-(UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, 25.0)]autorelease];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    [header setAlpha:0.8];
    
    UILabel *title;
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, (tableView.frame.size.width * 0.7), 20.0)];

    [title setText:@"Platillos permitidos"];
    [title setNumberOfLines:3];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setFont:[UIFont systemFontOfSize:13.0]];
    
    [header addSubview:title];
    [header addSubview:rateView];
    //    tableView.tableHeaderView = header;
    
    return header;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    if (indexPath.row == 0) 
        return header;
    if (indexPath.row == 1)
        return recomendaciones;
    if (indexPath.row == 2)
        return proteinas;
    if (indexPath.row == 3)
        return cereales;
    if (indexPath.row == 4)
        return v_cosidas;
    if (indexPath.row == 5)
        return v_crudas;
    if (indexPath.row == 6)
        return proteinasCell;
    if (indexPath.row == 7)
        return frutasCell;
    if (indexPath.row == 8)
        return lacteosCell;
    
    
    return cell;
    
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Todo OK!");
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

-(CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0)
        return 175.0;
    if(indexPath.row==1)
        return 135.0;
    if(indexPath.row >= 2 && indexPath.row <= 8)
        return 40.0;
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    NSLog(@"my Rating: %2f", rating);
    if (rateView.editable)
        rateView.rating = [self vote:rating];
    rateView.editable = NO;
}

-(float)vote:(float)v{
    NSString *urlConnection = [[[NSString alloc] initWithFormat:@"http://kot.mx/nuevo/WS/kotRatingMenu.php?idMenu=%@&rating=%.0f&idUserKot=",[menu objectForKey:@"id_menu"],v] autorelease];
    
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
        NSDictionary *menuDescription;
        if([messageError length]==0){
            // create a filtered list that will contain products for the search results table.
            menuDescription = [[[[contentJSON objectForKey:@"rating"] JSONRepresentation] JSONValue]retain];
            NSLog(@"rating actual: %@",[menuDescription objectForKey:@"rating"]);
            return [[menuDescription objectForKey:@"rating"] floatValue];
        }else{
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"KOT México" message:messageError delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
            [message show];
            [message release];
            message = nil;
        }
    }
    return 0.0;
}
/************************************************************************/
/************************************************************************/
/*********************** FACEBOOK DELEGATE ******************************/
/************************************************************************/
/************************************************************************/

-(IBAction)facebookShare:(id)sender{
    facebook = [[Facebook alloc] initWithAppId:@"251706724889890"];
	// Otherwise, we don't have a name yet, just wait for that to come through.
    NSMutableDictionary *params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"KOT México.", @"name",
     restaurantName, @"caption",
     [NSString stringWithFormat:@"Siguiendo el Método KOT comiendo \"%@\" en \"%@\" a través de mi KOT México iPhone App.",
      [menu objectForKey:@"nombre"], restaurantName], @"description",
     @"https://www.facebook.com/KOTMexico", @"link",
     [NSString stringWithFormat:@"%@",[menu objectForKey:@"img_url"]], @"picture",
     nil];  
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:nil];

}

-(IBAction)shareTwitter:(id)sender{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:[NSString stringWithFormat:@"Siguiendo el Método KOT comiendo \"%@\" en \"%@\" a través de mi KOT México iPhone App.",
                             [menu objectForKey:@"nombre"], restaurantName]
    ];//optional
    [twitter addImage:bannerHeader.image];
    [twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://twitter.com/Kot_Mexico"]]];
    
    if([TWTweetComposeViewController canSendTweet]){
        [self presentViewController:twitter animated:YES completion:nil];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to tweet"
                                                            message:@"You might be in Airplane Mode or not have service. Try again later."
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        if (TWTweetComposeViewControllerResultDone) {
//            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tweeted"
//                                                                message:@"You successfully tweeted"
//                                                               delegate:self cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//            [alertView show];
        } else if (TWTweetComposeViewControllerResultCancelled) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ooops..."
                                                                message:@"Algo salió mal, intente más tarde"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        [self dismissModalViewControllerAnimated:YES];
    };
    
}
@end
