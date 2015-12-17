//
//  PGBRealmBook.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBRealmBook.h"
#import "PGBHomeViewController.h"
#import "PGBParseAPIClient.h"
#import "PGBDataStore.h"

@implementation PGBRealmBook

- (instancetype)init{
    self = [self initWithTitle:@"" author:@"" genre:@"" language:@"" friendlyTitle:@"" downloadURL:@"" bookDescription:@"" ebookID:@"" isDownloaded:0 isBookmarked:0 bookCoverData:[[NSData alloc]init]];
    return self;
}

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
                bookCoverData:(NSData *)bookCoverData {
    
    self = [super init];
    if (self) {
        _title = title;
        _author = author;
        _genre = genre;
        _language = language;
        _friendlyTitle = friendlyTitle;
        _downloadURL = downloadURL;
        _bookDescription = bookDescription;
        _ebookID = ebookID;
        _isDownloaded = isDownloaded;
        _isBookmarked = isBookmarked;
        _bookCoverData = bookCoverData;
    }
    return self;
    
}

+ (NSString *)primaryKey
{
    return @"ebookID";
}

+ (void)storeUserBookDataWithBookwithUpdateBlock:(PGBRealmBook *(^)())updateBlock andCompletion:(void (^)())completionBlock{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];

    PGBRealmBook *book = updateBlock();
    [realm addOrUpdateObject:book];
    
    [realm commitWriteTransaction];
    
    completionBlock();
}

+ (void)storeUserBookDataWithBooks:(NSArray *)books andCompletion:(void (^)())completionBlock{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    for (PGBRealmBook *book in books) {
        [realm addOrUpdateObject:book];
    }

    [realm commitWriteTransaction];
    
    completionBlock();
}

+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:book];
    
    [realm addOrUpdateObject:book];
    [realm commitWriteTransaction];
}

+ (void)deleteUserBookDataForBook:(PGBRealmBook *)book andCompletion:(void (^)())completionBlock{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:book];
    [realm commitWriteTransaction];
    
    completionBlock();
}

+ (void)deleteAllUserBookDataWithCompletion:(void (^)())completionBlock{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    completionBlock();
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

+ (NSArray *)getUserBookDataInArrayIncludingCoverData{
    RLMResults *books = [PGBRealmBook allObjects];
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (PGBRealmBook *book in books) {
        
        NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:book.ebookID]];
        
        if (bookCoverData) {
            book.bookCoverData = bookCoverData;
        }
        
        [result addObject:book];
    }
    return result;
}

+(PGBRealmBook *)generateBooksWitheBookID:(NSString *)ebookID {
    
    PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"eBookNumbers == %@", ebookID];
    NSArray *coreDataBooks = [dataStore.managedBookObjects filteredArrayUsingPredicate:filter];
    
    return [PGBRealmBook createPGBRealmBookWithBook:[coreDataBooks firstObject]];
}


+ (PGBRealmBook *)createPGBRealmBookWithBook:(Book *)coreDataBook
{
    PGBRealmBook *realmBook = [[PGBRealmBook alloc]init];
    realmBook.ebookID = coreDataBook.eBookNumbers;
    realmBook.genre = coreDataBook.eBookGenres;
    realmBook.title = coreDataBook.eBookTitles;
    realmBook.friendlyTitle = coreDataBook.eBookFriendlyTitles;
    realmBook.language = coreDataBook.eBookLanguages;
    realmBook.author = coreDataBook.eBookAuthors;
    
    if ([self validateBookDataWithRealmBook:realmBook]){
        return realmBook;
    } else {
        return nil;
    }
    
}

- (BOOL)checkFriendlyTitleIfItHasAuthor:(NSString *)friendlyTitle
{
    if ([friendlyTitle containsString:@"by"])
    {
        NSMutableArray *wordsInFriendlyTitleInArray = [[friendlyTitle componentsSeparatedByString: @" "] mutableCopy];
        NSInteger index = [wordsInFriendlyTitleInArray indexOfObject:@"by"];
        NSInteger afterIndex = index + 1;
        if (afterIndex < wordsInFriendlyTitleInArray.count)
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)getAuthorFromFriendlyTitle:(NSString *)friendlyTitle
{
    
    friendlyTitle = [friendlyTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray *wordsInFriendlyTitleInArray = [[friendlyTitle componentsSeparatedByString: @" "] mutableCopy];
    NSMutableString *authorName = [NSMutableString new];
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    
    
    
    /*
     if (![coreDataBook.eBookFriendlyTitles isEqualToString:@""])
    
    here, the friendly title does contain the string "by", and so is of the correct format
    next step is to get the author of the book without the title
    this means we must get all the strings after the word "by"
    
    we find the index of element "by", and then append every element after that index to a string, in order to get the book title
     */
    NSUInteger indexOfStringBy = [wordsInFriendlyTitleInArray indexOfObject:@"by"];
    
    /*
     here we remove by, and everything before it, now the array is just the authors name
     */
        [wordsInFriendlyTitleInArray removeObjectsInRange:NSMakeRange (0, indexOfStringBy+1)];

    for (NSString *string in wordsInFriendlyTitleInArray) {
        if (![string isEqualToString:@""]){
            BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:0]];
            if (isUppercase) {
                [newArray addObject:string];
            }
        }
    }
//      append the array elements (authors name) to a string
    if (newArray.count > 1) {
        for (NSString *nameOfAuthor in newArray)
        {
            [authorName appendString:nameOfAuthor];
            /*
             add a space so the name isn't one word
             this also adds a space to the end of the last word
             */
            [authorName appendString:@" "];
        }
        
        NSString *authorWithSpace = authorName;
        authorWithSpace = [authorWithSpace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return authorWithSpace;
    }
    
    return nil;
}



-(NSString *)parseAuthor:(NSString *)author {
    author = [author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *unnecesssary = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"-", @"?", @"(", @")", @"BC"];
    
    for (NSString *thing in unnecesssary) {
        if ([author containsString:thing]) {
            
            author = [author stringByReplacingOccurrencesOfString:thing withString:@""];
        }
    }
    author = [author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([author hasSuffix:@","]){
        author = [author substringToIndex:[author length]-1];
    }
    
    NSMutableArray *wordsInAuthorInArray = [[author componentsSeparatedByString: @" "] mutableCopy];
    NSMutableArray *authorArray = [[NSMutableArray alloc]init];
    
    for (NSString *string in wordsInAuthorInArray) {
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:0]];
        if (isUppercase) {
            [authorArray addObject:string];
        }
    }
    if ([authorArray.firstObject containsString:@","]) {
        NSString *lastName = authorArray.firstObject;
        [authorArray removeObject:lastName];
        [authorArray insertObject:lastName atIndex:authorArray.count];
    }
    
    NSMutableString *newAuthor = [[NSMutableString alloc]init];
    
    for (NSString *name in authorArray) {
        [newAuthor appendString:name];
        [newAuthor appendString:@" "];
    }
    
    author = newAuthor;
    
    author = [author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([author hasSuffix:@","]){
        author = [author substringToIndex:[author length]-1];
    }
    
    return author;
}

+(BOOL)validateBookDataWithRealmBook:(PGBRealmBook *)realmBook{
    
    if (realmBook.title.length == 0 ||
        realmBook.author.length == 0 ||
        realmBook.ebookID.length == 0)
    {
        return NO;
    }
    
    return YES;
}


+(PGBRealmBook *)createPGBRealmBookContainingCoverImageWithBook:(Book *)coreDataBook {
    
    PGBRealmBook *realmBook = [PGBRealmBook createPGBRealmBookWithBook:coreDataBook];
    
    NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:coreDataBook.eBookNumbers]];
    realmBook.bookCoverData = bookCoverData;
    
    return realmBook;
}

+(NSURL *)createBookCoverURL:(NSString *)eBookNumber {
    
    if (eBookNumber.length) {
        
        NSString *eBookNumberParsed = [eBookNumber substringFromIndex:5];
        NSString *bookCoverURL = [NSString stringWithFormat:@"https://www.gutenberg.org/cache/epub/%@/pg%@.cover.medium.jpg", eBookNumberParsed, eBookNumberParsed];
        
        NSURL *url = [NSURL URLWithString:bookCoverURL];
        
        return url;
    }
    
    return nil;
}

+(void)fetchUserBookDataFromParseStoreToRealmWithCompletion:(void (^)())completionBlock {
    
    [PGBParseAPIClient fetchUserBookDataWithUserObject:[PFUser currentUser] andCompletion:^(NSArray *books) {
        for (NSDictionary *book in books) {
            
            NSOperationQueue *bgQueue = [[NSOperationQueue alloc]init];
            
            [bgQueue addOperationWithBlock:^{
                PGBRealmBook *realmBook = [[PGBRealmBook alloc]init];
                realmBook.ebookID = book[@"eBookID"];
                realmBook.title = book[@"eBookTitle"];
                realmBook.friendlyTitle = book[@"eBookFriendlyTitle"];
                realmBook.author = book[@"eBookAuthor"];
                realmBook.genre = book[@"eBookGenre"];
                realmBook.language = book[@"eBookLanguage"];
                realmBook.bookDescription = book[@"eBookDescription"];
                realmBook.isDownloaded = [book[@"isDownloaded"] integerValue];
                realmBook.isBookmarked = [book[@"isBookmarked"] integerValue];
                
                if (realmBook.ebookID.length)
                {
                    NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:realmBook.ebookID]];
                    
                    if (bookCoverData)
                    {
                        realmBook.bookCoverData = bookCoverData;
                    }
                    
                    NSLog(@"begin storing to realm");
                    [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
                        return realmBook;
                    } andCompletion:^{
                        completionBlock();
                    }];
                    
                }
            }];
        }
        
        NSLog(@"end storing to realm");
    }];
}

+(void)storeUserBookDataFromRealmStoreToParseWithRealmBook:(PGBRealmBook *)realmBook andCompletion:(void (^)())completionBlock {
    
    [PGBParseAPIClient storeUserBookDataWithUserObject:[PFUser currentUser] realmBookObject:realmBook andCompletion:^(PFObject *bookObject) {
        completionBlock();
    }];
}

+(void)updateParseWithRealmBookDataWithCompletion:(void (^)(BOOL success))completionBlock{
    [PGBParseAPIClient deleteUserBookDataWithUserObject:[PFUser currentUser] andCompletion:^(BOOL success) {
        if (success) {
            NSArray *booksInRealm = [PGBRealmBook getUserBookDataInArray];
            
            if (booksInRealm.count) {
                for (PGBRealmBook *realmBook in booksInRealm) {
    
                    [PGBParseAPIClient storeUserBookDataWithUserObject:[PFUser currentUser] realmBookObject:realmBook andCompletion:^(PFObject *bookObject) {
                        completionBlock(YES);
                    }];
                }
            }
            
            completionBlock(YES);
        } else {
            completionBlock(NO);
        }
    }];
}

+(PGBRealmBook *)findRealmBookInRealDatabaseWithRealmBook:(PGBRealmBook *)bookToBeFound {
    RLMResults *result = [PGBRealmBook objectsWhere:@"ebookID = %@",bookToBeFound.ebookID];
    
    return [result firstObject];
}

@end
