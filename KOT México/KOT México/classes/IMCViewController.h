//
//  IMCViewController.h
//  KOT México
//
//  Created by Benjamín Hernández on 21/01/14.
//  Copyright (c) 2014 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMCViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextView *leyendaInformativa;
- (IBAction)queEsIMC:(id)sender;
@property (retain, nonatomic) IBOutlet UIPickerView *sexoSelector;
@property (retain, nonatomic) NSArray *arrStatus;
@property float IMC;
@property int semanas;
@property BOOL isHombre;

@property (retain, nonatomic) IBOutlet UITextField *pesoTextInput;
@property (retain, nonatomic) IBOutlet UITextField *estaturaTextInput;
- (IBAction)calcularAction:(id)sender;
- (IBAction)especialistaKOTAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *queEsImcButton;
@property (retain, nonatomic) IBOutlet UILabel *sexoLabel;

@end