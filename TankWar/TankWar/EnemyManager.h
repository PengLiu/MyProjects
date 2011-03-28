//
//  EnemyManager.h
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class  GameScene;

@interface EnemyManager : CCNode {
    
    GameScene *world;
}

@property (nonatomic, retain) GameScene *world;


-(id) initWithScene:(GameScene *)world;

-(void) spawnEnemy:(int)level;


@end
