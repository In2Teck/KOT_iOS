//
//  AppDelegate.m
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 12/01/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize dToken;
@synthesize myLocation;
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    id presentedViewController = [window.rootViewController presentedViewController];
    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
    if (window && [className isEqualToString:@"MPInlineVideoFullscreenViewController"]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    
    //[self hideSplash];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone];
    
    myLocation = [[[MyCLController alloc]init]retain];
    myLocation.delegate = self;
    
//    [myLocation.locationManager startUpdatingLocation];
    
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:5.0];
    
    [Flurry setAppVersion:@"1.0.6"];
    [Flurry startSession:@"JDT6RSZJYB6SC98H7BPB"];
    [Flurry setSessionReportsOnCloseEnabled:YES];
    [Flurry setSessionReportsOnPauseEnabled:YES];
    [Flurry logEvent:@"initAppp" timed:YES];
    [Flurry logPageView];
//    [Flurry setDebugLogEnabled:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void) application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    dToken = [[NSData alloc]initWithData:deviceToken];
    
    /*token = [[NSString alloc]initWithString:deviceToken.description];
     NSLog(@"my tokenData: %@ ", deviceToken);
     self.dToken = [[NSString alloc]initWithString:token];
     //[self setDToken:token];
     NSLog(@"my tokenNSString: %@", dToken);
     [token release];
     */
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Failed to get token, error: %@", error);
    
    //[self setDToken:@"abc123"];
    
}


-(void)hideSplash{
    [myLocation.locationManager startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location {
	//locationLabel.text = [location description];
    [Flurry setLatitude:location.coordinate.latitude
                       longitude:location.coordinate.longitude
              horizontalAccuracy:location.horizontalAccuracy 
                verticalAccuracy:location.verticalAccuracy];

    myLocation.delegate = nil;
    [myLocation release];
}


- (void)locationError:(NSError *)error {
	//locationLabel.text = [error description];
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"KOT México" message:@"La localización KOT México no está activada, ve a configuración y en localización activar KOT México" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles: nil];
    [alert show];
    [alert release];
    alert = nil;
    
    [self.window removeFromSuperview];
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    myLocation.delegate = nil;
    [myLocation release];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application { 
    //[Flurry startSession:@"XIN21VKKUP734C6YJ3KI"];
    //your code
}

@end
