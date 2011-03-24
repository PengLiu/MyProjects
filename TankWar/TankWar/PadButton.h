//
//  PadButton.h
//  cocos2d-Joystick
//
//  Created by ezshine on 11-1-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol PadButtonDelegate <NSObject>
@optional
- (void) onPadButtonClicked:(CCNode*)sender;
@end

@interface PadButton : CCSprite<CCTargetedTouchDelegate> {
	id<PadButtonDelegate> delegate;
}

@property (nonatomic, assign) id<PadButtonDelegate> delegate;

//+(void)initWithLabel:(NSString *)label 

@end
