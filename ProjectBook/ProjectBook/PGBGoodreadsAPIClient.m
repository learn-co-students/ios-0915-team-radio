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
#import <Ono.h>


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


+ (void)getReviewsForBook:(NSString *)bookTitle completion:(void (^)(NSDictionary *))completionBlock
{
    NSString *titleWithPluses = [bookTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *goodreadsURL = [[NSMutableString alloc]init];
    
    PGBRealmBook *book = [[PGBRealmBook alloc]init];
    NSString *author = @"";
    
    //checks if friendlytitle has author, if so, parses out author
    if ([book checkFriendlyTitleIfItHasAuthor:book.friendlyTitle]) {
        author = [book getAuthorFromFriendlyTitle:book.friendlyTitle];
    }
    
    if (author && bookTitle) {
        NSString *authorWithPluses = [author stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@&author=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses, authorWithPluses];
    } else if (bookTitle) {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses];
        
        //LEO bug fix here - URL string can't contain accent cahracters - example for failure:https://www.goodreads.com/book/title.json?key=AckMqnduhbH8xQdja2Nw&title=The+Ancien+Régime
        //LEO bug fix here - URL string can't contain accent characters - example for failure:https://www.goodreads.com/book/title.json?key=AckMqnduhbH8xQdja2Nw&title=The+Ancien+Régime
        goodreadsURL = [goodreadsURL stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
        NSLog(@"goodReadsURL: %@", goodreadsURL);
        
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

- (void)getDescriptionForBookTitle:(NSString *)bookTitle completion:(void (^)(NSString *description))completion
{
    __block NSString *contentOfUrl = @"";
    // __weak typeof(self) tmpself = self;
    
    NSString *titleWithPluses = [bookTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *URL = [NSString stringWithFormat:@"%@/book/title.xml?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses];
    NSLog(@"url as string:%@", URL);
    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[aSession dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (((NSHTTPURLResponse *)response).statusCode == 200) {
                if (data) {
                    contentOfUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"This is working: %@", contentOfUrl);
                    NSString *bookDescription = [self getDescriptionWithContentsOfURLString:contentOfUrl];
                    completion(bookDescription);
                }
            }
    }] resume];
}

-(NSString*) getDescriptionWithContentsOfURLString:(NSString*) contentsOfURL{
    NSDictionary *dictionaryOfDescriptionAndURLS = [self methodToGetDescriptionsWithString:contentsOfURL];
    NSString *bookDescription = dictionaryOfDescriptionAndURLS[@"Book Description"];
    return bookDescription;
}

-(NSDictionary *)methodToGetDescriptionsWithString:(NSString *)string
{
    NSMutableArray *arrayOfDescription = [NSMutableArray new];
    NSMutableArray *arrayOfImageUrls = [NSMutableArray new];
    
    NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [string componentsSeparatedByCharactersInSet:newlineSet];
    
    for (NSString *line in lines)
    {
        if ([line hasPrefix:@"  <description"])
        {
            [arrayOfDescription addObject:line];
        }
        if ([line hasPrefix:@"<![CDATA[https"])
        {
            [arrayOfImageUrls addObject:line];
        }
    }

    NSString *bookDescription = arrayOfDescription[0];
    bookDescription = [bookDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL bookHasADescription = ![bookDescription isEqual:@"<description></description>"];
    
    if (bookHasADescription) {
        bookDescription = [bookDescription substringFromIndex:24];
        bookDescription = [bookDescription substringToIndex:bookDescription.length-17];
    } else {
        bookDescription = @"";
    }

    NSMutableArray *cleanedUpArrayOfImageUrls = [NSMutableArray new];
    
    for (NSString *imageURLString in arrayOfImageUrls)
    {
        NSString *imageURL = [imageURLString substringFromIndex:9];
        imageURL = [imageURL substringToIndex:imageURL.length-3];
        [cleanedUpArrayOfImageUrls addObject:imageURL];
    }
    
    NSDictionary *dictionaryOfDescriptionAndURLS = @{@"Book Description":bookDescription,
                                                     @"Image URLS":[cleanedUpArrayOfImageUrls firstObject],
                                                     };
    NSLog(@"dictionary:%@", dictionaryOfDescriptionAndURLS);
    return dictionaryOfDescriptionAndURLS;
}






@end
