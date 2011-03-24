//
//  GameScene.m
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "MainMenuScene.h"
#import "CCJoyStick.h"
#import "PlayerHelper.h"
#import "JoyStickLayer.h"
#import "EnemyManager.h"

@interface GameScene(PrivateMethod)

-(void) initPlayer;

-(void) initWorld;

-(void) initEnemy;

- (CGPoint)tileCoordForPosition:(CGPoint)position;

@end


@implementation GameScene

@synthesize worldMap;
@synthesize playerHelper;
@synthesize enemyManager;
@synthesize collisionObjs;

+(CCScene *) sceneWithMap:(NSString *)worldMapName{
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [[[GameScene alloc] initInWorld:worldMapName] autorelease];

	// add layer as a child to scene
	[scene addChild: layer];
    
    JoyStickLayer *joyStickLayer = [JoyStickLayer node];
    [joyStickLayer setGameScene:layer]; 
    
    [scene addChild:joyStickLayer]; 
	
	// return the scene
	return scene;
	
	
}

-(id) initInWorld:(NSString *)wm{
	
    
	if( (self=[super init])) {
        
        worldMapName = wm;
        collisionObjs = [NSMutableArray arrayWithCapacity:20];
        
        //Init world map
        [self initWorld];
        
        //Init player
        [self initPlayer];
        
        //Init Enemy
        [self initEnemy];
        
    }
    
    return self;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    
    int x = position.x / self.worldMap.tileSize.width;
    
    int y = ((self.worldMap.mapSize.height * self.worldMap.tileSize.height) - position.y) / self.worldMap.tileSize.height;

    return ccp(x, y);
}

-(void) initEnemy{
    
    self.enemyManager = [[EnemyManager alloc] initWithInWorld:self];
    [self.enemyManager createEnemy];
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    
    x = MIN(x, (self.worldMap.mapSize.width * self.worldMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (self.worldMap.mapSize.height * self.worldMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
  
}

-(void) initPlayer{
    
    self.playerHelper = [[PlayerHelper alloc] initWithScene:self];
    [self.playerHelper moveToPosition:ccp(300, 50)];
}

-(void) initWorld{
    
    self.worldMap = [CCTMXTiledMap tiledMapWithTMXFile:worldMapName];
    [self addChild:worldMap z:-1];
 
    CCTMXObjectGroup *collidableObjs = [worldMap objectGroupNamed:@"CollisionObjs"];
    
    for (NSMutableDictionary *dic in [collidableObjs objects]) {
        
        int x = [[dic valueForKey:@"x"] intValue];
        int y = [[dic valueForKey:@"y"] intValue];
        int width = [[dic valueForKey:@"width"] intValue];
        int height = [[dic valueForKey:@"height"] intValue];

        NSValue *rect = [NSValue valueWithCGRect:CGRectMake(x, y, width, height)];
        [self.collisionObjs addObject:rect];
        CCLOG(@"x%d,x%d ,w%d,h%d,d:%@", x, y,width,height,[dic description]);
    }

}

-(void) dealloc{
    [enemyManager release];
    [playerHelper release];
    [super dealloc];
}

@end
