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

-(id) initWithScene:(GameScene *)aWorld{
	
	if ((self = [super init])) {
		
		self.currentActionIndex = -1;
		
		self.world = aWorld;
        self.collisionObjs = world.collisionObjs;
		
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
		[player setPosition:ccp(300,-10)];
        [player setAnchorPoint:ccp(0.5 ,0.5)];
		[playerSheet addChild:player z:1];
        
        self.turret = [CCSprite spriteWithSpriteFrameName:@"turret1.png"];
        [turret setAnchorPoint:ccp(0.5,0.5)];
        [turret setPosition:ccp(300,-10)];
        [playerSheet addChild:turret z:1 tag:TURRET_NODE];
		
	}
	return self;
}


-(void) moveToPosition:(CGPoint) position{    
    
    //if ([world collisionCheck:[self positionRect:position withSprite:player]] == NO) {
    //    [turret setPosition:position];
    //    [player setPosition:position];	
    //    [world setViewpointCenter:[self getCurrentPosition]];
    //}   
    
    CGRect playerRect = [self positionRect:position withSprite:player];
    if ([self collisionCheck:playerRect] == NO) {
        [turret setPosition:position];
        [player setPosition:position];	
        [world setViewpointCenter:[self getCurrentPosition]];
    }
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
