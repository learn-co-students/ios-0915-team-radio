//
//  Book+CoreDataProperties.h
//  
//
//  Created by Wo Jun Feng on 12/2/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface Book (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eBookAuthors;
@property (nullable, nonatomic, retain) NSString *eBookFriendlyTitles;
@property (nullable, nonatomic, retain) NSString *eBookGenres;
@property (nullable, nonatomic, retain) NSString *eBookLanguages;
@property (nullable, nonatomic, retain) NSString *eBookNumbers;
@property (nullable, nonatomic, retain) NSString *eBookTitles;
@property (nullable, nonatomic, retain) NSString *eBookSearchTerms;

@end

NS_ASSUME_NONNULL_END
