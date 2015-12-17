//
//  PGBParseAPIClient.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PGBRealmBook.h"

@interface PGBParseAPIClient : NSObject

+(void)fetchUserProfileDataWithUserObject:(PFObject *)user andCompletion:(void (^)(PFObject *data))completionBlock;
+(void)fetchUserBookDataWithUserObject:(PFObject *)userObject andCompletion:(void (^)(NSArray *books))completionBlock;
+(void)storeUserBookDataWithUserObject:(PFObject *)userObject realmBookObject:(PGBRealmBook *)realmBook andCompletion:(void (^)(PFObject *bookObject))completionBlock;
+(void)deleteUserBookDataWithUserObject:(PFObject *)userObject andCompletion:(void (^)(BOOL success))completionBlock;
@end
