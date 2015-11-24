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
    self = [self initWithTitle:@"" author:@"" genre:@"" language:@"" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0 isDownloaded:NO isBookmarked:NO];
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                       author:(NSString *)author
                        genre:(NSString *)genre
                     language:(NSString *)language
                  downloadURL:(NSString *)downloadURL
              bookDescription:(NSString *)bookDescription
                datePublished:(NSDate *)datePublished
                      ebookID:(NSInteger)ebookID
                 isDownloaded:(BOOL)isDownloaded
                 isBookmarked:(BOOL)isBookmarked{

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
        _isDownloaded = isDownloaded;
        _isBookmarked = isBookmarked;
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
        PGBRealmBook *book1 = [[PGBRealmBook alloc]initWithTitle:@"Norwegian Wood" author:@"Haruki Murakami" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"This stunning and elegiac novel by the author of the internationally acclaimed Wind-Up Bird Chronicle has sold over 4 million copies in Japan and is now available to American audiences for the first time.  It is sure to be a literary event.\nToru, a quiet and preternaturally serious young college student in Tokyo, is devoted to Naoko, a beautiful and introspective young woman, but their mutual passion is marked by the tragic death of their best friend years before.  Toru begins to adapt to campus life and the loneliness and isolation he faces there, but Naoko finds the pressures and responsibilities of life unbearable.  As she retreats further into her own world, Toru finds himself reaching out to others and drawn to a fiercely independent and sexually liberated young woman.\nA poignant story of one college student's romantic coming-of-age, Norwegian Wood takes us to that distant place of a young man's first, hopeless, and heroic love." datePublished:[NSDate date] ebookID:0 isDownloaded:YES isBookmarked:NO];
        [PGBRealmBook storeUserBookDataWithBook:book1];
        
        PGBRealmBook *book2 = [[PGBRealmBook alloc]initWithTitle:@"Kafka on the Shore" author:@"Haruki Murakami" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"Kafka on the Shore, a tour de force of metaphysical reality, is powered by two remarkable characters: a teenage boy, Kafka Tamura, who runs away from home either to escape a gruesome oedipal prophecy or to search for his long-missing mother and sister; and an aging simpleton called Nakata, who never recovered from a wartime affliction and now is drawn toward Kafka for reasons that, like the most basic activities of daily life, he cannot fathom. Their odyssey, as mysterious to them as it is to us, is enriched throughout by vivid accomplices and mesmerizing events. Cats and people carry on conversations, a ghostlike pimp employs a Hegel-quoting prostitute, a forest harbors soldiers apparently unaged since World War II, and rainstorms of fish (and worse) fall from the sky. There is a brutal murder, with the identity of both victim and perpetrator a riddle - yet this, along with everything else, is eventually answered, just as the entwined destinies of Kafka and Nakata are gradually revealed, with one escaping his fate entirely and the other given a fresh start on his own." datePublished:[NSDate date] ebookID:0 isDownloaded:YES isBookmarked:YES];
        [PGBRealmBook storeUserBookDataWithBook:book2];
        
        PGBRealmBook *book3 = [[PGBRealmBook alloc]initWithTitle:@"Catcher In the Rye" author:@"J.D. Salinger" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"'...the first thing you'll probably want to know is where I was born and what my lousy childhood was like, and how my parents were occupied and all before they had me, and all that David Copperfield kind of crap, but I don't feel like going into it, if you want to know the truth. In the first place, that stuff bores me, and in the second place, my parents would have about two hemorrhages apiece if I told anything pretty personal about them.'\nSince his debut in 1951 as The Catcher in the Rye, Holden Caulfield has been synonymous with 'cynical adolescent.' Holden narrates the story of a couple of days in his sixteen-year-old life, just after he's been expelled from prep school, in a slang that sounds edgy even today and keeps this novel on banned book lists. His constant wry observations about what he encounters, from teachers to phonies (the two of course are not mutually exclusive) capture the essence of the eternal teenage experience of alienation." datePublished:[NSDate date] ebookID:0 isDownloaded:NO isBookmarked:YES];
        [PGBRealmBook storeUserBookDataWithBook:book3];
        
        PGBRealmBook *book4 = [[PGBRealmBook alloc]initWithTitle:@"The Hunger Games (Book 1)" author:@"Suzanne Collins" genre:@"Adventure" language:@"English" downloadURL:@"" bookDescription:@"In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. Long ago the districts waged war on the Capitol and were defeated. As part of the surrender terms, each district agreed to send one boy and one girl to appear in an annual televised event called, 'The Hunger Games,' a fight to the death on live TV. Sixteen-year-old Katniss Everdeen, who lives alone with her mother and younger sister, regards it as a death sentence when she is forced to represent her district in the Games. The terrain, rules, and level of audience participation may change but one thing is constant: kill or be killed." datePublished:[NSDate date] ebookID:0 isDownloaded:NO isBookmarked:YES];

        [PGBRealmBook storeUserBookDataWithBook:book4];
    }
}

@end
