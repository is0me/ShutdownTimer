//
//  AppController.m
//  ShutdownTimer
//
//  Created by Shinya ISOME on 11/01/04.
//  Copyright 2011 is0.me. All rights reserved.
//

#import "AppController.h"


@implementation AppController

-(id) init
{
	if(self == [super init]){
	}
	
	return (self);
	
} // init

-(void) awakeFromNib
{
	[textField setStringValue: @"タイマーをセットしてください"];
	[button setTitle:@"Start"];
	[self nowTimeStart];
	[startTime setDateValue:[[[NSDate alloc]init]autorelease]];
	
} // awakeFromNib

- (IBAction)startTimeWatch:(id)sender
{
    
	if([stopTimer isValid]){
		[textField setStringValue: @"タイマーをストップしました"];
		[stopTimer invalidate];
		stopTimer = nil;
	}else{
		[self start];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
		[textField setStringValue:[NSString stringWithFormat:@"%@にマシンを%@します",[formatter stringFromDate:[startTime dateValue]],[powerManagement titleOfSelectedItem]]];
		[button setTitle:@"Stop"];
	}
    
} // timeUpdate

-(void)start
{
	stopTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target: self 
                                               selector:@selector(compareDate:) 
                                               userInfo:nil 
                                                repeats:YES];	
}

-(void)nowTimeStart
{
	nowTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                target: self 
                                              selector:@selector(showNowTime:) 
                                              userInfo:nil 
                                               repeats:YES];	
}

-(void) compareDate:(NSTimer *)timer
{
	NSDate *now_time = [[[NSDate alloc]init]autorelease];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	NSDate *start_time = [startTime dateValue];
	[formatter setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
	NSString *formatter_start = [formatter stringFromDate:start_time];
	NSString *formatter_now = [formatter stringFromDate:now_time];
	
	if( [formatter_start isEqualToString:formatter_now] ){
		[self powerManagement:[powerManagement indexOfSelectedItem]];
	}
} // compareDate

-(void) showNowTime:(NSTimer *)timer
{
	NSDate *now_time = [[[NSDate alloc]init]autorelease];
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
	NSString *formatter_now = [formatter stringFromDate:now_time];
    
	[nowTime setStringValue:formatter_now];
	
} // showNowTime

-(void) powerManagement:(int)select
{
    OSStatus error = noErr;
    switch (select)
    {
		case 0:
            //sending sleep event to system
			error = [self SendAppleEventToSystemProcess:kAESleep];
            if (error == noErr)
			{printf("Computer is going to sleep!\n");}
            else
			{printf("Computer wouldn't sleep");}
		case 1:
            //sending restart event to system
            error = [self SendAppleEventToSystemProcess:kAERestart];
            if (error == noErr)
			{printf("Computer is going to restart!\n");}
            else
			{printf("Computer wouldn't restart\n");}
			break;
		case 2:
            //sending logout event to system
			error = [self SendAppleEventToSystemProcess:kAEReallyLogOut];
            if (error == noErr)
			{printf("Computer is going to logout!\n");}
            else
			{printf("Computer wouldn't logout");}
			break;
		case 3:
            //sending shutdown event to system
            error = [self SendAppleEventToSystemProcess:kAEShutDown];
            if (error == noErr)
			{printf("Computer is going to shutdown!\n");}
            else
			{printf("Computer wouldn't shutdown\n");}
			break;
		default:
			NSLog(@" ???? \n");
    }
}

- (void) dealloc
{
    [stopTimer release];
    [nowTimer release];
    [super dealloc];
}

-(OSStatus) SendAppleEventToSystemProcess:(AEEventID)EventToSend
{
	
	AEAddressDesc targetDesc;
    static const ProcessSerialNumber kPSNOfSystemProcess = { 0, kSystemProcess };
    AppleEvent eventReply = {typeNull, NULL};
    AppleEvent appleEventToSend = {typeNull, NULL};
	
    OSStatus error = noErr;
	
    error = AECreateDesc(typeProcessSerialNumber, &kPSNOfSystemProcess, 
						 sizeof(kPSNOfSystemProcess), &targetDesc);
	
    if (error != noErr)
    {
        return(error);
    }
	
    error = AECreateAppleEvent(kCoreEventClass, EventToSend, &targetDesc, 
							   kAutoGenerateReturnID, kAnyTransactionID, &appleEventToSend);
	
    AEDisposeDesc(&targetDesc);
    if (error != noErr)
    {
        return(error);
    }
	
    error = AESend(&appleEventToSend, &eventReply, kAENoReply, 
				   kAENormalPriority, kAEDefaultTimeout, NULL, NULL);
	
    AEDisposeDesc(&appleEventToSend);
    if (error != noErr)
    {
        return(error);
    }
	
    AEDisposeDesc(&eventReply);
	
    return(error); 
}

- (IBAction)selectedPopUp:(id)sender
{
    //	NSLog(@"%@(index=%d) is Selected.選択されました\n",[powerManagement titleOfSelectedItem],[powerManagement indexOfSelectedItem]);
}

@end