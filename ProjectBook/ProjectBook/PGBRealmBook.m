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

+ (NSString *)primaryKey {
    return @"ebookID";
}

+ (void)storeUserBookDataWithBookwithUpdateBlock:(PGBRealmBook *(^)())updateBlock {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
//    [realm addObject:book];
    PGBRealmBook *book = updateBlock();
    [realm addOrUpdateObject:book];
    [realm commitWriteTransaction];
}

+ (void)storeUserBookDataWithBook:(PGBRealmBook *)book{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:book];
    
    [realm addOrUpdateObject:book];
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

//+ (void)generateTestBookData{
//    if (![PGBRealmBook getUserBookDataInArray].count) {
//        PGBRealmBook *book1 = [[PGBRealmBook alloc]initWithTitle:@"Norwegian Wood" author:@"Haruki Murakami" genre:@"Fiction" language:@"English" friendlyTitle: @"" downloadURL:@"" bookDescription:@"This stunning and elegiac novel by the author of the internationally acclaimed Wind-Up Bird Chronicle has sold over 4 million copies in Japan and is now available to American audiences for the first time.  It is sure to be a literary event.\nToru, a quiet and preternaturally serious young college student in Tokyo, is devoted to Naoko, a beautiful and introspective young woman, but their mutual passion is marked by the tragic death of their best friend years before.  Toru begins to adapt to campus life and the loneliness and isolation he faces there, but Naoko finds the pressures and responsibilities of life unbearable.  As she retreats further into her own world, Toru finds himself reaching out to others and drawn to a fiercely independent and sexually liberated young woman.\nA poignant story of one college student's romantic coming-of-age, Norwegian Wood takes us to that distant place of a young man's first, hopeless, and heroic love." datePublished:[NSDate date] ebookID:@"" isDownloaded:YES isBookmarked:NO bookCoverData:nil];
//        
//        [PGBRealmBook storeUserBookDataWithBook:book1];
//        
//        PGBRealmBook *book2 = [[PGBRealmBook alloc]initWithTitle:@"Kafka on the Shore" author:@"Haruki Murakami" genre:@"Fiction" language:@"English" friendlyTitle:@"" downloadURL:@"" bookDescription:@"Kafka on the Shore, a tour de force of metaphysical reality, is powered by two remarkable characters: a teenage boy, Kafka Tamura, who runs away from home either to escape a gruesome oedipal prophecy or to search for his long-missing mother and sister; and an aging simpleton called Nakata, who never recovered from a wartime affliction and now is drawn toward Kafka for reasons that, like the most basic activities of daily life, he cannot fathom. Their odyssey, as mysterious to them as it is to us, is enriched throughout by vivid accomplices and mesmerizing events. Cats and people carry on conversations, a ghostlike pimp employs a Hegel-quoting prostitute, a forest harbors soldiers apparently unaged since World War II, and rainstorms of fish (and worse) fall from the sky. There is a brutal murder, with the identity of both victim and perpetrator a riddle - yet this, along with everything else, is eventually answered, just as the entwined destinies of Kafka and Nakata are gradually revealed, with one escaping his fate entirely and the other given a fresh start on his own." datePublished:[NSDate date] ebookID:0 isDownloaded:YES isBookmarked:YES bookCoverData:nil];
//        [PGBRealmBook storeUserBookDataWithBook:book2];
//        
//        PGBRealmBook *book3 = [[PGBRealmBook alloc]initWithTitle:@"Catcher In the Rye" author:@"J.D. Salinger" genre:@"Fiction" language:@"English" friendlyTitle:@"" downloadURL:@"" bookDescription:@"'...the first thing you'll probably want to know is where I was born and what my lousy childhood was like, and how my parents were occupied and all before they had me, and all that David Copperfield kind of crap, but I don't feel like going into it, if you want to know the truth. In the first place, that stuff bores me, and in the second place, my parents would have about two hemorrhages apiece if I told anything pretty personal about them.'\nSince his debut in 1951 as The Catcher in the Rye, Holden Caulfield has been synonymous with 'cynical adolescent.' Holden narrates the story of a couple of days in his sixteen-year-old life, just after he's been expelled from prep school, in a slang that sounds edgy even today and keeps this novel on banned book lists. His constant wry observations about what he encounters, from teachers to phonies (the two of course are not mutually exclusive) capture the essence of the eternal teenage experience of alienation." datePublished:[NSDate date] ebookID:0 isDownloaded:NO isBookmarked:YES bookCoverData:nil];
//        [PGBRealmBook storeUserBookDataWithBook:book3];
//        
//        PGBRealmBook *book4 = [[PGBRealmBook alloc]initWithTitle:@"The Hunger Games (Book 1)" author:@"Suzanne Collins" genre:@"Adventure" language:@"English" friendlyTitle:@"" downloadURL:@"" bookDescription:@"In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. Long ago the districts waged war on the Capitol and were defeated. As part of the surrender terms, each district agreed to send one boy and one girl to appear in an annual televised event called, 'The Hunger Games,' a fight to the death on live TV. Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she is forced to represent her district in the Games. The terrain, rules, and level of audience participation may change but one thing is constant: kill or be killed." datePublished:[NSDate date] ebookID:0 isDownloaded:NO isBookmarked:YES bookCoverData:nil];
//        
//        [PGBRealmBook storeUserBookDataWithBook:book4];
//    }
//}

+(void)generateClassicBooks {
    if (![PGBRealmBook getUserBookDataInArray].count) {
        PGBRealmBook *prideAndPrejudice = [[PGBRealmBook alloc]initWithTitle:@"Pride and Prejudice" author:@"Jane Austen" genre:@"Fiction" language:@"English" friendlyTitle:@"" downloadURL:@"https://www.gutenberg.org/ebooks/1342.epub.images" bookDescription:@"\"It is a truth universally acknowledged, that a single man in possession of a good fortune must be in want of a wife.\"\nSo begins Pride and Prejudice, Jane Austen's witty comedy of manners--one of the most popular novels of all time--that features splendidly civilized sparring between the proud Mr. Darcy and the prejudiced Elizabeth Bennet as they play out their spirited courtship in a series of eighteenth-century drawing-room intrigues." ebookID:nil isDownloaded:NO isBookmarked:nil bookCoverData:nil];
        
        [PGBRealmBook storeUserBookDataWithBook:prideAndPrejudice];
    }
    
    
} 

                                    

+ (PGBRealmBook *)createPGBRealmBookWithBook:(Book *)coreDataBook {
    
    PGBRealmBook *realmBook = [[PGBRealmBook alloc]init];
    //leo here
    realmBook.ebookID = coreDataBook.eBookNumbers;
    realmBook.genre = coreDataBook.eBookGenres;
    realmBook.author = coreDataBook.eBookAuthors;
    realmBook.title = coreDataBook.eBookTitles;
    realmBook.friendlyTitle = coreDataBook.eBookFriendlyTitles;
    realmBook.language = coreDataBook.eBookLanguages;
    
    if ([realmBook.language isEqualToString:@"en"]) {
        realmBook.language = @"English";
    } else if ([realmBook.language isEqualToString:@"de"]) {
        realmBook.language = @"German";
    } else if ([realmBook.language isEqualToString:@"fr"]) {
        realmBook.language = @"French";
    } else if ([realmBook.language isEqualToString:@"it"]) {
        realmBook.language = @"Italian";
    }
    
    if ([self validateBookDataWithRealmBook:realmBook]) {
        return realmBook;
        
    } else {
        return nil;
    }
    
    
    //end leo
    
    
    
////    first need to check if a book has an eBookNumber, if not, then it should not be shown
////    realmBook.ebookID = coreDataBook.eBookNumbers;
//    
//    if (coreDataBook.eBookNumbers.length == 0 ||
//        (coreDataBook.eBookTitles.length == 0 && coreDataBook.eBookFriendlyTitles.length == 0)) {
//        return nil;
//    }
//    
//    realmBook.title = coreDataBook.eBookTitles;
//    
//    realmBook.author = coreDataBook.eBookAuthors;
//    if ([coreDataBook.eBookAuthors isEqualToString:@""])
//    {
//        //if the author information is missing, check to see if friendly title information is present
//        if (![coreDataBook.eBookFriendlyTitles isEqualToString:@""])
//        {
//            
//            /*
//             
//             if friendly title information is present, check to see its of the correct format (Book Title by Author)
//             to check it has all three components ("book title", the word "by", and "book author") turn the friendly title into an array
//             
//             Example:
//             Original Friendly Title as String: "Harry Potter by J.K. Rowling"
//             New Format as an Array: @[@"Harry", @"Potter", @"by", @"J.K.", @"Rowling"];
//             
//             Everything before the string "by", is the title, everything after, is the author's name
//             
//             */
//            
//            //next step, check if the array contains the string "by"
//            //if it does, friendly title has the correct format, if not, then it doesn't
//            NSArray *stringToArray = [coreDataBook.eBookFriendlyTitles componentsSeparatedByString:@" "];
//            
//            if ([stringToArray containsObject:@"by"])
//            {
//                //here, the friendly title does contain the string "by", and so is of the correct format
//                //next step is to get the author of the book without the title
//                //this means we must get all the strings after the word "by"
//                NSMutableArray *mutableStringToArray = [stringToArray mutableCopy];
//                
//                //we find the index of element "by", and then append every element after that index to a string, in order to get the book title
//                NSUInteger indexOfStringBy = [mutableStringToArray indexOfObject:@"by"];
//                
//                //here we remove by, and everything before it, now the array is just the authors name
//                [mutableStringToArray removeObjectsInRange:NSMakeRange(0, indexOfStringBy)];
//                
//                NSMutableString *authorName = [NSMutableString new];
//                
//                //append the array elements (authors name) to a string
//                for (NSString *element in mutableStringToArray)
//                {
//                    [authorName appendString:element];
//                    
//                    //add a space so the name isn't one word
//                    //this also adds a space to the end of the last word
//                    [authorName appendString:@" "];
//                }
//                
//                //need to remove the last character in the string which is just a space
//                [authorName substringToIndex:authorName.length-1];
//                realmBook.author = authorName;
//            }
//        } //if there is no book author, or friendly title, then it remains empty
//        else if ([coreDataBook.eBookAuthors isEqualToString:@""]) {
//            realmBook.author = @"";
//        }
//    }
    

}
+(BOOL)validateBookDataWithRealmBook:(PGBRealmBook *)realmBook{
    
    if (realmBook.title.length == 0 ||
        realmBook.author.length == 0 || [realmBook.author isEqualToString:@"Various"] || [realmBook.author isEqualToString:@"Unknown"] || realmBook.ebookID.length == 0) {
        return NO;
    }
    
    return YES;
}


+ (PGBRealmBook *)createPGBRealmBookContainingCoverImageWithBook:(Book *)coreDataBook {
    
    PGBRealmBook *realmBook = [PGBRealmBook createPGBRealmBookWithBook:coreDataBook];
    
    NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:coreDataBook.eBookNumbers]];
    realmBook.bookCoverData = bookCoverData;
    
    return realmBook;
}

+ (NSURL *)createBookCoverURL:(NSString *)eBookNumber {
    
    if (eBookNumber.length) {
        
        NSString *eBookNumberParsed = [eBookNumber substringFromIndex:5];
        NSString *bookCoverURL = [NSString stringWithFormat:@"https://www.gutenberg.org/cache/epub/%@/pg%@.cover.medium.jpg", eBookNumberParsed, eBookNumberParsed];
        
        NSURL *url = [NSURL URLWithString:bookCoverURL];
        
        return url;
    }
    
    return nil;
}

+ (void)fetchUserBookDataFromParseStoreToRealmWithCompletion:(void (^)())completionBlock {
    
    [PGBParseAPIClient fetchUserBookDataWithUserObject:[PFUser currentUser] andCompletion:^(NSArray *books) {
        for (NSDictionary *book in books) {
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
            
            if (realmBook.ebookID.length) {
                NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:realmBook.ebookID]];
                if (bookCoverData) {
                    realmBook.bookCoverData = bookCoverData;
                }
//                realmBook.bookCoverData = bookCoverData;
            }

            
            [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
                return realmBook;
            }];
        }
        
        completionBlock();
    }];
}

+ (void)storeUserBookDataFromRealmStoreToParseWithRealmBook:(PGBRealmBook *)realmBook andCompletion:(void (^)())completionBlock {
    
//    [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
    
        [PGBParseAPIClient storeUserBookDataWithUserObject:[PFUser currentUser] realmBookObject:realmBook andCompletion:^(PFObject *bookObject) {
            completionBlock();
        }];
        
//        return realmBook;
//    }];

}



@end
