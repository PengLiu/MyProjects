//
//  RoationUtil.h
//  TankWar
//
//  Created by Ammen on 11-4-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

@interface RoationUtil : NSObject {
    
}

+(float) joyStickyToSpriteRotation:(float)angle offSetAngle:(float) offset;

+(CGPoint) shootTarget:(CGPoint) startPoint withJoyStickAngle:(float)angle;

+(float) angleBetween:(CGPoint) startPoint endPoint:(CGPoint)endPoint;

+(float) angleTo360:(float)angle withOffset:(float)offset;

//根据两点见夹角计算box2d移动冲量比,并各个方向的分量上乘以ration比例
+(b2Vec2) phyPower:(float)pointsAngle withRatio:(float)ratio;

@end
