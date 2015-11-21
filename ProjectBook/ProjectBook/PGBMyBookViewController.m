//
//  PGBMyBookViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/19/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBMyBookViewController.h"
#import "PGBBookCustomTableCell.h"
#import "PGBRealmBook.h"

@interface PGBMyBookViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *bookSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *bookSearchBar;

@property (strong, nonatomic) NSPredicate *searchFilter;

@property (strong, nonatomic)NSArray *books;
@property (strong, nonatomic)NSArray *booksDisplayed;

@end

@implementation PGBMyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.bookTableView.rowHeight = 70;
    
    self.bookTableView.delegate = self;
    self.bookTableView.dataSource = self;
    self.bookSearchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //begin test data
    [PGBRealmBook generateTestBookData];
    self.books = [PGBRealmBook getUserBookDataInArray];
    //end test data
    
    self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == 1 "];
    self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
}

- (IBAction)bookSegmentedControlSelected:(UISegmentedControl *)sender {
    
    if (self.bookSegmentControl.selectedSegmentIndex == 0) {
        
        if ([self.bookSearchBar.text isEqualToString:@""]) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == 1 "];
        } else {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isDownloaded == 1", self.bookSearchBar.text];
        }
        
        self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
    }
    else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
        
        if ([self.bookSearchBar.text isEqualToString:@""]) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == 1 "];
        } else {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isBookmarked == 1", self.bookSearchBar.text];
        }
        
        self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
    }
    
    [self.bookTableView reloadData];
}

- (IBAction)searchButtonTapped:(id)sender {
    [self.bookTableView setContentOffset:CGPointZero animated:YES];
    [self.bookSearchBar becomeFirstResponder];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.bookSearchBar becomeFirstResponder];
}

#pragma mark - Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.booksDisplayed.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bookTableView) {
        
        PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        PGBRealmBook *book = self.booksDisplayed[indexPath.row];
        cell.titleLabel.text = book.title;
        cell.authorLabel.text = book.author;
        cell.genreLabel.text = book.genre;
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (![searchText isEqualToString:@""]) {
        if (self.bookSegmentControl.selectedSegmentIndex == 0) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isDownloaded == 1", searchText];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        } else if (self.bookSegmentControl.selectedSegmentIndex == 1){
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isBookmarked == 1", searchText];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        }
    } else {
        if (self.bookSegmentControl.selectedSegmentIndex == 0) {
            NSLog(@"selected segment index = 0");
            self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == 1"];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        }
        else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
            NSLog(@"selected segment index = 1");
            self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == 1"];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        }
    }
    
    [self.bookTableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.bookSearchBar resignFirstResponder];
}

@end
