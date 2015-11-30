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

#import <XMLDictionary.h>
#import <QuartzCore/QuartzCore.h>
//#import "SVViewController.h"
#import "SVPullToRefresh.h"

#import <GROAuth.h>

#import "PGBDataStore.h"
#import "Book.h"
#import <AFNetworking/AFNetworking.h>
#import <Availability.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface PGBHomeViewController ()

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property (nonatomic, assign) int currentList;
@property (nonatomic, assign) int initialPage;
@property (strong, nonatomic) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
//@property (nonatomic, readwrite) SVPullToRefreshPosition position;

@property (strong, nonatomic) PGBBookCustomTableCell *customCell;

@property (strong, nonatomic) NSMutableArray *bookCovers;

@end

@implementation PGBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.bookTableView setDelegate:self];
    [self.bookTableView setDataSource:self];
    
    //    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NOVEL_Logo_small"]];
    //    logo.contentMode = UIViewContentModeScaleAspectFit;
    //
    //    CGRect frame = logo.frame;
    //    frame.size.width = 30;
    //    logo.frame = frame;
    
    UIImage *logo = [UIImage imageNamed:@"NOVEL_Logo_small"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    [self.navigationItem.titleView sizeToFit];
    
    //coreData
    //commented by leo
    //    [PGBRealmBook generateTestBookData];
    //    self.books = [PGBRealmBook getUserBookDataInArray];
    //    self.books = @[self.books[0], self.books[1], self.books[2]];
    self.books = [[NSMutableArray alloc]init];
    self.bookCovers = [[NSMutableArray alloc]init];
    [self getRandomBooks];
    
    //xib
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    self.bookTableView.rowHeight = 80;
    
    [PGBGoodreadsAPIClient getReviewsWithCompletion:@"Haruki Murakami" bookTitle:"Kafka on the Shore" completion:^(NSArray *reviews) {
        for (
    }]
    
}

- (void)getRandomBooks{
    
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc] init];
    
    NSOperation *fetchBookOperation = [NSBlockOperation blockOperationWithBlock:^{
        PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
        [dataStore fetchData];
        
        for (NSUInteger i = 0; i < 100; i++) {
            NSUInteger randomNumber = arc4random_uniform((u_int32_t)dataStore.managedBookObjects.count);
            
            PGBRealmBook *realmBook = [[PGBRealmBook alloc]init];
            Book *coreDataBook = dataStore.managedBookObjects[randomNumber];
            
            realmBook.author = coreDataBook.eBookAuthors;
            realmBook.title = coreDataBook.eBookTitles;
            realmBook.genre = coreDataBook.eBookGenres;
            realmBook.ebookID = coreDataBook.eBookNumbers;
    
            NSData *bookCoverData = [NSData dataWithContentsOfURL:[self createBookCoverURL:coreDataBook.eBookNumbers]];
            realmBook.bookCoverData = bookCoverData;
            
            [self.books addObject:realmBook];
            
            if (!realmBook.bookCoverData) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.bookTableView reloadData];
                }];
            }
        }
    }];
    
    [bgQueue addOperation:fetchBookOperation];
}

- (NSURL *)createBookCoverURL:(NSString *)eBookNumber{
    NSString *eBookNumberParsed = [eBookNumber substringFromIndex:5];
    NSString *bookCoverURL = [NSString stringWithFormat:@"https://www.gutenberg.org/cache/epub/%@/pg%@.cover.medium.jpg", eBookNumberParsed, eBookNumberParsed];
    
    NSURL *url = [NSURL URLWithString:bookCoverURL];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *img = [[UIImage alloc]initWithData:data];
    //    CGSize size = img.size;
    return url;
}

-(void) cellDownloadButtonTapped:(UIButton*) button
{
    //create modal view to show when downloading, show view once downloaded
    
    button.enabled = NO; // FIXME: re-enable button after download succeeds/fails
    // THIS IS A LIL HACKY — will change if you change the view heirarchy of the cell
    PGBBookCustomTableCell *cell = (PGBBookCustomTableCell*)[[[button superview] superview] superview];
    
    PGBRealmBook *realmBook = [[PGBRealmBook alloc]init];
    realmBook = self.books[self.bookTableView.indexPathForSelectedRow.row];
    
    NSString *neweBookID = [realmBook.ebookID substringFromIndex:5];
    
    if (cell && [cell isKindOfClass:[PGBBookCustomTableCell class]]){
        NSLog(@"selected book is: %@; URL: %@", cell.titleLabel.text, cell.bookURL);
        
        NSString *downloadURL = [NSString stringWithFormat:@"http://www.gutenberg.org/ebooks/%@.epub.images", neweBookID];
        
        NSURL *URL = [NSURL URLWithString:downloadURL];
        self.downloadHelper = [[PGBDownloadHelper alloc] init];
        [self.downloadHelper download:URL];
        
        
        //during download
        UIAlertController *downloadComplete = [UIAlertController alertControllerWithTitle:@"Book Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
        
        [downloadComplete addAction:ok];
        [self presentViewController:downloadComplete animated:YES completion:nil];
        
        
        //when download, disable button
        self.customCell.downloadButton.enabled = NO;
        
    }
    else {
        NSLog(@"Didn't get a cell, I fucked UP");
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    PGBRealmBook *book = self.books[indexPath.row];
    //    Book *book = self.books[indexPath.row];
    
    cell.titleLabel.text = book.title;
    cell.authorLabel.text = book.author;
    cell.genreLabel.text = book.genre;
//    cell.bookCover.image = self.bookCovers[indexPath.row];
    UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
    if (!bookCoverImage) {
        bookCoverImage = [UIImage imageNamed:@"91fJxgs69QL._SL1500_"];
    }
    
    cell.bookCover.image = bookCoverImage;
    
    [cell.downloadButton addTarget:self action:@selector(cellDownloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.bookURL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"bookInfoSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PGBBookPageViewController *bookPageVC = segue.destinationViewController;
    
    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = self.books[selectedIndexPath.row];
//    Book *bookAtIndexPath = self.books[selectedIndexPath.row];
    
    bookPageVC.titleBook = bookAtIndexPath.title;
    bookPageVC.author = bookAtIndexPath.author;
    bookPageVC.genre = bookAtIndexPath.genre;
    bookPageVC.language = bookAtIndexPath.language;
    bookPageVC.ebookID = bookAtIndexPath.ebookID;
    
    //    bookPageVC.ebookID = bookAtIndexPath.eBookNumbers;
    //    bookPageVC.bookDescription = bookAtIndexPath.bookDescription;
//    bookPageVC.books = bookPageVC.books;
    
}
                         
//login info
- (IBAction)loginButtonTouched:(id)sender {
    
    if (![PFUser currentUser]) { // No user logged in
        self.loginButton.title = @"Login";
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword
         | PFLogInFieldsLogInButton
         | PFLogInFieldsPasswordForgotten
         | PFLogInFieldsFacebook
         | PFLogInFieldsSignUpButton
         | PFLogInFieldsDismissButton];
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    //    } else {
    //        self.loginButton.title = @"Log out";
    //
    //    }
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
    self.loginButton.title = @"Log out";
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
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
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
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
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

@end
