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
#import "PGBBookPageViewController.h"

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
    
    UIImage *logo = [[UIImage imageNamed:@"Novel_Logo_small"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.bookTableView.rowHeight = 70;
    
    self.bookTableView.delegate = self;
    self.bookTableView.dataSource = self;
    self.bookSearchBar.delegate = self;
    
    //begin test data
//    [PGBRealmBook generateTestBookData];
    //end test data
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.books = [PGBRealmBook getUserBookDataInArray];
    
    [self loadDefaultContent];
}

- (void)loadDefaultContent{
    self.bookSegmentControl.selectedSegmentIndex = 0;
    self.bookSearchBar.text = @"";
    self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == YES"];
    self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
    [self.bookTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

//    [self.bookTableView setContentOffset:CGPointMake(0, 44) animated:NO];
//    [self.bookTableView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)bookSegmentedControlSelected:(UISegmentedControl *)sender {
    
    if (self.bookSegmentControl.selectedSegmentIndex == 0) {
        
        if ([self.bookSearchBar.text isEqualToString:@""]) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == YES"];
        } else {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isDownloaded == YES", self.bookSearchBar.text];
        }
        
        self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
    }
    else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
        
        if ([self.bookSearchBar.text isEqualToString:@""]) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == YES"];
        } else {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isBookmarked == YES", self.bookSearchBar.text];
        }
        
        self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
    }
    
    [self.bookTableView reloadData];
    
}

- (IBAction)searchButtonTapped:(id)sender {
    
    [UITableView animateWithDuration:0.2 animations:^{
        [self.bookTableView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        [self.bookSearchBar becomeFirstResponder];
    }];
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
        
        if (book.bookCoverData) {
            cell.bookCover.image = [UIImage imageWithData: book.bookCoverData];
        }
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (![searchText isEqualToString:@""]) {
        if (self.bookSegmentControl.selectedSegmentIndex == 0) {
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isDownloaded == YES", searchText];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        } else if (self.bookSegmentControl.selectedSegmentIndex == 1){
            self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ AND isBookmarked == YES", searchText];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        }
    } else {
        if (self.bookSegmentControl.selectedSegmentIndex == 0) {
            NSLog(@"selected segment index = 0");
            self.searchFilter = [NSPredicate predicateWithFormat:@"isDownloaded == YES"];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        }
        else if (self.bookSegmentControl.selectedSegmentIndex == 1) {
            NSLog(@"selected segment index = 1");
            self.searchFilter = [NSPredicate predicateWithFormat:@"isBookmarked == YES"];
            self.booksDisplayed = [self.books filteredArrayUsingPredicate:self.searchFilter];
        }
    }
    
    [self.bookTableView reloadData];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.bookSearchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"bookDetailSegue" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PGBBookPageViewController *bookPageVC = segue.destinationViewController;
    
    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = self.booksDisplayed[selectedIndexPath.row];
    
    bookPageVC.book = bookAtIndexPath;
}

@end
