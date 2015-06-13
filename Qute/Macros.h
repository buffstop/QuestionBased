//
//  Macros.h
//  Qute
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#ifndef Qute_Macros_h
#define Qute_Macros_h

static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}
#endif
