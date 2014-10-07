//
//  MetodoKotViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"
@interface MetodoKotViewController : UITableViewController{
    CommonDAO *sqlite;
}

@property (nonatomic,retain) IBOutlet UITableViewCell *infoCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *ejemKotCell;

-(IBAction)ejemploMujerIntensa:(id)sender;
-(IBAction)ejemploMujerProgresiva:(id)sender;

-(IBAction)ejemploHombreIntenso:(id)sender;
-(IBAction)ejemploHombreProgresivo:(id)sender;
@end
