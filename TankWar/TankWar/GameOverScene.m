//
//  GameOverScene.m
//  TankWar
//
//  Created by Ammen on 11-3-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameOverScene.h"
#import "MainMenuScene.h"


@implementation GameOverScene


+(CCScene *) scene{
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
	
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
		CCSprite *menuBackground = [CCSprite spriteWithFile:@"gameover.jpg"];
		[menuBackground setPosition:ccp( size.width /2 , size.height/2 )];
		[self addChild:menuBackground z:-1];
		
		//Display Game Name
		CCLabelTTF *gameNameLabel = [CCLabelTTF labelWithString:@"Tank War" fontName:@"Verdana" fontSize:30];
		[gameNameLabel setPosition:ccp( size.width /2 , size.height - 50 )];
		[self addChild:gameNameLabel z:0];
		
		
		//Display menu lables
		CCLabelTTF *restartGameLabel = [CCLabelTTF labelWithString:@"Restart" fontName:@"Verdana" fontSize:30];
		CCMenuItemLabel * restartGame = [CCMenuItemLabel itemWithLabel:restartGameLabel target:self selector: @selector(newGame:)]; 
		CCMenu * menu = [CCMenu menuWithItems:restartGame,nil]; 
		[menu alignItemsVerticallyWithPadding:5]; 
		[self addChild:menu];
		[menu setPosition:ccp( size.width /2 , 120)];
		
	}
	
	return self;
}

-(void) newGame:(id)sender{
    [[CCDirector sharedDirector]replaceScene:[MainMenuSence scene]];
}

-(void)dealloc{
    CCLOG(@"GameOver Scene dealloc");
    [super dealloc];
}


@end
