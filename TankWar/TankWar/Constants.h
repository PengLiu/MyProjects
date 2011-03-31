//
//  Constants.h
//  Shooter
//
//  Created by Ammen on 11-3-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//


#define PI 3.1415926

#define PTM_RATIO 32
//For box2d body size .5f is 1m, so we use pixle/PTM_RATIO/2 to transfer pixle to meter.
#define BODY_PTM_RATIO 64

//Damping for tank body
#define BETTER_LINE_DAMPING 10
#define  BETTER_ANGULAR_DAMPING 10


#define TANK_SPRITE_BATCH_NODE 1
#define BULLET_SPRITE_BATCH_NODE 2


typedef enum  {
	EnemyTank,
    PlayerTank
}TankType;

// GKSession ID
#define TANKWAR_SESSIONID @"tankwar"