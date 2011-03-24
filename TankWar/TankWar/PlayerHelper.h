//
//  PlayerHelper.h
//  Shooter
//
//  Created by Ammen on 11-3-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameScene;

@interface PlayerHelper : CCNode {

	CCSpriteBatchNode *playerSheet;
	
	NSMutableArray *actionArray;
	
	CCSprite *player;
    CCSprite *turret;
	
	GameScene *world;
	
	NSInteger currentActionIndex;
    
    NSMutableArray *collisionObjs;
    
    float angle;
}

@property (nonatomic, retain) CCSpriteBatchNode *playerSheet;
@property (nonatomic, retain) NSMutableArray *actionArray;
@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) CCSprite *turret;
@property (nonatomic, retain) GameScene *world;
@property (nonatomic, retain) NSMutableArray *collisionObjs;

@property (nonatomic) float angle;
@property (nonatomic) NSInteger currentActionIndex;

-(id) initWithScene:(GameScene *)world;

-(void) stopCurrentAction;

-(CGPoint) getCurrentPosition;

-(void) moveToPosition:(CGPoint) position;
-(void) fire;

@end
