//
//  FaqViewController.h
//  KOT México
//
//  Created by Benjamín Hernández on 11/03/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaqViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSMutableArray *dataSource;

@end