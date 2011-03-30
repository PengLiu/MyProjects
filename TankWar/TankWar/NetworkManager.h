//
//  NetworkManager.h
//  TankWar
//
//  Created by Ammen on 11-3-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface NetworkManager : NSObject <GKPeerPickerControllerDelegate,GKSessionDelegate> {

    GKSession *gameSession;
    
    NSString *gamePeerId;
    
    int	gameUniqueID;
}

@property (nonatomic, retain) GKSession *gameSession;
@property (nonatomic, retain) NSString *gamePeerId;

@end
