//
//  CCLayout.m
//  cocos2d-Joystick
//
//  Created by ezshine on 11-2-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCLayout.h"


@implementation CCLayout

+(CGPoint)TopLeft
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(0,size.height);
}
+(CGPoint)TopLeftWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(offsetpoint.x,size.height+offsetpoint.y);
}

+(CGPoint)TopCenter
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width/2,size.height);
}
+(CGPoint)TopCenterWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width/2+offsetpoint.x,size.height+offsetpoint.y);
}

+(CGPoint)TopRight
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width,size.height);
}
+(CGPoint)TopRightWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width+offsetpoint.x,size.height+offsetpoint.y);
}
//
+(CGPoint)Left
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(0,size.height/2);
}
+(CGPoint)LeftWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(offsetpoint.x,size.height/2+offsetpoint.y);
}

+(CGPoint)Center
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width/2,size.height/2);
}
+(CGPoint)CenterWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width/2+offsetpoint.x,size.height/2+offsetpoint.y);
}

+(CGPoint)Right
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width,size.height/2);
}
+(CGPoint)RightWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width+offsetpoint.x,size.height/2+offsetpoint.y);
}
//
+(CGPoint)BottomLeft
{
	return ccp(0,0);
}
+(CGPoint)BottomLeftWithOffsetPoint:(CGPoint)offsetpoint
{
	return offsetpoint;
}

+(CGPoint)BottomCenter
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width/2,0);
}
+(CGPoint)BottomCenterWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width/2+offsetpoint.x,offsetpoint.y);
}

+(CGPoint)BottomRight
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width,0);
}
+(CGPoint)BottomRightWithOffsetPoint:(CGPoint)offsetpoint
{
	CGSize size = [[CCDirector sharedDirector] winSize];
	return ccp(size.width+offsetpoint.x,offsetpoint.y);
}

@end
