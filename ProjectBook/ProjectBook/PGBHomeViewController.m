//
//  PGBHomeViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/18/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBHomeViewController.h"
#import "PGBDownloadHelper.h"
#import "PGBRealmBook.h"
#import "PGBCustomBookCollectionViewCell.h"
#import "PGBBookViewController.h"
#import "PGBLoginViewController.h"
#import "PGBSignUpViewController.h"
#import "PGBParseAPIClient.h"
#import "PGBDataStore.h"
#import "Book.h"
#import "Reachability.h"
#import "PGBImageTableViewCell.h"
#import "PGBConstants.h"

static dispatch_once_t onceToken;

@interface PGBHomeViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) PGBCustomBookCollectionViewCell *bookCoverCell;
@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property (strong, nonatomic) PGBDataStore *dataStore;

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSMutableArray *classicBooks;
@property (strong, nonatomic) NSMutableArray *shakespeareBooks;

@end

@implementation PGBHomeViewController

#pragma mark VCLifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check network connection
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
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
    
    [reach startNotifier];
    
    UIImage *logo = [[UIImage imageNamed:@"NOVEL_Logo_small"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    
    self.books = [NSMutableArray arrayWithCapacity:50];
    self.classicBooks = [NSMutableArray arrayWithCapacity:50];
    self.shakespeareBooks = [NSMutableArray arrayWithCapacity:50];
    
    self.dataStore = [PGBDataStore sharedDataStore];
    [self.dataStore fetchData];
    
    [self addMainTable];
    
    //fetch from parse when the app opens for the first time
    [self fetchBookFromParse];
    
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

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //do it once
    dispatch_once (&onceToken, ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading Books";
        hud.labelFont = [UIFont fontWithName:@"Moon-Bold" size:14.0f];
        
        NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
        
        [backgroundQueue addOperationWithBlock:^{
            NSArray *mostPopularBooks = @[ @"etext1342", @"etext46", @"etext11", @"etext76", @"etext84", @"etext1952", @"etext1661", @"etext2701", @"etext23", @"etext98", @"etext5200", @"etext345", @"etext1232", @"etext74", @"etext2542", @"etext844", @"etext174", @"etext4300", @"etext1400", @"etext1260", @"etext135"];
            
            for (NSString *ebookNumber in mostPopularBooks) {
                PGBRealmBook *book =[PGBRealmBook generateBooksWitheBookID:ebookNumber];
                if (book) {
                    [self.books addObject:book];
                }
            }
            
            NSArray *harvardClassicBooks = @[ @"etext22456", @"etext28", @"etext4081", @"etext1597", @"etext1399", @"etext1656", @"etext13726", @"etext10378", @"etext20203", @"etext4028", @"etext2880", @"etext3296", @"etext1657", @"etext766", @"etext12816", @"etext1012", @"etext996", @"etext9662", @"etext16643", @"etext1237", @"etext8418", @"etext5314", @"etext41", @"etext2610", @"etext3160", @"etext18269", @"etext1342", @"etext1232", @"etext33"];
            
            for (NSString *ebookNumber in harvardClassicBooks) {
                PGBRealmBook *book =[PGBRealmBook generateBooksWitheBookID:ebookNumber];
                if (book) {
                    [self.classicBooks addObject:book];
                }
            }
            
            
            NSArray *shakespearesBooks = @[ @"etext2265", @"etext1777", @"etext2264", @"etext2267", @"etext1041", @"etext2235", @"etext2242", @"etext1430", @"etext1128", @"etext1522", @"etext1121", @"etext2243", @"etext2253", @"etext1107", @"etext1103", @"etext2240", @"etext1539", @"etext1535", @"etext2268", @"etext1126", @"etext1045" ];
            
            for (NSString *ebookNumber in shakespearesBooks) {
                PGBRealmBook *book =[PGBRealmBook generateBooksWitheBookID:ebookNumber];
                if (book) {
                    [self.shakespeareBooks addObject:book];
                } else {
                    NSLog(@"this is outttttt: %@", ebookNumber);
                }
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [hud setHidden:YES];
                [self.mainTable reloadData];
            }];
        }];
        
    });
    
    
}

#pragma mark Generate Books

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
                            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                            [center postNotificationName:@"StoringDataFromParseToRealm" object:nil];
                        }];
                        
                    }];
                }
            }];
            
        }
    }];
}

- (void)generateBook {
    PGBDataStore *dataStore = [PGBDataStore sharedDataStore];
    [dataStore fetchData];
    
    for (NSInteger i = 0; i < 30; i++) {
        PGBRealmBook *newBook = [PGBRealmBook createPGBRealmBookWithBook:dataStore.managedBookObjects[i]];
        if (newBook) {
            [self.books addObject:newBook];
        }
    }
    
    [self.mainTable reloadData];
}


- (NSURL *)createBookCoverURL:(NSString *)eBookNumber{
    NSString *eBookNumberParsed = [eBookNumber substringFromIndex:5];
    NSString *bookCoverURL = [NSString stringWithFormat:@"https://www.gutenberg.org/cache/epub/%@/pg%@.cover.medium.jpg", eBookNumberParsed, eBookNumberParsed];
    
    NSURL *url = [NSURL URLWithString:bookCoverURL];
    return url;
}
#pragma mark TableView Methods 

- (void)addMainTable {
    
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.bounces = NO;
    if ([kDeviceOS >= 9.0f) {
        self.mainTable.cellLayoutMarginsFollowReadableWidth = NO;
    }
    self.mainTable.backgroundColor = [UIColor whiteColor];
    self.mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.mainTable];
    // top should equal navbar.mas_bottom and bottom should equal tabbar.mas_top
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64.0f);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height).offset(-113.0f);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else return (iPadUI) ? 90.0f : 45.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithRed:0.29 green:0.72 blue:0.31 alpha:1.0];
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(8.0f);
        make.centerY.mas_equalTo(headerView.mas_centerY);
        
    }];
    
    if (section == 1)
        sectionLabel.text = @"Popular";
    else if (section == 2)
        sectionLabel.text = @"Classics";
    else if (section == 3)
        sectionLabel.text = @"Shakespear";
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.section == 0) ? tableView.frame.size.height / 2.75f : tableView.frame.size.height / 3.75f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.section == 0 && indexPath.row == 0) {
        PGBImageTableViewCell *imageCell = [[PGBImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageCell"];
        [imageCell.mainImage setImage:[UIImage imageNamed:@"girlimage"]];
        cell = imageCell;
    } else {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumLineSpacing = 12.0f;
        [flowLayout setSectionInset:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];

        self.bookView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.bookView.tag = indexPath.section;
        self.bookView.dataSource = self;
        self.bookView.delegate = self;
        self.bookView.backgroundColor = [UIColor whiteColor];
        [self.bookView registerClass:[PGBCustomBookCollectionViewCell class] forCellWithReuseIdentifier:@"BookCover"];
        
        [cell.contentView addSubview:self.bookView];
        [self.bookView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.contentView.mas_top);
            make.bottom.mas_equalTo(cell.contentView.mas_bottom);
            make.right.mas_equalTo(cell.contentView.mas_right);
            make.left.mas_equalTo(cell.contentView.mas_left);
        }];
    }
    return cell;
}



#pragma mark CollectionView methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag == 1) {
        return self.books.count;
    } else if (collectionView.tag == 2) {
        return self.classicBooks.count;
    }  else if (collectionView.tag == 3) {
        return self.shakespeareBooks.count;
    }
    
    return self.classicBooks.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.width / 4.5 , collectionView.frame.size.height - 24.0f);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PGBCustomBookCollectionViewCell *cell = (PGBCustomBookCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCover" forIndexPath:indexPath];
    
    if (collectionView.tag == 1) {
        if (self.books.count != 0) {
            if (indexPath.row < self.books.count) {
                PGBRealmBook *book = self.books[indexPath.row];
                cell.titleLabel.text = book.title;
                cell.authorLabel.text = book.author;
            }
        }
        return cell;
        
    } else if (collectionView.tag == 2) {
        if (self.classicBooks.count != 0) {
            if (indexPath.row < self.classicBooks.count) {
                PGBRealmBook *book = self.classicBooks[indexPath.row];
                cell.titleLabel.text = book.title;
                cell.authorLabel.text = book.author;
            }
        }
        return cell;
        
    } else if (collectionView.tag == 3) {
        if (self.shakespeareBooks.count != 0) {
            if (indexPath.row < self.shakespeareBooks.count) {
                PGBRealmBook *book = self.shakespeareBooks[indexPath.row];
                    cell.titleLabel.text = book.title;
                    cell.authorLabel.text = @"William Shakespeare";
            }
        }
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PGBRealmBook *bookAtIndexPath = nil;
    
    if (collectionView.tag == 1) bookAtIndexPath = self.books[indexPath.row];
    else if (collectionView.tag == 2) bookAtIndexPath = self.classicBooks[indexPath.row];
    else if (collectionView.tag == 3) bookAtIndexPath = self.shakespeareBooks[indexPath.row];
    
    PGBBookViewController *bookInfoVC = [[PGBBookViewController alloc] init];
    bookInfoVC.book = bookAtIndexPath;
    [self.navigationController pushViewController:bookInfoVC animated:YES];
}

#pragma mark Login Methods

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
        
        // user logged in
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Do you want to logout?"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             self.loginButton.enabled = NO;
                                                             
                                                             //update parse when user logs out
                                                             [PGBRealmBook updateParseWithRealmBookDataWithCompletion:^(BOOL success) {
                                                                 if (success) {
                                                                     NSLog(@"update parse completed");
                                                                 } else {
                                                                     NSLog(@"failed to updateParseWithRealmBookDataWithCompletion");
                                                                 }
                                                                 
                                                                 [PFUser logOut];
                                                                 self.loginButton.enabled = YES;
                                                                 self.loginButton.title = @"Login";
                                                             }];
                                                         }];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
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
    
    [[[UIAlertView alloc] initWithTitle:@"Failed to log in..."
                                message:@"Make sure you enter valid credentials!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    
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

#pragma mark Parse Methods

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
    self.loginButton.title = @"Logout";
}

@end