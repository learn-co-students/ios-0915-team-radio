//
//  AppDelegate.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "AppDelegate.h"

#import "PGBDownloadHelper.h"
#import "PGBRealmUser.h"
#import "PGBRealmBook.h"
#import "PGBGoodreadsAPIClient.h"
#import "PGBParseAPIClient.h"
#import <Parse/Parse.h>
#import <GROAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "PGBparsingThroughText.h"
#import "PGBDataStore.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    /*
     
    [PGBGoodreadsAPIClient getReviewsForBook:@"The Adventures of Huckleberry Finn" completion:^(NSDictionary *reviewDict) {
        
        self.htmlString = [reviewDict[@"reviews_widget"] mutableCopy];
        
        NSData *htmlData = [self.htmlString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *baseURL = [NSURL URLWithString:@"https://www.goodreads.com"];
        
        // make / constrain webview
        
        CGRect webViewFrame = CGRectMake(0, 0, self.webViewContainer.frame.size.width, self.webViewContainer.frame.size.height);
        
        self.webView = [[WKWebView alloc]initWithFrame: webViewFrame];
        [self.webViewContainer addSubview:self.webView];
        //                self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        //
        //                [self.webView.leftAnchor constraintEqualToAnchor:self.webViewContainer.leftAnchor].active = YES;
        //                [self.webView.rightAnchor constraintEqualToAnchor:self.webViewContainer.rightAnchor].active = YES;
        //                [self.webView.topAnchor constraintEqualToAnchor:self.webViewContainer.bottomAnchor].active = YES;
        //                [self.webView.bottomAnchor constraintEqualToAnchor:self.webViewContainer.bottomAnchor].active = YES;
        
        
        [self.webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:baseURL];
        
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.scrollView.delegate = self;
        
        //            [self.webView.heightAnchor constraintEqualToConstant:300];
        //            [self.webViewContainer layoutSubviews];
        completionBlock(YES);
    }];
    
    */


//    PGBGoodreadsAPIClient *goodReads = [[PGBGoodreadsAPIClient alloc] init];
//    //    [goodReads methodToGetDescriptions];
//    //    NSLog(@"%@", [goodReads methodToGetDescriptions]);
//    [goodReads getURLAsString:@"https://www.goodreads.com/book/title.xml?key=AckMqnduhbH8xQdja2Nw&title=Hound+of+the+Baskervilles&author=Arthur+Conan+Doyle"];

    
    //for banner image
//    UIImage *image = [[UIImage imageNamed:@"NOVEL_Banner"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    
//    [[UINavigationBar appearance] titlevie
    //test array of books
//    PGBparsingThroughText *newTask = [[PGBparsingThroughText alloc]init];
//    NSArray *finalArrayOfDictionary = [newTask cleanUpArrays];
//
//    NSLog(@"THIS IS THE FINAL DICTIONARY: %@", finalArrayOfDictionary);
//
//    NSLog(@"Begin store to core data");

//    NSLog(@"documents directory: %@", [self applicationDocumentsDirectory]);
//    
//    PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
////    [dataStore generateTestDataWithArrayOfBooks:finalArrayOfDictionary];
//    [dataStore fetchData];
//    
//    NSMutableArray *array = [NSMutableArray new];
//    NSInteger i = 0;
//    for (Book *book in dataStore.managedBookObjects) {
//        PGBRealmBook *realmBook = [PGBRealmBook createPGBRealmBookContainingCoverImageWithBook:book];
//        if (realmBook) {
////            [array addObject:realmBook];
//            NSLog(@"%lu",i+1);
//            i++;
//        }
//
//    }
//    
//    NSLog(@"%lu",array.count);

//    NSLog(@"Final book data from core data: %@",dataStore.managedBookObjects);
//    NSLog(@"End store to core data");
//    end test
    
//    PGBGoodreadsAPIClient *testGoodReadsAPI = [[PGBGoodreadsAPIClient alloc] init];
//    NSLog(@"Goodreadsapiclient dummylogin about to be called\n.");
//    [PGBGoodreadsAPIClient getReviewsWithCompletion:@"Haruki Murakami" bookTitle:@"Norwegian Wood" completion:nil];
//    
//    PGBGoodreadsAPIClient *testingXMLParsing = [[PGBGoodreadsAPIClient alloc] init];
//    NSLog(@"%@", [testingXMLParsing methodToGetDescriptions]);
    
    
    

    // Override point for customization after application launch.
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    
    // Initialize Parse.
    [Parse setApplicationId:@"VADP3uGjgBGfaYax1jbKoDlKzhCYyilh8I83XfmI"
                  clientKey:@"XFszBVoY8vDT5MUqM82ACP0lfqKeOv9er01VC3NM"];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [GROAuth setGoodreadsOAuthWithConsumerKey:@"AckMqnduhbH8xQdja2Nw"
                                       secret:@"xlhPN1dtIA5CVXFHVF1q3eQfaUM1EzsT546C6bOZno"];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.github.learn-co-students.ios-0915-team-radio.ProjectBook" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProjectBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProjectBook.sqlite"];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //send a notification to NSNotificationCenter:
    [[NSNotificationCenter defaultCenter] postNotificationName: @"dGWeFofcrQ" object:self];
}

@end
