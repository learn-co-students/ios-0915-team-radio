//
//  PGBLibraryViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/19/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBLibraryViewController.h"
#import "PGBSearchCustomTableCell.h"
#import "PGBRealmBook.h"
#import "PGBBookViewController.h"
#import "PGBParseAPIClient.h"
#import <YYWebImage/YYWebImage.h>


@interface PGBLibraryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *bookSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *bookSearchBar;

@property (strong, nonatomic) NSPredicate *searchFilter;

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) NSMutableArray *booksDisplayed;

@end

@implementation PGBLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBSearchCustomTableCell" bundle:nil] forCellReuseIdentifier:@"SearchCustomCell"];
    self.bookTableView.rowHeight = 80;
    
    self.bookTableView.delegate = self;
    self.bookTableView.dataSource = self;
    self.bookSearchBar.delegate = self;
    
    self.books = [[NSMutableArray alloc]init];
    self.booksDisplayed = [[NSMutableArray alloc]init];
    
    //load default table view content
    [self loadTableViewContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.bookSearchBar.text = @"";
    
    [self fetchBookFromRealm];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData:) name:@"StoringDataFromParseToRealm" object:nil];
}

- (void)reloadTableViewData: (NSNotification *)notification {
    NSLog(@"storing data from parse to realm, refresh table!!!");
    [self fetchBookFromRealm];
}

- (void)fetchBookFromRealm
{
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc]init];
    
    [bgQueue addOperationWithBlock:^{
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.books = [[PGBRealmBook getUserBookDataInArray] mutableCopy];
            [self loadTableViewContent];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self.bookTableView reloadData];
            }];
        }];
    }];
}


- (void)fetchBookFromParse
{
    NSOperationQueue *bgQueue = [[NSOperationQueue alloc]init];
    
    [bgQueue addOperationWithBlock:^{
        if ([PFUser currentUser]) {
            
            [PGBParseAPIClient fetchUserProfileDataWithUserObject:[PFUser currentUser] andCompletion:^(PFObject *data) {
                NSLog(@"user data: %@", data);
                
                PFObject *user = data;
                if (user) {
                    
                    [PGBRealmBook fetchUserBookDataFromParseStoreToRealmWithCompletion:^{
                        NSLog(@"successfully fetch book from parse");
                        
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            self.books = [[PGBRealmBook getUserBookDataInArray] mutableCopy];
                            [self loadTableViewContent];
                            [self.bookTableView reloadData];
                        }];
                    }];
                }
            }];
            
        } else {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                self.books = [[PGBRealmBook getUserBookDataInArray] mutableCopy];
                [self loadTableViewContent];
                [self.bookTableView reloadData];
            }];
        }
    }];
}

- (void)loadTableViewContent
{
    if (self.bookSegmentControl.selectedSegmentIndex == 0) {
        self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == YES"];
        self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
    } else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
        self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == YES"];
        self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
    }
}

- (IBAction)bookSegmentedControlSelected:(UISegmentedControl *)sender
{
    
    if (self.bookSegmentControl.selectedSegmentIndex == 0) {
        
        if (!self.bookSearchBar.text.length) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == YES"];
        } else {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isDownloaded == YES", self.bookSearchBar.text];
        }
        
        self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
    }
    else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
        
        if (!self.bookSearchBar.text.length) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == YES"];
        } else {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isBookmarked == YES", self.bookSearchBar.text];
        }
        
        self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
    }
    
    [self.bookTableView reloadData];
    
}

- (IBAction)searchButtonTapped:(id)sender
{
    [UITableView animateWithDuration:0.2 animations:^{
        [self.bookTableView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        [self.bookSearchBar becomeFirstResponder];
    }];
}

#pragma mark - Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.booksDisplayed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.bookTableView) {
        
        PGBSearchCustomTableCell *cell = (PGBSearchCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchCustomCell" forIndexPath:indexPath];
        
        PGBRealmBook *book = self.booksDisplayed[indexPath.row];

        cell.titleLabel.text = book.title;
        cell.authorLabel.text = book.author;
        cell.genreLabel.text = book.genre;

        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""]) {
        if (self.bookSegmentControl.selectedSegmentIndex == 0) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isDownloaded == YES", searchText];
            self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
        } else if (self.bookSegmentControl.selectedSegmentIndex == 1){
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isBookmarked == YES", searchText];
            self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
        }
    } else {
        if (self.bookSegmentControl.selectedSegmentIndex == 0) {
            NSLog(@"selected segment index = 0");
            self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == YES"];
            self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
        }
        else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
            NSLog(@"selected segment index = 1");
            self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == YES"];
            self.booksDisplayed = [[self.books filteredArrayUsingPredicate:self.searchFilter] mutableCopy];
        }
    }
    
    [self.bookTableView reloadData];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.bookSearchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"bookDetailSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PGBBookViewController *bookPageVC = segue.destinationViewController;
    
    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = self.booksDisplayed[selectedIndexPath.row];
    
    bookPageVC.book = bookAtIndexPath;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.bookTableView) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.bookTableView & editingStyle == UITableViewCellEditingStyleDelete) {
 
        PGBRealmBook *bookToBeDeleted = self.booksDisplayed[indexPath.row];
        
        [self.booksDisplayed removeObject:bookToBeDeleted];
        
        [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
            if (self.bookSegmentControl.selectedSegmentIndex == 0) {
                bookToBeDeleted.isDownloaded = NO;
            } else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
                bookToBeDeleted.isBookmarked = NO;
            }
            
            return bookToBeDeleted;
        } andCompletion:^{
             [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];

    }
    
}

@end
