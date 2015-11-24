//
//  Book+CoreDataProperties.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/23/15.
//  Copyright © 2015 FIS. All rights reserved.
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

@end

NS_ASSUME_NONNULL_END
