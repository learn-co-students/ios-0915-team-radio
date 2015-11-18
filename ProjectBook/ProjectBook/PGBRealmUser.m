//
//  PGBRealmUser.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBRealmUser.h"

@implementation PGBRealmUser

- (instancetype)init{
    self = [self initWithUsername:@""];
    return self;
}

- (instancetype)initWithUsername:(NSString *)username{
    self = [super init];
    if (self) {
        _username = username;
    }
    return self;
}


+ (void)storeUserProbileDataWithUser:(PGBRealmUser *)user{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:user];
    [realm commitWriteTransaction];
}

+ (void)deleteUserProfileDataForUser:(PGBRealmUser *)user{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:user];
    [realm commitWriteTransaction];
}

+ (RLMResults *)getUserProfileData{
    RLMResults *user = (RLMResults *)[[PGBRealmUser allObjects]firstObject];
    return user;
}


//// books should presist in the phone, one to many relationship is not really needed
//- (void)storeUserBookDataWith:(PGBRealmBook *)book{
//    RLMRealm *realm = [RLMRealm defaultRealm];
//
//    [realm beginWriteTransaction];
//   // PGBRealmBook *newBook = [[PGBRealmBook alloc]initWithTitle:@"Hunger Games"];
//    [realm addObject:book];
//    [realm commitWriteTransaction];
//}


@end
