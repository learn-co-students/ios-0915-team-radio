//
//  PGBRealmBook.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Realm/Realm.h>
#import "PGBRealmUser.h"
#import <UIKit/UIKit.h>

@interface PGBRealmBook : RLMObject

@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *author;
@property (strong, nonatomic)NSString *genre;
@property (strong, nonatomic)NSString *language;
@property (strong, nonatomic)NSString *downloadURL;
@property (strong, nonatomic)NSString *bookDescription;
@property (strong, nonatomic)NSDate *datePublished;
@property (assign, nonatomic)NSString *ebookID;
@property (assign, nonatomic)BOOL isDownloaded;
@property (assign, nonatomic)BOOL isBookmarked;

- (instancetype)init;
- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
                        genre:(NSString *)genre
                     language:(NSString *)language
                  downloadURL:(NSString *)downloadURL
              bookDescription:(NSString *)bookDescription
                datePublished:(NSDate *)datePublished
                      ebookID:(NSString *)ebookID
                 isDownloaded:(BOOL)isDownloaded
                 isBookmarked:(BOOL)isBookmarked;
+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book;
+ (void)deleteUserBookDataForBook:(PGBRealmBook *)book;
+ (void)deleteAllUserBookData;
+ (RLMResults *)getUserBookData;
+ (NSArray *)getUserBookDataInArray;

+ (void)generateTestBookData;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<PGBRealmBook>
RLM_ARRAY_TYPE(PGBRealmBook)
