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

@synthesize phyWorld;
@synthesize bulletBody;

@synthesize attack;

-(id) initBullet:(NSInteger)bulletType inPhyWorld:(b2World *)pw inGameWorld:(GameScene *)gw atPosition:(CGPoint)p{
    
    if ((self = [super init])) {
        
        self.gameWorld = gw;
        self.phyWorld = pw;
        
        [self initBulletSprite:1 atPosition:p];
    }
    
    return self;
}

//Public Methods



-(void) fire:(b2Vec2)force{
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
    [gameWorld removeChild:bulletSprite cleanup:YES];
    //Remove box2d body
    phyWorld ->DestroyBody(bulletBody);
}

//Private Methods

-(void) initBulletSprite:(NSInteger) bulletType atPosition:(CGPoint)p{
    
    //TODO: Create SpriteBatchNode for all bullet sprites.
    self.bulletSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bullet%d.png",bulletType]];
    bulletSprite.position = p;
    [gameWorld addChild:self.bulletSprite z:1];
    
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
