/*
 * 3DxClientConnection.m
 *
 * Opens the conection to 3DxWareMac / the devive
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

#import <3DConnexionClient/ConnexionClient.h>
#import <3DConnexionClient/ConnexionClientAPI.h>

#import "3DxEventData.h"
#import "3DxClientConnection.h"

#define kDevID_SpaceMousePro 0xC62b

#ifdef NDEBUG
#define NSLog(...)
#else
#define NSLog(...)
#endif

/*
 If defined: This sample only gets the button data via kConnexionCmdHandleButtons,
 mappings done in the driver (processed in kConnexionCmdAppSpecific) will have no effect.
 */
//#define WE_DONT_WANT_TO_USE_APPLICATIONCOMMANDS



//==============================================================================
// Make the linker happy for the framework check (see link below for more info)
// http://developer.apple.com/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WeakLinking.html

extern OSErr InstallConnexionHandlers() __attribute__((weak_import));

//==============================================================================
// Quick & dirty way to access our class variables from the C callback

TDxMouseConnexion	*gConnexionTest = 0L;

void messageHandler3DMouse(io_connect_t connection, natural_t messageType, void *messageArgument);

@interface TDxMouseConnexion (private_methods)
-(void)updateData:(TDxEventData *)data;
@end

//==============================================================================
@implementation TDxMouseConnexion
//==============================================================================
-(id)initConnexion
{
  if(InstallConnexionHandlers != NULL)
	{
    if (self = [super init])
    {
      accessLock = [[NSLock alloc] init];
      dataObj = [[TDxEventData alloc] init];
      gConnexionTest = self;
      NSLog(@"-initConnexion: %p, dataObject = %p", self, dataObj);

      return self;
    }
  }
  return nil;
}

-(void)dealloc
{
  [dataObj release];
  [super dealloc];
}

-(UInt16)connection
{
  return fConnexionClientID;
}

-(void)updateData:(TDxEventData *)data
{
  //NSLog(@"clientconnexion updateData %@", data);
  [accessLock lock];
  [dataObj setValuesFromEventData:data];
  [accessLock unlock];

  //NSLog(@"-updateData: called (thread: %p)\nData=%@", [NSThread currentThread], data);
  
  [[NSNotificationCenter defaultCenter] postNotificationName:
   [NSString stringWithFormat:@"3DxMouseEvent_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]]
                                                      object:self];
}


-(void)getData:(TDxEventData *)data
{
  [accessLock lock];
  [data setValuesFromEventData:dataObj];
  [accessLock unlock];
}

-(void)connexionThreadMain:(id)argumentObject
{ 
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSRunLoop* runLoop = [NSRunLoop currentRunLoop];

  NSLog(@"-connexionThreadMain...device thread ID = %p", [NSThread currentThread]);

  [self start3DMouse];
  while ([[NSThread currentThread] isCancelled] == NO)//(moreWorkToDo && !exitNow)
  {
    // Run the run loop but timeout immediately if the input source isn't waiting to fire.
    [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
  }
  [pool drain];
}


- (void)start3DMouse
{
	OSErr	error;
  NSLog(@"start3DMouse");

	// Quick hack to keep the sample as simple as possible, don't use in shipping code
	gConnexionTest = self;

	// Make sure the framework is installed
	if(InstallConnexionHandlers != NULL)
	{
		// Install message handler and register our client
		error = InstallConnexionHandlers(messageHandler3DMouse, 0L, 0L);
		
		// This takes over system-wide
    fConnexionClientID = RegisterConnexionClient(kConnexionClientWildcard, (uint8 *)"TemplateApp", kConnexionClientModeTakeOver, kConnexionMaskAxis);

#ifndef WE_DONT_WANT_TO_USE_APPLICATIONCOMMANDS
		// A separate API call is required to capture buttons beyond the first 8
    if (fConnexionClientID)
    {
      SetConnexionClientMask(fConnexionClientID, kConnexionMaskAllButtons);
      //SetConnexionClientButtonMask(fConnexionClientID, kConnexionMaskAllButtons);
      // Note: These calls wil disable th epossibility to act on Application Commands
    }
#endif
  }
}

- (void)terminate3DMouse
{
	// Make sure the framework is installed
	if(InstallConnexionHandlers != NULL)
	{
		//Unregister our client and clean up all handlers
		if (fConnexionClientID) UnregisterConnexionClient(fConnexionClientID);
		CleanupConnexionHandlers();
	}
}

-(int)deviceID
{
  SInt32 result;
  
  if (ConnexionControl(kConnexionCtlGetDeviceID, 0, &result))
    return 0;
  
  result = (result & 0xFFFF);
  
  return (result & 0xFFFF);
}

//==============================================================================
int getButton(NSUInteger buttonMask)
{
  int button = 0;
  
  for (int i = 0; i < 32; i++)
  {
    if (buttonMask & (1 << i))
      button += i;
  }
  return button + 1;
}


void messageHandler3DMouse(io_connect_t connection, natural_t messageType, void *messageArgument)
{
	ConnexionDeviceState		*state;
  SInt32						vidPid;
	UInt32						signature;
	NSString					*string;
	ConnexionDevicePrefs		prefs;
	OSErr						error;

	switch(messageType)
	{
		case kConnexionMsgDeviceState:
			state = (ConnexionDeviceState*)messageArgument;
      // decipher what command/event is being reported by the driver
      switch (state->command)
      {
        case kConnexionCmdHandleAxis:
          {
            TDxEventData *data = [[TDxEventData alloc] init];
            
            data.tx = state->axis[0];
            data.ty = state->axis[1];
            data.tz = state->axis[2];
            data.rx = state->axis[3];
            data.ry = state->axis[4];
            data.rz = state->axis[5];
            
            [data setIsMotionEvent];
            
            [gConnexionTest updateData:data];
            [data release];
          }
          break;
        case kConnexionCmdHandleButtons:
          {
            TDxEventData *data = [[TDxEventData alloc] init];
            
            if (state->buttons != 0)
              data.button = getButton(state->buttons);
            else
              data.button = 0;

            [data setIsButtonEvent];

            [gConnexionTest updateData:data];
            [data release];
          }
          break;
        case kConnexionCmdAppSpecific:
          NSLog(@"kConnexionCmdAppSpecific %i", state->buttons);
          break;
        case kConnexionCmdHandleRawData:
        default:
          break;
      }                
			break;
		case kConnexionMsgPrefsChanged:
      signature = (UInt32)((long)messageArgument); // note that 4-byte values are passed by value, not by pointer
			if (signature < 10)
        string = [NSString stringWithFormat: @"%d", signature];
			else
        string = [NSString stringWithFormat: @"%c%c%c%c", (signature >> 24) & 0xFFU, (signature >> 16) & 0xFFU, (signature >> 8) & 0xFFU, signature & 0xFFU];

      NSLog(@"PrefsChanged - Application signature: %@", string);
			(void)ConnexionControl(kConnexionCtlGetDeviceID, 0, &vidPid);
      NSLog(@"PrefsChanged - %x VendorID: %x, DeviceID: %x", vidPid, (vidPid & 0xFF00), (vidPid & 0x00FF));
			error = ConnexionGetCurrentDevicePrefs(kDevID_SpaceMousePro, &prefs);
			if(error == noErr)
			{
//        NSString *appName = [NSString stringWithFormat:@"%s", (char*)&prefs.appName[1]];
        NSLog(@"PrefsChanged - 3D Mouse prefs for device 0x%x and application %@",
              kDevID_SpaceMousePro,
              [NSString stringWithFormat:@"%s", (char*)&prefs.appName[1]]);
			}
      break;
		default:
			// other messageTypes can happen and should be ignored
			break;
	}
}
@end
