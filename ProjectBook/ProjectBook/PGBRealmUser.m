//
//  PGBRealmUser.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBRealmUser.h"

@implementation PGBRealmUser

- (instancetype)init
{
    self = [self initWithUsername:@"" firstname:@"" lastname:@"" location:@"" email:@""];
    return self;
}

- (instancetype)initWithUsername:(NSString *)username
                       firstname:(NSString *)firstname
                        lastname:(NSString *)lastname
                        location:(NSString *)location
                           email:(NSString *)email
{
    self = [super init];
    if (self) {
        _username = username;
        _firstname = firstname;
        _lastname = lastname;
        _location = location;
        _email = email;
    }
    return self;
}


+ (void)storeUserProbileDataWithUser:(PGBRealmUser *)user
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:user];
    [realm commitWriteTransaction];
}

+ (void)deleteUserProfileDataForUser:(PGBRealmUser *)user
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:user];
    [realm commitWriteTransaction];
}

+ (void)deleteAllUserProfileData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

+ (RLMResults *)getUserProfileData
{
    RLMResults *user = (RLMResults *)[[PGBRealmUser allObjects]firstObject];
    return user;
}


@end
