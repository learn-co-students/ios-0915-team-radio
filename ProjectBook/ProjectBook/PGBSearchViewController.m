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

@interface PGBSearchViewController () <UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource> {
    //pagination
    UIActivityIndicatorView *spinner;
    
}

@property (weak, nonatomic) IBOutlet UITableView *bookTableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) UISearchBar *bookSearchBar;
@property (strong, nonatomic) UIView *defaultContentView;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) PGBDataStore *dataStore;

//pagination
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) BOOL noMoreResultsAvail;
@property (nonatomic) BOOL loading;

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
    self.noMoreResultsAvail =NO;
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


#pragma UITableView DataSource Method ::
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.books.count;
    
    //pagination
    if([ self.books count] ==0){
        return 0;
    }
    else {
        return [self.books count]+1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bookTableView) {
        
        PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        //pagination
//        PGBRealmBook *realmBook = self.books[indexPath.row];

        
        //pagination
        if (self.books.count != 0) {
            if(indexPath.row <[self.books count]){
                
//                cell.textLabel.text =[self.dataArray objectAtIndex:indexPath.row];
                PGBRealmBook *realmBook = self.books[indexPath.row];
                
                if (realmBook.title.length != 0) {
                    cell.titleLabel.text = realmBook.title;
                } else {
                    cell.titleLabel.text = realmBook.friendlyTitle;
                }
                
                cell.authorLabel.text = realmBook.author;
                cell.genreLabel.text = realmBook.genre;
            }
            else{
                if (!self.noMoreResultsAvail) {
                    spinner.hidden =NO;
                    cell.textLabel.text=nil;
                    
                    
                    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    spinner.frame = CGRectMake(150, 10, 24, 50);
                    [cell addSubview:spinner];
                    if ([self.dataArray count] >= 10) {
                        [spinner startAnimating];
                    }
                }
                
                else{
                    [spinner stopAnimating];
                    spinner.hidden=YES;
                    
                    cell.textLabel.text=nil;
                    
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

#pragma UISearchBar Method::
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    self.defaultContentView.hidden = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if ([self.bookSearchBar.text length] == 0) {
        self.defaultContentView.hidden = NO;
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    //  this is causing some UI lag/FIX ME
    NSString *lowercaseAndUnaccentedSearchText = [searchText stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"eBookSearchTerms CONTAINS %@", lowercaseAndUnaccentedSearchText];
//    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"(eBookTitles CONTAINS[c] %@) OR (eBookFriendlyTitles CONTAINS[c] %@)", searchText, searchText];
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
    
    //pagination
    self.dataArray = [self.books mutableCopy];
//     NSArray *itemsForView = [completeArray subarrayWithRange: NSMakeRange( startIndex, count )];
    self.books = [[self.dataArray subarrayWithRange:NSMakeRange(0, 9)] mutableCopy];
    [self.dataArray removeObjectsInRange:NSMakeRange(0, 9)];

    [self.bookTableView reloadData];
    
    if ([searchText length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:self.bookSearchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar {
    
    self.defaultContentView.hidden = NO;
    [searchBar resignFirstResponder];
}

#pragma UIScroll View Method::
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.bookSearchBar resignFirstResponder];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scroll view did end decelarting");
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
//    
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
//    for (int i=1; i<=10 ; i++) {
//        
//        PGBRealmBook *newBook = [[PGBRealmBook alloc]init];
//        newBook.title = [NSString stringWithFormat:@"%lu",i];
//        [array addObject:newBook];
//    }
//    NSArray *newArray = [self.dataArray subarrayWithRange:NSMakeRange(10, 19)];
    NSArray *newArray = [self.dataArray subarrayWithRange:NSMakeRange(0, 9)];
    [self.dataArray removeObjectsInRange:NSMakeRange(0, 9)];
    [self.books addObjectsFromArray:newArray];
    
    [self.bookTableView reloadData];
}


@end
