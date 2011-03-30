
#import "ContactListener.h"
#import "cocos2d.h"
#import "Bullet.h"
#import "Tank.h"

void ContactListener::BeginContact(b2Contact* contact){
    
    //CCLOG(@"Contact....");

    b2Body *ba = contact->GetFixtureA() ->GetBody();
    b2Body *bb = contact->GetFixtureB() -> GetBody();
    
    if (ba->GetType() != b2_staticBody &&  ba->IsBullet()) {
        Bullet *bullet = (Bullet *) ba->GetUserData();
        bullet.needToBeExploded = YES;
        
        if(bb->GetType() != b2_staticBody && !bb->IsBullet()){
            Tank *tank = (Tank *)bb->GetUserData();
            [tank injuredWithBullet:bullet];
        }
        
    }
    
    if (bb->GetType() != b2_staticBody &&  bb->IsBullet()) {
        Bullet *bullet = (Bullet *) bb->GetUserData();
        bullet.needToBeExploded = YES;
        
        if(ba->GetType() != b2_staticBody && !ba->IsBullet()){
            Tank *tank = (Tank *)ba->GetUserData();
            [tank injuredWithBullet:bullet];
        }
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