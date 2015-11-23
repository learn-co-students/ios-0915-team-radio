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
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"objcCMR.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProjectBook" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
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
//
//    Book *bookOne = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
//    
//    bookOne.eBookAuthors = testArray[0][@"eBookAuthors"];
//    bookOne.eBookFriendlyTitles = testArray[0][@"eBookFriendlyTitles"];
//    bookOne.eBookGenres = testArray[0][@"eBookGenres"];
//    bookOne.eBookLanguages = testArray[0][@"eBookLanguages"];
//    bookOne.eBookNumbers = testArray[0][@"eBookNumbers"];
//    bookOne.eBookTitles = testArray[0][@"eBookTitles"];
//    
//    Book *bookTwo = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
//
//    bookTwo.eBookAuthors = testArray[1][@"eBookAuthors"];
//    bookTwo.eBookFriendlyTitles = testArray[1][@"eBookFriendlyTitles"];
//    bookTwo.eBookGenres = testArray[1][@"eBookGenres"];
//    bookTwo.eBookLanguages = testArray[1][@"eBookLanguages"];
//    bookTwo.eBookNumbers = testArray[1][@"eBookNumbers"];
//    bookTwo.eBookTitles = testArray[1][@"eBookTitles"];
//    
    for (NSDictionary *book in arrayOfDictioanries) {
        Book *newBook = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
        newBook.eBookAuthors = book[@"eBookAuthors"];
        newBook.eBookFriendlyTitles = book[@"eBookFriendlyTitles"];
        newBook.eBookGenres = book[@"eBookGenres"];
        newBook.eBookLanguages = book[@"eBookLanguages"];
        newBook.eBookNumbers = book[@"eBookNumbers"];
        newBook.eBookTitles = book[@"eBookTitles"];
    }
    
    // save and refetch
    [self saveContext];
    [self fetchData];
}

@end


