//
//  CCLayout.h
//  cocos2d-Joystick
//
//  Created by ezshine on 11-2-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCLayout : CCNode {

}

+(CGPoint)TopLeft;
+(CGPoint)TopLeftWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)TopCenter;
+(CGPoint)TopCenterWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)TopRight;
+(CGPoint)TopRightWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)Left;
+(CGPoint)LeftWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)Center;
+(CGPoint)CenterWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)Right;
+(CGPoint)RightWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)BottomLeft;
+(CGPoint)BottomLeftWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)BottomCenter;
+(CGPoint)BottomCenterWithOffsetPoint:(CGPoint)offsetpoint;

+(CGPoint)BottomRight;
+(CGPoint)BottomRightWithOffsetPoint:(CGPoint)offsetpoint;

@end
