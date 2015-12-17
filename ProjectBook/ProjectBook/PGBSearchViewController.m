//
//  PGBSearchViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSearchViewController.h"
#import "PGBBookViewController.h"
#import "PGBSearchCustomTableCell.h"
#import "PGBRealmBook.h"
#import "PGBDataStore.h"
#import "Book.h"
#import <Masonry/Masonry.h>


@interface PGBSearchViewController () <UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UISearchBar *bookSearchBar;
@property (strong, nonatomic) UIView *defaultContentView;

@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) PGBDataStore *dataStore;

@property (strong, nonatomic)UITapGestureRecognizer *dismissKeyboardGesture;

@property (nonatomic, strong)NSOperationQueue *bgQueue;
@property (nonatomic, strong)NSOperationQueue *bookCoverBgQueue;

@property (nonatomic, strong) NSTimer *searchTimer;

@end

@implementation PGBSearchViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadDefaultView];
    
    self.dataStore = [PGBDataStore sharedDataStore];
    [self.dataStore fetchData];
    
    self.books = [[NSMutableArray alloc]init];
    
    self.dismissKeyboardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:self.dismissKeyboardGesture];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bookSearchBar.hidden = NO;
}

- (void)loadDefaultView{
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
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBSearchCustomTableCell" bundle:nil] forCellReuseIdentifier:@"SearchCustomCell"];
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
    
    UIButton *dramaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [dramaButton addTarget:self
                     action:@selector(dramaButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [dramaButton setTitle:@"Drama" forState:UIControlStateNormal];
    dramaButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [historyButton addTarget:self
                    action:@selector(historyButtonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
    [historyButton setTitle:@"History" forState:UIControlStateNormal];
    historyButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    UIButton *comedyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [comedyButton addTarget:self
                      action:@selector(comedyButtonTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    [comedyButton setTitle:@"Comedy" forState:UIControlStateNormal];
    comedyButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    UIButton *operaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [operaButton addTarget:self
                     action:@selector(operaButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [operaButton setTitle:@"Opera" forState:UIControlStateNormal];
    operaButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    UIButton *biographyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [biographyButton addTarget:self
                     action:@selector(biographyButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [biographyButton setTitle:@"Biography" forState:UIControlStateNormal];
    biographyButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    UIButton *childrenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [childrenButton addTarget:self
                     action:@selector(childrenButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    [childrenButton setTitle:@"Children" forState:UIControlStateNormal];
    childrenButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    
    //adding buttons to stack view
    UIStackView *genreButtonStackView = [[UIStackView alloc]init];
    genreButtonStackView.axis = UILayoutConstraintAxisVertical;
    genreButtonStackView.distribution = UIStackViewDistributionFillEqually;
    genreButtonStackView.alignment = UIStackViewAlignmentCenter;
    genreButtonStackView.spacing = 0;
    
    [genreButtonStackView addArrangedSubview:fictionButton];
    [genreButtonStackView addArrangedSubview:romanceButton];
    [genreButtonStackView addArrangedSubview:dramaButton];
    [genreButtonStackView addArrangedSubview:historyButton];
    [genreButtonStackView addArrangedSubview:comedyButton];
    [genreButtonStackView addArrangedSubview:operaButton];
    [genreButtonStackView addArrangedSubview:biographyButton];
    [genreButtonStackView addArrangedSubview:childrenButton];
    
    genreButtonStackView.translatesAutoresizingMaskIntoConstraints = false;
    [self.defaultContentView addSubview:genreButtonStackView];
    
    [genreButtonStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.defaultContentView);
    }];
}


-(void)fictionButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"fiction";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)romanceButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"romance";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)dramaButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"drama";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)historyButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"history";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)comedyButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"comedy";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)operaButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"opera";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)biographyButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"biography";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}

-(void)childrenButtonTapped:(UIButton *)sender {
    self.bookSearchBar.text = @"children";
    [self.bookSearchBar becomeFirstResponder];
    [self searchBar:self.bookSearchBar textDidChange:self.bookSearchBar.text];
}


#pragma UITableView DataSource Method ::
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bookTableView) {
        
        PGBSearchCustomTableCell *cell = (PGBSearchCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchCustomCell" forIndexPath:indexPath];
        
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
    
    PGBBookViewController *bookPageVC = segue.destinationViewController;

    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
    PGBRealmBook *bookAtIndexPath = self.books[selectedIndexPath.row];
    
    bookPageVC.book = bookAtIndexPath;
}

#pragma UISearchBar Method::

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar == self.bookSearchBar) {
        if (!self.bookSearchBar.text.length) {
            self.defaultContentView.hidden = NO;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar == self.bookSearchBar) {
        if (self.bookSearchBar.isFirstResponder) {
            self.defaultContentView.hidden = YES;
        }

        NSString *lowercaseAndUnaccentedSearchText = [searchText stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
        
        [self.searchTimer invalidate];
        self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(searchTimerFired:) userInfo:@{ @"searchString": lowercaseAndUnaccentedSearchText } repeats:NO];
        
        if (!searchText.length) {
            self.dismissKeyboardGesture.enabled = YES;
        } else {
            self.dismissKeyboardGesture.enabled = NO;
        }
        
    }
}

- (void)searchTimerFired:(NSTimer *)timer
{
    NSString *searchText = timer.userInfo[@"searchString"];
    
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"eBookSearchTerms CONTAINS %@", searchText];
    NSArray *coreDataBooks = [self.dataStore.managedBookObjects filteredArrayUsingPredicate:searchFilter];

    [self.books removeAllObjects];

    for (Book *coreDataBook in coreDataBooks) {
        PGBRealmBook *realmBook = [PGBRealmBook createPGBRealmBookWithBook:coreDataBook];

        if (realmBook) {
            [self.books addObject:realmBook];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bookTableView reloadData];
    });
}

- (void) hideKeyboard {
    self.defaultContentView.hidden = NO;
    [self.bookSearchBar resignFirstResponder];
}

#pragma UIScroll View Method::
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.bookTableView && self.bookSearchBar.text.length) {
        [self.bookSearchBar resignFirstResponder];
    }
    
}

@end
