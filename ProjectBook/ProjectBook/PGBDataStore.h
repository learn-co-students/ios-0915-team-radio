//
//  PGBDataStore.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/23/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PGBDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *managedBookObjects;

+ (instancetype) sharedDataStore;

- (void)saveContext;
- (void)fetchData;
- (NSURL *)applicationDocumentsDirectory;
- (void) generateTestDataWithArrayOfBooks:(NSArray *)arrayOfDictioanries;


@end


