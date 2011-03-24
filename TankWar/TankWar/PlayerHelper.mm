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

@interface PlayerHelper(PrivateMethod)

-(void) changeAction:(NSInteger) targetActionIndex;

-(CGRect) positionRect:(CGPoint)point withSprite:(CCSprite*)sprite;

-(BOOL) collisionCheck:(CGRect) targetRect;

-(void) addNewSprite:(CCSprite *)sprite;

@end


@implementation PlayerHelper

@synthesize playerSheet;
@synthesize actionArray;
@synthesize turret;
@synthesize player;
@synthesize world;
@synthesize collisionObjs;

@synthesize angle;
@synthesize currentActionIndex;

@synthesize tankBody;

-(id) initWithScene:(GameScene *)aWorld{
	
	if ((self = [super init])) {
		
		self.currentActionIndex = -1;
		
		self.world = aWorld;
		
		//Load player png.
		CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"tank.png"];
		self.playerSheet = [CCSpriteBatchNode batchNodeWithTexture:playerTexture];
		[world addChild:playerSheet z:1 tag:PLAYER_BATCH_NODE];
		
		
		CCSpriteFrameCache* playerFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
		[playerFrameCache addSpriteFramesWithFile:@"tank.plist"];
		
		//Init walk action array
//		self.actionArray = [NSMutableArray array];
//		
//		for (int j=1; j<=8; j++) {
//			
//			//Init Player frames
//			NSMutableArray *walkAnimFrames = [NSMutableArray array];
//			
//			for(int i = 2; i <=5 ; ++i) {
//				[walkAnimFrames addObject:
//				 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
//				  [NSString stringWithFormat:@"%d-%d.png", j, i]]];
//			}
//			
//			//Init walk animation
//			CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.15f];
//			[self.actionArray addObject:
//				[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]]];
//			
//		}

		self.player = [CCSprite spriteWithSpriteFrameName:@"bodyu1.png"];
		[player setPosition:ccp(200,200)];
            [player setAnchorPoint:ccp(0.5 ,0.5)];
		[playerSheet addChild:player z:1];
        
            [self addNewSprite:player];
        
            self.turret = [CCSprite spriteWithSpriteFrameName:@"turret1.png"];
            [turret setAnchorPoint:ccp(0.5,0.5)];
            [turret setPosition:ccp(200,200)];
            [playerSheet addChild:turret z:1 tag:TURRET_NODE];
        
	}
	return self;
}


-(void) moveWithAngle:(float)an Direction:(CGPoint)direction Power:(float)power{
    
    
    float nextx = player.position.x;
    float nexty = player.position.y;
    nextx += -direction.x * power;
    nexty += -direction.y * power;
    
    CGPoint pointOne = player.position;
    CGPoint pointTwo = ccp(nextx,nexty);
    
    float tmpAngle = atan2f(pointOne.x - pointTwo.x, pointOne.y - pointTwo.y);
    
    float bodyAngle = -tankBody ->GetAngle();
    
    tankBody->SetTransform(tankBody->GetPosition(),-tmpAngle);    
    tankBody->ApplyForce( b2Vec2(sin(bodyAngle) * 4, cos(bodyAngle) * 4), tankBody->GetPosition());
    
    //TODO: make turret as a part of tank body
//    [turret setPosition:player.position];
    
}

-(BOOL) collisionCheck:(CGRect) targetRect{
    
    for (NSValue *value in self.collisionObjs) {
        CGRect rect = [value CGRectValue];
        if (!CGRectIsNull(CGRectIntersection(rect, targetRect))) {
            CCLOG(@"Collision");
            return YES;
        }
    }
    return NO;
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
    bodyDef.linearDamping = 1;
    bodyDef.angularDamping = 1;
    
    bodyDef.position.Set(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
    bodyDef.userData = self;
    self.tankBody = world.phyWorld ->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;

    
    dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    tankBody->CreateFixture(&fixtureDef);
}


-(void) fire{
    
    CCSprite *bullet=[CCSprite spriteWithFile:@"bullet.png"];
	
    bullet.position = turret.position;
	
    float ran= - angle * 3.14159/180;
    
    float vx1 = cos(ran) * 40;
    float vy1 = sin(ran) * 40;
    
    bullet.position = ccp(turret.position.x + vx1, turret.position.y + vy1);
    
	float vx = cos(ran) * 400;
	float vy = sin(ran) * 400;
	
	id moveact=[CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:.8 
                position:ccp(bullet.position.x+vx,bullet.position.y+vy)] rate:1];
    
	id movedone=[CCCallFuncND actionWithTarget:self selector:@selector(onBulletMoveDone:data:) data:bullet];
    
	[bullet runAction:[CCSequence actions:moveact,movedone,nil]];
	
    [world addChild:bullet z:1];
    
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
