//
//  RestauranteMenuViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 01/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "../../JSON/JSON.h"
#import "RateView.h"

@interface RestauranteMenuViewController : UIViewController<RateViewDelegate>{
    IBOutlet UIImageView *bannerView;
    IBOutlet UILabel     *direccion;
    NSString *idRestaurante;
    NSMutableArray *listOfItems;
    NSString *urlImage;
    NSDictionary *itemMenu;
}
@property(nonatomic, retain) NSMutableArray *listOfItems;

@property(nonatomic, retain) IBOutlet UILabel *direccion;
@property(nonatomic,retain) NSDictionary *itemMenu;

-(IBAction)callContact:(id)sender;
-(IBAction)showMap:(id)sender;
-(IBAction)addToContacts:(id)sender;

-(void)showLoadingView;
-(void)loadImageView;
-(void)loadJSONContent;
-(NSDictionary *)loadJSONDetail:(NSString*)idMenu;
@end
