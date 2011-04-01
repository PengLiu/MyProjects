//
//  Bullet.h
//  TankWar
//
//  Created by Ammen on 11-3-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "cocos2d.h"
#import "Box2D.h"

@class GameScene;

@interface Bullet : CCNode {
    
    
    GameScene *gameWorld;
    CCSprite *bulletSprite;
    
    b2World *phyWorld;
    b2Body *bulletBody;
    
    BOOL needToBeExploded;
    BOOL needToBeDeleted;
    
    CCAction *fireAction;
    
    //伤害
    float attack;
    
    TankType senderType;
    BulletTargetType bulletTargetType;
}

@property (nonatomic) BOOL needToBeExploded;
@property (nonatomic) BOOL needToBeDeleted;

@property (nonatomic, retain) CCSprite *bulletSprite;
@property (nonatomic, assign) GameScene *gameWorld;

@property (nonatomic) b2World *phyWorld;
@property (nonatomic) b2Body *bulletBody;

@property (nonatomic, retain) CCAction *fireAction;

@property (nonatomic) TankType senderType;
@property (nonatomic) BulletTargetType bulletTargetType;

@property (nonatomic) float attack;

-(id) initBullet:(NSInteger)bulletType inPhyWorld:(b2World *)pw inGameWorld:(GameScene *)gw atPosition:(CGPoint)p sender:(TankType)tt;

-(void) fire:(b2Vec2)force fireAngle:(float)angle;

-(void) explod;

-(void) destory;

@end
