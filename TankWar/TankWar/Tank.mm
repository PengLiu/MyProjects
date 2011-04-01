//
//  PlayerHelper.m
//  Shooter
//
//  Created by Ammen on 11-3-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RotaionUtil.h"
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

@synthesize type;
@synthesize moveType;

@synthesize angle;
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
       
        if (t == PlayerTank) {
            self.hp = 1000;
            self.ap = 100;
            self.attack = 20;
            self.defense = 2;
            self.movement = 50;
            self.fireFrequency = 0.6;
            self.firePower = 10;
        }else{
            self.hp = 100;
            self.ap = 100;
            self.attack = 20;
            self.defense = 2;
            self.movement = 60;
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

-(void) moveTo:(float)a{
    
    CGPoint startPoint = turretSprite.position;
    CGPoint targetPoint = [RotaionUtil shootTarget:startPoint withJoyStickAngle:a];
    
    float moveAngle = [RotaionUtil angleBetween:startPoint endPoint:targetPoint];

    float bodyAngle = -tankBody ->GetAngle();
    tankBody->SetTransform(tankBody->GetPosition(),-moveAngle);    
    
    b2Vec2 vect = [RotaionUtil phyPower:bodyAngle withRatio:movement];
    
    tankBody->ApplyForce(vect, tankBody->GetPosition());
    
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
    
    CGPoint startPoint = turretSprite.position;
    
    Bullet *bullet = [[Bullet alloc] initBullet:1 inPhyWorld:world.phyWorld inGameWorld:world atPosition:startPoint sender:type];
    bullet.attack = attack;
    
    
    float fireAngle;
    float bulletRogation;
    b2Vec2 vect;
    
    if (type == PlayerTank) {
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"fire.mp3"];
        
        CGPoint targetPoint = [RotaionUtil shootTarget:startPoint withJoyStickAngle:angle];
        fireAngle = [RotaionUtil angleBetween:startPoint endPoint:targetPoint];
        
        bulletRogation = [RotaionUtil joyStickyToSpriteRotation:angle offSetAngle:180];
        vect = [RotaionUtil phyPower:fireAngle withRatio:firePower];
        
    }else if(type == EnemyTank){
        
        CGPoint targetPoint = [world.tank getCurrentPosition];
        fireAngle = [RotaionUtil angleBetween:startPoint endPoint:targetPoint];
        bulletRogation = [RotaionUtil angleTo360:fireAngle withOffset:90];
        vect = [RotaionUtil phyPower:fireAngle withRatio:firePower];
    }
    
    [bullet fire:vect fireAngle:bulletRogation];
}



-(void) go:(ccTime) dt{
    
    //Player tank position
    CGPoint playerPosition = [world.tank getCurrentPosition];
    CGPoint selfPosition = tankSprite.position;
    
    float moveAngle = atan2f(playerPosition.x - selfPosition.x, playerPosition.y - selfPosition.y);
    tankBody->SetTransform(tankBody->GetPosition(),-moveAngle);   
    
    
    //固定位置
    //if (moveType == FixedPosition) {
        
   // }else if(moveType == ChasePlayers){
     b2Vec2 force = [RotaionUtil phyPower:moveAngle withRatio:movement];
    
      //  b2Vec2 force = b2Vec2(sin(moveAngle) * movement, cos(moveAngle) * movement);
        tankBody -> ApplyLinearImpulse(force, tankBody->GetPosition());
   // }else if(moveType == RandomMov){
        
   // }
       
    //转向
    turretSprite.rotation = [RotaionUtil angleTo360:moveAngle withOffset:0];
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
