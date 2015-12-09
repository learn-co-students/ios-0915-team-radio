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
#import "PGBGoodreadsAPIClient.h"
#import "PGBCustomBookCollectionViewCell.h"

#import "PGBLoginViewController.h"
#import "PGBSignUpViewController.h"
#import "PGBParseAPIClient.h"

#import "PGBDataStore.h"
#import "Book.h"
#import <AFNetworking/AFNetworking.h>
#import <Availability.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface PGBHomeViewController () {
    
    UIActivityIndicatorView *spinner;
    
}

@property (strong, nonatomic) NSMutableArray *books;
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

@property (nonatomic, strong)NSOperationQueue *bgQueue;
@property (nonatomic, strong)NSOperationQueue *bookCoverBgQueue;


@end

@implementation PGBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.bookCollectionView setDelegate:self];
    [self.bookCollectionView setDataSource:self];
    
    //logo for banner
    UIImage *logo = [[UIImage imageNamed:@"Novel_Logo_small"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    //coreData
//    commented by leo
//        [PGBRealmBook generateTestBookData];
//        self.books = [PGBRealmBook getUserBookDataInArray];
//        self.books = @[self.books[0], self.books[1], self.books[2]];
    self.books = [NSMutableArray arrayWithCapacity:100];
//    [self generateRandomBookByCount:10];
    [self generateBook];
//    [self generateClassics];
//    self.books = [[PGBRealmBook getUserBookDataInArray] mutableCopy];
//    [self.books addObject:self.books[0]];
    
    //xib
    
    [self.bookCollectionView registerNib:[UINib nibWithNibName:@"PGBCustomBookCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bookCoverCell"];
    
    self.bookCollectionView.backgroundColor = [UIColor whiteColor];
    self.bookCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([PFUser currentUser] && ![self.loginButton.title isEqual: @"👤"]) {
        [self changeLoginButtonToProfileIcon];
        
    } else if (![PFUser currentUser] && ![self.loginButton.title isEqual: @"Login"]){
        [self.loginButton setTitle:@"Login"];
    }
    
    
    //leo test parse here
    //put this into background thread
    
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc]init];
    
    [bgQueue addOperationWithBlock:^{
        
        [PGBParseAPIClient fetchUserProfileDataWithUserObject:[PFUser currentUser] andCompletion:^(PFObject *data) {
            NSLog(@"user data: %@", data);
            
            PFObject *user = data;
            if (user) {
                
                [PGBRealmBook deleteAllUserBookData];
                
                [PGBRealmBook fetchUserBookDataFromParseStoreToRealmWithCompletion:^{
                    NSLog(@"successfully fetch book from parse");
                }];
            }
        }];
    }];
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
    
    [self.bookCollectionView reloadData];
}

- (void)generateClassics {
    PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
    [dataStore fetchData];
    
    [PGBRealmBook generateClassicBooks];
    for (Book *book in dataStore.managedBookObjects) {
        [PGBRealmBook createPGBRealmBookWithBook:book];
        if (book)
        {
            [self.books addObject:book];
        }
    }
    
    
    [self.bookCollectionView reloadData];
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
//                            [self.bookCollectionView reloadData];
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
//                    [self.bookCollectionView reloadData];
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
    NSLog(@"book count %lu", self.books.count);
    return self.books.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCoverCell" forIndexPath:indexPath];
    
    PGBCustomBookCollectionViewCell *cell = (PGBCustomBookCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"bookCoverCell" forIndexPath:indexPath];
    

    if (self.books.count != 0) {
        if (indexPath.row < self.books.count)
        {
            PGBRealmBook *book = self.books[indexPath.row];

//            cell.titleLabel.text = @"THINGS";
//            cell.authorLabel.text = @"AN AUTHOR";
            
            UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
//
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
}

//segue
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"bookPageSegue" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PGBBookPageViewController *bookPageVC = segue.destinationViewController;
    
    NSArray *arrayOfIndexPaths = [self.bookCollectionView indexPathsForSelectedItems];
    
    NSIndexPath *selectedIndexPath = [arrayOfIndexPaths firstObject];
    
//    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = self.books[selectedIndexPath.row];
    
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