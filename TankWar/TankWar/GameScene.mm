//
//  GameScene.m
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContactListener.h"

#import "Constants.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "CCJoyStick.h"
#import "Tank.h"
#import "JoyStickLayer.h"
#import "EnemyManager.h"
#import "SimpleAudioEngine.h"
#import "Bullet.h"
#import "GameOverScene.h"

@interface GameScene(PrivateMethod)

-(void) initWorld;

-(void) initBodyTiles;
-(void) addRectAt:(CGPoint)point withSize:(CGPoint)size dynamic:(bool)d rotation:(float)r 
         friction:(float)f density:(float)d restitution:(float)re boxId:(float)id;

-(void) initPlayer;

-(void) initEnemy;

-(void) playBGM;


//Util methods

-(BOOL) isPointInScreen:(CGPoint)point;
-(b2Vec2) toMeters:(CGPoint)point;
-(CGPoint) toPixels:(b2Vec2)vec;
-(CGPoint)calculateActualPositioin:(CGPoint)position;


@end


@implementation GameScene

@synthesize worldMap;
@synthesize tank;
@synthesize enemyManager;

@synthesize phyWorld;
@synthesize contactListener;

+(CCScene *) scene{
    
    CCScene *scene = [CCScene node];
    
    GameScene *layer = [GameScene node];
    [scene addChild: layer];
    
    JoyStickLayer *joyStickLayer = [JoyStickLayer node];
    [joyStickLayer setGameScene:layer]; 
    [scene addChild:joyStickLayer]; 
    return scene;

}
//+(CCScene *) sceneWithMap:(NSString *)worldMapName{
//	
//	// 'scene' is an autorelease object.
//	CCScene *scene = [CCScene node];
//	
//	// 'layer' is an autorelease object.
//	GameScene *layer = [[GameScene alloc] initInWorld:worldMapName];
//	// add layer as a child to scene
//	[scene addChild: layer];
//    [layer release];
//    
//    JoyStickLayer *joyStickLayer = [JoyStickLayer node];
//    [joyStickLayer setGameScene:layer]; 
//    
//    [scene addChild:joyStickLayer]; 
//	
//	// return the scene
//	return scene;
//	
//	
//}

//-(id) initInWorld:(NSString *)wm{
-(id) init{	
    
	if( (self=[super init])) {

        worldMapName = @"desert_world";
        
        //Init world map
        [self initWorld];
        [self initBodyTiles];
        //Init player
        [self initPlayer];
        //Init Enemy
        [self initEnemy];
        //Play background music
        [self playBGM];
    }
    
    return self;
}



//Private methods

-(void) initWorld{
    
    //Load world map
    worldMap = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"%@.tmx",worldMapName]];
    [worldMap setAnchorPoint:ccp(0,0)];
    [self addChild:worldMap z:-1];
    
    //Init box2d world
    b2Vec2 gravity;
    gravity.Set(0.0f, 0.0f);
    
    // Do we want to let bodies sleep?
    // This will speed up the physics simulation
    bool doSleep = true;
    
    // Construct a world object, which will hold and simulate the rigid bodies.
    phyWorld = new b2World(gravity, doSleep);
    
    contactListener = new ContactListener();
    
    phyWorld ->SetContactListener(contactListener);
    
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


//Create staic body from tiled map 
-(void) initBodyTiles{
    
    //searching for object layer called "CollisionObjs"
    CCTMXObjectGroup *objects = [worldMap objectGroupNamed:@"CollisionObjs"];
    NSMutableDictionary * objPoint;
    int x ;
    int y ;
    int w ;
    int h ;
    
    for (objPoint in [objects objects]) {
        x = [[objPoint valueForKey:@"x"] intValue];
        y = [[objPoint valueForKey:@"y"] intValue];
        w = [[objPoint valueForKey:@"width"] intValue];
        h = [[objPoint valueForKey:@"height"] intValue];
        CGPoint point=ccp(x+w/2,y+h/2);
        CGPoint size=ccp(w,h);
        //this method builds a box2D rectangle and adds it to the box2D world
        [self addRectAt:point withSize:size dynamic:false rotation:0 friction:.3 density:0 restitution:0 boxId:-1];
        
    }
}

-(void) addRectAt:(CGPoint)point withSize:(CGPoint)size dynamic:(bool)dy rotation:(float)r 
         friction:(float)f density:(float)d restitution:(float)re boxId:(float)id{
    
    
    b2BodyDef bodyDef;
    
    if(dy){
        bodyDef.type = b2_dynamicBody;
    }
    
    bodyDef.position = [self toMeters:point];
    
    b2Body *body = phyWorld ->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape staticBox;
    staticBox.SetAsBox(size.x/BODY_PTM_RATIO, size.y/BODY_PTM_RATIO);//These are mid points for our 1m box
	
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &staticBox;	
    fixtureDef.density = d;
    fixtureDef.friction = r;
    fixtureDef.restitution = re;
    //fixtureDef.rotation = r;
    body->CreateFixture(&fixtureDef);
    
}

//Init player tank
-(void) initPlayer{
    self.tank = [[Tank alloc] initWithScene:self atPosition:ccp(200,200) tankType:PlayerTank];
}

//Init enemy tank
-(void) initEnemy{
    enemyManager = [[EnemyManager alloc] initWithScene:self];
    [enemyManager spawnEnemy:1 atPosition:ccp(300,300)];
}

//Player background music
-(void) playBGM{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gamewaiting.mp3"];
}

//Util methods
-(BOOL) isPointInScreen:(CGPoint)point{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint screenCenter = [self calculateActualPositioin:[tank getCurrentPosition]];
    
    if (point.x > (screenCenter.x + winSize.width/2) || point.x < (screenCenter.x - winSize.width/2)) {
        return NO;
    }
    
    if (point.y > (screenCenter.y + winSize.height/2) || point.y < (screenCenter.y - winSize.height/2)) {
        return NO;
    }
    
    return YES;
}

-(b2Vec2) toMeters:(CGPoint)point {
    return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}
-(CGPoint) toPixels:(b2Vec2)vec {
    return ccpMult(CGPointMake(vec.x, vec.y), PTM_RATIO);
}

-(CGPoint)calculateActualPositioin:(CGPoint)position{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    
    x = MIN(x, (self.worldMap.mapSize.width * self.worldMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (self.worldMap.mapSize.height * self.worldMap.tileSize.height) 
            - winSize.height/2);
    
    return ccp(x,y);
}




//public methods


-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint actualPosition = [self calculateActualPositioin:position];
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}


-(void) destory{
    [enemyManager destoryAll];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[CCDirector sharedDirector]replaceScene:[GameOverScene node]];
}



//Selector and schedule methods

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
            
            if(b->IsBullet()){
                
                Bullet *bullet = (Bullet*)b->GetUserData();
                
                if (bullet.needToBeDeleted) {
                    [bullet destory];
                    [bullet release];
                }else if(bullet.needToBeExploded){
                    [bullet explod];
                    [bullet release];
                }else{
                    CCSprite *bulletSprite = bullet.bulletSprite;
                    CGPoint point = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                    
                    if ([self isPointInScreen:point]) {
                        bulletSprite.position = point;
                    }else{
                        //Clean sprite
                        bullet.needToBeDeleted = YES;
                    } 
                }
                
            }else{
                //Synchronize the AtlasSprites position and rotation with the corresponding body
                Tank *ph = (Tank*)b->GetUserData();
                
                if (ph.hp <= 0) {
                    if (ph.type == PlayerTank) {
                        [self destory];
                    }else{
                        [enemyManager destoryTank:ph];
                    }
                    
                }else{
            
                    CCSprite *tankBody = ph.tankSprite;
                    CGPoint point = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                    float rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                    tankBody.position = point;
                    tankBody.rotation = rotation;
                
                    CCSprite *turret = ph.turretSprite;
                    turret.position = point;
                    tankBody.rotation = rotation;
                    [self setViewpointCenter:point];
                }
            }
		}	
	}
}













-(void) dealloc{
    
    CCLOG(@"Game Scene Dealloc");
    
    //Release box2d objs
    delete contactListener;
    
    delete phyWorld;
    phyWorld = NULL;
    delete m_debugDraw;
    
    [enemyManager release];
    [tank release];
    
    [super dealloc];
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


@end
