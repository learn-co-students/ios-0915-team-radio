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
    //[realm addObject:book];
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
    

    //LEO - preprocessor has already taken care of the issues below:
//    if ([realmBook checkFriendlyTitleIfItHasAuthor:realmBook.friendlyTitle])
//    {
//        realmBook.author = [realmBook getAuthorFromFriendlyTitle:realmBook.friendlyTitle];
//        if (!realmBook.author) {
//            realmBook.author = [realmBook parseAuthor:realmBook.author];
//        }
//    }
    
        //LEO - this casue performance issue
//    realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
//    realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
//    
//    realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:@"ò" withString:@"o"];
//    realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:@"ò" withString:@"o"];
//    
//    realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:@"ë" withString:@"e"];
//    realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:@"ë" withString:@"e"];
//    
//    NSArray *aCharacters = @[ @"à", @"á", @"â", @"ä", @"æ", @"ã", @"å", @"ā" ];
//    NSArray *eCharacters = @[ @"è", @"é", @"ê", @"ë", @"ē", @"ė", @"ę" ];
//    NSArray *iCharacters = @[ @"î", @"ï", @"í", @"ī", @"į", @"ì" ];
//    NSArray *oCharacters = @[ @"ô", @"ö", @"ò", @"ó", @"ø", @"ō", @"õ" ];
//    NSArray *uCharacters = @[ @"û", @"ü", @"ù", @"ú", @"ū", @"u" ];
//    NSArray *nCharacters = @[ @"ñ", @"ń"];
//
//    realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:@"ÿ" withString:@"y"];
//    realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:@"ß" withString:@"ss"];
//    
//    for (NSString *special in nCharacters) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:special withString:@"n"];
//        realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:special withString:@"n"];
//    }
//    
//    for (NSString *special in aCharacters) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:special withString:@"a"];
//        realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:special withString:@"a"];
//    }
//    
//    for (NSString *special in eCharacters) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:special withString:@"e"];
//        realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:special withString:@"e"];
//    }
//    
//    for (NSString *special in iCharacters) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:special withString:@"i"];
//        realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:special withString:@"i"];
//    }
//    
//    for (NSString *special in oCharacters) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:special withString:@"o"];
//        realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:special withString:@"o"];
//    }
//    
//    for (NSString *special in uCharacters) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:special withString:@"u"];
//        realmBook.author = [realmBook.author stringByReplacingOccurrencesOfString:special withString:@"u"];
//    }
    
    //for genre
    //LEO - this casue performance issue 
//    if ([realmBook.genre containsString:@"Comedy"]){
//        realmBook.genre = @"Comedy";
//    } else if ([realmBook.genre containsString:@"Operas"]){
//        realmBook.genre = @"Opera";
//    } else if ([realmBook.genre containsString:@"Romances"]){
//        realmBook.genre = @"Romance";
//    } else if ([realmBook.genre containsString:@"Biography"]){
//        realmBook.genre = @"Biography";
//    } else if ([realmBook.genre containsString:@"Short stories"]){
//        realmBook.genre = @"Short Stories";
//    } else if ([realmBook.genre containsString:@"Children's stories"]){
//        realmBook.genre = @"Children's Stories";
//    } else if ([realmBook.genre containsString:@"Political ethics"]){
//        realmBook.genre = @"Political ethics";
//    } else if ([realmBook.genre containsString:@"Epic literature"]){
//        realmBook.genre = @"Epic Literature";
//    } else if ([realmBook.genre containsString:@"Epic poetry"]){
//        realmBook.genre = @"Epic Poetry";
//    } else if ([realmBook.genre containsString:@"Fables"]){
//        realmBook.genre = @"Fables";
//    } else if ([realmBook.genre containsString:@"Classical literature"]){
//        realmBook.genre = @"Classical Literature";
//    } else if ([realmBook.genre containsString:@"Ethics"]){
//        realmBook.genre = @"Ethics";
//    } else if ([realmBook.genre containsString:@"Sonnets"]){
//        realmBook.genre = @"Sonnets";
//    } else if ([realmBook.genre containsString:@"Fairy plays"]){
//        realmBook.genre = @"Fairy plays";
//    } else if ([realmBook.genre containsString:@"Children's literature"]){
//        realmBook.genre = @"Children's Literature";
//    } else if ([realmBook.genre containsString:@"Tragicomedy"]){
//        realmBook.genre = @"Tragicomedy";
//    } else if ([realmBook.genre containsString:@"Apologetics"]){
//        realmBook.genre = @"Apologetics";
//    } else if ([realmBook.genre containsString:@"God"]){
//        realmBook.genre = @"Religion";
//    } else if ([realmBook.genre containsString:@"Literature"]){
//        realmBook.genre = @"Literature";
//    } else if ([realmBook.genre containsString:@"Science"]){
//        realmBook.genre = @"Science";
//    } else if ([realmBook.genre containsString:@"Musical notation"]){
//        realmBook.genre = @"Musical notation";
//    } else if ([realmBook.genre containsString:@"Renaissance"]){
//        realmBook.genre = @"Renaissance";
//    } else if ([realmBook.genre containsString:@"Fairy tales"]){
//        realmBook.genre = @"Fairy tales";
//    } else if ([realmBook.genre containsString:@"Juvenile literature"]){
//        realmBook.genre = @"Juvenile literature";
//    } else if ([realmBook.genre containsString:@"Latin poetry"]){
//        realmBook.genre = @"Latin poetry";
//    } else if ([realmBook.genre containsString:@"Satire"]){
//        realmBook.genre = @"Satire";
//    } else if ([realmBook.genre containsString:@"Women"]){
//        realmBook.genre = @"Women";
//    } else if ([realmBook.genre containsString:@"Popular music"]){
//        realmBook.genre = @"Popular Music";
//    } else if ([realmBook.genre containsString:@"Juvenile poetry"]){
//        realmBook.genre = @"Juvenile Poetry";
//    } else if ([realmBook.genre containsString:@"Mathematics"]){
//        realmBook.genre = @"Mathematics";
//    } else if ([realmBook.genre containsString:@"Folklore"]){
//        realmBook.genre = @"Folklore";
//    } else if ([realmBook.genre containsString:@"Adventure"]){
//        realmBook.genre = @"Adventure";
//    } else if ([realmBook.genre containsString:@"Psychology"]){
//        realmBook.genre = @"Psychology";
//    } else if ([realmBook.genre containsString:@"Love stories"]){
//        realmBook.genre = @"Love Stories";
//    } else if ([realmBook.genre containsString:@"Editorials"]){
//        realmBook.genre = @"Editorials";
//    } else if ([realmBook.genre containsString:@"classics"]){
//        realmBook.genre = @"Classics";
//    } else if ([realmBook.genre containsString:@"Classics"]){
//        realmBook.genre = @"Classics";
//    } else if ([realmBook.genre containsString:@"Art"]){
//        realmBook.genre = @"Art";
//    } else if ([realmBook.genre containsString:@"Bible"]){
//        realmBook.genre = @"Bible";
//    } else if ([realmBook.genre containsString:@"Fantasy"]){
//        realmBook.genre = @"Fantasy";
//    } else if ([realmBook.genre containsString:@"Textbooks"]){
//        realmBook.genre = @"Textbook";
//    } else if ([realmBook.genre containsString:@"Shakespeare"]){
//        realmBook.genre = @"Shakespeare";
//    } else if ([realmBook.genre containsString:@"Architecture"]){
//        realmBook.genre = @"Architecture";
//    } else if ([realmBook.genre containsString:@"Business"]){
//        realmBook.genre = @"Business";
//    } else if ([realmBook.genre containsString:@"Philosophy"]){
//        realmBook.genre = @"Philosophy";
//    } else if ([realmBook.genre containsString:@"Juvenile fiction"]){
//        realmBook.genre = @"Juvenile Fiction";
//    } else if ([realmBook.genre containsString:@"Economics"]){
//        realmBook.genre = @"Economics";
//    } else if ([realmBook.genre containsString:@"Philosophy"]){
//        realmBook.genre = @"Philosophy";
//    } else if ([realmBook.genre containsString:@"Mystery"]){
//        realmBook.genre = @"Mystery";
//    } else if ([realmBook.genre containsString:@"Fiction"]){
//        realmBook.genre = @"Fiction";
//    } else if ([realmBook.genre containsString:@"Drama"]){
//        realmBook.genre = @"Drama";
//    } else if ([realmBook.genre containsString:@"Poetry"]){
//        realmBook.genre = @"Poetry";
//    } else if ([realmBook.genre containsString:@"drama"]){
//        realmBook.genre = @"Drama";
//    } else if ([realmBook.genre containsString:@"History"]){
//        realmBook.genre = @"History";
//    } else if ([realmBook.genre containsString:@"fiction"]){
//        realmBook.genre = @"Fiction";
//    } else if ([realmBook.genre containsString:@"poetry"]){
//        realmBook.genre = @"Poetry";
//    } else {
//        realmBook.genre = nil;
//        //        NSLog (@"genresss:%@", realmBook.genre);
//    }
    
//    else {
//        realmBook.genre = nil;
//    }
    

    //for punctuation
    //LEO - this cause performance issue
//    if ([realmBook.title containsString:@"&quot;"]) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    } else if ([realmBook.title containsString:@"&amp;"]) {
//        realmBook.title = [realmBook.title stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//    }
    

    //for language
    //LEO - this cause performance issue 
//    if ([realmBook.language isEqualToString:@"en"]){
//        realmBook.language = @"English";
//    } else if ([realmBook.language isEqualToString:@"de"]){
//        realmBook.language = @"German";
//    } else if ([realmBook.language isEqualToString:@"fr"]){
//        realmBook.language = @"French";
//    } else if ([realmBook.language isEqualToString:@"it"]){
//        realmBook.language = @"Italian";
//    } else if ([realmBook.language isEqualToString:@"fi"]){
//        realmBook.language = @"Finnish";
//    } else if ([realmBook.language isEqualToString:@"zh"]){
//        realmBook.language = @"Chinese";
//    } else if ([realmBook.language isEqualToString:@"es"]){
//        realmBook.language = @"Spanish";
//    } else if ([realmBook.language isEqualToString:@"pt"]){
//        realmBook.language = @"Portuguese";
//    } else if ([realmBook.language isEqualToString:@"tr"]){
//        realmBook.language = @"Turkish";
//    } else if ([realmBook.language isEqualToString:@"el"]){
//        realmBook.language = @"Greek";
//    }  else if ([realmBook.language isEqualToString:@"eo"]){
//        realmBook.language = @"Esperanto";
//    }  else if ([realmBook.language isEqualToString:@"la"]){
//        realmBook.language = @"Latin";
//    }  else if ([realmBook.language isEqualToString:@"hu"]){
//        realmBook.language = @"Hungarian";
//    } else if ([realmBook.language isEqualToString:@"ru"]){
//        realmBook.language = @"Russian";
//    }  else if ([realmBook.language isEqualToString:@"nl"]){
//        realmBook.language = @"Dutch";
//    }  else if ([realmBook.language isEqualToString:@"pl"]){
//        realmBook.language = @"Polish";
//    }   else if ([realmBook.language isEqualToString:@"tl"]){
//        realmBook.language = @"Tagalog";
//    }  else if ([realmBook.language isEqualToString:@"ca"]){
//        realmBook.language = @"Catalan";
//    }  else if ([realmBook.language isEqualToString:@"da"]){
//        realmBook.language = @"Danish";
//    }  else if ([realmBook.language isEqualToString:@"no"]){
//        realmBook.language = @"Norwegian";
//    }  else if ([realmBook.language isEqualToString:@"ja"]){
//        realmBook.language = @"Japanese";
//    }  else if ([realmBook.language isEqualToString:@"sl"]){
//        realmBook.language = @"Slovenian";
//    }  else if ([realmBook.language isEqualToString:@"bg"]){
//        realmBook.language = @"Bulgarian";
//    }  else if ([realmBook.language isEqualToString:@"sv"]){
//        realmBook.language = @"Swedish";
//    }  else if ([realmBook.language isEqualToString:@"cs"]){
//        realmBook.language = @"Czech";
//    }  else if ([realmBook.language isEqualToString:@"ia"]){
//        realmBook.language = @"Interlingua";
//    }  else if ([realmBook.language isEqualToString:@"ilo"]){
//        realmBook.language = @"Iloko";
//    }  else if ([realmBook.language isEqualToString:@"he"]){
//        realmBook.language = @"Hebrew";
//    }  else if ([realmBook.language isEqualToString:@"te"]){
//        realmBook.language = @"Telugu";
//    }  else if ([realmBook.language isEqualToString:@"is"]){
//        realmBook.language = @"Icelandic";
//    }  else if ([realmBook.language isEqualToString:@"lt"]){
//        realmBook.language = @"Lithuanian";
//    }  else if ([realmBook.language isEqualToString:@"br"]){
//        realmBook.language = @"Breton";
//    }  else if ([realmBook.language isEqualToString:@"cy"]){
//        realmBook.language = @"Welsh";
//    }  else if ([realmBook.language isEqualToString:@"af"]){
//        realmBook.language = @"Afrikaans";
//    }
//    
//    else {
//        NSLog (@"language needs to be changed: %@", realmBook.language);
//    }
    
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
//        [realmBook.author isEqualToString:@"Various"] ||
//        [realmBook.author isEqualToString:@"Unknown"] ||
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
                    
                    //                [PGBRealmBook storeUserBookDataFromRealmStoreToParseWithRealmBook:realmBook andCompletion:^{
                    //                    completionBlock();
                    //                }];
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

@end
