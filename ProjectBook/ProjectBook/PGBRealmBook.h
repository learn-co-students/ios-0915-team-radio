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

+ (NSString *)primaryKey; //override primary key
+ (void)fetchUserBookDataFromParseStoreToRealmWithCompletion:(void (^)())completionBlock;
+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book;
+ (void)storeUserBookDataWithBookwithUpdateBlock:(PGBRealmBook *(^)())updateBlock andCompletion:(void (^)())completionBlock;
+ (void)storeUserBookDataFromRealmStoreToParseWithRealmBook:(PGBRealmBook *)realmBook andCompletion:(void (^)())completionBlock;
+ (void)deleteUserBookDataForBook:(PGBRealmBook *)book andCompletion:(void (^)())completionBlock;
+ (void)deleteAllUserBookDataWithCompletion:(void (^)())completionBlock;
+ (void)updateParseWithRealmBookDataWithCompletion:(void (^)(BOOL success))completionBlock;
+ (PGBRealmBook *)findRealmBookInRealDatabaseWithRealmBook:(PGBRealmBook *)bookToBeFound;

+ (RLMResults *)getUserBookData;
+ (NSArray *)getUserBookDataInArray;
+ (PGBRealmBook *)createPGBRealmBookWithBook:(Book *)book;
+ (PGBRealmBook *)generateBooksWitheBookID:(NSString *)ebookID;
+ (BOOL)validateBookDataWithRealmBook:(PGBRealmBook *)realmBook;

- (NSString *)getAuthorFromFriendlyTitle:(NSString *)friendlyTitle;
- (BOOL)checkFriendlyTitleIfItHasAuthor:(NSString *)friendlyTitle;
- (NSString *)parseAuthor:(NSString *)author;


@end

RLM_ARRAY_TYPE(PGBRealmBook)
