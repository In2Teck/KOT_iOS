//
//  PlatilloViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 02/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "RateView.h"
#import "LoadingView.h"
#import "JSON.h"

@interface PlatilloViewController : UIViewController<RateViewDelegate>{
    RateView *rateView;
    NSDictionary *menu;
    NSString *restaurantName;
    
    //Facebook *facebook;
}
//@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic,retain) NSDictionary *menu;
@property (nonatomic, retain) NSString *restaurantName;

@property (nonatomic,retain) IBOutlet UITableViewCell *header;
@property (nonatomic,retain) IBOutlet UITableViewCell *proteinas;
@property (nonatomic,retain) IBOutlet UITableViewCell *cereales;
@property (nonatomic,retain) IBOutlet UITableViewCell *v_cosidas;
@property (nonatomic,retain) IBOutlet UITableViewCell *v_crudas, *proteinasCell, *frutasCell, *lacteosCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *recomendaciones;
@property (nonatomic,retain) IBOutlet UIImageView     *bannerHeader;
@property (nonatomic,retain) IBOutlet UITextView      *descripcion;

/////////////////////////////////////////////////
//////////////////// LABELS /////////////////////
/////////////////////////////////////////////////

@property (nonatomic,retain) IBOutlet UILabel *proteinasLabel;
@property (nonatomic,retain) IBOutlet UILabel *cerealesLabel;
@property (nonatomic,retain) IBOutlet UILabel *v_cosidasLabel;
@property (nonatomic,retain) IBOutlet UILabel *v_crudasLabel, *proteinaLabel, *frutasLabel, *lacteosLabel;

/////////////////////////////////////////////////
////////////////// FACEBOOk /////////////////////
/////////////////////////////////////////////////

//@property (nonatomic, retain) FBSession *session;
//@property (nonatomic, retain) FBLoginDialog *loginDialog;
//@property (nonatomic, copy) NSString *facebookName;
//@property (nonatomic, assign) BOOL posting;

-(IBAction)facebookShare:(id)sender;
-(IBAction)shareTwitter:(id)sender;
//- (void)postToWall;
//- (void)getFacebookName;
//-(void)initFacebook;

/////////////////////////////////////////////////
/////////////////// Methods /////////////////////
/////////////////////////////////////////////////
-(void)showLoadingView;
-(void)loadBannerHeader;
-(float)vote:(float)v;
@end
