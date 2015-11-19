//
//  PGBHomeViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/18/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBHomeViewController.h"
#import "PGBBookCustomTableCell.h"
#import "PGBDownloadHelper.h"
#import "PGBBookPageViewController.h"

@interface PGBHomeViewController ()

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *authors;
@property (strong, nonatomic) NSMutableArray *genres;
@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;

@end

@implementation PGBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.bookTableView setDelegate:self];
    [self.bookTableView setDataSource:self];
   
    self.titles = [[NSMutableArray alloc]init];
    self.authors = [[NSMutableArray alloc]init];
    self.genres = [[NSMutableArray alloc]init];
    
    [self.titles addObject:@"Norwegian Wood"];
    [self.titles addObject:@"Kafka on the Shore"];
    
    [self.authors addObject:@"Haruki Murakami"];
    [self.authors addObject:@"Haruki Murakami"];
    
    [self.genres addObject:@"Fiction"];
    [self.genres addObject:@"Fiction"];
    
    [self.bookTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    self.bookTableView.rowHeight = 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PGBBookCustomTableCell *cell = (PGBBookCustomTableCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row];
//        cell.titleLabel.text = @"whatuppppppweawjnadjlandlkawndasSKJanskjBSNasjhbjansjhBSawa";
    cell.authorLabel.text = [self.authors objectAtIndex:indexPath.row];
    cell.genreLabel.text = [self.genres objectAtIndex:indexPath.row];
//        cell.genreLabel.text = @"lakjsdlf;ajwleralksjdflajwelkrajsdlfjalwejrlajsdfjlakwerlsal;er";
    [cell.downloadButton addTarget:self action:@selector(cellDownloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.bookURL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
    
    return cell;
}

-(void) cellDownloadButtonTapped:(UIButton*) button
{
    button.enabled = NO; // FIXME: re-enable button after download succeeds/fails
    // THIS IS A LIL HACKY — will change if you change the view heirarchy of the cell
    PGBBookCustomTableCell *cell = (PGBBookCustomTableCell*)[[[button superview] superview] superview];
    
    if (cell && [cell isKindOfClass:[PGBBookCustomTableCell class]]){
        NSLog(@"selected book is: %@; URL: %@", cell.titleLabel.text, cell.bookURL);
        
        NSURL *URL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
        self.downloadHelper = [[PGBDownloadHelper alloc] init];
        [self.downloadHelper download:URL];
    }
    else {
        NSLog(@"Didn't get a cell, I fucked UP");
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"bookInfoSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    PGBBookPageViewController *bookPageVC = segue.destinationViewController;
//    
//    NSIndexPath *selectedIndexPath = self.bookTableView.indexPathForSelectedRow;
//    FISLocation *locationAtIndex = self.bookTableView[selectedIndexPath.row];
//    
//    
//    bookPageVC.triviaDetails = locationAtIndex.trivia;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-
(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
