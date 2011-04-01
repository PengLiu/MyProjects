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
#import "Tank.h"
#import "SimpleAudioEngine.h"


@interface EnemyManager(PrivateMethods)
    


@end


@implementation EnemyManager
    
@synthesize world;
@synthesize tankArray;

-(id) initWithScene:(GameScene *)w{
        
    if ((self = [super init])) {
        self.world = w;
        self.tankArray = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

-(void) spawnEnemy:(int)level atPosition:(CGPoint)p{
    

    int tmpAiType = arc4random() % 3;
    
    AIMoveType aiMoveType;
    switch (tmpAiType) {
        case 0:
            aiMoveType = RandomMove;
            break;
        case 1:
            aiMoveType = FixedPosition;
            break;
        case 2:
            aiMoveType = ChasePlayers;
            break;
        default:
            break;
    }
     
    CCLOG(@"Move type%d",aiMoveType);
    Tank *t = [[Tank alloc] initEnemyTankWithScene:world atPosition:p aiMoveType:aiMoveType];
    
    [tankArray addObject:t];
    [t release];
}

-(void) destoryTank:(Tank *)t{
    
    [tankArray removeObject:t];
    [[SimpleAudioEngine sharedEngine]playEffect:@"enemydown.mp3"];
    
    [t destory];
    if ([tankArray count] <5) {
        for (int i =0 ; i<10; i++) {
            int x = arc4random() % 400 + 50;
            int y = arc4random() % 300 + 40;
            [self spawnEnemy:1 atPosition:ccp(x,y)];
        }
    }
}

-(void)destoryAll{
    //Clean all enemy tanks
    for (Tank *t in tankArray){
        [t destory];
    }
    [tankArray removeAllObjects];
}

//Private methods

-(void) dealloc{
    [super dealloc];
}

@end
