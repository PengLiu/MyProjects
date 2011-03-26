//
//  ContactListener.h
//  TankWar
//
//  Created by Ammen on 11-3-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "Box2D.h"

const int32 k_maxContactPoints = 2048;

struct ContactPoint
{
    b2Fixture* fixtureA;
    b2Fixture* fixtureB;
    b2Vec2 normal;
    b2Vec2 position;
    b2PointState state;
};

class ContactListener : public b2ContactListener {

    
public:

    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact);
    
};
