//
//  GameScene.m
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
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

@synthesize phyWorld;

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
    //[self.playerHelper moveToPosition:ccp(300, 50)];
}

-(void) initWorld{
    
    //Load world map
    self.worldMap = [CCTMXTiledMap tiledMapWithTMXFile:worldMapName];
    [self addChild:worldMap z:-1];
    
    
    //Init box2d world
    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    
    // Do we want to let bodies sleep?
    // This will speed up the physics simulation
    bool doSleep = true;
    
    // Construct a world object, which will hold and simulate the rigid bodies.
    phyWorld = new b2World(gravity, doSleep);
    
    phyWorld->SetContinuousPhysics(true);
    
    // Debug Draw functions
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    phyWorld->SetDebugDraw(m_debugDraw);
    
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    //		flags += b2DebugDraw::e_jointBit;
    //		flags += b2DebugDraw::e_aabbBit;
    //		flags += b2DebugDraw::e_pairBit;
    //		flags += b2DebugDraw::e_centerOfMassBit;
    m_debugDraw->SetFlags(flags);
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    b2Body* groundBody = phyWorld->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;		
    
    int worldWidth = worldMap.mapSize.width * worldMap.tileSize.width;
    int worldHeight = worldMap.mapSize.height * worldMap.tileSize.height;
    
    // bottom
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(worldWidth/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0,worldHeight/PTM_RATIO), b2Vec2(worldWidth/PTM_RATIO,worldHeight/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // left
    groundBox.SetAsEdge(b2Vec2(0,worldHeight/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2(worldWidth/PTM_RATIO,worldHeight/PTM_RATIO), b2Vec2(worldWidth/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);

    
    [self schedule: @selector(tick:)];
    
}


-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	phyWorld->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = phyWorld->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
                PlayerHelper *ph = (PlayerHelper*)b->GetUserData();
                CCSprite *tankBody = ph.player;
            
                CGPoint point = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                float rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                tankBody.position = point;
                tankBody.rotation = rotation;
                
                CCSprite *turret = ph.turret;
                turret.position = point;
                tankBody.rotation = rotation;
                [self setViewpointCenter:point];
		}	
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	phyWorld->SetGravity( gravity );
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	phyWorld->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

-(void) dealloc{
    
    //Release box2d objs
    delete phyWorld;
    phyWorld = NULL;
    delete m_debugDraw;
    
    [enemyManager release];
    [playerHelper release];
    [super dealloc];
}

@end
