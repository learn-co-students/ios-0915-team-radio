//
//  PGBNewChatViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/4/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBNewChatViewController.h"
#import "PGBBookCustomTableCell.h"
#import "PGBRealmBook.h"
#import "PGBDataStore.h"
#import "PGBChatRoom.h"
#import "PGBSearchChatPreviewViewController.h"
#import "PGBChatMessageVC.h"

@interface PGBNewChatViewController () <UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bookSearchTableView;
@property (weak, nonatomic) IBOutlet UIView *searchview;
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UIButton *createChatButton;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIView *defaultView;
@property (strong, nonatomic) NSMutableArray *books;
@property (strong, nonatomic) PGBDataStore *dataStore;

@property (weak, nonatomic) IBOutlet UIView *previewContainerView;
@property (nonatomic, weak) PGBSearchChatPreviewViewController *previewVC;

@property (strong, nonatomic) PGBRealmBook *selectedBook;

@property (strong, nonatomic) PGBChatRoom *createChat;
@property (strong, nonatomic) NSString *chatId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topicBottomConstraint;

@end

@implementation PGBNewChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultView];
    
    self.dataStore = [PGBDataStore sharedDataStore];
    [self.dataStore fetchData];
    self.books = [NSMutableArray new];
    
    self.topicTextField.delegate = self;
    [self.topicTextField setReturnKeyType:UIReturnKeyDone];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.topicTextField becomeFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)topicTextField{
    
    [self.topicTextField resignFirstResponder];
    return YES;
}

- (void)loadDefaultView {
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"Search for a book...";
    self.searchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    [self.bookSearchTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.bookSearchTableView.rowHeight = 70;
    
    self.bookSearchTableView.delegate = self;
    self.bookSearchTableView.dataSource = self;
    
    self.createChatButton.hidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bookSearchTableView) {
        
        PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
        
        //pagination
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
    
    [self.searchBar resignFirstResponder];
    self.searchBar.hidden = YES;
    tableView.hidden = YES;
    self.createChatButton.hidden = NO;
    //show book details in a sec
    self.previewVC.book = self.books[indexPath.row];
    [UIView animateWithDuration:0.25 animations:^{
        self.previewContainerView.alpha = 1;
    }];
    self.selectedBook = self.books[indexPath.row];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.defaultView.hidden = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if ([self.searchBar.text length] == 0) {
        self.defaultView.hidden = NO;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *lowercaseAndUnaccentedSearchText = [searchText stringByFoldingWithOptions:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch locale:nil];
    
    NSPredicate *searchFilter = [NSPredicate predicateWithFormat:@"eBookSearchTerms CONTAINS %@", lowercaseAndUnaccentedSearchText];
    
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
    [self.bookSearchTableView reloadData];
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar {
    self.defaultView.hidden = NO;
    [searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PreviewEmbedSegue"]) {
        self.previewVC = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"toNewChat"]) {

        PGBChatMessageVC *chatMessageVC = (PGBChatMessageVC *)segue.destinationViewController;
        chatMessageVC.currentChatRoom = self.createChat;
        
        
    }
}

- (IBAction)creatChatTouched:(id)sender {
    
    if (self.topicTextField.text.length == 0){
     
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"Please include a topic!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okayAction];
        [self presentViewController:alert animated:YES completion:nil];
   
    } else {
        self.createChat = [PGBChatRoom new];
        self.createChat.topic = self.topicTextField.text;
        self.createChat.bookId = self.selectedBook.ebookID;
        self.createChat.bookTitle = self.selectedBook.title;
        [self.createChat save];
        
        // CALL ON DELEGATE TO MAKE IT DO STUFF
//        [self.delegate sendNewChatBackToFirstVC];
        // DISMISS (or make the delegate dismiss you)
        
    }
}



- (IBAction)returnToActiveChats:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
