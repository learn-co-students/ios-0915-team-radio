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

#import "PGBRealmBook.h"
#import "Book.h"
#import "PGBDataStore.h"

@interface PGBGoodreadsAPIClient ()

@property (strong, nonatomic) PGBDataStore *dataStore;

@end

@implementation PGBGoodreadsAPIClient
NSString *const GOODREADS_KEY = @"AckMqnduhbH8xQdja2Nw";
NSString *const GOODREADS_SECRET = @"xlhPN1dtIA5CVXFHVF1q3eQfaUM1EzsT546C6bOZno";
NSString *const GOODREADS_API_URL = @"https://www.goodreads.com/";


+(void)getReviewsWithCompletion:(NSString *)author bookTitle:(NSString *)bookTitle completion:(void (^)(NSDictionary *))completionBlock
{
    
//    bookTitle = @"Norwegian Wood";
//    author = @"Haruki Murakami";
    NSString *titleWithPluses = [bookTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *goodreadsURL = [[NSMutableString alloc]init];
    
    
//    if (author && bookTitle) {
//        NSString *authorWithPluses = [author stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@&author=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses, authorWithPluses];
//    } else
//        
        if (bookTitle) {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses];
    } else {
        NSLog (@"didn't work!!");
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:goodreadsURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];

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
