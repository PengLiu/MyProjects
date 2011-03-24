//
//  HandDrawScene.m
//  Shooter
//
//  Created by Ammen on 11-3-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HandDrawScene.h"

@implementation HandDrawScene

@synthesize drawPoints;


+(CCScene *) scene{

    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HandDrawScene *layer = [HandDrawScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
    
}

-(id) init{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        self.drawPoints = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

-(void) registerWithTouchDispatcher{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kCCMenuTouchPriority swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Touch Begin");
    return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Touch End");
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CCLOG(@"Moved");
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    [drawPoints addObject:NSStringFromCGPoint(touchLocation)];
    [drawPoints addObject:NSStringFromCGPoint(oldTouchLocation)];
}

-(void) draw{
    
    glEnable(GL_LINE_SMOOTH);
    
    for(int i = 0; i < [drawPoints count]; i+=2){
        
        CGPoint start = CGPointFromString([drawPoints objectAtIndex:i]);
        CGPoint end = CGPointFromString([drawPoints objectAtIndex:i+1]);
        
        ccDrawLine(start, end);
        
    }
    
}


@end
