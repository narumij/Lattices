/*
 * 3DxClientConnection.h
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

#import <Cocoa/Cocoa.h>


//==============================================================================
@interface TDxMouseConnexion : NSObject
{
	UInt16	 fConnexionClientID;
  TDxEventData *dataObj;
  NSLock *accessLock;
}
//==============================================================================

-(id)initConnexion;
-(void)start3DMouse;
-(void)terminate3DMouse;
-(int)deviceID;
-(void)getData:(TDxEventData *)data;
-(UInt16)connection;

-(void)connexionThreadMain:(id)argumentObject;

@end
//==============================================================================
