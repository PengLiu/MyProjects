//
//  JoyStickLayer.h
//  Shooter
//
//  Created by Ammen on 11-3-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCJoyStick.h"
#import "GameScene.h"


@interface JoyStickLayer : CCLayer<CCJoyStickDelegate> {
	
	CCJoyStick *leftJoystick;
	CCJoyStick *rightJoystick;
    
    CCSprite *hp;
    CCSprite *mana;
    
	GameScene *gameScene;
}

@property (nonatomic, retain) CCJoyStick *leftJoystick;
@property (nonatomic, retain) CCJoyStick *rightJoystick;
@property (nonatomic, retain) CCSprite *hp;
@property (nonatomic, retain) CCSprite *mana;

@property (nonatomic, retain) GameScene *gameScene;



@end
