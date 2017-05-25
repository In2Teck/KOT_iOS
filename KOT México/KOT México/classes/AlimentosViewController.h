//
//  AlimentosViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"
@interface AlimentosViewController : UIViewController{
    CommonDAO *sqlite;
    NSMutableArray *alimentosList;
}
@property(nonatomic,retain) IBOutlet  UITableView *myTableViewController;
@property BOOL isMujerIntensivo;
//@property BOOL isVegetariano;
@end
