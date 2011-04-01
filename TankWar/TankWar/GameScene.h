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
#import "ContactListener.h"


@class JoyStickLayer;
@class Tank;
@class EnemyManager;

@interface GameScene : CCLayer {
    
    b2World* phyWorld;
    GLESDebugDraw *m_debugDraw;
    
    
    CCTMXTiledMap *worldMap;
    CCTMXTiledMap *worldOverMap;
    
    Tank *tank;
    
    EnemyManager *enemyManager;
    
    NSString *worldMapName;
    
    ContactListener *contactListener;
}

@property (nonatomic, retain) Tank *tank;
@property (nonatomic, retain) EnemyManager *enemyManager;

@property (nonatomic, retain) CCTMXTiledMap *worldMap;
@property (nonatomic, retain) CCTMXTiledMap *worldOverMap;

@property (nonatomic) b2World *phyWorld;
@property (nonatomic) ContactListener *contactListener;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) sceneWithMap:(NSString *)worldMapName;

-(id) initInWorld:(NSString *)worldMapName;

-(void)setViewpointCenter:(CGPoint) position;

-(void) destory;

@end
