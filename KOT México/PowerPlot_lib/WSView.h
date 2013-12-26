#import <UIKit/UIKit.h>
#import "WSVersion.h"
#import "NAAmethyst.h"


///
///  WSView.h
///  PowerPlot
///
///  Basic view class which uses the simple versioning mechanism
///  (optional).
///
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSView : UIView {

    WSVersion *_thisVersion;
}

@property (copy) WSVersion *thisVersion; ///< Version information of class.

/** Return the version info from thisVersion object. */
- (NSString *)version;

@end
