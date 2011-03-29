//
//  EnemyManager.h
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class  Tank;
@class  GameScene;

@interface EnemyManager : CCNode {

    GameScene *world;
    
    NSMutableArray *tankArray;
}

@property (nonatomic, assign) GameScene *world;
@property (nonatomic, retain) NSMutableArray *tankArray;

-(id) initWithScene:(GameScene *)world;

-(void) spawnEnemy:(int)level atPosition:(CGPoint)p;

-(void) destoryAll;

-(void) destoryTank:(Tank *)t;

@end
