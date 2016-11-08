/*
 * 3DxEventData.h
 *
 * Container for 3D Mouse event data
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


@interface TDxEventData : NSObject
{
  int tx, ty, tz;
  int rx, ry, rz;
  int button;
  BOOL buttonEvent;
  BOOL motionEvent;
  NSTimeInterval timeStamp;
}
-(id)initWithTDxEventData:(TDxEventData *)inData;
-(void)setValuesFromEventData:(TDxEventData *)inData;
-(void)setIsButtonEvent;
-(void)setIsMotionEvent;
-(BOOL)isZeroEvent;

@property (readwrite,assign) int tx;
@property (readwrite,assign) int ty;
@property (readwrite,assign) int tz;
@property (readwrite,assign) int rx;
@property (readwrite,assign) int ry;
@property (readwrite,assign) int rz;
@property (readwrite,assign) int button;
@property (readwrite,assign) NSTimeInterval timeStamp;
@property (readonly) BOOL buttonEvent;
@property (readonly) BOOL motionEvent;
@end
