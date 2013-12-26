//
//  CustomMPMoviePlayerViewController.m
//  Info7iPhoneAppHouse
//
//  Created by Daniel Felipe Heredia Saucedo on 3/12/12.
//  Copyright (c) 2012 Naranya Apphouse. All rights reserved.
//

#import "CustomMPMoviePlayerViewController.h"

@interface CustomMPMoviePlayerViewController ()


@end

@implementation CustomMPMoviePlayerViewController
/*
- (void)movieFinishedCallback:(NSNotification*) aNotification
{
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    [[NSNotificationCenter 	defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerLoadStateDidChangeNotification 
     object:nil];
    [player stop];
    
    [self dismissMoviePlayerViewControllerAnimated];
}

- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	
	if ([self.moviePlayer loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter 	defaultCenter] 
         removeObserver:self
         name:MPMoviePlayerLoadStateDidChangeNotification 
         object:nil];
        
	}
}*/

-(void)showAndPlayOver:(UIViewController *)vc
{
    
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayer.useApplicationAudioSession=NO;
    //[self.moviePlayer stop];
    [vc presentMoviePlayerViewControllerAnimated:self];
    
   //Al parecer no es necesaria la notificacion si no quieres hacer nada al final del video
    //(Dato no seguro)
    /*
    [[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self];*/
    /*
    // Register that the load state changed (movie is ready)
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayerLoadStateChanged:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:nil];
    [self.moviePlayer play];*/
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.moviePlayer stop];

}



@end
