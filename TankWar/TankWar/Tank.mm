//
//  PlayerHelper.m
//  Shooter
//
//  Created by Ammen on 11-3-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "SimpleAudioEngine.h"
#import "Tank.h"
#import "GameScene.h"
#import "Bullet.h"

@interface Tank(PrivateMethod)

-(void) changeAction:(NSInteger) targetActionIndex;

-(void) addNewSprite:(CCSprite *)sprite;

-(void) initWeapon;

-(void) aiControlSwitch:(BOOL) start;

@end


@implementation Tank

@synthesize world;

@synthesize playerSheet;

@synthesize turretSprite;
@synthesize tankSprite;

@synthesize tankBody;

@synthesize angle;
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
        
        self.type = t;
       
        self.hp = 100;
        self.ap = 100;
        self.attack = 20;
        self.defense = 2;
        
        if (t == PlayerTank) {
            self.movement = 10;
            self.fireFrequency = 0.6;
            self.firePower = 10;
        }else{
            self.movement = 3;
            self.fireFrequency = 1;
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
        
        if (t == EnemyTank) {
            [self aiControlSwitch:YES];
        }
        
        
	}
	return self;
}

//Public methods

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

-(CGPoint) getCurrentPosition{
	return tankSprite.position;
}

//Private Methods

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

-(void) aiControlSwitch:(BOOL) start{
    if (start) {
        [self schedule:@selector(go:) interval:0.08];
        [self startFire];
    }else{
        [self unschedule:@selector(go:)];
    }
}




//Schedule Methods

-(void) fire:(ccTime) dt{
    
    float ran= -angle * PI/180;
    
    float vx1 = cos(ran) * 50;
    float vy1 = sin(ran) * 50;
    
    CGPoint pointOne = ccp(turretSprite.position.x + vx1, turretSprite.position.y + vy1);
    
	float vx = cos(ran) * 100;
	float vy = sin(ran) * 100;
    CGPoint pointTwo = ccp(turretSprite.position.x + vx, turretSprite.position.y + vy);
    
    float fireAngle = atan2f(pointTwo.x - pointOne.x, pointTwo.y - pointOne.y);
    
    Bullet *bullet = [[Bullet alloc] initBullet:1 inPhyWorld:world.phyWorld inGameWorld:world atPosition:pointOne sender:type];
    bullet.attack = attack;
    
    float bulletRogation = fireAngle * 180 / PI;
    
    [bullet fire:b2Vec2(sin(fireAngle) * firePower, cos(fireAngle) * firePower) fireAngle:bulletRogation + 90];
    
    if (type == PlayerTank) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"fire.mp3"];
    }
}



-(void) go:(ccTime) dt{
    
    //Player tank position
    CGPoint playerPosition = [world.tank getCurrentPosition];
    CGPoint selfPosition = tankSprite.position;
    
    float moveAngle = atan2f(playerPosition.x - selfPosition.x, playerPosition.y - selfPosition.y);
    tankBody->SetTransform(tankBody->GetPosition(),-moveAngle);   
    
    b2Vec2 force = b2Vec2(sin(moveAngle) * movement, cos(moveAngle) * movement);
    // tankBody -> ApplyLinearImpulse(force, tankBody->GetPosition());
    
    float turrentRogation = moveAngle * 180 / PI;
    
    turretSprite.rotation = turrentRogation;
    self.angle = turrentRogation - 90;
}


-(void)draw{

}

-(void) dealloc{
    CCLOG(@"Tank dealloc");
    [super dealloc];
}

-(NSString*)description{
    return [NSString stringWithFormat:@"Tank: position:x:%f,y%f",tankSprite.position.x,tankSprite.position.y];
}

@end
