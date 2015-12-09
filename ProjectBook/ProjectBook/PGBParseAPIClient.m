//
//  PGBParseAPIClient.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBParseAPIClient.h"


@implementation PGBParseAPIClient

+(void)fetchUserProfileDataWithUserObject:(PFObject *)userObject andCompletion:(void (^)(PFObject *data))completionBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId = %@", userObject.objectId];
    PFQuery *query = [PFUser queryWithPredicate:predicate];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error)
        {
            completionBlock(object);
        }else {
            NSLog(@"Unable to get user data from parse");
        }
    }];
}

+(void)fetchUserBookDataWithUserObject:(PFObject *)userObject andCompletion:(void (^)(NSArray *books))completionBlock
{
    PFQuery *query = [PFQuery queryWithClassName:@"book"];
    [query whereKey:@"owner" equalTo:userObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error)
        {
            completionBlock(objects);
        } else {
            NSLog(@"Unable to get book data from parse");
        }
    }];
    
}

+(void)storeUserBookDataWithUserObject:(PFObject *)userObject realmBookObject:(PGBRealmBook *)realmBook andCompletion:(void (^)(PFObject *bookObject))completionBlock
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eBookID = %@", realmBook.ebookID];
    
    PFQuery *query = [PFQuery queryWithClassName:@"book" predicate:predicate];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable bookObject, NSError * _Nullable error) {
        
        if (bookObject)
        {
            //NSLog(@"book exist - udpate book");
            bookObject[@"owner"] = userObject;
            bookObject[@"eBookID"] = realmBook.ebookID;
            bookObject[@"eBookAuthor"] = realmBook.author;
            bookObject[@"eBookTitle"] = realmBook.title;
            bookObject[@"eBookFriendlyTitle"] = realmBook.friendlyTitle;
            bookObject[@"eBookGenre"] = realmBook.genre;
            bookObject[@"eBookLanguage"] = realmBook.language;
            bookObject[@"eBookDescription"] = realmBook.bookDescription;
            bookObject[@"isDownloaded"] = [NSNumber numberWithBool:realmBook.isDownloaded];
            bookObject[@"isBookmarked"] = [NSNumber numberWithBool:realmBook.isBookmarked];
            
            [bookObject saveInBackground];

            completionBlock(bookObject);
            
        }else {
            
            NSLog(@"book doesn't - new book");
            PFObject *newBook = [PFObject objectWithClassName:@"book"];
            newBook[@"owner"] = userObject;
            newBook[@"eBookID"] = realmBook.ebookID;
            newBook[@"eBookAuthor"] = realmBook.author;
            newBook[@"eBookTitle"] = realmBook.title;
            newBook[@"eBookFriendlyTitle"] = realmBook.friendlyTitle;
            newBook[@"eBookGenre"] = realmBook.genre;
            newBook[@"eBookLanguage"] = realmBook.language;
            newBook[@"eBookDescription"] = realmBook.bookDescription;
            newBook[@"isDownloaded"] = [NSNumber numberWithBool:realmBook.isDownloaded];
            newBook[@"isBookmarked"] = [NSNumber numberWithBool:realmBook.isBookmarked];
    
            [newBook saveInBackground];
            
            completionBlock(newBook);

        }
        NSLog(@"error %@",error.localizedDescription);
    }];

}



@end
