//
//  HandDrawScene.h
//  Shooter
//
//  Created by Ammen on 11-3-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HandDrawScene : CCLayer {
    
    NSMutableArray *drawPoints;
    
}

@property (nonatomic, retain) NSMutableArray *drawPoints;

+(CCScene *) scene;

@end
