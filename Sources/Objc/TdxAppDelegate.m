/*
 * TdxAppDelegate.m
 *
 * Application delegate
 *
 *
 * Copyright notice:
 * (c) 2009-2014 3Dconnexion. All rights reserved.
 *
 * This file and source code are an integral part of the "3Dconnexion
 * Software Developer Kit", including all accompanying documentation,
 * and is protected by intellectual property laws. All use of the
 * 3Dconnexion Software Developer Kit is subject to the License
 * Agreement found in the "LicenseAgreementSDK.txt" file.
 * All rights not expressly granted by 3Dconnexion are reserved.
 */

#import "3DxEventData.h"
#import "3DxClientConnection.h"
#import "TdxAppDelegate.h"

#ifdef NDEBUG
#define NSLog(...)
#else
#define NSLog(...)
#endif

@interface TdxAppDelegate (private_methods)
-(void)loadSettings;
-(void)saveSettings;
@end

NSString *TdxEventNotification = @"TdxEventNotification";

@implementation TdxAppDelegate

@synthesize window;
@synthesize labelValuesOut;
@synthesize labelCounterOut;
@synthesize labelEventType;

-(void)timerFired:(NSTimer *)inTimer
{
  static long val = 0;
  [labelCounterOut setIntegerValue:val++];
}

-(void)tdxNotificationAction:(NSNotification *)aNotification
{
//  if (!eventDataArrived)
//  {
    eventDataArrived = YES;
    [connexion getData:dataObject];
    //NSLog(@"tdxNotificationAction .. updates...");
//    [(id)(NSApp.delegate) performSelectorOnMainThread:@selector(updateDeviceData:) withObject:dataObject waitUntilDone:NO];
    NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
    NSNotification *note = [NSNotification notificationWithName:TdxEventNotification
                                                         object:[[TDxEventData alloc] initWithTDxEventData:dataObject]];
    [queue enqueueNotification:note
                  postingStyle:NSPostASAP
                  coalesceMask:NSNotificationCoalescingOnName
                      forModes:nil];
//  }
}


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  dataObject = [[TDxEventData alloc] init];
  eventDataArrived = NO;
  connexion = [[TDxMouseConnexion alloc] initConnexion];//WithDataObject:dataObject];
  NSLog(@"-applicationDidFinishLaunching, connecting to 3D Mouse. Connection");
  NSLog(@"-applicationDidFinishLaunching...main thread ID = %p", [NSThread currentThread]);

  // set up notification
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(tdxNotificationAction:)
                                               name:[NSString stringWithFormat:@"3DxMouseEvent_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]]
                                             object:connexion];
  
  [labelEventType setStringValue:@"-"];

  // now activate the device(thread)
  connexionThread = [[NSThread alloc] initWithTarget:connexion selector:@selector(connexionThreadMain:) object:self];
  [connexionThread start];

  // generate some load on the UI / main thread to demonstrate, that
  // device data is coming through correctly and undelaed (not buffered)
  if (!testTimer)
  {
    // (re)enable the device / motion and buttons
    testTimer = [NSTimer scheduledTimerWithTimeInterval:0.0001
                                                   target:self
                                                 selector:@selector(timerFired:)
                                                 userInfo:nil
                                                  repeats:YES];
  }

  // show the window
  [window makeKeyAndOrderFront:self];
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
  NSLog(@"-applicationWillTerminate, closing connection");

  // save before leaving!
  [self saveSettings];

	// End connection to 3dmouse driver
	if (connexion)
	{
		[connexion terminate3DMouse];
	}
}


- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
#pragma unused(sender)
  return NSTerminateNow;
}


- (void)applicationDidResignActive:(NSNotification *)aNotification
{
  //[connexion setActive:NO];
}


- (void)applicationDidBecomeActive:(NSNotification *)aNotification
{
  //[connexion setActive:YES];
}

#pragma mark -
#pragma mark Methods for accessing user settings
-(void)saveSettings
{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

  if (standardUserDefaults)
  {
    // implement whatever values need to be written
  }
}


-(void)loadSettings
{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

  if (standardUserDefaults)
  {
    // implement whatever values need to be read
  }
}

#pragma mark -
#pragma mark dummy sample methods for executing a command
-(void)firstCommand
{
  NSLog(@"Executing the first command.");
}

-(void)secondCommand
{
  NSLog(@"Executing the second command.");
}

-(void)thirdCommand
{
  NSLog(@"Executing the third command.");
}

-(void)fourthCommand
{
  NSLog(@"Executing the fourth command.");
}

-(void)fifthCommand
{
  NSLog(@"Executing the fith command.");
}


#pragma mark -
#pragma mark event updater
-(void)updateDeviceData:(TDxEventData *)devData
{
  [accessLock lock];

  TDxEventData *mydata = [[TDxEventData alloc] initWithTDxEventData:devData];

  [labelValuesOut setStringValue:[NSString stringWithFormat:@"-updateDeveiceData: called (thread: %p)\nData=%@",
                                  [NSThread currentThread],
                                  mydata]];

  if (mydata.buttonEvent)
  {
    //NSLog(@"EventType: ButtonEvent");
    [labelEventType setStringValue:@"ButtonEvent"];
    switch (mydata.button)
    {
      case 1:
        [self firstCommand];
        break;
      case 2:
        [self secondCommand];
        break;
      case 3:
        [self thirdCommand];
        break;
      case 4:
        [self fourthCommand];
        break;
      case 5:
        [self fifthCommand];
        break;
      default:
        break;
    }
  }
  else
  {
    if (![mydata isZeroEvent])
    {
      //NSLog(@"EventType: MotionEvent");
      [labelEventType setStringValue:@"MotionEvent"];
    }
    else
    {
      //NSLog(@"EventType: ZeroEvent");
      [labelEventType setStringValue:@"ZeroEvent"];
    }
  }
  
  [accessLock unlock];
  eventDataArrived = NO;
}
@end
