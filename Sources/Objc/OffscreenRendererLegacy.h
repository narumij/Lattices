//
//  OffscreenRenderer.h
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface OffscreenRendererLegacy : NSObject
@property(retain) SCNScene *scene;
@property(weak) SCNNode *pointOfView;
- (NSImage*)imageWithSize:(NSSize)size;
@end
