//
//  RestaurantViewController.h
//  Kot México
//
//  Created by Gilberto Julián de la Orta Hernández on 13/12/11.
//  Copyright (c) 2011 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "../../JSON/JSON.h"

@interface RestaurantViewController : UITableViewController<UISearchDisplayDelegate, UISearchBarDelegate>{
	NSArray			*listContent;			// The master content.
	NSMutableArray	*filteredListContent;	// The content filtered as a result of a search.
	
	// The saved state of the search UI if a memory warning removed the view.
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
    
    LoadingView *splashLoading;
    NSArray *restaurante;
}

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain) NSMutableArray *filteredListContent;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

-(void) loadJSONService;
-(void) showSplashScrean;

@end
