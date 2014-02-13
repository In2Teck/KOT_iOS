//
//  PreferencesViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 01/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../../JSON/JSON.h"
#import "LoadingView.h"
#import "CommonDAO.h"



@interface PreferencesViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
    NSMutableArray *arrayNo;
    UIDatePicker *datePickerView;
    BOOL isLoged;
    
    NSArray *user;
    CommonDAO *sqlite;
    BOOL isHiddenNavigationBar;
}
@property(nonatomic, assign) BOOL isHiddenNavigationBar;
@property(nonatomic, retain) IBOutlet UITableView *myTableView;
//@property(nonatomic, retain) IBOutlet UINavigationBar *myNavigationBar;

@property(nonatomic,retain) IBOutlet UIButton    *generoButton;

@property(nonatomic,retain) IBOutlet UITextField *codigo,*password, *repitPassword;
@property(nonatomic,retain) IBOutlet UITextField *correo, *email;

@property(nonatomic,retain) IBOutlet UITextField *nombre;
@property(nonatomic,retain) IBOutlet UITextField *apellido;
@property(nonatomic,retain) IBOutlet UITextField *edad;
@property(nonatomic,retain) IBOutlet UITextField *altura;

@property(nonatomic, retain) IBOutlet UITableViewCell *loginCell;
@property(nonatomic, retain) IBOutlet UITableViewCell *registroCell;

-(IBAction)loginUser:(id)sender;
-(IBAction)registroUser:(id)sender;
-(IBAction)selectSexo:(id)sender;

-(void)fechaNacimiento;

-(void)loginUserAction;
-(void)logoutUserAction;
-(void)registroUserAction;

-(IBAction)infoButtonPressed:(id)sender;

@end
