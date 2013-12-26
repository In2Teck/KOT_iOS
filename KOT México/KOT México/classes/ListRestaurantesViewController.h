//
//  ListRestaurantesViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 01/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "LoadingView.h"
@class OverlayViewController;

@interface ListRestaurantesViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSMutableArray *listOfItems, *ciudades, *dataSourceList;
	NSMutableArray *copyListOfItems;
	
    IBOutlet UISearchBar *searchBar;
	IBOutlet UIView *selectCity;
    IBOutlet UIButton *comboButton;
    
	BOOL searching;
	BOOL letUserSelectRow;
    
    OverlayViewController *ovController;
    
    UIPickerView *pickerView;
    
    NSString *selectCityId;
    
}
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;


-(void) loadJSONService;
-(void) showSplashScrean;
-(NSMutableArray *)loadJSONDetail:(NSString*)idRestaurante;

@end
