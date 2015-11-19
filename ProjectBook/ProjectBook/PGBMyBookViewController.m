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

@interface PGBMyBookViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myBookListTableView;

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *authors;
@property (strong, nonatomic) NSMutableArray *genres;

//@property (strong, nonatomic)NSArray *books;
@property (strong, nonatomic)NSArray *books;

@end

@implementation PGBMyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.myBookListTableView setDelegate:self];
    [self.myBookListTableView setDataSource:self];
    
    //begin test data
    //only run this once!
//    PGBRealmBook *book1 = [[PGBRealmBook alloc]initWithTitle:@"Norwegian" author:@"Hariku Murakami" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
//    [PGBRealmBook storeUserBookDataWithBook:book1];
//    
//    PGBRealmBook *book2 = [[PGBRealmBook alloc]initWithTitle:@"Kafka on the Shore" author:@"Hariku Murakami" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
//    [PGBRealmBook storeUserBookDataWithBook:book2];
//    
//    PGBRealmBook *book3 = [[PGBRealmBook alloc]initWithTitle:@"Sup" author:@"Leo" genre:@"Fiction" language:@"English" downloadURL:@"" bookDescription:@"" datePublished:[NSDate date] ebookID:0];
//    [PGBRealmBook storeUserBookDataWithBook:book3];
    
    self.books = @[[PGBRealmBook getUserBookDataInArray][0]];
    //end test data
    
    [self.myBookListTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    self.myBookListTableView.rowHeight = 70;
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.books.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];

    PGBRealmBook *book = self.books[indexPath.row];
    cell.titleLabel.text = book.title;
    cell.authorLabel.text = book.author;
    cell.genreLabel.text = book.genre;
    
    return cell;
}
@end
