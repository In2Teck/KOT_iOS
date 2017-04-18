//
//  CollapsableTableViewViewController.h
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import "LoadingView.h"
#import "../../JSON/JSON.h"

@interface CollapsableTableViewViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,MyCLControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UITableView* myTableView;
    
    NSMutableArray *listNutriologos;
    NSMutableArray *dataSourseList;
    NSMutableArray *ciudades;
    
    NSInteger *selectContact;
    BOOL isMonterrey;
    
    NSString *numberPhone;
    
    UIPickerView *pickerView;
    
}
@property(nonatomic,retain)IBOutlet UITableView        *myTableView;
@property(nonatomic,retain)IBOutlet UISegmentedControl *segmented;
@property(nonatomic,retain)IBOutlet UIButton *selectPicker;
-(IBAction)callNumber:(id)sender;
-(IBAction)addContact:(id)sender;
-(IBAction)showMap:(id)sender;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) NSString *indexStr;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (retain, nonatomic) IBOutlet UIPickerView *locationPicker;
- (IBAction)segmentedControlChanged:(id)sender;
//@property (retain, nonatomic) IBOutlet UIPickerView *locationPicker;

//- (IBAction) toggleSection2;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
-(void)showLoadingView;
-(void)loadingJSONNutriologos;
-(CGFloat)getDistance:(CLLocation*)lManager;
@end

