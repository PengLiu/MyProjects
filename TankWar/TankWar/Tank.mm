//
//  PlayerHelper.m
//  Shooter
//
//  Created by Ammen on 11-3-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "Tank.h"
#import "GameScene.h"
#import "Bullet.h"

@interface Tank(PrivateMethod)

-(void) changeAction:(NSInteger) targetActionIndex;

-(CGRect) positionRect:(CGPoint)point withSprite:(CCSprite*)sprite;

-(void) addNewSprite:(CCSprite *)sprite;

-(void) initWeapon;

-(void) initTankAnimation;

-(void) aiControlSwitch:(BOOL) start;

@end


@implementation Tank

@synthesize playerSheet;
@synthesize actionArray;
@synthesize turretSprite;
@synthesize tankSprite;
@synthesize world;
@synthesize walkAnim;
@synthesize fireAnim;

@synthesize angle;
@synthesize currentActionIndex;

@synthesize tankBody;

@synthesize type;
@synthesize hp;
@synthesize ap;
@synthesize fireFrequency;
@synthesize firePower;
@synthesize defense;
@synthesize attack;
@synthesize movement;

-(id) initWithScene:(GameScene *)aWorld atPosition:(CGPoint) posision tankType:(TankType) t{
	
	if ((self = [super init])) {
		
        self.world = aWorld;
        
        [world addChild:self];
        
		self.currentActionIndex = -1;
        
        self.type = t;
       
        self.hp = 100;
        self.ap = 100;
        self.attack = 20;
        self.defense = 2;
        
        if (t == PlayerTank) {
            self.movement = 10;
            self.fireFrequency = 0.3;
            self.firePower = 10;
        }else{
            self.movement = 3;
            self.fireFrequency = 0.6;
            self.firePower = 5;
        }
        
        //Load player png.
        CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"tank.png"];
        self.playerSheet = [CCSpriteBatchNode batchNodeWithTexture:playerTexture];
        [world addChild:playerSheet z:1 tag:TANK_SPRITE_BATCH_NODE];
        
        
        CCSpriteFrameCache* playerFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
        [playerFrameCache addSpriteFramesWithFile:@"tank.plist"];
		
        if (type == PlayerTank) {
            self.tankSprite = [CCSprite spriteWithSpriteFrameName:@"bodyu1.png"];
            self.turretSprite = [CCSprite spriteWithSpriteFrameName:@"turret1.png"];                     
        }else{
            self.tankSprite = [CCSprite spriteWithSpriteFrameName:@"bodyu2.png"];
            self.turretSprite = [CCSprite spriteWithSpriteFrameName:@"turret2.png"];
        }
        
        [tankSprite setPosition:posision];
        [tankSprite setAnchorPoint:ccp(0.5 ,0.5)];
        [playerSheet addChild:tankSprite z:1];
        
        [self addNewSprite:tankSprite];
        
        [turretSprite setPosition:posision];
        [turretSprite setAnchorPoint:ccp(0.5,0.5)];
        [playerSheet addChild:turretSprite z:1];
        
//        //Test Sprite
//        CCTexture2D *testTexture = [[CCTextureCache sharedTextureCache] addImage:@"tank_a.png"];
//		CCSpriteBatchNode *testSpriteSheet = [CCSpriteBatchNode batchNodeWithTexture:testTexture];
//		[world addChild:testSpriteSheet z:1];
//
//        CCSpriteFrameCache* testFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
//		[testFrameCache addSpriteFramesWithFile:@"tank_a.plist"];
//        
//        CCSprite *testSprite = [CCSprite spriteWithSpriteFrameName:@"tank_a_1.png"];
//        [testSprite setAnchorPoint:ccp(0.5,0.5)];
//        [testSprite setPosition:ccp(300,300)];
//        [testSpriteSheet addChild:testSprite z:1];
//
//        [self initTankAnimation];
//        
//        [testSprite runAction:self.fireAnim];
//        
//        testSprite.flipY = YES;
        
        if (t == EnemyTank) {
            [self aiControlSwitch:YES];
        }
        
        
	}
	return self;
}

-(void) initTankAnimation{
    
    NSMutableArray *animFrames = [NSMutableArray array];
    
    //Load walk animation
    for (int j=1; j<=14; j++) {
        
        [animFrames addObject:
        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
        [NSString stringWithFormat:@"tank_a_%d.png", j]]];
    
        //Init walk animation
        CCAnimation *walk = [CCAnimation animationWithFrames:animFrames delay:0.2f];
        self.walkAnim = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walk restoreOriginalFrame:NO]];
        
    }
    
    //Init Fire Animation
    [animFrames removeAllObjects];
    
    //Load walk animation
    for (int j=15; j<=23; j++) {
        
        [animFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"tank_a_%d.png", j]]];
        
        //Init walk animation
        CCAnimation *fire = [CCAnimation animationWithFrames:animFrames delay:0.2f];
        self.fireAnim = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fire restoreOriginalFrame:NO]];
        
    }
    
}

-(void) moveToDirection:(CGPoint)direction WithPower:(float)power{
    
    float nextx = tankSprite.position.x;
    float nexty = tankSprite.position.y;
    
    nextx += -direction.x * power;
    nexty += -direction.y * power;
    
    CGPoint pointOne = tankSprite.position;
    CGPoint pointTwo = ccp(nextx,nexty);
    
    float tmpAngle = atan2f(pointOne.x - pointTwo.x, pointOne.y - pointTwo.y);
    
    float bodyAngle = -tankBody ->GetAngle();
    
    tankBody->SetTransform(tankBody->GetPosition(),-tmpAngle);    
    tankBody->ApplyForce( b2Vec2(sin(bodyAngle) * 50, cos(bodyAngle) * 50), tankBody->GetPosition());
    
    //TODO: make turret as a part of tank body
//    [turret setPosition:player.position];
    
}


-(CGRect) positionRect:(CGPoint)point withSprite:(CCSprite*)sprite{
    
	CGSize contentSize = [sprite contentSize];
	CGRect result = CGRectOffset(CGRectMake(0, 0, contentSize.width, contentSize.height), point.x-contentSize.width/2, point.y-contentSize.height/2);
	return result;
}


-(void) changeAction:(NSInteger)targetActionIndex{
	
	if (currentActionIndex != targetActionIndex) {
		if (currentActionIndex >= 0) {
			[tankSprite stopAction:[actionArray objectAtIndex:currentActionIndex]];
		}
		[tankSprite runAction:[actionArray objectAtIndex:targetActionIndex]];
		currentActionIndex = targetActionIndex;
	}
}

-(void) stopCurrentAction{
	if (currentActionIndex >= 0) {
		[tankSprite stopAction:[actionArray objectAtIndex:currentActionIndex]];
		switch (currentActionIndex) {
			case 0:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"1-1.png"]];
				break;
			case 1:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"2-1.png"]];
				break;
			case 2:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"3-1.png"]];
				break;
			case 3:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"4-1.png"]];
				break;
			case 4:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"5-1.png"]];
				break;
			case 5:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"6-1.png"]];
				break;
			case 6:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"7-1.png"]];
				break;
			case 7:
				[tankSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"8-1.png"]];
				break;
		}
		currentActionIndex = -1;
	}
}

-(void) addNewSprite:(CCSprite *)sprite{
	
    // Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    
    bodyDef.type = b2_dynamicBody;
    //bodyDef.allowSleep = true;
    bodyDef.linearDamping = BETTER_LINE_DAMPING;
    bodyDef.angularDamping = BETTER_ANGULAR_DAMPING;
    bodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    bodyDef.userData = self;
    
    self.tankBody = world.phyWorld ->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;
    
    // /2 because for body size .5f is 1m
    float bodyWidth = [tankSprite boundingBox].size.width /BODY_PTM_RATIO;
    float bodyHeight = [tankSprite boundingBox].size.height /BODY_PTM_RATIO;
    
    dynamicBox.SetAsBox(bodyWidth, bodyHeight);//These are mid points for our 1m box
	
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    tankBody->CreateFixture(&fixtureDef);
}

-(void) injuredWithBullet:(Bullet *)bullet{
    self.hp -= bullet.attack;
}

-(void) stopFire{
    [self unschedule:@selector(fire:)];
}

-(void) startFire{
    [self schedule: @selector(fire:) interval:fireFrequency];
}

-(void) fire:(ccTime) dt{
    
    float ran= -angle * PI/180;
    
    float vx1 = cos(ran) * 35;
    float vy1 = sin(ran) * 35;
    
    CGPoint pointOne = ccp(turretSprite.position.x + vx1, turretSprite.position.y + vy1);
    
	float vx = cos(ran) * 100;
	float vy = sin(ran) * 100;
    CGPoint pointTwo = ccp(turretSprite.position.x + vx, turretSprite.position.y + vy);

    float fireAngle = atan2f(pointTwo.x - pointOne.x, pointTwo.y - pointOne.y);
    
    Bullet *bullet = [[Bullet alloc] initBullet:1 inPhyWorld:world.phyWorld inGameWorld:world atPosition:pointOne];
    bullet.attack = attack;
    [bullet fire:b2Vec2(sin(fireAngle) * firePower, cos(fireAngle) * firePower)];
}

-(void)onBulletMoveDone:(id)sender data:(CCSprite*)bullet
{
	[world removeChild:bullet cleanup:YES];
}

-(CGPoint) getCurrentPosition{
	return tankSprite.position;
}

-(void) aiControlSwitch:(BOOL) start{
    if (start) {
        [self schedule:@selector(go:) interval:0.08];
        [self startFire];
    }else{
        [self unschedule:@selector(go:)];
    }
}

-(void) go:(ccTime) dt{
    
    //Player tank position
    CGPoint playerPosition = [world.tank getCurrentPosition];
    CGPoint selfPosition = tankSprite.position;
    
    float moveAngle = atan2f(playerPosition.x - selfPosition.x, playerPosition.y - selfPosition.y);
    tankBody->SetTransform(tankBody->GetPosition(),-moveAngle);   
    
    b2Vec2 force = b2Vec2(sin(moveAngle) * movement, cos(moveAngle) * movement);
    tankBody -> ApplyLinearImpulse(force, tankBody->GetPosition());
    
    float turrentRogation = moveAngle * 180 / PI;
    
    turretSprite.rotation = turrentRogation;
    self.angle = turrentRogation - 90;
}


-(void) destory{
    
    CCParticleSun* explosion = [CCParticleSun node];
    explosion.positionType = kCCPositionTypeRelative;
    explosion.autoRemoveOnFinish = YES;
    explosion.startSize = 10;
    explosion.endSize = 50;
    explosion.duration = 1;
   // explosion.speed = 3.0f;
    explosion.anchorPoint = ccp(.5,.5);
    explosion.position = tankSprite.position;
    //explosion.texture = [tankSprite texture];
    [world addChild: explosion z: self.zOrder+1];
    
    //Remove Sprite
    [playerSheet removeChild:tankSprite cleanup:YES];
    [playerSheet removeChild:turretSprite cleanup:YES];
    //Remove box2d body
    world.phyWorld ->DestroyBody(tankBody);
    
    [world removeChild:self cleanup:YES];
}

-(void)draw{
    
//    if(type == EnemyTank) {
//        glColor4ub(255, 0, 0, 100); 
//        glLineWidth(3);
//        CGPoint s = ccp(tankSprite.position.x - 10, tankSprite.position.y + 30);
//        CGPoint e = ccp(tankSprite.position.x + 10, tankSprite.position.y + 30);
//        ccDrawLine(s,e);
//    }
}

-(void) dealloc{
    CCLOG(@"Tank dealloc");
    [super dealloc];
}

-(NSString*)description{
    NSString* str = [NSString stringWithFormat:@"Tank:%d position:x:%f,y%f",tankId,tankSprite.position.x,tankSprite.position.y];
    return str;
}

@end
