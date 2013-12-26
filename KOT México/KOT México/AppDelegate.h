//
//  AppDelegate.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"
@interface AppDelegate :  NSObject <UIApplicationDelegate, MyCLControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@property (nonatomic,retain) NSData *dToken;

@property (nonatomic, retain)  MyCLController *myLocation;
-(void)hideSplash;

@end
