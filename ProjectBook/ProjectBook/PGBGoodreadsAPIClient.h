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

//reviews
+ (void)getReviewsForBook:(PGBRealmBook *)realmBook completion:(void (^)(NSDictionary *))completionBlock;
- (NSString *)getURLForBookAndAuthor:(PGBRealmBook *)realmBook;

//description
- (NSDictionary *)methodToGetDescriptionsAndImageURLSWithString:(NSString *)string;
- (void)getDescriptionForBookTitle:(PGBRealmBook *)realmBook completion:(void (^)(NSString *description))completion;

//images
- (NSString *)getImageURLWithContentsOfURLString:(NSString *)contentsOfURL;
- (void)getImageURLForBookTitle:(PGBRealmBook *)realmBook completion:(void (^)(NSString *imageURL))completion;

@end
