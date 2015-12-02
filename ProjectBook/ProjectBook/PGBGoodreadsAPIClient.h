//
//  PGBGoodreadsAPIClient.h
//  ProjectBook
//
//  Created by Olivia Lim on 11/24/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface PGBGoodreadsAPIClient : NSObject

+(void)getReviewsWithCompletion:(NSString *)author bookTitle:(NSString *)bookTitle completion:(void (^)(NSDictionary *))completionBlock;

@end
