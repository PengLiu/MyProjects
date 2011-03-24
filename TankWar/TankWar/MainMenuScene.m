//
//  MainMenuSence.m
//  Shooter
//
//  Created by Ammen on 11-3-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import "HandDrawScene.h"

@implementation MainMenuSence


+(CCScene *) scene{
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuSence *layer = [MainMenuSence node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
	
	
}

-(id) init{
	

	if( (self=[super init])) {

		self.isTouchEnabled = YES;
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		//Display background image
		CCSprite *menuBackground = [CCSprite spriteWithFile:@"mainmenu.jpg"];
		[menuBackground setPosition:ccp( size.width /2 , size.height/2 )];
		[self addChild:menuBackground z:-1];
		
		//Display Game Name
		CCLabelTTF *gameNameLabel = [CCLabelTTF labelWithString:@"Game Name" fontName:@"Verdana" fontSize:30];
		[gameNameLabel setPosition:ccp( size.width /2 , size.height - 50 )];
		[self addChild:gameNameLabel z:0];
		
		
		//Display menu lables
		CCLabelTTF *newGameLabel = [CCLabelTTF labelWithString:@"New Game" fontName:@"Verdana" fontSize:20];
		CCLabelTTF *optionLabel = [CCLabelTTF labelWithString:@"Options" fontName:@"Verdana" fontSize:20];
		CCLabelTTF *aboutLabel = [CCLabelTTF labelWithString:@"About" fontName:@"Verdana" fontSize:20];
		
		
		CCMenuItemLabel * newgame = [CCMenuItemLabel itemWithLabel:newGameLabel target:self selector: @selector(newGame:)]; 
		CCMenuItemLabel * options = [CCMenuItemLabel itemWithLabel:optionLabel target:self selector: @selector(options:)];
		CCMenuItemLabel * about = [CCMenuItemLabel itemWithLabel:aboutLabel target:self selector: @selector(about:)];
		
		CCMenu * menu = [CCMenu menuWithItems:newgame,options, about,nil]; 
		[menu alignItemsVerticallyWithPadding:5]; 
		[self addChild:menu];
		[menu setPosition:ccp( size.width /2 , 120)];
		
	}
	
	return self;
}

-(void)newGame:(id)sender{
	
	//Go to game scene
	[[CCDirector sharedDirector]replaceScene:[GameScene sceneWithMap:@"desert_world.tmx"]];
}
-(void)options:(id)sender {
	[[CCDirector sharedDirector]replaceScene:[HandDrawScene scene]];
}
-(void)about:(id)sender {
	
}

-(void)dealloc{
		
	CCLOG(@"Main Menu Dealloc");
	[super dealloc];
	
}


@end
