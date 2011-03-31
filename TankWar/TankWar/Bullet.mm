//
//  Bullet.m
//  TankWar
//
//  Created by Ammen on 11-3-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "Bullet.h"
#import "Box2D.h"

@class GameScene;

@interface Bullet(PrivateMethod)

-(void) initBulletSprite:(NSInteger) bulletType atPosition:(CGPoint)p;

@end


@implementation Bullet

@synthesize needToBeExploded;
@synthesize needToBeDeleted;
@synthesize bulletSprite;
@synthesize gameWorld;

@synthesize fireAction;

@synthesize senderType;

@synthesize phyWorld;
@synthesize bulletBody;

@synthesize attack;

-(id) initBullet:(NSInteger)bt inPhyWorld:(b2World *)pw inGameWorld:(GameScene *)gw atPosition:(CGPoint)p sender:(TankType)tt{
    
    if ((self = [super init])) {
        
        senderType = tt;
        self.gameWorld = gw;
        self.phyWorld = pw;
        
        [self initBulletSprite:1 atPosition:p];
    }
    
    return self;
}

//Public Methods



-(void) fire:(b2Vec2)force fireAngle:(float)angle{
    bulletSprite.rotation = angle;
     bulletBody -> ApplyLinearImpulse(force, bulletBody->GetPosition());
}

-(void) explod{
    CCParticleSun* explosion = [CCParticleSun node];
    explosion.positionType = kCCPositionTypeRelative;
    explosion.autoRemoveOnFinish = YES;
    explosion.startSize = 5;
    explosion.endSize = 10;
    explosion.duration = .8;
    explosion.anchorPoint = ccp(.5,.5);
    explosion.position = bulletSprite.position;
    [gameWorld addChild: explosion];
    [self destory];
}

-(void) destory{
    //Remove Sprite
   [bulletSprite stopAction:fireAction];
    
    CCSpriteBatchNode *bulletBatchNode = (CCSpriteBatchNode *)[gameWorld getChildByTag:BULLET_SPRITE_BATCH_NODE];
    [bulletBatchNode removeChild:bulletSprite cleanup:YES];
    //Remove box2d body
    phyWorld ->DestroyBody(bulletBody);
}

//Private Methods

-(void) initBulletSprite:(NSInteger) bulletType atPosition:(CGPoint)p{
    
    //TODO: Create SpriteBatchNode for all bullet sprites.
    
    self.bulletSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d-1.png", bulletType]];
    bulletSprite.position = p;
    
    CCSpriteBatchNode *bulletBatchNode = (CCSpriteBatchNode *)[gameWorld getChildByTag:BULLET_SPRITE_BATCH_NODE];
    [bulletBatchNode addChild:bulletSprite z:1];
    
    //Init bullet frames
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    
    for(int i = 1; i <=2 ; ++i) {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"%d-%d.png", bulletType, i]]];
    }
    
    //Init bullet animation
    CCAnimation *fireAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:.05];
    self.fireAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fireAnim restoreOriginalFrame:NO]];
    
    [bulletSprite runAction:fireAction];
    
    b2BodyDef bodyDef;
    
    bodyDef.type = b2_dynamicBody;
    bodyDef.userData = self;
    bodyDef.position.Set(bulletSprite.position.x/PTM_RATIO, bulletSprite.position.y/PTM_RATIO);
    
    self.bulletBody = phyWorld ->CreateBody(&bodyDef);
    bulletBody->SetBullet(true);
    
    // Define another box shape for our dynamic body.
    b2CircleShape bulletBox;
    bulletBox.m_radius = [bulletSprite boundingBox].size.width/2/BODY_PTM_RATIO;
	
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    
    fixtureDef.isSensor = true;
    fixtureDef.shape = &bulletBox;	
    bulletBody->CreateFixture(&fixtureDef);
    
}

-(void) dealloc{
    CCLOG(@"Bullet deallco");
    [super dealloc];
}


@end
