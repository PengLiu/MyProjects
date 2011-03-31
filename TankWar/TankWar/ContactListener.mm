
#import "ContactListener.h"
#import "cocos2d.h"
#import "Bullet.h"
#import "Tank.h"

void ContactListener::BeginContact(b2Contact* contact){
    
    //CCLOG(@"Contact....");

    b2Body *ba = contact->GetFixtureA() ->GetBody();
    b2Body *bb = contact->GetFixtureB() -> GetBody();
    
    //双方都是子弹
    if (ba->IsBullet() && bb->IsBullet()) {
        
        Bullet *bulleta = (Bullet *) ba->GetUserData();
        Bullet *bulletb = (Bullet *) bb->GetUserData();
        
        if (bulleta.senderType == bulletb.senderType) {
            return;
        }else{
            bulleta.needToBeExploded = YES;
            bulletb.needToBeExploded = YES;
            return;
        }
    }else {
        
        if(ba->IsBullet() && bb->GetType() != b2_staticBody ){
        
            Bullet *bullet = (Bullet *) ba->GetUserData();
            Tank *tank = (Tank *)bb->GetUserData();
        
            if (bullet.senderType == tank.type) {
                return;
            }else{
                bullet.needToBeExploded = YES;
                [tank injuredWithBullet:bullet];
            }
        
        
        }else if(bb->IsBullet() && ba->GetType() != b2_staticBody ){
        
            Bullet *bullet = (Bullet *) bb->GetUserData();
            Tank *tank = (Tank *)ba->GetUserData();
        
            if (bullet.senderType == tank.type) {
                return;
            }else{
                bullet.needToBeExploded = YES;
                [tank injuredWithBullet:bullet];
            }
        }else if(ba->IsBullet() && bb->GetType() == b2_staticBody){
            Bullet *bullet = (Bullet *) ba->GetUserData();
            bullet.needToBeExploded = YES;
        }else if(bb->IsBullet() && ba->GetType() == b2_staticBody){
            Bullet *bullet = (Bullet *) bb->GetUserData();
            bullet.needToBeExploded = YES;
        }
    }
    
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