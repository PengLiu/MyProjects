//
//  PlayerHelper.m
//  Shooter
//
//  Created by Ammen on 11-3-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "PlayerHelper.h"
#import "GameScene.h"
#import "Constants.h"
#import "Bullet.h"

@interface PlayerHelper(PrivateMethod)

-(void) changeAction:(NSInteger) targetActionIndex;

-(CGRect) positionRect:(CGPoint)point withSprite:(CCSprite*)sprite;

-(void) addNewSprite:(CCSprite *)sprite;

-(void) initWeapon;

@end


@implementation PlayerHelper

@synthesize playerSheet;
@synthesize actionArray;
@synthesize turret;
@synthesize player;
@synthesize world;

@synthesize firePower;
@synthesize angle;
@synthesize currentActionIndex;

@synthesize tankBody;

-(id) initWithScene:(GameScene *)aWorld{
	
	if ((self = [super init])) {
		
        [aWorld addChild:self];
        
		self.currentActionIndex = -1;
		
		self.world = aWorld;
		
		//Load player png.
		CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"tank.png"];
		self.playerSheet = [CCSpriteBatchNode batchNodeWithTexture:playerTexture];
		[world addChild:playerSheet z:1 tag:PLAYER_BATCH_NODE];
		
		
		CCSpriteFrameCache* playerFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
		[playerFrameCache addSpriteFramesWithFile:@"tank.plist"];

		self.player = [CCSprite spriteWithSpriteFrameName:@"bodyu1.png"];
		[player setPosition:ccp(200,200)];
        [player setAnchorPoint:ccp(0.5 ,0.5)];
		[playerSheet addChild:player z:1];
        
        [self addNewSprite:player];
    
        self.turret = [CCSprite spriteWithSpriteFrameName:@"turret1.png"];
        [turret setAnchorPoint:ccp(0.5,0.5)];
        [turret setPosition:ccp(200,200)];
        [playerSheet addChild:turret z:1];
        
        [self initWeapon];
	}
	return self;
}

-(void) initWeapon{
    //Load from tank properties
    self.firePower = 10;
}

-(void) moveToDirection:(CGPoint)direction WithPower:(float)power{
    
    float nextx = player.position.x;
    float nexty = player.position.y;
    nextx += -direction.x * power;
    nexty += -direction.y * power;
    
    CGPoint pointOne = player.position;
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
			[player stopAction:[actionArray objectAtIndex:currentActionIndex]];
		}
		[player runAction:[actionArray objectAtIndex:targetActionIndex]];
		currentActionIndex = targetActionIndex;
	}
}

-(void) stopCurrentAction{
	if (currentActionIndex >= 0) {
		[player stopAction:[actionArray objectAtIndex:currentActionIndex]];
		switch (currentActionIndex) {
			case 0:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"1-1.png"]];
				break;
			case 1:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"2-1.png"]];
				break;
			case 2:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"3-1.png"]];
				break;
			case 3:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"4-1.png"]];
				break;
			case 4:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"5-1.png"]];
				break;
			case 5:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"6-1.png"]];
				break;
			case 6:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"7-1.png"]];
				break;
			case 7:
				[player setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"8-1.png"]];
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
    float bodyWidth = [player boundingBox].size.width /BODY_PTM_RATIO;
    float bodyHeight = [player boundingBox].size.height /BODY_PTM_RATIO;
    
    dynamicBox.SetAsBox(bodyWidth, bodyHeight);//These are mid points for our 1m box
	
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    tankBody->CreateFixture(&fixtureDef);
}

-(void) stopFire{
    [self unschedule:@selector(fire:)];
}

-(void) startFire{
    [self schedule: @selector(fire:) interval:0.3];
}

-(void) fire:(ccTime) dt{
    
    
    float ran= -angle * PI/180;
    
    float vx1 = cos(ran) * 35;
    float vy1 = sin(ran) * 35;
    
    CGPoint pointOne = ccp(turret.position.x + vx1, turret.position.y + vy1);
    
	float vx = cos(ran) * 100;
	float vy = sin(ran) * 100;
    CGPoint pointTwo = ccp(turret.position.x + vx, turret.position.y + vy);

    float fireAngle = atan2f(pointTwo.x - pointOne.x, pointTwo.y - pointOne.y);
    
    Bullet *bullet = [[Bullet alloc] initBullet:1 inPhyWorld:world.phyWorld inGameWorld:world atPosition:pointOne];
    [bullet fire:b2Vec2(sin(fireAngle) * firePower, cos(fireAngle) * firePower)];
}

-(void)onBulletMoveDone:(id)sender data:(CCSprite*)bullet
{
	[world removeChild:bullet cleanup:YES];
}

-(CGPoint) getCurrentPosition{
	return player.position;
}

-(void)draw{


}

@end
