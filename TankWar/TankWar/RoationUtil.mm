//
//  RoationUtil.m
//  TankWar
//
//  Created by Ammen on 11-4-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Constants.h"
#import "RoationUtil.h"


@implementation RoationUtil

//offset 参数根据图片位置有关，如果是图片是面向右方则offset为0
+(float) joyStickyToSpriteRotation:(float)angle offSetAngle:(float) offset{
    return (-angle + offset);
}

+(CGPoint) shootTarget:(CGPoint) startPoint withJoyStickAngle:(float)angle{
    
    float ran= angle * PI/180;
    
    float vx = cos(ran) * 100;
	float vy = sin(ran) * 100;
    
    return ccp(startPoint.x + vx, startPoint.y + vy);
}

+(float) angleBetween:(CGPoint) startPoint endPoint:(CGPoint)endPoint{
    
    return atan2f(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    
}

+(float) angleTo360:(float)angle withOffset:(float)offset{
    return angle * 180 / PI + offset;
}


+(b2Vec2) phyPower:(float)pointsAngle withRatio:(float)ratio{
    return b2Vec2(sin(pointsAngle) * ratio, cos(pointsAngle) * ratio);
}

@end
