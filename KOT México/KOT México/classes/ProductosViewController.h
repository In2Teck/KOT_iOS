//
//  ProductosViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"

@interface ProductosViewController : UITableViewController{
    CommonDAO *sqlite;
    NSMutableArray *items;
}

@end
