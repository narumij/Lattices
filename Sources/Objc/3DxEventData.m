/*
 * 3DxEventData.m
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

#import "3DxEventData.h"


@implementation TDxEventData

@synthesize tx;
@synthesize ty;
@synthesize tz;
@synthesize rx;
@synthesize ry;
@synthesize rz;
@synthesize button;
@synthesize timeStamp;
@synthesize buttonEvent;
@synthesize motionEvent;

-(id)init
{
  self = [super init];
  if (self)
  {
    tx = 0;
    ty = 0;
    tz = 0;
    rx = 0;
    ry = 0;
    rz = 0;
    button = 0;
    motionEvent = NO;
    buttonEvent = NO;

    //NSDate *aDate = [NSDate date];
    timeStamp  = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"init... %f", timeStamp);
    //[aDate release];
  }
  else
  {
    self = nil;
  }    
  return self;
}

- (id)initWithTDxEventData:(TDxEventData *)inData
{
  self = [super init];
  if (self)
  {
    tx = ty = tz = 0;
    rx = ry = rz = 0;
    button = 0;
    motionEvent = NO;
    buttonEvent = NO;
    if (inData)
    {
      tx = inData.tx;
      ty = inData.ty;
      tz = inData.tz;
      rx = inData.rx;
      ry = inData.ry;
      rz = inData.rz;
      button      = inData.button;
      timeStamp   = inData.timeStamp;
      buttonEvent = inData.buttonEvent;
      motionEvent = inData.motionEvent;
    }
  }
  else
  {
    self = nil;
  }    
  return self;  
}

-(void)setValuesFromEventData:(TDxEventData *)inData
{
  //tx = ty = tz = 9;
  //NSLog(@"TDxEventData -setValuesFromEventData ... %@ - %@", self, inData);
  if (inData)
  {
    tx = inData.tx;
    ty = inData.ty;
    tz = inData.tz;
    rx = inData.rx;
    ry = inData.ry;
    rz = inData.rz;
    button      = inData.button;
    timeStamp   = inData.timeStamp;//[NSDate timeIntervalSince1970];
    buttonEvent = inData.buttonEvent;
    motionEvent = inData.motionEvent;
  }
}

-(BOOL)isZeroEvent
{
  return ((tx == 0 ) && (ty == 0) && (tz == 0) && (rx == 0) && (ry == 0) && (rz == 0));
}


-(void)setIsButtonEvent
{
  buttonEvent = YES;
  motionEvent = NO;
}

-(void)setIsMotionEvent
{
  buttonEvent = NO;
  motionEvent = YES;
}

-(void)dealloc
{
  [super dealloc];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"[(%f) %i %i %i / %i %i %i] Button %i", timeStamp, tx, ty, tz, rx, ry, rz, button];
}
@end
