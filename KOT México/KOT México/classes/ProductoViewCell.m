//
//  ProductoViewCell.m
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 04/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "ProductoViewCell.h"

@implementation ProductoViewCell

@synthesize myTableViewController;
@synthesize img;
@synthesize commentTextLabel;
@synthesize producto;
@synthesize facebook;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(IBAction)facebookShare:(id)sender{
    facebook = [[Facebook alloc] initWithAppId:@"251706724889890"];
//    facebook = [[Facebook alloc] init];
	// Otherwise, we don't have a name yet, just wait for that to come through.
    
    NSMutableDictionary *params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"KOT México.", @"name",
     [producto objectAtIndex:2], @"caption",
     @"Bajar de peso no siempre tiene que ser difícil.\nA través de mi KOT México iPhone App.", @"description",
     @"https://www.facebook.com/KOTMexico", @"link",
     [NSString stringWithFormat:@"http://kot.mx/IBR_imagenes/%@.jpg", [producto objectAtIndex:4]], @"picture",
     nil];  
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
    
}
// FBDialogDelegate
- (void)dialogDidComplete:(FBDialog *)dialog {
}


-(IBAction)shareTwitter:(id)sender{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:[NSString stringWithFormat:@"Bajar de peso no siempre tiene que ser difícil a través de mi KOT México iPhone App"]];//optional
    [twitter addImage:self.img.image];
    [twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://www.kot.mx"]]];
    
    if([TWTweetComposeViewController canSendTweet]){
        [self.myTableViewController presentViewController:twitter animated:YES completion:nil];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to tweet"
                                                            message:@"No estás logeado en el dispositivo."
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
                                                                message:@"Algo salió mal, intente más tarde."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        [self.myTableViewController dismissModalViewControllerAnimated:YES];
    };

}
#pragma mark Memory Cleanup

- (void)viewDidUnload {

}

- (void)dealloc {
    [super dealloc];
}

@end
