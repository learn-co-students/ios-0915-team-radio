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

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)fetchData;

+ (instancetype) sharedDataStore;
- (void) generateTestDataWithArrayOfBooks:(NSArray *)arrayOfDictioanries;
@end


