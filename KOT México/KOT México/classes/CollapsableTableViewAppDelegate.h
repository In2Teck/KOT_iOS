//
//  CollapsableTableViewAppDelegate.h
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollapsableTableViewViewController;

@interface CollapsableTableViewAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    CollapsableTableViewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CollapsableTableViewViewController *viewController;

@end

