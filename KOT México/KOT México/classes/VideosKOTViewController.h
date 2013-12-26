//
//  VideosKOTViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 03/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"

@interface VideosKOTViewController : UIViewController{
    CommonDAO *sqlite;
    NSMutableArray *items;
}

@end
