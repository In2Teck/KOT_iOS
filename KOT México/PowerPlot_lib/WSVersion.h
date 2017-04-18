#import <Foundation/Foundation.h>
#import "WSAuxiliary.h"


/** Name of this package. */
#define kPackageName @"PowerPlot"

/** Name of developer. */
#define kDeveloperName @"Dr. Wolfram Schroers, NuAS, Berlin, Germany"

/** Current package version number. */
#define kPackageVersion 1.1

/** Version of the current class. */
#define kClassVersion 1.1

/** (Internal) revision info supplied by SVN/CVS. */
/** Comment this line out for release builds without internal info! */
#define __DEBUG

#ifdef __DEBUG
/** Unique commit ID (force SVN to always update info in this file on
    each commit). This requires a custom script which wraps the
    commit-command. */
#define kCommitID @"@COMMIT_ID"

/** SVN-supplied magic strings. */
#define kSVNId @"$Id: WSVersion.h 846 2011-07-23 19:20:01Z wolfram $"
#define kSVNRevision @"$Revision: 846 $"
#define kSVNDate @"$Date: 2011-07-23 21:20:01 +0200 (Sat, 23 Jul 2011) $"
#define kSVNAuthor @"$Author: wolfram $"
#endif


///
///  WSVersion.h
///  PowerPlot
///
///  Generic and simple versioning mechanism whose implementation and
///  use is optional.
///
///
///  Created by Wolfram Schroers on 03/15/10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


@interface WSVersion : NSObject {

    NSString *_packageName, *_developerName;
    CGFloat _packageVersion, _requiredVersion, _classVersion;
#ifdef __DEBUG
    NSString *_SVNId, *_SVNRevision, *_SVNDate, *_SVNAuthor;
#endif
}

@property (readonly) NSString *packageName;   ///< Name of package.
@property (readonly) NSString *developerName; ///< Name of developer/software house.
@property (readonly) CGFloat packageVersion;  ///< Version tag for the entire package.
@property (readonly) CGFloat requiredVersion; ///< Required version number for current class.
@property (readonly) CGFloat classVersion;    ///< Actual version number of current class.
#ifdef __DEBUG
@property (readonly) NSString *SVNId;
@property (readonly) NSString *SVNRevision;
@property (readonly) NSString *SVNDate;
@property (readonly) NSString *SVNAuthor;
#endif

/** @brief Return if this object satisfies version requirements.
 
    You should overwrite this method with your own implementation if
    you want the versioning mechanism to detect incompatibilities.

    @return YES in case of a version conflict, NO otherwise.
 */
- (BOOL)conflictingVersion;

/** Return version information and internal revision info (debug).

    With the debug flag activitated, the version information is
    significantly more verbose and contains the SVN magic
    keywords. These should not be used in release versions.

    @return  An NSString with version information.
 */
- (NSString *)version;

@end
