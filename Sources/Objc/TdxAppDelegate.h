/*
 * TdxAppDelegate.h
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

#import <Cocoa/Cocoa.h>

extern NSString *TdxEventNotification;

@interface TdxAppDelegate : NSObject <NSApplicationDelegate>
{
  NSTimer *testTimer;
  NSThread *connexionThread;
  TDxMouseConnexion *connexion;
  TDxEventData *dataObject;

  NSLock *accessLock;
  BOOL eventDataArrived;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *labelValuesOut;
@property (assign) IBOutlet NSTextField *labelCounterOut;
@property (assign) IBOutlet NSTextField *labelEventType;

-(void)updateDeviceData:(TDxEventData *)devData;

// some sample dummy metheods to execute something on command
-(void)firstCommand;
-(void)secondCommand;
-(void)thirdCommand;
-(void)fourthCommand;
-(void)fifthCommand;
@end
