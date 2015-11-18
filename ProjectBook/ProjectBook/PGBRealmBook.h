//
//  PGBRealmBook.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Realm/Realm.h>

@interface PGBRealmBook : RLMObject
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *author;
@property (strong, nonatomic)NSString *genre;
@property (strong, nonatomic)NSDate *yearPublished;
@property (assign, nonatomic)NSInteger rating;
@property (strong, nonatomic)NSData *bookFile;
@property (assign, nonatomic)BOOL isDownloaded;



- (instancetype)init;
- (instancetype)initWithTitle:(NSString *)title;
+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book;
+ (void)deleteUserBookDataForBook:(PGBRealmBook *)book;
+ (RLMResults *)getUserBookData;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<PGBRealmBook>
RLM_ARRAY_TYPE(PGBRealmBook)
