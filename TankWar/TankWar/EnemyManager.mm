//
//  EnemyManager.m
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "EnemyManager.h"
#import "Constants.h"
#import "GameScene.h"

@implementation EnemyManager
    
@synthesize enemyArray;
@synthesize gameScene;
@synthesize enemySheet;

-(id) initWithInWorld:(GameScene *) world{
    
    if ((self = [super init])) {
        
        self.enemyArray = [NSMutableArray arrayWithCapacity:20];
        self.gameScene = world;
        
        CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"enemy.png"];
		self.enemySheet = [CCSpriteBatchNode batchNodeWithTexture:playerTexture];
		[self.gameScene addChild:enemySheet z:1 tag:ENEMY_BATCH_NODE];
    }
    
    return self;
}
 
-(void) createEnemy{
    
    self.enemySheet = (CCSpriteBatchNode *)[self.gameScene getChildByTag:ENEMY_BATCH_NODE];
    
    CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"enemy.png"];
    CCSprite *enemy = [CCSprite spriteWithTexture:playerTexture];
    [enemy setPosition:ccp(100,400)];
    
    [enemySheet addChild:enemy z:1];
}


@end
