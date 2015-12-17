//
//  PGBGoodreadsAPIClient.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/24/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBGoodreadsAPIClient.h"
#import "PGBRealmBook.h"
#import "Book.h"
#import "PGBDataStore.h"
#import "PGBConstants.h"

#import <AFNetworking/AFNetworking.h>


@interface PGBGoodreadsAPIClient ()

@property (strong, nonatomic) PGBDataStore *dataStore;

@end

@implementation PGBGoodreadsAPIClient
NSString *const GOODREADS_API_URL = @"https://www.goodreads.com";


+ (void)getReviewsForBook:(PGBRealmBook *)realmBook completion:(void (^)(NSDictionary *))completionBlock
{
    NSString *goodreadsURL = @"";
    NSString *author = @"";
    NSString *title = @"";
    
    if ([realmBook checkFriendlyTitleIfItHasAuthor:realmBook.friendlyTitle]) {
        author = [realmBook getAuthorFromFriendlyTitle:realmBook.friendlyTitle];
    } else {
        author = [realmBook parseAuthor:realmBook.author];
    }
    
    title = [realmBook.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    author = [author stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    if (author && title) {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@&author=%@", GOODREADS_API_URL, GOODREADS_KEY, title, author];
    } else if (title) {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, title];
    }
    
    goodreadsURL = [goodreadsURL stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:goodreadsURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         completionBlock(responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         //LEO - pass back nothing to completion block for failure
         completionBlock(nil);
         NSLog(@"Fail: %@",error.localizedDescription);
     }];
    
}


-(NSString *)getURLForBookAndAuthor:(PGBRealmBook *)realmBook
{
    NSString *author = @"";
    NSString *title = @"";
    NSString *goodreadsURL = @"";
    
    if ([realmBook checkFriendlyTitleIfItHasAuthor:realmBook.friendlyTitle]) {
        author = [realmBook getAuthorFromFriendlyTitle:realmBook.friendlyTitle];
        NSLog (@"author: %@", author);
    } else {
        author = [realmBook parseAuthor:realmBook.author];
    }
    
    title = [realmBook.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    author = [author stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    if (author && title) {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.xml?key=%@&title=%@&author=%@", GOODREADS_API_URL, GOODREADS_KEY, title, author];
    } else if (title) {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.xml?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, title];
    }
    
    goodreadsURL = [goodreadsURL stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
    NSLog (@"%@", goodreadsURL);
    
    return goodreadsURL;
}

- (void)getDescriptionForBookTitle:(PGBRealmBook *)realmBook completion:(void (^)(NSString *description))completion
{
    __block NSString *contentOfUrl = @"";
    NSString *URL = [self getURLForBookAndAuthor:realmBook];
    
    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[aSession dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
            if (((NSHTTPURLResponse *)response).statusCode == 200)
            {
                if (data)
                {
                    contentOfUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          
                    NSString *bookDescription = [self getDescriptionWithContentsOfURLString:contentOfUrl];
                    
                    NSArray *htmlTags = @[ @"<br", @"<strong>", @"<em>", @"<p>", @"</a>"];
                    
                    for (NSString *tag in htmlTags) {
                        if ([bookDescription containsString:tag]) {
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"<a href=\"" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
                            bookDescription = [bookDescription stringByReplacingOccurrencesOfString:@"\">" withString:@""];
                        }
                    }
                    completion(bookDescription);
                }
            } else {
                completion(nil);
                
            }
    }] resume];
    
}

- (void)getImageURLForBookTitle:(PGBRealmBook *)realmBook completion:(void (^)(NSString *imageURL))completion
{
    __block NSString *contentOfUrl = @"";
    NSString *URL = [self getURLForBookAndAuthor:realmBook];
    
    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[aSession dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (((NSHTTPURLResponse *)response).statusCode == 200)
          {
              if (data)
              {
                  contentOfUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                  NSString *imageURL = [self getImageURLWithContentsOfURLString:contentOfUrl];
                  completion(imageURL);

              }
          }
      }] resume];
    
}

- (NSString *)getDescriptionWithContentsOfURLString:(NSString *)contentsOfURL
{
    NSDictionary *dictionaryOfDescriptionAndURLS = [self methodToGetDescriptionsAndImageURLSWithString:contentsOfURL];
    NSString *bookDescription = dictionaryOfDescriptionAndURLS[@"Book Description"];
    
    return bookDescription;
}

- (NSString *)getImageURLWithContentsOfURLString:(NSString *)contentsOfURL
{
    NSDictionary *dictionaryOfImageURL = [self methodToGetDescriptionsAndImageURLSWithString:contentsOfURL];
    NSString *imageURL = dictionaryOfImageURL[@"Image URLS"];
    
    return imageURL;
}

- (NSDictionary *)methodToGetDescriptionsAndImageURLSWithString:(NSString *)string
{
    
    NSMutableArray *arrayOfDescription = [NSMutableArray new];
    NSMutableArray *arrayOfImageUrls = [NSMutableArray new];
    
    NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
    
    NSArray *lines = [string componentsSeparatedByCharactersInSet:newlineSet];  /* 
                                                                                 the string, 'string' is
                                                                                 broken apart at every new  
                                                                                 line; and each line
                                                                                 becomes its own element in 
                                                                                 the array 'lines' 
                                                                                 */
    
    /*
     We are looking for book descriptions, and image urls; and we know that book descriptions are always prefixed by the string "  <description" and image urls are always prefixed by the string @"<!CDATA[https"
     
     here we add any line that is prefixed by these strings to one array for descriptions, and another for image urls...these are not the only tags that descriptions and urls have, just the first
     
     the first <description string will always be associated with the acutal book description, any other description tag is used for other descriptions that are not neccessary
     */
    
    for (NSString *line in lines)
    {

        if ([line hasPrefix:@"  <image_url>"])
        {
            [arrayOfImageUrls addObject:line];
        }

        if ([line hasSuffix:@"</description>"]) {
            [arrayOfDescription addObject:line];
        }

    }
    
    /*
     Get the first element in the book description array (it will always be the actual book description
     */
    NSString *bookDescription = arrayOfDescription[0];
    
    NSArray *arrayOfTagsToBeRemoved = @[@"  <description>", @"<![CDATA[", @"</strong>", @"<br>", @"</description>", @"]]>"];
    
    for (NSString *string  in arrayOfTagsToBeRemoved) {
        bookDescription = [bookDescription stringByReplacingOccurrencesOfString:string withString:@""];
    }
    
    if (!bookDescription.length) {
        bookDescription = @"There is no description for this book.";
    }
    
    NSMutableArray *cleanedUpArrayOfImageUrls = [NSMutableArray new];
    
    for (NSString *imageURLString in arrayOfImageUrls)
    {
        if (![imageURLString containsString:@"<![CDATA["]){
            NSString *imageURL = [imageURLString stringByReplacingOccurrencesOfString:@"<image_url>" withString:@""];
            imageURL = [imageURL stringByReplacingOccurrencesOfString:@"</image_url>" withString:@""];
            imageURL = [imageURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [cleanedUpArrayOfImageUrls addObject:imageURL];
        }
    }
    
    NSDictionary *dictionaryOfDescriptionAndURLS = @{@"Book Description":bookDescription,
                                                     @"Image URLS":[cleanedUpArrayOfImageUrls firstObject],
                                                     };
    
    return dictionaryOfDescriptionAndURLS;
}





@end
