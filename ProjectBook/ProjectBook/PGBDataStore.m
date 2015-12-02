//
//  PGBDataStore.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/23/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBDataStore.h"
#import "Book.h"

@implementation PGBDataStore
@synthesize managedObjectContext = _managedObjectContext;

+ (instancetype)sharedDataStore {
    static PGBDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[PGBDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"objcCMR.sqlite"];
    NSURL *appBundleStoreURL = [[NSBundle mainBundle] URLForResource:@"ProjectBook" withExtension:@"sqlite"];

    NSURL *documentsStoreURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"ProjectBook.sqlite"];
    
    if(![documentsStoreURL checkResourceIsReachableAndReturnError:nil]) {
        [[NSFileManager defaultManager] copyItemAtURL:appBundleStoreURL toURL:documentsStoreURL error:nil];
    }

    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProjectBook" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:documentsStoreURL options:nil error:&error];
//    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)fetchData
{
    // TODO: make an NSFetchRequest, execute and fill datastore
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
    
    self.managedBookObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    // TODO: finish this so it will generate test data if your datastore is empty
//    if (self.managedBookObjects.count == 0) {
//         [self generateTestData];
//    }
}

- (void) generateTestDataWithArrayOfBooks:(NSArray *)arrayOfDictioanries
{
//    NSArray *testArray = @[   @{
//                                  @"eBookAuthors" : @"Wolfensberger, Arnold",
//                                  @"eBookFriendlyTitles" : @"Theory of Silk Weaving by Arnold Wolfensberger",
//                                  @"eBookGenres" : @"Silk industry",
//                                  @"eBookLanguages" : @"en",
//                                  @"eBookNumbers" : @"etext14600@",
//                                  @"eBookTitles" : @"",
//                                  },
//                              @{
//                                  @"eBookAuthors" : @"LEO",
//                                  @"eBookFriendlyTitles" : @"Theory of Silk Weaving by Arnold Wolfensberger",
//                                  @"eBookGenres" : @"Silk industry",
//                                  @"eBookLanguages" : @"en",
//                                  @"eBookNumbers" : @"etext14600@",
//                                  @"eBookTitles" : @"",
//                                  }
//                              ];
    
    for (NSDictionary *book in arrayOfDictioanries) {
        Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
        newBook.eBookAuthors = book[@"eBookAuthors"];
        newBook.eBookFriendlyTitles = book[@"eBookFriendlyTitles"];
        newBook.eBookGenres = book[@"eBookGenres"];
        newBook.eBookLanguages = book[@"eBookLanguages"];
        newBook.eBookNumbers = book[@"eBookNumbers"];
        newBook.eBookTitles = book[@"eBookTitles"];
        
        NSString *lowerCaseTitles = [newBook.eBookTitles stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
        
        NSString *lowerCaseFriendlyTitles = [newBook.eBookFriendlyTitles stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
        
        newBook.eBookSearchTerms = [NSString stringWithFormat:@"%@ %@", lowerCaseTitles, lowerCaseFriendlyTitles];
    }
    
    // save and refetch
    [self saveContext];
    [self fetchData];
}

@end


