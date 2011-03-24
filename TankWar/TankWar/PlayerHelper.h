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

@class GameScene;

@interface PlayerHelper : CCNode {

    
    GameScene *world;
    
	CCSpriteBatchNode *playerSheet;
        
    
    CCSprite *player;
    CCSprite *turret;
    
    //Box2d tank body
    b2Body *tankBody;
    
    float angle;
}

@property (nonatomic, retain) CCSpriteBatchNode *playerSheet;
@property (nonatomic, retain) NSMutableArray *actionArray;
@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) CCSprite *turret;
@property (nonatomic, retain) GameScene *world;

@property (nonatomic) float angle;
@property (nonatomic) NSInteger currentActionIndex;

@property (nonatomic)  b2Body *tankBody;

-(id) initWithScene:(GameScene *)world;

-(void) stopCurrentAction;

-(CGPoint) getCurrentPosition;


-(void) moveToDirection:(CGPoint)direction WithPower:(float)power;

-(void) startFire;
-(void) stopFire;

@end
