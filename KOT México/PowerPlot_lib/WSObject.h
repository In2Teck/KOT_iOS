#import <Foundation/Foundation.h>
#import "WSVersion.h"


///
///  WSObject.h
///  PowerPlot
///
///  Basic, generic base class for objects that are not views. Also
///  included is a definition for the synthesize-setter auxilliary
///  function.
///
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSObject : NSObject {

    WSVersion *_thisVersion;
}

@property (copy) WSVersion *thisVersion; ///< Version information for class implementation.

/** Return the version info from thisVersion object.

    @return The version information as an NSString.
 */
- (NSString *)version;

@end
