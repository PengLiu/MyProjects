
#import "ContactListener.h"
#import "cocos2d.h"
#import "Bullet.h"

void ContactListener::BeginContact(b2Contact* contact){
    
    CCLOG(@"Contact....");

    b2Body *ba = contact->GetFixtureA() ->GetBody();
    b2Body *bb = contact->GetFixtureB() -> GetBody();
    
    if (ba->GetType() != b2_staticBody &&  ba->IsBullet()) {
        Bullet *bullet = (Bullet *) ba->GetUserData();
        bullet.needToBeDeleted = YES;
    }
    
    if (bb->GetType() != b2_staticBody &&  bb->IsBullet()) {
        Bullet *bullet = (Bullet *) bb->GetUserData();
        bullet.needToBeDeleted = YES;
    }
    
    //if (contact->IsSolid()) {
    //    NSLog(@"Contact is solid");
    //}
}

void ContactListener::EndContact(b2Contact* contact){
   // CCLOG(@"end contact");
}

void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold){
    //const b2Manifold* manifold = contact->GetManifold();
}

void ContactListener::PostSolve(b2Contact* contact){
   // const b2ContactImpulse* impulse;
}