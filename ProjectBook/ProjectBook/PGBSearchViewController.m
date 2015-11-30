//
//  PGBSearchViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSearchViewController.h"
#import "PGBBookCustomTableCell.h"
#import "PGBRealmBook.h"
#import <Masonry/Masonry.h>

@interface PGBSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (strong, nonatomic)UISearchBar *bookSearchBar;
@property (strong, nonatomic)UISearchController *searchController;
@property (strong, nonatomic)NSArray *books;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)UIView *defaultContentView;

@end

@implementation PGBSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //begin test data
    [PGBRealmBook generateTestBookData];
    self.books = [PGBRealmBook getUserBookDataInArray];
    //end test data
    
    
    self.bookSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 10, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height/2)];
    self.bookSearchBar.placeholder = @"Search";
    self.bookSearchBar.delegate = self;
    
    [self.navigationController.navigationBar addSubview:self.bookSearchBar];
    
    [self.bookSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"), NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
//
//    self.searchController.searchBar.delegate = self;
//    self.searchController.searchResultsUpdater = self;
    
//        self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.bookTableView.rowHeight = 70;

    self.bookTableView.delegate = self;
    self.bookTableView.dataSource = self;
    
    //default content view to show book genres
    self.defaultContentView = [[UIView alloc]initWithFrame:[self.bookTableView bounds]];
    self.defaultContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.defaultContentView];

    [self.defaultContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"search controller protocol!!");
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bookTableView) {
        
        PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        PGBRealmBook *book = self.books[indexPath.row];
        
        cell.titleLabel.text = book.title;
        cell.authorLabel.text = book.author;
        cell.genreLabel.text = book.genre;
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.defaultContentView.hidden = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.bookSearchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);

    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:self.bookSearchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar {
        self.defaultContentView.hidden = NO;
    [searchBar resignFirstResponder];
}




@end
