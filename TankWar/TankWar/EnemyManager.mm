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

-(id) initWithScene:(GameScene *)w{
    
    if ((self = [super init])) {
            
        self.world = w;
 
    }
    return self;
}

-(void) spawnEnemy:(int)level{
    [[Tank alloc] initWithScene:world atPosition:ccp(200,300) tankType:EnemyTank];
}

//Private methods


@end
