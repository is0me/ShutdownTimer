//
//  ShutdownTimerAppDelegate.h
//  ShutdownTimer
//
//  Created by Shinya ISOME on 11/01/04.
//  Copyright 2011 is0.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ShutdownTimerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
