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
#import "PGBDataStore.h"
#import "Book.h"
#import "PGBBookPageViewController.h"
#import <Masonry/Masonry.h>

@interface PGBSearchViewController () <UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UISearchBar *bookSearchBar;
@property (strong, nonatomic) UIView *defaultContentView;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) PGBDataStore *dataStore;

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
//    [PGBRealmBook generateTestBookData];
//    self.books = [PGBRealmBook getUserBookDataInArray];
    
    self.dataStore = [PGBDataStore sharedDataStore];
    [self.dataStore fetchData];
    
    self.books = [[NSMutableArray alloc]init];
    //end test data
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.bookSearchBar.hidden = NO;
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
    return self.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bookTableView) {
        
        PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        PGBRealmBook *realmBook = self.books[indexPath.row];

        if (realmBook.title.length != 0) {
            cell.titleLabel.text = realmBook.title;
        } else {
            cell.titleLabel.text = realmBook.friendlyTitle;
        }

        cell.authorLabel.text = realmBook.author;
        cell.genreLabel.text = realmBook.genre;
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.bookSearchBar resignFirstResponder];
    self.bookSearchBar.hidden = YES;
    
    [self performSegueWithIdentifier:@"bookDetailSegue" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PGBBookPageViewController *bookPageVC = segue.destinationViewController;
    
    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = self.books[selectedIndexPath.row];
//    Book *bookAtIndexPath = self.books[selectedIndexPath.row];
    
    if (bookAtIndexPath.title.length != 0) {
        bookPageVC.titleBook = bookAtIndexPath.title;
    } else {
        bookPageVC.titleBook = bookAtIndexPath.friendlyTitle;
    }
    
    bookPageVC.author = bookAtIndexPath.author;
    bookPageVC.genre = bookAtIndexPath.genre;
    bookPageVC.language = bookAtIndexPath.language;
    bookPageVC.bookDescription = @"No description yet";
    bookPageVC.ebookID = bookAtIndexPath.ebookID;
    bookPageVC.books = bookPageVC.books;
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
    
        //  this is causing some UI lag/FIX ME
        NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"(eBookTitles CONTAINS[c] %@) OR (eBookFriendlyTitles CONTAINS[c] %@)", searchText, searchText];
        //    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"(eBookTitles CONTAINS[c] %@) ", searchText];
        NSArray *coreDataBooks = [self.dataStore.managedBookObjects filteredArrayUsingPredicate:searchFilter];
        
        //convert core data book object into PGBRealmBook object
        [self.books removeAllObjects];
        
        for (Book *coreDataBook in coreDataBooks) {
            PGBRealmBook *realmBook = [[PGBRealmBook alloc]init];
            realmBook.title = coreDataBook.eBookTitles;
            realmBook.friendlyTitle = coreDataBook.eBookFriendlyTitles;
            realmBook.author = coreDataBook.eBookAuthors;
            realmBook.genre = coreDataBook.eBookGenres;
            realmBook.language = coreDataBook.eBookLanguages;
            realmBook.ebookID  = coreDataBook.eBookNumbers;
            //not getting book cover images here
            [self.books addObject:realmBook];
        }
    
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
