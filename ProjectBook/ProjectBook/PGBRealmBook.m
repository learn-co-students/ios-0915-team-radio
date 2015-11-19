//
//  PGBRealmBook.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBRealmBook.h"

@implementation PGBRealmBook

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

- (instancetype)init{
    self = [self initWithTitle:@"" author:@"" genre:@"" language:@"" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
                        genre:(NSString *)genre
                     language:(NSString *)language
                  downloadURL:(NSString *)downloadURL
              bookDescription:(NSString *)bookDescription
                datePublished:(NSDate *)datePublished
                      ebookID:(NSInteger)ebookID{
    self = [super init];
    if (self) {
        _title = title;
        _author = author;
        _genre = genre;
        _language = language;
        _downloadURL = downloadURL;
        _bookDescription = bookDescription;
        _datePublished = datePublished;
        _ebookID = ebookID;
    }
    return self;
}

+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:book];
    [realm commitWriteTransaction];
}

+ (void)deleteUserBookDataForBook:(PGBRealmBook *)book{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:book];
    [realm commitWriteTransaction];
}

+ (void)deleteAllUserBookData{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

+ (RLMResults *)getUserBookData{
    RLMResults *books = [PGBRealmBook allObjects];
    return books;
}

+ (NSArray *)getUserBookDataInArray{
    RLMResults *books = [PGBRealmBook allObjects];
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (PGBRealmBook *book in books) {
        [result addObject:book];
    }
    return result;
}

+(void)generateTestBookData{
    if (![PGBRealmBook getUserBookDataInArray].count) {
        PGBRealmBook *book1 = [[PGBRealmBook alloc]initWithTitle:@"Norwegian" author:@"Hariku Murakami" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
        [PGBRealmBook storeUserBookDataWithBook:book1];
        
        PGBRealmBook *book2 = [[PGBRealmBook alloc]initWithTitle:@"Kafka on the Shore" author:@"Hariku Murakami" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
        [PGBRealmBook storeUserBookDataWithBook:book2];
        
        PGBRealmBook *book3 = [[PGBRealmBook alloc]initWithTitle:@"Sup" author:@"Leo" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
        [PGBRealmBook storeUserBookDataWithBook:book3];
    }
}

@end
