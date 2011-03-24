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
		
		//CCLOG(@"angle:%f power:%f direction:%f,%f",angle,power,direction.x,direction.y);
        //CCLOG(@"Player position:x%f,y%f",gameScene.playerHelper.player.position.x,gameScene.playerHelper.player.position.y);
        gameScene.playerHelper.player.rotation = -angle + 90;

		float nextx = gameScene.playerHelper.player.position.x;
		float nexty = gameScene.playerHelper.player.position.y;
		
		// With power
		//nextx += direction.x * (power*8);
		//nexty += direction.y * (power*8);
		
		nextx += direction.x * 3;
		nexty += direction.y * 3;
        
		float mapWidth = gameScene.worldMap.mapSize.width;
		float mapHeight = gameScene.worldMap.tileSize.height;
		float mapTileWidth = gameScene.worldMap.tileSize.width;
		float mapTileHeith = gameScene.worldMap.tileSize.height;
        
		if (nextx <= (mapWidth * mapTileWidth -30) && nexty <= (mapHeight * mapTileHeith - 110)
			&&nextx >= 30 && nexty >= 50) {
			[gameScene.playerHelper moveToPosition:ccp(nextx, nexty)];
        }
	}else if (sender == rightJoystick) {
        
        gameScene.playerHelper.turret.rotation = -angle +90 ;
        gameScene.playerHelper.angle = -angle;
		[gameScene.playerHelper fire];
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
	}
	
}


-(void) dealloc{

	[super dealloc];
}

@end
