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

//子弹动画效果
#define BULLET_SPRITE_BATCH_NODE 2

//坦克动画效果 
#define TANK_ANIMATION_BATCH_NODE 3

// GKSession ID
#define TANKWAR_SESSIONID @"tankwar"


typedef enum  {
	EnemyTank,
    PlayerTank
}TankType;

typedef enum{
    
    RandomMove, //随机移动
    FixedPosition, //固定位置
    ChasePlayers   //追击玩家
    
}AIMoveType;

//子弹打到的目标类型
typedef enum {
    bBuilding,
    bEnemyTank,
    bBullet
}BulletTargetType;
