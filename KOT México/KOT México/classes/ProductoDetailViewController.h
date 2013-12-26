//
//  ProductoDetailViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"
@interface ProductoDetailViewController : UIViewController{
    NSMutableArray *producto;
    NSMutableArray *productoDetail;
    CommonDAO *sqlite;
    
    //This is the index of the cell which will be expanded
    NSInteger selectedIndex;
    NSInteger selectedSection;
}

@property(nonatomic,retain)NSMutableArray *productoDetail;
@property(nonatomic,retain) IBOutlet UITableView *myTableView;

@end
