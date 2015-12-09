//
//  PGBRealmBook.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "PGBRealmUser.h"
#import "Book.h"

@interface PGBRealmBook : RLMObject

//@property (assign, nonatomic)NSInteger id;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *author;
@property (strong, nonatomic)NSString *genre;
@property (strong, nonatomic)NSString *language;
@property (strong, nonatomic)NSString *friendlyTitle;
@property (strong, nonatomic)NSString *downloadURL;
@property (strong, nonatomic)NSString *bookDescription;
@property (assign, nonatomic)NSString *ebookID;
@property (assign, nonatomic)BOOL isDownloaded;
@property (assign, nonatomic)BOOL isBookmarked;
@property (strong, nonatomic)NSData *bookCoverData;

- (instancetype)init;
- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
                        genre:(NSString *)genre
                     language:(NSString *)language
                friendlyTitle:(NSString *)friendlyTitle
                  downloadURL:(NSString *)downloadURL
              bookDescription:(NSString *)bookDescription
                      ebookID:(NSString *)ebookID
                 isDownloaded:(BOOL)isDownloaded
                 isBookmarked:(BOOL)isBookmarked
                bookCoverData:(NSData *)bookCoverData;

+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book;
+ (void)storeUserBookDataWithBookwithUpdateBlock:(PGBRealmBook *(^)())updateBlock;
+ (void)deleteUserBookDataForBook:(PGBRealmBook *)book;
+ (void)deleteAllUserBookData;
+ (RLMResults *)getUserBookData;
+ (NSArray *)getUserBookDataInArray;
+ (PGBRealmBook *)createPGBRealmBookWithBook:(Book *)book;
+ (PGBRealmBook *)createPGBRealmBookContainingCoverImageWithBook:(Book *)coreDataBook;
+ (NSURL *)createBookCoverURL:(NSString *)eBookNumber;
+ (BOOL)validateBookDataWithRealmBook:(PGBRealmBook *)realmBook;

+ (void)fetchUserBookDataFromParseStoreToRealmWithCompletion:(void (^)())completionBlock;
+ (void)storeUserBookDataFromRealmStoreToParseWithRealmBook:(PGBRealmBook *)realmBook andCompletion:(void (^)())completionBlock;

//override primary key
+ (NSString *)primaryKey;

+ (void)generateTestBookData;
+ (void)generateClassicBooks;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<PGBRealmBook>
RLM_ARRAY_TYPE(PGBRealmBook)
