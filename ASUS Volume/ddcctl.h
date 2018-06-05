//
//  ddcctl.h
//  ASUS Volume
//
//  Created by Bruce Sheplan on 5/27/18.
//  Copyright © 2018 Bruce Sheplan. All rights reserved.
//

#ifndef ddcctl_h
#define ddcctl_h

#import <Foundation/Foundation.h>
#import <AppKit/NSScreen.h>
#import "DDC.h"

void updateVolume(NSUInteger displayId, int value);

#endif /* ddcctl_h */
