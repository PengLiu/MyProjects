//
//  PlayerHelper.h
//  Shooter
//
//  Created by Ammen on 11-3-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"

@class Bullet;
@class GameScene;

@interface Tank : CCNode {

    
    GameScene *world;
    
	CCSpriteBatchNode *playerSheet;
    
    CCSprite *tankSprite;
    CCSprite *turretSprite;
    
    //Box2d tank body
    b2Body *tankBody;
    
    //Tank properties
    //射击角度
    float angle;
    
    //射击速度
    float firePower;
    //射击频率 单位秒
    float fireFrequency;
    //防御
    float defense;
    //攻击力
    float attack;
    //移动力
    float movement;
    
    float hp;
    float ap;
    
    //坦克类型：玩家／敌人
    TankType type;
    //坦克的移动方式，随机的巡逻，固定路径行走..
    AIMoveType moveType;
    
}

@property (nonatomic, assign) GameScene *world;

@property (nonatomic, retain) CCSpriteBatchNode *playerSheet;

@property (nonatomic, retain) CCSprite *tankSprite;
@property (nonatomic, retain) CCSprite *turretSprite;

@property (nonatomic)  b2Body *tankBody;

@property (nonatomic) TankType type;
@property (nonatomic) AIMoveType moveType;

@property (nonatomic) float angle;
@property (nonatomic) float hp;
@property (nonatomic) float ap;
@property (nonatomic) float fireFrequency;
@property (nonatomic) float firePower;
@property (nonatomic) float defense;
@property (nonatomic) float attack;
@property (nonatomic) float movement;


-(id) initWithScene:(GameScene *)aWorld atPosition:(CGPoint) posision tankType:(TankType) type;

-(CGPoint) getCurrentPosition;

-(void) injuredWithBullet:(Bullet *)bullet;

-(void) moveToDirection:(CGPoint)direction WithPower:(float)power;

-(void) startFire;
-(void) stopFire;

-(void) destory;

@end
