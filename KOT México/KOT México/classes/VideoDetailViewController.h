//
//  VideoDetailViewController.h
//  KOT México
//
//  Created by Gilberto Julián de la Orta Hernández on 05/02/12.
//  Copyright (c) 2012 Naranya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDAO.h"

@interface VideoDetailViewController : UIViewController{
}

@property(nonatomic,retain) NSMutableArray *videoDetail;
@property(nonatomic,retain) IBOutlet UITextView *descripcion;
@property(nonatomic,retain) IBOutlet UITableViewCell *myTableViewCell;
//-(IBaction)viewVideo:(id)sender;
-(IBAction)watchVideo:(id)sender;
-(void)moviePlayerPlaybackDidFinish:(NSNotification*)notification ;
@end
