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

#import "PGBLoginViewController.h"
#import "PGBSignUpViewController.h"

#import <XMLDictionary.h>
#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"

#import <GROAuth.h>

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
//@property (nonatomic, readwrite) SVPullToRefreshPosition position;

@property (strong, nonatomic) PGBBookCustomTableCell *customCell;

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
    
    [self.bookTableView setDelegate:self];
    [self.bookTableView setDataSource:self];
    
    UIImage *logo = [UIImage imageNamed:@"NOVEL_Logo_small"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    [self.navigationItem.titleView sizeToFit];
    
    //coreData
    //commented by leopoo
    //    [PGBRealmBook generateTestBookData];
    //    self.books = [PGBRealmBook getUserBookDataInArray];
    //    self.books = @[self.books[0], self.books[1], self.books[2]];
    self.books = [NSMutableArray arrayWithCapacity:100];
    [self generateRandomBookByCount:100];
    
    //xib
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    self.bookTableView.rowHeight = 80;
    
    
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

- (void)generateRandomBookByCount:(NSInteger)count{
    //bg Queue
    self.bgQueue = [[NSOperationQueue alloc]init];
    self.bookCoverBgQueue = [[NSOperationQueue alloc]init];
    
    self.bgQueue.maxConcurrentOperationCount = 1;
    self.bookCoverBgQueue.maxConcurrentOperationCount = 5;
    
    NSOperation *fetchBookOperation = [NSBlockOperation blockOperationWithBlock:^{
        PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
        [dataStore fetchData];
        
        NSMutableArray *booksGeneratedSoFar = [NSMutableArray new];
        
        for (NSInteger i = 0; i < count; i++) {
            NSInteger randomNumber = arc4random_uniform((u_int32_t)dataStore.managedBookObjects.count);
            
            Book *coreDataBook = dataStore.managedBookObjects[randomNumber];
            
            //if a book has already been shown, itll be added into the mutable array
            //if the same book is called again, then i is lowered by 1, the for loops starts again, and so i is increased by 1
            //this makes sure that there will always be 100 random numbers to check
            if ([booksGeneratedSoFar containsObject:coreDataBook]) {
                i--;
                continue;
            }
            
            PGBRealmBook *realmBook = [PGBRealmBook createPGBRealmBookWithBook:coreDataBook];
            
            if (realmBook) {
                
                NSOperation *fetchBookCoverOperation = [NSBlockOperation blockOperationWithBlock:^{
                    
                    NSData *bookCoverData = [NSData dataWithContentsOfURL:[PGBRealmBook createBookCoverURL:coreDataBook.eBookNumbers]];
                    realmBook.bookCoverData = bookCoverData;
                    
                     if (i < self.books.count && self.books[i]) {  //fixed a crash bug
                        
                        PGBRealmBook *realmBook = self.books[i];
                        realmBook.bookCoverData = bookCoverData;
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [self.bookTableView reloadData];
                        }];
                        
                    }
                }];
                
                
                [self.books addObject:realmBook];
                [booksGeneratedSoFar addObject:coreDataBook]; //add to list of shown books
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [self.bookTableView reloadData];
                    
                    [self.bookCoverBgQueue addOperation:fetchBookCoverOperation];
                }];
            } else {
                
                //Didn't find a book that we should display to user, resetting counter down by 1
                i--;
            }
            
        }
    }];
    
    [self.bgQueue addOperation:fetchBookOperation];
}

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
    //    return self.books.count;
    //pagination
    if([ self.books count] == 0){
        return 0;
    }
    else {
        return [self.books count] + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    //    PGBRealmBook *book = self.books[indexPath.row];
    //    //    Book *book = self.books[indexPath.row];
    //
    //    cell.titleLabel.text = book.title;
    //    cell.authorLabel.text = book.author;
    //    cell.genreLabel.text = book.genre;
    ////    cell.bookCover.image = self.bookCovers[indexPath.row];
    //    UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
    //    if (!bookCoverImage) {
    //        bookCoverImage = [UIImage imageNamed:@"no_book_cover"];
    //    }
    //
    //    cell.bookCover.image = bookCoverImage;
    //    cell.bookURL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
    
    //pagination
    if (self.books.count != 0) {
        if(indexPath.row < [self.books count]){
            
            PGBRealmBook *book = self.books[indexPath.row];
            
            cell.titleLabel.text = book.title;
            cell.authorLabel.text = book.author;
            cell.genreLabel.text = book.genre;
            //    cell.bookCover.image = self.bookCovers[indexPath.row];
            UIImage *bookCoverImage = [UIImage imageWithData:book.bookCoverData];
            if (!bookCoverImage) {
                bookCoverImage = [UIImage imageNamed:@"no_book_cover"];
            }
            
            cell.bookCover.image = bookCoverImage;
            cell.bookURL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
        }
        else{
            if (!self.noMoreResultsAvail) {
                spinner.hidden =NO;
                //                cell.textLabel.text=n;
                cell.titleLabel.text = @"";
                cell.authorLabel.text = @"";
                cell.genreLabel.text = @"";
                cell.bookCover.image = nil;
                
                
                spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.frame = CGRectMake(150, 10, 24, 50);
                [cell addSubview:spinner];
                if ([self.books count] >= 10) {
                    [spinner startAnimating];
                }
            }
            
            else{
                [spinner stopAnimating];
                spinner.hidden=YES;
                
                //                cell.textLabel.text=nil;
                cell.titleLabel.text = @"";
                cell.authorLabel.text = @"";
                cell.genreLabel.text = @"";
                cell.bookCover.image = nil;
                
                UILabel* loadingLabel = [[UILabel alloc]init];
                loadingLabel.font=[UIFont boldSystemFontOfSize:14.0f];
                loadingLabel.textAlignment = UITextAlignmentLeft;
                loadingLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
                loadingLabel.numberOfLines = 0;
                loadingLabel.text=@"No More data Available";
                loadingLabel.frame=CGRectMake(85,20, 302,25);
                [cell addSubview:loadingLabel];
            }
        }
    }
    
    
    return cell;
}


#pragma UIScroll View Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            [self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:0.2];
            
        }
    }
}

#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed{
    
    //cancel operations first to avoid too much background jobs running
    [self.bgQueue cancelAllOperations];
    [self.bookCoverBgQueue cancelAllOperations];
    
    if (self.books.count >= 100) {
        
        NSLog(@"before: %lu",[self.books count]);
        //index range 0-4 , 5 items
        [self.books removeObjectsInRange:NSMakeRange(0, self.books.count/4)];
        NSLog(@"after remove: %lu",[self.books count]);
    }
    
    [self generateRandomBookByCount:(self.books.count/4)+1];
    
    NSLog(@"number of books in array %lu",self.books.count);
    [self.bookTableView reloadData];
    
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