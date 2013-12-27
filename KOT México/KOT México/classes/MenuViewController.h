//
//  MenuViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../JSON/JSON.h"

@interface MenuViewController : UIViewController{
    NSArray *user;
    NSDictionary *intensivo;
    NSDictionary *progresivo;
    NSString     *semanas;
}

-(IBAction)alimentosKOT:(id)sender;
-(IBAction)productosKOT:(id)sender;
-(IBAction)metodoKot:(id)sender;
-(IBAction)progresoKot:(id)sender;
-(IBAction)restaurantesKOT:(id)sender;

-(void)loadMiMetodoKot;
@end
