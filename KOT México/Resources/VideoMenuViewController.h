//
//  VideoMenuViewController.h
//  KOT México
//
//  Created by Benjamín Hernández on 17/03/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSON.h>

@interface VideoMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) NSMutableArray *items_pacientes, *items_especialistas, *fotos_especialistas, *fotos_pacientes;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;

@end
