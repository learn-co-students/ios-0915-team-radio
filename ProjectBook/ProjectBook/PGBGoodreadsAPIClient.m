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
    /* 
     format book titles correctly by replacing spaces with the + sign
     */
    NSString *titleWithPluses = [bookTitle stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *goodreadsURL = [[NSMutableString alloc]init];
    
    PGBRealmBook *book = [[PGBRealmBook alloc]init];
    NSString *author = @"";
    
    /* 
     checks if friendlytitle has author, if so, parses out author
     friendly title has the format "BookTitle by AuthorName"
     Example "Harry Potter and the Sorcerer's Stone by J.K. Rowling" 
     */
    
    if ([book checkFriendlyTitleIfItHasAuthor:book.friendlyTitle])
    {
        author = [book getAuthorFromFriendlyTitle:book.friendlyTitle];
    }
    
    if (author && bookTitle)
    {
        NSString *authorWithPluses = [author stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@&author=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses, authorWithPluses];
        
    } else if (bookTitle)
    {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.json?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses];
        goodreadsURL = [goodreadsURL stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
        NSLog(@"goodReadsURL: %@", goodreadsURL);
        
    } else {
        NSLog (@"didn't work!!");
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:goodreadsURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
    
}

-(NSString *)getURLForBookAndAuthor:(PGBRealmBook *)realmBook
{

    NSString *author = nil;
    NSString *goodreadsURL = [[NSMutableString alloc]init];
    NSString *titleWithPluses = [realmBook.title stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"friendlyTitle %@ for bookTitle %@", realmBook.friendlyTitle, realmBook.title);
   
    /*
     checks if friendlytitle has author, if so, parses out author
     */
    
    if ([realmBook checkFriendlyTitleIfItHasAuthor:realmBook.friendlyTitle])
    {
        author = [realmBook getAuthorFromFriendlyTitle:realmBook.friendlyTitle];
        NSLog (@"author: %@", author);
    }
    
    if (author && realmBook.title)
    {
        NSString *authorWithPluses = [author stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.xml?key=%@&title=%@&author=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses, authorWithPluses];
        
        return goodreadsURL;
    } else if (realmBook.title)
    {
        goodreadsURL = [NSString stringWithFormat:@"%@/book/title.xml?key=%@&title=%@", GOODREADS_API_URL, GOODREADS_KEY, titleWithPluses];
        
        return goodreadsURL;
    }
    
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
                    /* 
                     NSLog(@"This is working: %@", contentOfUrl); 
                     */
                    NSString *bookDescription = [self getDescriptionWithContentsOfURLString:contentOfUrl];
                    completion(bookDescription);
                }
            }
    }] resume];
    
}

-(NSString *)getDescriptionWithContentsOfURLString:(NSString *)contentsOfURL
{
    NSDictionary *dictionaryOfDescriptionAndURLS = [self methodToGetDescriptionsWithString:contentsOfURL];
    NSString *bookDescription = dictionaryOfDescriptionAndURLS[@"Book Description"];
    
    return bookDescription;
}

-(NSDictionary *)methodToGetDescriptionsWithString:(NSString *)string
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
        if ([line hasPrefix:@"  <description"])
        {
            [arrayOfDescription addObject:line];
        }
        if ([line hasPrefix:@"<![CDATA[https"])
        {
            [arrayOfImageUrls addObject:line];
        }
    }
    
    /*
     Get the first element in the book description array (it will always be the actual book description
     */
    NSString *bookDescription = arrayOfDescription[0];
    
    
    /*
     Example of tags placed on book descriptions:   "  <description><![CDATA[Holmes" ... Holmes is the first word of the actual description.  To combat additional tags, an array of all known tags is made, and to get rid of tags, add the string of the tag into the array.  The order is important (the tag that first appears should be the first element in the array, the second tag to appear is the second element...etc.
     */
    NSArray *arrayOfPotentialPrefixes = @[@"  <description>", @"<![CDATA["];
    
    for (NSString *string in arrayOfPotentialPrefixes)
    {
        /*
         string here is the tag in array being checked against the description to see if its there
         the string length, is the length of the tag
         */
        
        NSUInteger stringLength = string.length;
        NSRange range = NSMakeRange(0, stringLength);
        
        /*
         substring to range will break the original string into the first few characters (upto stringLength)
         if the new string is the same as the tag, the new string formed will start where the tag ends
         
         Example:   "  <description><![CDATA[Holmes...."
         The string formed is as long as stringLength aka "  <description>"
         since this string is equal to the first tag being checked, the new string starts after this
         so the new string now is: "<![CDATA[Holmes ..."
         */
        
        if ([[bookDescription substringWithRange:range] isEqualToString:string])
        {
            bookDescription = [bookDescription substringFromIndex:stringLength];
        }
    }
    
    /*
     After getting rid of all tags before the description starts, all tags after the description ends must be deleted
     The same format for suffix tag deletion is applied as the format for prefix tag deletion
     */
    
    NSArray *arrayOfPotentialSuffixes = @[@"</description>", @"]]>"];
    for (NSString *string  in arrayOfPotentialSuffixes)
    {
        NSUInteger stringLength = string.length;
        if (stringLength)
        {
            NSUInteger bookDescriptionLength = bookDescription.length;
            if (bookDescriptionLength)
            {
                if ([[bookDescription substringFromIndex:bookDescriptionLength-stringLength] isEqualToString:string])
                {
                    bookDescription = [bookDescription substringToIndex:bookDescriptionLength-stringLength];
                }
            } else {
                bookDescription = @"There is no description for this book.";
            }
        }
        
    }
    
    NSMutableArray *cleanedUpArrayOfImageUrls = [NSMutableArray new];
    /*
     All imageUrlStrings have the same format for tags, and so this was done manually with magic numbers
     */
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
