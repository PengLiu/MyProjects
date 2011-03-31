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
    
    int aiType = arc4random() % 3;
    CCLOG(@"Move type%d",aiType);
    Tank *t = [[Tank alloc] initWithScene:world atPosition:p tankType:EnemyTank];
    t.movement = aiType;
    
    [tankArray addObject:t];
    [t release];
}

-(void) destoryTank:(Tank *)t{
    
    [tankArray removeObject:t];
    [t destory];
    if ([tankArray count] <2) {
        [self spawnEnemy:1 atPosition:ccp(400,400)];
        [self spawnEnemy:1 atPosition:ccp(400,400)];
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
