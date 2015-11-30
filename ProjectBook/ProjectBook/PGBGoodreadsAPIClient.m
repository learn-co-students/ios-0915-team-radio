//
//  PGBGoodreadsAPIClient.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/24/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBGoodreadsAPIClient.h"
#import <GROAuth.h>
#import <XMLDictionary.h>
#import <AFNetworking/AFNetworking.h>


@implementation PGBGoodreadsAPIClient
NSString *const GOODREADS_KEY = @"AckMqnduhbH8xQdja2Nw";
NSString *const GOODREADS_SECRET = @"xlhPN1dtIA5CVXFHVF1q3eQfaUM1EzsT546C6bOZno";
NSString *const GOODREADS_API_URL = @"www.goodreads.com/";


+(void)getReviewsWithCompletion:(void (^)(NSArray *))completionBlock
{
    
}


-(void)dummyLoginMethod {
    //goodreads user login -- in viewDidAppear
    
    //NOTE - this is causing the page to load even after user is logged in, this needs to moved somewhere or add in a login check to not load it if user already logged in
    [GROAuth loginWithGoodreadsWithCompletion:^(NSDictionary *authParams, NSError *error) {
        if (error) {
            NSLog(@"Error logging in: %@", [error.userInfo objectForKey:@"userInfo"]);
        } else {
            NSURLRequest *userIDRequest = [GROAuth goodreadsRequestForOAuthPath:@"api/auth_user" parameters:nil HTTPmethod:@"GET"];
            
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:userIDRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"user request is back!");
                NSLog(@"error: %@", error);
                NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSDictionary *dictionary = [NSDictionary dictionaryWithXMLString:dataString];
                
                NSLog(@"%@", dictionary);
            }];
            [task resume];
        }
    }];
}

@end
