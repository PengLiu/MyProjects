////
////  Bullet.m
////  TankWar
////
////  Created by Ammen on 11-3-25.
////  Copyright 2011年 __MyCompanyName__. All rights reserved.
////
//
//#import "Constants.h"
//#import "Bullet.h"
//#import "GameScene.h"
//
//@interface Bullet(PrivateMethod)
//
//-(void) initBullet:(int)type;
//
//@end
//
//@implementation Bullet
//    
//
//
////-(void) initBullet:(int)type atPosition:(CGPoint) p{
////    
////    CCSprite *bullet=[CCSprite spriteWithFile:[NSString stringWithFormat:@"bullet%d.png",type]];
////    [bullet setPosition:p];
////    [world addChild:bullet z:1];
////    
////    b2BodyDef bodyDef;
////    
////    bodyDef.type = b2_dynamicBody;
////    bodyDef.userData = bullet;
////    bodyDef.position.Set(bullet.position.x/PTM_RATIO, bullet.position.y/PTM_RATIO);
////    
////    self.bulletBody = world.phyWorld ->CreateBody(&bodyDef);
////    bulletBody->SetBullet(true);
////    
////    // Define another box shape for our dynamic body.
////    b2CircleShape bulletBox;
////    bulletBox.m_radius = [bullet boundingBox].size.width/2/BODY_PTM_RATIO;
////	
////    // Define the dynamic body fixture.
////    b2FixtureDef fixtureDef;
////    fixtureDef.shape = &bulletBox;	
////    bulletBody->CreateFixture(&fixtureDef);
////    
////}
//
//
//@end
