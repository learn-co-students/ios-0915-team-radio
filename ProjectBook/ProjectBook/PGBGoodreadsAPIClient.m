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

-(void)somemethod
{
    NSMutableArray *newArray = [NSMutableArray new];
     __block NSMutableArray *anInteger = [NSMutableArray new];
    
    
    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[aSession dataTaskWithURL:[NSURL URLWithString:@"https://www.goodreads.com/book/title.xml?key=AckMqnduhbH8xQdja2Nw&title=Hound+of+the+Baskervilles&author=Arthur+Conan+Doyle"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            if (data) {
                NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [newArray addObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                [anInteger addObject:contentOfURL];
                
                
                
                NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
                NSArray *lines = [contentOfURL componentsSeparatedByCharactersInSet:newlineSet];
                 NSLog(@"Lines as elements %@", lines);
                
                NSMutableArray *mutableLines = [lines mutableCopy];
                for (NSString *line in mutableLines)
                {
                    if (line.length > 14)
                    {
                        NSString *first = [line substringToIndex:14];
                        if ([first isEqualToString:@"  description"])
                        {
                            [mutableLines addObject:line];
                            NSLog(@"array %@", mutableLines);
                        } else {
                            
                        
                        }
                    }
                    
                }
                
                NSLog(@"here");
            

            }
        }
    }] resume];
   
    
    //NSLog(@"Got here, %@", newArray);
    //return nil;
    
    
//    NSHTTPURLResponse *response;
//    NSData *data;
//    
//    NSURLSession *aSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [aSession dataTaskWithURL:[NSURL URLWithString:@"https://www.goodreads.com/book/title.xml?key=AckMqnduhbH8xQdja2Nw&title=Hound+of+the+Baskervilles&author=Arthur+Conan+Doyle"]];
//     
//     if (response.statusCode == 200) {
//         
//         if (data) {
//             NSString *contentOfURL = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             [newArray addObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
//             NSLog(@" contents:%@", contentOfURL);
//             
//             
//         }
//     }
//    NSLog(@"Got Here");
//    return nil;
}



-(NSDictionary *)methodToGetDescriptions
//{
//    NSData *data;
//    NSError *error;
//    
//    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
//    for (ONOXMLElement *element in document.rootElement.children) {
//        NSLog(@"%@: %@", element.tag, element.attributes);
//    }
//    
//    // Support for Namespaces
//    NSString *author = [[document.rootElement firstChildWithTag:@"creator" inNamespace:@"dc"] stringValue];
//    
//    // Automatic Conversion for Number & Date Values
//    NSDate *date = [[document.rootElement firstChildWithTag:@"created_at"] dateValue]; // ISO 8601 Timestamp
//    NSInteger numberOfWords = [[[document.rootElement firstChildWithTag:@"word_count"] numberValue] integerValue];
//    BOOL isPublished = [[[document.rootElement firstChildWithTag:@"is_published"] numberValue] boolValue];
//    
//    // Convenient Accessors for Attributes
//    NSString *unit = [document.rootElement firstChildWithTag:@"Length"][@"unit"];
//    NSDictionary *authorAttributes = [[document.rootElement firstChildWithTag:@"author"] attributes];
//    
//    // Support for XPath & CSS Queries
//    [document enumerateElementsWithXPath:@"//Content" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%@", element);
//    }];


//NSData *data = ...;
//NSError *error;

//ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];
//for (ONOXMLElement *element in document.rootElement.children) {
//    NSLog(@"%@: %@", element.tag, element.attributes);




{
    
    //NSLog(@"fourth xml as string:%@", XMLasString);
    
    //NSLog(@"xml as a string:%@", secondString);
    
    
//NSURL *url = [[NSURL alloc] initWithString:@"https://www.goodreads.com/book/title.xml?key=AckMqnduhbH8xQdja2Nw&title=Hound+of+the+Baskervilles&author=Arthur+Conan+Doyle"];
    
//    NSLog(@"the URL is:%@", url);
//NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//
//    NSLog(@"xmlparser:%@", xmlparser);
//    
//    NSString *XMLasString = [NSString stringWithFormat:@"%@", xmlparser.description];
//    
//    NSLog(@"xml as a string:%@ %lu", XMLasString, XMLasString.length);
    [self somemethod];
    NSString *someString;
    NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [someString componentsSeparatedByCharactersInSet:newlineSet];
   // NSLog(@"Lines as elements %@", lines);
    NSMutableArray *importantLines = [NSMutableArray new];
    NSMutableArray *imageURL = [NSMutableArray new];
    
    NSString *thingWeWant = @"  <description>";
    NSString *thingWeWantAlso = @"  <image_url>";
    
    for (NSString *line in lines)
    {
        if (line.length > 13) {
            NSString *lookingForURL = [line substringToIndex:13];
            NSString *lookingForDescription = [line substringToIndex:14];
            
            if ([lookingForDescription isEqualToString:thingWeWant])
            {
                [importantLines addObject:line];
            }
            else if ([lookingForURL isEqualToString:thingWeWantAlso])
            {
                NSUInteger index = [lines indexOfObject:line];
                
                [imageURL addObject:[imageURL objectAtIndex:index+1]];
                
        }
        
        }
    }
    
    NSString *description = importantLines[0];
    NSString *imageURLAsString = imageURL[0];
    
    description = [description substringFromIndex:25];
    description = [description substringToIndex:(description.length-19)];
    
    imageURLAsString = [imageURLAsString substringFromIndex:9];
    imageURLAsString = [imageURLAsString substringToIndex:(imageURLAsString.length-2)];
    
    NSDictionary *dictionaryOfDescriptionAndBookURL = @{@"Description":description,
                                                        @"URL":imageURLAsString};
    
    
    
    
    
    
    return dictionaryOfDescriptionAndBookURL;
}






@end
