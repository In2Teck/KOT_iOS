//
//  CustomMPMoviePlayerViewController.h
//  Info7iPhoneAppHouse
//
//  Created by Daniel Felipe Heredia Saucedo on 3/12/12.
//  Copyright (c) 2012 Naranya Apphouse. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

/**
 This class acts as a wrapper of MPMoviePlayerViewController, setting some properties to default values. This class requieres to be instantiate with initWithContentURL: method to work correctly.
 */
@interface CustomMPMoviePlayerViewController : MPMoviePlayerViewController
/**
 Display and init the reproduction of the video over the vc controller.
 @param vc UIViewController used to display the video player.
 */
-(void)showAndPlayOver:(UIViewController *)vc;
@end
