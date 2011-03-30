//
//  NetworkManager.m
//  TankWar
//
//  Created by Ammen on 11-3-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NetworkManager.h"
#import "cocos2d.h"
#import "Constants.h"


@implementation NetworkManager

@synthesize gamePeerId;
@synthesize gameSession;


-(id) init{
    
    if ((self = [super init])) {
        
        GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
        picker.delegate = self;
        [picker show]; 
        
        NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
        gameUniqueID = [uid hash];
    }
    
    return self;
}



-(void) dealloc{
    
    [gameSession release];
    [gamePeerId release];
    
    [super dealloc];
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context { 
    
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    CCLOG(@"Data Received:%@",aStr);
    
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setDelegate:self];
    [dialog setTitle:@"Friend Message"];
    [dialog setMessage:aStr];
    [dialog addButtonWithTitle:@"Yes"];
    [dialog addButtonWithTitle:@"No"];
    [dialog show];
    [dialog release];
    
    [aStr release];
}

- (void)sendNetworkPacket:(GKSession *)session packetID:(int)packetID withData:(void *)data ofLength:(int)length reliable:(BOOL)howtosend{

    NSString* str= @"teststring";
    NSData* packet=[str dataUsingEncoding:NSUTF8StringEncoding];

    if(howtosend == YES) { 
        [session sendData:packet toPeers:[NSArray arrayWithObject:gamePeerId] withDataMode:GKSendDataReliable error:nil];
    } else {
        [session sendData:packet toPeers:[NSArray arrayWithObject:gamePeerId] withDataMode:GKSendDataUnreliable error:nil];
    }
    
}

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{
    CCLOG(@"xxxx");
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    return [[[GKSession alloc] initWithSessionID:TANKWAR_SESSIONID displayName:nil sessionMode:GKSessionModePeer] autorelease]; 
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
    
    CCLOG(@"didConnectPeer%@",peerID);
    self.gamePeerId = peerID;
    
    // Make sure we have a reference to the game session and it is set up
	self.gameSession = session; // retain
	self.gameSession.delegate = self; 
	[self.gameSession setDataReceiveHandler:self withContext:NULL];
	
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
    
    [self sendNetworkPacket:self.gameSession packetID:1 withData:&gameUniqueID ofLength:sizeof(int) reliable:YES];
}


- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    CCLOG(@"peerPickerControllerDidCancel");
    // autorelease the picker. 
	picker.delegate = nil;
    [picker autorelease]; 
	
	// invalidate and release game session if one is around.
	if(self.gameSession != nil)	{
		//[self invalidateSession:self.gameSession];
		self.gameSession = nil;
	}
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    CCLOG(@"didChangeState ");
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
     CCLOG(@"didReceiveConnectionRequestFromPeer ");
}


- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    CCLOG(@"connectionWithPeerFailed ");
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    CCLOG(@"didFailWithError");
}


@end
