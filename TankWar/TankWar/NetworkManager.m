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

NSError *err;

-(id) init{
    
    if ((self = [super init])) {
        NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
        gameUniqueID = [uid hash];
    }
    
    return self;
}



-(void) dealloc{
    
    //[gameSession release];
    //[gamePeerId release];
    
    [super dealloc];
}

//Public Methods
-(void) startPicker{
    
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby | GKPeerPickerConnectionTypeOnline;
    [picker show]; 
}

-(void) endConnection{
    [gameSession disconnectFromAllPeers];
    gameSession.available = NO;
    [gameSession setDataReceiveHandler: nil withContext: nil];
    gameSession.delegate = nil;
    [gameSession release];
}

-(void) sendNetwork:(NSData *)data{
    //以安全方式发送数据到所有连接的客户端
    [gameSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&err];
    if (err) {
        CCLOG(@"Send data error:%@",[err localizedDescription]);
        err = nil;
    }
 
}

//GKPeerPickerControllerDelegate Methods

-(GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    GKSession* session = [[GKSession alloc] initWithSessionID:TANKWAR_SESSIONID displayName:TANKWAR_SESSIONID sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}


- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{

}


- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{

    //Here another peer really connected to us, we retain peerID, and session.
    self.gamePeerId = peerID;
	self.gameSession = session;
	
    gameSession.delegate = self; 
	
    [gameSession setDataReceiveHandler:self withContext:NULL];
	
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
}

// User cancel the connection.
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    CCLOG(@"peerPickerControllerDidCancel");
    // autorelease the picker. 
	picker.delegate = nil;
    [picker autorelease]; 
	
	// invalidate and release game session if one is around.
	if(self.gameSession != nil)	{
		[self invalidateSession:self.gameSession];
		self.gameSession = nil;
	}
}

-(void)invalidateSession:(GKSession *)session {
	if(session != nil) {
		[session disconnectFromAllPeers]; 
		session.available = NO; 
		[session setDataReceiveHandler: nil withContext: NULL]; 
		session.delegate = nil; 
	}
}

//DataReceiveHandler methods

-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context { 
    
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


//GKSessionDelegate Methods

//收到其他客户端的连接请求
-(void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    CCLOG(@"Receive connection request from %@ with name:%@",peerID,[session displayNameForPeer:peerID]);
}

//有新的客户端连接成功
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    CCLOG(@"Peer:%@ with status--%@",peerID, state);
    
    switch (state){
            
        case GKPeerStateConnected:
            // Record the peerID of the other peer.
            // Inform your game that a peer has connected.
            break;
        case GKPeerStateDisconnected:
            // Inform your game that a peer has left.
            break;
    }
    
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    CCLOG(@"Connection with peer error:%@.",[error localizedDescription]);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    CCLOG(@"Connection Error:%@.",[error localizedDescription]);
}

@end
