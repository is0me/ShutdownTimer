//
//  AppController.h
//  ShutdownTimer
//
//  Created by Shinya ISOME on 11/01/04.
//  Copyright 2011 is0.me. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <stdio.h> 
#import <CoreServices/CoreServices.h>
#import <Carbon/Carbon.h>

@interface AppController : NSObject {
	
	IBOutlet NSTextField *textField;
	IBOutlet NSDatePicker *startTime;
	IBOutlet NSTextField *nowTime;
	IBOutlet NSButton *button;
	IBOutlet NSPopUpButton *powerManagement;
	
	NSTimer *stopTimer;
	NSTimer *nowTimer;
	
}

-(IBAction) startTimeWatch: (id)sender;
-(void) start;
-(void) nowTimeStart;
-(void) compareDate:(NSTimer *)timer;
-(void) showNowTime:(NSTimer *)timer;
-(void) powerManagement: (int)select;
-(void) dealloc;
-(OSStatus) SendAppleEventToSystemProcess:(AEEventID)EventToSend;
-(IBAction)selectedPopUp:(id)sender;

@end
