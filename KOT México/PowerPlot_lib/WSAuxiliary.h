///
///  @file
///  WSAuxiliary.h
///  PowerPlot
///
///  Header file with auxiliary definitions useful for all projects.
///
///
///  Created by Wolfram Schroers on 16.10.10.
///  Copyright 2010 Numerik & Analyse Schroers. All rights reserved.
///


/// Auxilliary macro definition for writing BOOL via NSLog.
#define BOOLTOSTRING(a) a ? @"YES" : @"NO"



/** @brief Definitions from Objective-C runtime (synthesize-accessors).
 
    These are the declarations of Objective-C runtime functions used
    in the synthesize-d accessor methods for instance property
    variables.
 
    Source:
    http://cocoawithlove.com/2009/10/memory-and-thread-safe-custom-property.html
 */
id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic,
                      BOOL shouldCopy);
void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic,
                     BOOL hasStrong);

/// A set of convenience macros to property accessors (same source as above).
#define AtomicRetainedSetToFrom(dest, source) \
objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, NO)
#define AtomicCopiedSetToFrom(dest, source) \
objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, YES)
#define AtomicAutoreleasedGet(source) \
objc_getProperty(self, _cmd, (ptrdiff_t)(&source) - (ptrdiff_t)(self), YES)
#define AtomicStructToFrom(dest, source) \
objc_copyStruct(&dest, &source, sizeof(__typeof__(source)), YES, NO)

