//
//  PGBHomeViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/18/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBHomeViewController.h"
#import "PGBBookCustomTableCell.h"
#import "PGBDownloadHelper.h"
#import "PGBBookPageViewController.h"
#import "PGBRealmBook.h"
//#import "PGBGoodreadsAPIClient.h"
#import "PGBCustomBookCollectionViewCell.h"

#import "PGBLoginViewController.h"
#import "PGBSignUpViewController.h"
#import "PGBParseAPIClient.h"
#import "Reachability.h"

#import "PGBDataStore.h"
#import "Book.h"
#import <AFNetworking/AFNetworking.h>
#import <Availability.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static dispatch_once_t onceToken;

@interface PGBHomeViewController () {
    
}

//book arrays

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSMutableArray *classicBooks;
@property (strong, nonatomic) NSMutableArray *shakespeareBooks;

@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property (nonatomic, assign) int currentList;
@property (nonatomic, assign) int initialPage;
@property (strong, nonatomic) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

@property (strong, nonatomic) PGBCustomBookCollectionViewCell *bookCoverCell;

//pagination
//@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) BOOL noMoreResultsAvail;
@property (nonatomic) BOOL loading;

@property (assign, nonatomic) BOOL isLoggedin;
//@property (nonatomic, assign) dispatch_once_t *once;

@property (nonatomic, strong)NSOperationQueue *bgQueue;
@property (nonatomic, strong)NSOperationQueue *bookCoverBgQueue;

@property (strong, nonatomic) PGBDataStore *dataStore;




@end

@implementation PGBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //logo for banner
    UIImage *logo = [[UIImage imageNamed:@"Novel_Logo_small"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    //coreData
//    commented by leo
//        [PGBRealmBook generateTestBookData];
//        self.books = [PGBRealmBook getUserBookDataInArray];
//        self.books = @[self.books[0], self.books[1], self.books[2]];
    self.books = [NSMutableArray arrayWithCapacity:50];
    self.classicBooks = [NSMutableArray arrayWithCapacity:50];
    self.shakespeareBooks = [NSMutableArray arrayWithCapacity:50];

//    [self generateRandomBookByCount:10];
//    [self generateBook];
//    [self generateClassics];
//    self.books = [[PGBRealmBook getUserBookDataInArray] mutableCopy];
//    [self.books addObject:self.books[0]];
    
    self.dataStore = [PGBDataStore sharedDataStore];
    [self.dataStore fetchData];
    
//popular books
    //delegate
    [self.popularCollectionView setDelegate:self];
    [self.popularCollectionView setDataSource:self];
    
    //xib
    [self.popularCollectionView registerNib:[UINib nibWithNibName:@"PGBCustomBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bookCoverCell"];
    
    self.popularCollectionView.backgroundColor = [UIColor whiteColor];
    self.popularCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
//classic books
    //delegate
    [self.classicsCollectionView setDelegate:self];
    [self.classicsCollectionView setDataSource:self];
    
    //xib
    [self.classicsCollectionView registerNib:[UINib nibWithNibName:@"PGBCustomBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bookCoverCell"];
    
    self.classicsCollectionView.backgroundColor = [UIColor whiteColor];
    self.classicsCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    

//classic books
    //delegate
    [self.shakespeareCollectionView setDelegate:self];
    [self.shakespeareCollectionView setDataSource:self];
    
    //xib
    [self.shakespeareCollectionView registerNib:[UINib nibWithNibName:@"PGBCustomBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bookCoverCell"];
    
    self.shakespeareCollectionView.backgroundColor = [UIColor whiteColor];
    self.shakespeareCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);

    //fetch from parse when the app opens for the first time
    //user can kill the app and re-open, however they don't need to re-login
    [self fetchBookFromParse];

    
    //Reachability to check network connection
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"UNREACHABLE!");
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"The Internet connection appears to be offline"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([PFUser currentUser] && ![self.loginButton.title isEqual: @"👤"]) {
        [self changeLoginButtonToProfileIcon];
        
    } else if (![PFUser currentUser] && ![self.loginButton.title isEqual: @"Login"]){
        [self.loginButton setTitle:@"Login"];
    }

}




-(void)fetchBookFromParse {
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc]init];
    
    [bgQueue addOperationWithBlock:^{
        if ([PFUser currentUser]) {
            
            [PGBParseAPIClient fetchUserProfileDataWithUserObject:[PFUser currentUser] andCompletion:^(PFObject *data) {
                NSLog(@"user data: %@", data);
                
                PFObject *user = data;
                if (user) {
            
                    [PGBRealmBook deleteAllUserBookDataWithCompletion:^{
                    
                        [PGBRealmBook fetchUserBookDataFromParseStoreToRealmWithCompletion:^{
                            NSLog(@"successfully fetch book from parse");
                            
//                            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//                                //alert user that their library is update????
//                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hello"
//                                                                                               message:@"Your library is now updated!"
//                                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                                
//                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                                      handler:^(UIAlertAction * action) {}];
//                                
//                                [alert addAction:defaultAction];
//                                [self presentViewController:alert animated:YES completion:nil];
//                            }];
                            
                            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                            [center postNotificationName:@"StoringDataFromParseToRealm" object:nil];
                        }];
                        
                    }];
                }
            }];
            
        } 
    }];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //do it once
    dispatch_once (&onceToken, ^{
        
        NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
        
        [backgroundQueue addOperationWithBlock:^{
            NSArray *mostPopularBooks = @[ @"etext1342", @"etext46", @"etext11", @"etext76", @"etext84", @"etext1952", @"etext1661", @"etext2701", @"etext23", @"etext98", @"etext5200", @"etext345", @"etext1232", @"etext74", @"etext2542", @"etext844", @"etext174", @"etext4300", @"etext1400", @"etext1260", @"etext135"];
            
            for (NSString *ebookNumber in mostPopularBooks) {
                PGBRealmBook *book =[PGBRealmBook generateBooksWitheBookID:ebookNumber];
                if (book) {
                    [self.books addObject:book];
                    //                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //                    [self.popularCollectionView reloadData];
                    //                }];
                }
            }
            
            NSArray *harvardClassicBooks = @[ @"etext22456", @"etext28", @"etext4081", @"etext1597", @"etext1399", @"etext1656", @"etext13726", @"etext10378", @"etext20203", @"etext4028", @"etext2880", @"etext3296", @"etext1657", @"etext766", @"etext12816", @"etext1012", @"etext996", @"etext9662", @"etext16643", @"etext1237", @"etext8418", @"etext5314", @"etext41", @"etext2610", @"etext3160", @"etext18269", @"etext1342", @"etext1232", @"etext33"];
            
            for (NSString *ebookNumber in harvardClassicBooks) {
                PGBRealmBook *book =[PGBRealmBook generateBooksWitheBookID:ebookNumber];
                if (book) {
                    [self.classicBooks addObject:book];
                    //                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //                    [self.classicsCollectionView reloadData];
                    //                }];
                }
            }
            
            
            NSArray *shakespearesBooks = @[ @"etext2265", @"etext1112", @"etext2264", @"etext2267", @"etext1041", @"etext2235", @"etext2242", @"etext1430", @"etext1128", @"etext1120", @"etext1121", @"etext2243", @"etext2253", @"etext1107", @"etext1526", @"etext1103", @"etext2240", @"etext1539", @"etext1535", @"etext2268", @"etext1126", @"etext1045" ];
            
            for (NSString *ebookNumber in shakespearesBooks) {
                PGBRealmBook *book =[PGBRealmBook generateBooksWitheBookID:ebookNumber];
                if (book) {
                    [self.shakespeareBooks addObject:book];
                } else {
                    NSLog(@"this is outttttt: %@", ebookNumber);
                }
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.classicsCollectionView reloadData];
                [self.popularCollectionView reloadData];
                [self.shakespeareCollectionView reloadData];
                
            }];
        }];
        
    });
}

- (void)generateBook {
    PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
    [dataStore fetchData];
    
//    for (Book *coreDataBook in dataStore.managedBookObjects) {
//        [PGBRealmBook createPGBRealmBookWithBook:coreDataBook];
//    }
    for (NSInteger i = 0; i < 30; i++) {
        PGBRealmBook *newBook = [PGBRealmBook createPGBRealmBookWithBook:dataStore.managedBookObjects[i]];
        if (newBook) {
             [self.books addObject:newBook];
        }
    }
    
    [self.popularCollectionView reloadData];
}

//- (void)generateRandomBookByCount:(NSInteger)count{
//    NSLog(@"genraing books");
//    //bg Queue
//    self.bgQueue = [[NSOperationQueue alloc]init];
//    self.bookCoverBgQueue = [[NSOperationQueue alloc]init];
//    
//    self.bgQueue.maxConcurrentOperationCount = 1;
//    self.bookCoverBgQueue.maxConcurrentOperationCount = 5;
//    
//    NSOperation *fetchBookOperation = [NSBlockOperation blockOperationWithBlock:^{
//        PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
//        [dataStore fetchData];
//        
//        NSMutableArray *booksGeneratedSoFar = [NSMutableArray new];
//        
//        for (NSInteger i = 0; i < count; i++) {
//            NSInteger randomNumber = arc4random_uniform((u_int32_t)dataStore.managedBookObjects.count);
//            
//            Book *coreDataBook = dataStore.managedBookObjects[randomNumber];
//            
//            //if a book has already been shown, itll be added into the mutable array
//            //if the same book is called again, then i is lowered by 1, the for loops starts again, and so i is increased by 1
//            //this makes sure that there will always be 100 random numbers to check
//            if ([booksGeneratedSoFar containsObject:coreDataBook]) {
//                i--;
//                continue;
//            }
//            
//            PGBRealmBook *realmBook = [PGBRealmBook createPGBRealmBookWithBook:coreDataBook];
//            
//            if (realmBook) {
//                
//                NSOperation *fetchBookCoverOperation = [NSBlockOperation blockOperationWithBlock:^{
//                    
//                    NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:coreDataBook.eBookNumbers]];
//                    realmBook.bookCoverData = bookCoverData;
//                    
//                     if (i < self.books.count && self.books[i]) {  //fixed a crash bug
//                        
//                        PGBRealmBook *realmBook = self.books[i];
//                        realmBook.bookCoverData = bookCoverData;
//                        
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            [self.popularCollectionView reloadData];
//                        }];
//                        
//                    }
//                }];
//                
//                
//                [self.books addObject:realmBook];
//                [booksGeneratedSoFar addObject:coreDataBook]; //add to list of shown books
//                
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    
//                    [self.popularCollectionView reloadData];
//                    
//                    [self.bookCoverBgQueue addOperation:fetchBookCoverOperation];
//                }];
//            } else {
//                
//                //Didn't find a book that we should display to user, resetting counter down by 1
//                i--;
//            }
//            
//        }
//    }];
//    
//    [self.bgQueue addOperation:fetchBookOperation];
//}

- (NSURL *)createBookCoverURL:(NSString *)eBookNumber{
    NSString *eBookNumberParsed = [eBookNumber substringFromIndex:5];
    NSString *bookCoverURL = [NSString stringWithFormat:@"https://www.gutenberg.org/cache/epub/%@/pg%@.cover.medium.jpg", eBookNumberParsed, eBookNumberParsed];
    
    NSURL *url = [NSURL URLWithString:bookCoverURL];
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    UIImage *img = [[UIImage alloc]initWithData:data];
    //    CGSize size = img.size;
    
    //    [self.bgQueue addOperation:fetchBookOperation];
    return url;
}

//collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"popular book count %lu", self.books.count);
//    NSLog(@"classic book count %lu", self.classicBooks.count);
    
    if (collectionView == self.popularCollectionView) {
        return self.books.count;
    } else if (collectionView == self.classicsCollectionView) {
        return self.classicBooks.count;
    }  else if (collectionView == self.shakespeareCollectionView) {
        return self.shakespeareBooks.count;
    }
    
    return self.classicBooks.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PGBCustomBookCollectionViewCell *cell = (PGBCustomBookCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCoverCell" forIndexPath:indexPath];
    
    if (collectionView == self.popularCollectionView)
    {
        if (self.books.count != 0) {
            if (indexPath.row < self.books.count)
            {
                PGBRealmBook *book = self.books[indexPath.row];
                UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
                
                if (bookCoverImage) {
                    cell.bookCover.image = bookCoverImage;
                } else {
                    cell.titleTV.text = book.title;
                    cell.authorLabel.text = book.author;
                }
                //            cell.titleTV.adjustsFontSizeToFitWidth = YES;
                //            cell.titleTV.minimumFontSize = 0;
                //            cell.authorLabel.adjustsFontSizeToFitWidth = YES;
            }
        }
        return cell;
        
    } else if (collectionView == self.classicsCollectionView) {
        if (self.classicBooks.count != 0) {
            if (indexPath.row < self.classicBooks.count)
            {
                PGBRealmBook *book = self.classicBooks[indexPath.row];
                UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
                
                if (bookCoverImage) {
                    cell.bookCover.image = bookCoverImage;
                } else {
                    cell.titleTV.text = book.title;
                    cell.authorLabel.text = book.author;
                }
                //cell.titleTV.adjustsFontSizeToFitWidth = YES;
                //cell.titleTV.minimumFontSize = 0;
                //cell.authorLabel.adjustsFontSizeToFitWidth = YES;
            }
        }
        return cell;
        
    } else if (collectionView == self.shakespeareCollectionView) {
        if (self.shakespeareBooks.count != 0) {
            if (indexPath.row < self.shakespeareBooks.count)
            {
                PGBRealmBook *book = self.shakespeareBooks[indexPath.row];
                UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
                
                if (bookCoverImage) {
                    cell.bookCover.image = bookCoverImage;
                } else {
                    cell.titleTV.text = book.title;
                    cell.authorLabel.text = @"William Shakespeare";
                }
                //cell.titleTV.adjustsFontSizeToFitWidth = YES;
                //cell.titleTV.minimumFontSize = 0;
                //cell.authorLabel.adjustsFontSizeToFitWidth = YES;
            }
        }
        return cell;
    }
    return nil;
}

//segue
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"bookPageSegue" sender:collectionView];
    [self performSegueWithIdentifier:@"bookSegue" sender:collectionView];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PGBBookPageViewController *bookPageVC = segue.destinationViewController;
    
    NSArray *arrayOfIndexPaths;
    NSArray *relevantBookArray;
    
    if (sender == self.popularCollectionView) {
        arrayOfIndexPaths = [self.popularCollectionView indexPathsForSelectedItems];
        relevantBookArray = self.books;
    } else if (sender == self.classicsCollectionView) {
        arrayOfIndexPaths = [self.classicsCollectionView indexPathsForSelectedItems];
        relevantBookArray = self.classicBooks;
    }  else if (sender == self.shakespeareCollectionView) {
        arrayOfIndexPaths = [self.shakespeareCollectionView indexPathsForSelectedItems];
        relevantBookArray = self.shakespeareBooks;
    }
    
    NSLog(@"arrayOfIndexPaths: %@", arrayOfIndexPaths);
    
    
    NSIndexPath *selectedIndexPath = [arrayOfIndexPaths firstObject];
    
    NSLog(@"selectedIndexPath: %@", selectedIndexPath);

    
//    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = relevantBookArray[selectedIndexPath.row];
    
    NSLog(@"bookAtIndexPath: %@", bookAtIndexPath);

    
    bookPageVC.book = bookAtIndexPath;
    
}

//login info
- (IBAction)loginButtonTouched:(id)sender {
    
    if (![PFUser currentUser]) { // No user logged in
        self.loginButton.title = @"Login";
        // Create the log in view controller
        PGBLoginViewController *logInViewController = [[PGBLoginViewController alloc] init];
        
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword
         | PFLogInFieldsLogInButton
         | PFLogInFieldsPasswordForgotten
         | PFLogInFieldsFacebook
         | PFLogInFieldsSignUpButton
         | PFLogInFieldsDismissButton];
        // Create the sign up view controller
        PGBSignUpViewController *signUpViewController = [[PGBSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        [signUpViewController setFields:PFSignUpFieldsDefault | PFSignUpFieldsAdditional];
        
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
    else {
        
        // user logged in; go to profile...
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"profile" bundle:nil];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self changeLoginButtonToProfileIcon];
    
    //once logged in fetch book from parse
    [self fetchBookFromParse];
}




// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PGBSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    return informationComplete;
    
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (void)changeLoginButtonToProfileIcon {
    self.loginButton.title = @"👤";
}

@end