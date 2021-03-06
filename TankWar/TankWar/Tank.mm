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

-(void) initAnimations;

@end


@implementation Tank

@synthesize world;

@synthesize playerSheet;
@synthesize tankdownSheet;

@synthesize turretSprite;
@synthesize tankSprite;
@synthesize explosionSprite;

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

@synthesize explosionEffect;
@synthesize fireEffec;

-(id) initEnemyTankWithScene:(GameScene *)aWorld atPosition:(CGPoint) position aiMoveType:(AIMoveType) aiMoveType{
    
    if ((self = [super init])) {
        
        self.moveType = aiMoveType;
        self.type = EnemyTank;
        self.world = aWorld;
        [world addChild:self];
        
        //Init properties
        self.hp = 100;
        self.ap = 100;
        self.attack = 20;
        self.defense = 2;
        self.movement = 2.5;
        self.fireFrequency = 1;
        self.firePower = 5;
        
        [self aiControlSwitch:YES];
        
        
        //Load player png.
        CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"tank.png"];
        self.playerSheet = [CCSpriteBatchNode batchNodeWithTexture:playerTexture];
        [world addChild:playerSheet z:1 tag:TANK_SPRITE_BATCH_NODE];
        
        
        CCSpriteFrameCache* playerFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
        [playerFrameCache addSpriteFramesWithFile:@"tank.plist"];
		
        self.tankSprite = [CCSprite spriteWithSpriteFrameName:@"tankb.png"];
        self.turretSprite = [CCSprite spriteWithSpriteFrameName:@"turretb_1_1.png"];
        
        [tankSprite setPosition:position];
        [tankSprite setAnchorPoint:ccp(0.5 ,0.5)];
        [playerSheet addChild:tankSprite z:1];
        
        [self addNewSprite:tankSprite];
        
        [turretSprite setPosition:position];
        [turretSprite setAnchorPoint:ccp(0.5,0.2)];
        [playerSheet addChild:turretSprite z:1];
        
        [self initAnimations];
        
    }
    return self;
}

-(id) initPlayerTankWithScene:(GameScene *)aWorld atPosition:(CGPoint) position{
	
	if ((self = [super init])) {
		
        self.type = PlayerTank;
        self.world = aWorld;
        [world addChild:self];
        
        //Init properties
        self.hp = 1000;
        self.ap = 100;
        self.attack = 20;
        self.defense = 2;
        self.movement = 50;
        self.fireFrequency = 0.6;
        self.firePower = 10;
        
        //Load player png.
        CCTexture2D *playerTexture = [[CCTextureCache sharedTextureCache] addImage:@"tank.png"];
        self.playerSheet = [CCSpriteBatchNode batchNodeWithTexture:playerTexture];
        [world addChild:playerSheet z:1 tag:TANK_SPRITE_BATCH_NODE];
        
        
        CCSpriteFrameCache* playerFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
        [playerFrameCache addSpriteFramesWithFile:@"tank.plist"];
		
        self.tankSprite = [CCSprite spriteWithSpriteFrameName:@"tanka.png"];
        self.turretSprite = [CCSprite spriteWithSpriteFrameName:@"turreta_1_1.png"];                     

        
        [tankSprite setPosition:position];
        [tankSprite setAnchorPoint:ccp(0.5 ,0.5)];
        [playerSheet addChild:tankSprite z:1];
        
        [self addNewSprite:tankSprite];
        
        [turretSprite setPosition:position];
        [turretSprite setAnchorPoint:ccp(0.5,0.2)];
        [playerSheet addChild:turretSprite z:1];
        
        [self initAnimations];
        
        
	}
	return self;
}

//Public methods


-(void) destory{
    
    //Stop fire event
    [self unschedule:@selector(fire:)];
    
    //Remove Sprite
    [playerSheet removeChild:tankSprite cleanup:YES];
    [playerSheet removeChild:turretSprite cleanup:YES];
    //Remove box2d body
    world.phyWorld ->DestroyBody(tankBody);
    
    [tankdownSheet addChild:explosionSprite z:1];
    [explosionSprite setPosition:tankSprite.position];
    [explosionSprite runAction:explosionEffect];
    
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
    float damage = bullet.attack;
    self.hp -= damage;
    //TODO:增加暴击计算

    CCLabelBMFont *damageStr = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d",(int)damage] fntFile:@"feedbackFont.fnt"];
    [world addChild:damageStr z:2];
    [damageStr setPosition:tankSprite.position];
    [damageStr setColor:ccRED];
    
    //伤害数字动画
    id scale = [CCScaleTo actionWithDuration:.3 scale:1.5];
    id fadeout = [CCFadeOut actionWithDuration:.3];
    id removeSprite = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
    
    [damageStr runAction:[CCSequence actions: scale, fadeout, removeSprite, nil]];
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

-(void) initAnimations{
    
    CCTexture2D *tankdownTexture = [[CCTextureCache sharedTextureCache] addImage:@"tankdown_a.png"];
    self.tankdownSheet = [CCSpriteBatchNode batchNodeWithTexture:tankdownTexture];
    [world addChild:tankdownSheet z:1 tag:TANK_ANIMATION_BATCH_NODE];
    
    
    CCSpriteFrameCache* tankdownFrameCache = [CCSpriteFrameCache sharedSpriteFrameCache]; 
    [tankdownFrameCache addSpriteFramesWithFile:@"tankdown_a.plist"];
    
    int count = 15;
    NSMutableArray *tankdownAnimFrames = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 1; i <=count ; ++i) {
        [tankdownAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"tankdown_a_%d.png", i]]];
    }
    
    //爆炸动画
    CCAnimation *tankdownAnim = [CCAnimation animationWithFrames:tankdownAnimFrames delay:.1];
    self.explosionEffect = [CCSequence actions: [CCAnimate actionWithAnimation:tankdownAnim restoreOriginalFrame:NO], 
                            [CCCallFunc actionWithTarget:self selector:@selector(releaseResource)], nil];
    
    self.explosionSprite = [CCSprite spriteWithSpriteFrameName:@"tankdown_a_1.png"];
    
    //射击动画
    count = 2;
    [tankdownAnimFrames removeAllObjects];
    for(int i = 1; i <=count ; ++i) {
        if (type == PlayerTank) {
            [tankdownAnimFrames addObject:
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"turreta_1_%d.png", i]]];
        }else{
            [tankdownAnimFrames addObject:
            [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"turreta_1_%d.png", i]]];     
        }
    }
    CCAnimation *fireAnim = [CCAnimation animationWithFrames:tankdownAnimFrames delay:.2];
    self.fireEffec = [CCSequence actions: [CCAnimate actionWithAnimation:fireAnim restoreOriginalFrame:NO], 
                      [CCCallFunc actionWithTarget:self selector:@selector(recoverTurretSprite)], nil];
    
    
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

-(void) aiControlSwitch:(BOOL) start{
    if (start) {
        [self schedule:@selector(go:) interval:0.08];
        [self startFire];
    }else{
        [self unschedule:@selector(go:)];
    }
}

//Schedule Methods

-(void) recoverTurretSprite{
    
    if (type == PlayerTank) {
         [turretSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"turreta_1_1.png"]];
    }else{
         [turretSprite setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"turreta_2_1.png"]];
    }
}

-(void) removeSprite:(CCNode *)sprite{
    CCLOG(@"Remove damage text");
    [world removeChild:sprite cleanup:YES];
}

-(void) releaseResource{
    CCLOG(@"release resource");
    [explosionSprite stopAction:explosionEffect];
    [tankdownSheet removeChild:explosionSprite cleanup:YES];
    [world removeChild:self cleanup:YES];
}

-(void) fire:(ccTime) dt{
    
    CGPoint startPoint = turretSprite.position;
    
    Bullet *bullet = [[Bullet alloc] initBullet:1 inPhyWorld:world.phyWorld inGameWorld:world atPosition:startPoint sender:type];
    bullet.attack = attack;
    
    
    float fireAngle;
    float bulletRogation;
    b2Vec2 vect;
    
    [turretSprite runAction:fireEffec];

    
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
    if (moveType == FixedPosition) {
        
    }else if(moveType == ChasePlayers){
        b2Vec2 force = [RotaionUtil phyPower:moveAngle withRatio:movement];
        tankBody -> ApplyLinearImpulse(force, tankBody->GetPosition());
      //b2Vec2 force = b2Vec2(sin(moveAngle) * movement, cos(moveAngle) * movement);
        
    }else if(moveType == RandomMove){
        
    }
       
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
