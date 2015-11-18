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

@property (strong, nonatomic)NSString *username;
@property (strong, nonatomic)NSString *firstName;
@property (strong, nonatomic)NSString *lastName;
@property (strong, nonatomic)NSString *location;
@property (strong, nonatomic)NSString *gender;
//@property RLMArray<PGBRealmBook *><PGBRealmBook> *books;

- (instancetype)init;
- (instancetype)initWithUsername:(NSString *)username;
+ (void)storeUserProbileDataWithUser:(PGBRealmUser *)user;
+ (void)deleteUserProfileDataForUser:(PGBRealmUser *)user;
+ (PGBRealmUser *)getUserProfileData;

@end
