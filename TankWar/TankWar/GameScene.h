//
//  GameScene.h
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@class JoyStickLayer;
@class PlayerHelper;
@class EnemyManager;

@interface GameScene : CCLayer {
    
    b2World* phyWorld;
    GLESDebugDraw *m_debugDraw;
    
    
    CCTMXTiledMap *worldMap;
    
    PlayerHelper *playerHelper;
    
    EnemyManager *enemyManager;
    
    NSString *worldMapName;

}

@property (nonatomic, retain) PlayerHelper *playerHelper;
@property (nonatomic, retain) EnemyManager *enemyManager;

@property (nonatomic, retain) CCTMXTiledMap *worldMap;

@property (nonatomic) b2World *phyWorld;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) sceneWithMap:(NSString *)worldMapName;

-(id) initInWorld:(NSString *)worldMapName;

-(void)setViewpointCenter:(CGPoint) position;

@end
