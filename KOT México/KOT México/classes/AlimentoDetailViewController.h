//
//  AlimentoDetailViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"
@interface AlimentoDetailViewController : UIViewController{
    CommonDAO *sqlite;
    NSMutableArray *descripcion;
    NSMutableArray *alimentoDetail;
}
@property (nonatomic,retain) NSMutableArray *alimentoDetail;
@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@property (assign,nonatomic) int type;
@end
