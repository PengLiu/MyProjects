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
    
    NSMutableArray *enemyArray;
    
    CCSpriteBatchNode *enemySheet;
    
    GameScene *gameScene;
}

@property (nonatomic, retain) NSMutableArray *enemyArray;
@property (nonatomic, retain) CCSpriteBatchNode *enemySheet;
@property (nonatomic, retain) GameScene *gameScene;

-(id) initWithInWorld:(GameScene *) gameScene;
    
-(void) createEnemy;

@end
