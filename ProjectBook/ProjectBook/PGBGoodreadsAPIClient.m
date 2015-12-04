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
NSString *const GOODREADS_API_URL = @"https://www.goodreads.com";


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
        
        //LEO bug fix here - URL string can't contain accent cahracters - example for failure:https://www.goodreads.com/book/title.json?key=AckMqnduhbH8xQdja2Nw&title=The+Ancien+Régime
        goodreadsURL = [goodreadsURL stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
        
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


-(NSArray *)parseATextFile
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"file_name" withExtension:@"txt"];
    
    NSString *fileContents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineSet];
    
    return lines;
}



//-(void)methodToGetDescriptions:(NSArray *)array
//{
//    NSUInteger indexOfImageUrlStart = [array indexOfObject:@"                <image_url nophoto='false'>"];
//    NSUInteger indexOfImageUrlFinish = [array indexOfObject:@"                </image_url>"];
//    
//    NSUInteger indexOfDescriptionStart = [array indexOfObject:@"                    <description"];
//    NSUInteger indexOfDescriptionFinish = [array indexOfObject:@"                    </description>"];
//    
//}






@end
