//
//  PGBRealmUser.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "PGBRealmBook.h"

@interface PGBRealmUser : RLMObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *email;

- (instancetype)init;
- (instancetype)initWithUsername:(NSString *)username
                       firstname:(NSString *)firstname
                        lastname:(NSString *)lastname
                        location:(NSString *)location
                           email:(NSString *)email;
+ (void)storeUserProbileDataWithUser:(PGBRealmUser *)user;
+ (void)deleteUserProfileDataForUser:(PGBRealmUser *)user;
+ (void)deleteAllUserProfileData;
+ (PGBRealmUser *)getUserProfileData;

@end
