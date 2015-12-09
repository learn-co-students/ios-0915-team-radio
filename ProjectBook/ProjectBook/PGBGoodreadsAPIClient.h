//
//  PGBGoodreadsAPIClient.h
//  ProjectBook
//
//  Created by Olivia Lim on 11/24/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PGBRealmBook.h"

@interface PGBGoodreadsAPIClient : NSObject

+ (void)getReviewsForBook:(NSString *)bookTitle completion:(void (^)(NSDictionary *))completionBlock;
- (NSDictionary *)methodToGetDescriptionsWithString:(NSString *)string;
//- (void)getDescriptionForBookTitle:(NSString *)bookTitle completion:(void (^)(NSString *description))completion;

- (void)getDescriptionForBookTitle:(PGBRealmBook *)realmBook completion:(void (^)(NSString *description))completion;
- (NSString *)getURLForBookAndAuthor:(PGBRealmBook *)realmBook;

@end
