//
//  ProgresoViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../FBConnect.h"
#import "Twitter/Twitter.h"
#import "CommonDAO.h"
#import "LoadingView.h"
#import <MessageUI/MessageUI.h>
#import "../../JSON/JSON.h"

@interface ProgresoViewController : UIViewController <FBSessionDelegate, FBRequestDelegate,MFMailComposeViewControllerDelegate>{
    
    CommonDAO *sqlite;
    NSString *estado;
    
    NSMutableArray *pesoList;
    NSMutableArray *medidaList;
    
    NSString *medidaActual;
    NSString *medidaMeta;
    NSString *grasaMeta;
    NSString *grasaActual;
    NSString *pesoActual;
    NSString *pesoMeta;
    BOOL      updateViews;
    
    Facebook *facebook;
}
@property(nonatomic,retain)IBOutlet UITextField *actual;
@property(nonatomic,retain)IBOutlet UITextField *meta;
@property(nonatomic,retain)IBOutlet UISegmentedControl *segmented;
@property(nonatomic,retain)IBOutlet UIView *chart;
@property(nonatomic,retain)IBOutlet UIView *chartMedida;
@property(nonatomic,retain)IBOutlet UIView *chartGrasa;
@property(nonatomic,retain)IBOutlet UIImageView *banderaImageView;
@property(nonatomic,retain)IBOutlet UILabel *llevasLabel;
@property(nonatomic,retain)IBOutlet UILabel *metaLabel;
@property(nonatomic,retain)IBOutlet UILabel *faltanteLabel;
@property(nonatomic,retain)IBOutlet UIButton *add;

@property(nonatomic,assign) BOOL updateViews;
@property(nonatomic,retain) NSMutableArray *pesoList;
@property(nonatomic,retain) NSMutableArray *medidaList;
@property(nonatomic,retain) NSMutableArray *grasasList;
@property(nonatomic, retain) NSString *peso_inicio, *medida_inicio, *grasa_inicio;
/////////  FACEBOOK //////////


-(IBAction)changeView:(id)sender;
-(IBAction)nuevPesoMedida:(id)sender;
-(IBAction)facebookShare:(id)sender;
-(IBAction)shareTwitter:(id)sender;
-(IBAction)sendEmail:(id)sender;

-(void)initChartPeso;
-(void)initChartMedida;

-(void)loadJSONDataService;
-(void)reloadDataView;

@end
