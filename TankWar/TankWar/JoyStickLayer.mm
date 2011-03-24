//
//  JoyStickLayer.m
//  Shooter
//
//  Created by Ammen on 11-3-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JoyStickLayer.h"
#import "PlayerHelper.h"
#import "Constants.h"

@interface JoyStickLayer(Private)

-(void) initJoyStick;

//-(void) initButtons;

-(void) initPlayerStatus;

@end



@implementation JoyStickLayer

@synthesize leftJoystick;
@synthesize rightJoystick;
@synthesize gameScene;
@synthesize hp;
@synthesize mana;


-(id) init{
	
	if ((self =[super init])) {
				
        //Init HP and Mana bar
        [self initPlayerStatus];
        
		//Init Game Joystick
		[self initJoyStick];
		
		//Init Buttons
		//[self initButtons];
        
		
	}
	return self;
	
}

-(void) initPlayerStatus{
    
    CCSprite *hpBar = [CCSprite spriteWithFile:@"bar.png"];

    [hpBar setRotation:90];
    [hpBar setPosition:ccp(100,300)];
    [hpBar setScaleY:100];
    //[bar setAnchorPoint:ccp(0.5,0)];
    
    [self addChild:hpBar];
    
}


-(void) initButtons{
		
	//CCMenuItemImage *buttonMenuItem = [CCMenuItemImage itemFromNormalImage:@"button_a1.png"
//									selectedImage: @"button_a2.png" target:self
//									selector:@selector(buttonAClicked:)];
//	
//	// Create a menu and add your menu items to it
//	CCMenu *buttonMenu = [CCMenu menuWithItems:buttonMenuItem, nil];
//	
//	// Arrange the menu items vertically
//	[buttonMenu alignItemsVertically];
//	buttonMenu.position=ccp(400,80);
//	// add the menu to your scene
//	[self addChild:buttonMenu];
	
}

//-(void)buttonAClicked: (CCMenuItem  *) menuItem
//{
//	[gameLayer fire];
//}

-(void) initJoyStick{
	
	self.leftJoystick = [CCJoyStick initWithBallRadius:25 MoveAreaRadius:65 
									   isFollowTouch:NO isCanVisible:YES isAutoHide:NO hasAnimation:YES];
	[leftJoystick setBallTexture:@"Ball.png"];
	[leftJoystick setDockTexture:@"Dock.png"];
	[leftJoystick setStickTexture:@"Stick.jpg"];
	[leftJoystick setHitAreaWithRadius:80];
	[leftJoystick setPosition:ccp(80,80)];
	[leftJoystick setDelegate:self];
	
	
	self.rightJoystick = [CCJoyStick initWithBallRadius:25 MoveAreaRadius:65 
										 isFollowTouch:NO isCanVisible:YES isAutoHide:NO hasAnimation:YES];
	[rightJoystick setBallTexture:@"Ball.png"];
	[rightJoystick setDockTexture:@"Dock.png"];
	[rightJoystick setStickTexture:@"Stick.jpg"];
	[rightJoystick setHitAreaWithRadius:80];
	[rightJoystick setPosition:ccp(380,80)];
	[rightJoystick setDelegate:self];
	[self addChild:leftJoystick];
	[self addChild:rightJoystick];
	
}

- (void) onCCJoyStickUpdate:(CCNode*)sender Angle:(float)angle Direction:(CGPoint)direction Power:(float)power
{
    
	if (sender == leftJoystick) {
        gameScene.playerHelper.player.rotation = -angle + 90;
        [gameScene.playerHelper moveToDirection:direction WithPower:power];
        
	}else if (sender == rightJoystick) {
        gameScene.playerHelper.turret.rotation = -angle +90 ;
        gameScene.playerHelper.angle = -angle;
	}
}

- (void) onCCJoyStickActivated:(CCNode*)sender
{
	if (sender == leftJoystick) {
		[leftJoystick setBallTexture:@"Ball_hl.png"];
		[leftJoystick setDockTexture:@"Dock_hl.png"];
        
	}else if (sender == rightJoystick) {
		[rightJoystick setBallTexture:@"Ball_hl.png"];
		[rightJoystick setDockTexture:@"Dock_hl.png"];
        //Tank fire
        [gameScene.playerHelper startFire];
	}
}
- (void) onCCJoyStickDeactivated:(CCNode*)sender
{
    
	if (sender == leftJoystick) {
		[leftJoystick setBallTexture:@"Ball.png"];
		[leftJoystick setDockTexture:@"Dock.png"];
		//[gameScene.playerHelper stopCurrentAction];
        
	}else if (sender == rightJoystick) {
		[rightJoystick setBallTexture:@"Ball.png"];
		[rightJoystick setDockTexture:@"Dock.png"];
        //Tank stop fire
        [gameScene.playerHelper stopFire];
	}
	
}


-(void) dealloc{

	[super dealloc];
}

@end