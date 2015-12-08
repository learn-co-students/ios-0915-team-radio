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
+(void)fetchUserBookDataWithUserObject:(PFObject *)userObject andCompletion:(void (^)(NSArray *objects))completionBlock;
//+(void)storeUserBookDataWithUserObject:(PFObject *)userObject andCompletion:(void (^)())completionBlock;
+(void)storeUserBookDataWithUserObject:(PFObject *)userObject realmBookObject:(PGBRealmBook *)realmBook andCompletion:(void (^)(PFObject *bookObject))completionBlock;
@end
