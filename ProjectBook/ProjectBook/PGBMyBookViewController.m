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

@interface PGBMyBookViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *myBookListTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *bookSearchBar;
//@property (strong, nonatomic) IBOutlet UISearchController *bookSearchController;
@property (strong, nonatomic) IBOutlet UISearchController *bookSearchController;
@property (strong, nonatomic) NSPredicate *searchFilter;


@property (strong, nonatomic)NSArray *books;

@end

@implementation PGBMyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //begin test data
    [PGBRealmBook generateTestBookData];
    NSArray *books = [PGBRealmBook getUserBookDataInArray];
    self.books = @[books[0]];
    //end test data
    
    [self.myBookListTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.myBookListTableView.rowHeight = 70;
    
    self.myBookListTableView.delegate = self;
    self.myBookListTableView.dataSource = self;
    self.bookSearchBar.delegate = self;
    self.bookSearchController.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    NSLog(@"view did appear!!");
}

- (IBAction)bookSegmentedControlSelected:(UISegmentedControl *)sender {
    
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    NSArray *books = [PGBRealmBook getUserBookDataInArray];
    
    if (selectedSegment == 0) {
        NSLog(@"selected segment index = 0");
        self.books = @[books[0]];
    }
    else{
        NSLog(@"selected segment index = 1");
        self.books = @[books[1], books[2]];
    }
    
    [self.myBookListTableView reloadData];
}

- (IBAction)searchButtonTapped:(id)sender {
    self.bookSearchBar.hidden = NO;
    [self.bookSearchBar becomeFirstResponder];
}


#pragma mark - Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.myBookListTableView) {
        
        PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        PGBRealmBook *book = self.books[indexPath.row];
        cell.titleLabel.text = book.title;
        cell.authorLabel.text = book.author;
        cell.genreLabel.text = book.genre;
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
//    // Tells the table data source to reload when text changes
//
////    [self filterContentForSearchText:searchString scope:
////     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    // Tells the table data source to reload when scope bar selection changes
////    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
////     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
//    // Return YES to cause the search result table view to be reloaded.
//    return YES;
//}
//- (void)didDismissSearchController:(UISearchController *)searchController{
//    self.bookSearchBar.hidden = YES;
//}
//
//- (void)willDismissSearchController:(UISearchController *)searchController{
//    self.bookSearchBar.hidden = YES;
//        NSLog(@"dismiss seach contrlle");
//}
//
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
//    NSLog(@"update search result!");
//}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"editing search bar- text :%@", searchText);
    
    self.searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS %@",
                              searchText];
    
    self.books = [self.books filteredArrayUsingPredicate:self.searchFilter];
    [self.myBookListTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"search bar cancel button");
    
    
    [self dismissSearchBar];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"search bar should end edit");
    
    [self dismissSearchBar];
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissSearchBar];
}

- (void)dismissSearchBar{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.2;
    [self.bookSearchBar.layer addAnimation:animation forKey:nil];
    
    self.bookSearchBar.hidden = YES;
    
    [self.bookSearchBar resignFirstResponder];
}


@end
