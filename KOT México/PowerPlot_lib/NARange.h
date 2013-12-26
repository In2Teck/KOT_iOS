/**
 *  @file
 *  NARange.h
 *  NuAS Amethyst Graphics System
 *
 *  NARange is a utility structure that manages intervals of floating
 *  point values. It is implemented similar to NSRange and others and
 *  offers a few additional feature functions.
 *
 *
 *  Created by Wolfram Schroers on 11/02/09.
 *  Copyright 2009-2010 Numerik & Analyse Schroers. All rights reserved.
 *
 */

#ifndef __NARANGE_H__
#define __NARANGE_H__

#include <Foundation/Foundation.h>
#include "NABase.h"


/** Constant: Invalid NARange. */
#define NARANGE_INVALID NARangeMake(NAN, NAN)

/** An interval with starting and ending point. */
typedef struct _NARange {
    NAFloat rMin;
    NAFloat rMax;
} NARange;

/** Alias name. */
typedef NARange *NARangePointer;


/** Inline function to quickly define a NARange. */
NS_INLINE NARange NARangeMake(NAFloat minVal, NAFloat maxVal) {
    NARange r;
    // Ascertain that the minimum is always the smaller value.
    if (maxVal<minVal) {
        NAFloat tmp;
        tmp = minVal; minVal = maxVal; maxVal = tmp;
    }
    r.rMin = minVal;
    r.rMax = maxVal;
    return r;
}

/** Return the width of a NARange. */
NS_INLINE NAFloat NARangeLen(NARange range) {
    return fabs(range.rMax - range.rMin);
}

/** Return the center point of a NARange. */
NS_INLINE NAFloat NARangeCenter(NARange range) {
    return 0.5*(range.rMax + range.rMin);
}

/** Return the maximum range covered by the two ranges supplied. */
NS_INLINE NARange NARangeMax(NARange range1, NARange range2) {
    NARange r;
    r.rMin = fmin(range1.rMin, range2.rMin);
    r.rMax = fmax(range1.rMax, range2.rMax);
    return r;
}

/** Return a range stretched by the golden ratio with the same center. */
NS_INLINE NARange NARangeStretchGoldenRatio(NARange range) {
    NARange r;
    NAFloat center = (range.rMin + range.rMax)/2.0;
    NAFloat halfNewSize = 0.5 * M_GOLDENRATIO * (range.rMax - range.rMin);
    
    r.rMin = center - halfNewSize;
    r.rMax = center + halfNewSize;
    return r;
}


#endif /* __NARANGE_H__ */

