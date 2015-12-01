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

@interface PGBSearchViewController () <UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UISearchBar *bookSearchBar;
@property (strong, nonatomic) NSArray *books;
@property (strong, nonatomic) NSArray *booksDisplayed;
@property (strong, nonatomic) UIView *defaultContentView;

@end

@implementation PGBSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create search bar
    self.bookSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 10, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height/2)];
    self.bookSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.bookSearchBar.placeholder = @"Search";
    self.bookSearchBar.delegate = self;
    
    [self.navigationController.navigationBar addSubview:self.bookSearchBar];
    
    [self.bookSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    //create table view custom cell
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.bookTableView.rowHeight = 70;
    
    self.bookTableView.delegate = self;
    self.bookTableView.dataSource = self;
    
    //create default content view to show book genres
    self.defaultContentView = [[UIView alloc]initWithFrame:[self.bookTableView bounds]];
    self.defaultContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.defaultContentView];
    
    [self.defaultContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //create book genre buttons into stack view
    UIButton *fictionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [fictionButton addTarget:self
               action:@selector(fictionButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    [fictionButton setTitle:@"Fiction" forState:UIControlStateNormal];
    fictionButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    UIButton *romanceButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [romanceButton addTarget:self
                      action:@selector(romanceButtonTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    [romanceButton setTitle:@"Romance" forState:UIControlStateNormal];
    romanceButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    //adding buttons to stack view
    UIStackView *genreButtonStackView = [[UIStackView alloc]init];
    genreButtonStackView.axis = UILayoutConstraintAxisVertical;
    genreButtonStackView.distribution = UIStackViewDistributionFillEqually;
    genreButtonStackView.alignment = UIStackViewAlignmentCenter;
    genreButtonStackView.spacing = 0;
    
    [genreButtonStackView addArrangedSubview:fictionButton];
    [genreButtonStackView addArrangedSubview:romanceButton];
    
    genreButtonStackView.translatesAutoresizingMaskIntoConstraints = false;
    [self.defaultContentView addSubview:genreButtonStackView];
    
    [genreButtonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.defaultContentView);
    }];
    
    //begin test data
    [PGBRealmBook generateTestBookData];
    self.books = [PGBRealmBook getUserBookDataInArray];
    //end test data
}

-(void)fictionButtonTapped:(UIButton *)sender {
    NSLog(@"fiction button Tapped!");
}

-(void)romanceButtonTapped:(UIButton *)sender {
    NSLog(@"romance button tapped!");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

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

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.defaultContentView.hidden = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if ([self.bookSearchBar.text length] == 0) {
        self.defaultContentView.hidden = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.bookSearchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
    
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", searchText];
    self.booksDisplayed = [self.books filteredArrayUsingPredicate:searchFilter];
    
    [self.bookTableView reloadData];
    
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:self.bookSearchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar {
    self.defaultContentView.hidden = NO;
    [searchBar resignFirstResponder];
}




@end
