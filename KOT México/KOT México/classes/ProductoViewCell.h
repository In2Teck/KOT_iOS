//
//  ProductoViewCell.h
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 04/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../FBConnect.h"
#import "Twitter/Twitter.h"
@interface ProductoViewCell : UITableViewCell <FBDialogDelegate>{
    
    IBOutlet UILabel *commentTextLabel;
    IBOutlet UIImageView *img;
    NSMutableArray *producto;
    
    Facebook *facebook;
	BOOL login;
    
}
@property (nonatomic, retain) Facebook *facebook;
@property(nonatomic,retain)UITableViewController *myTableViewController;

@property(nonatomic,retain)IBOutlet UILabel *commentTextLabel;
@property(nonatomic, retain) IBOutlet UIImageView *img;
@property(nonatomic, retain) NSMutableArray *producto;

-(IBAction)facebookShare:(id)sender;

-(IBAction)shareTwitter:(id)sender;
@end
