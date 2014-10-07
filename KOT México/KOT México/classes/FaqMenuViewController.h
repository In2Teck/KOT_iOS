//
//  FaqMenuViewController.h
//  KOT México
//
//  Created by Benjamín Hernández on 11/03/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSON.h>

@interface FaqMenuViewController : UIViewController
- (IBAction)sobreMetodo:(id)sender;
- (IBAction)hacerMetodo:(id)sender;
- (IBAction)sobreProductos:(id)sender;

@property (retain, nonatomic) NSMutableArray *categoria_1;
@property (retain, nonatomic) NSMutableArray *categoria_2;
@property (retain, nonatomic) NSMutableArray *categoria_3;

@end
