//
//  PGBMyBookViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/19/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBMyBookViewController.h"
#import "PGBBookCustomTableCell.h"

@interface PGBMyBookViewController ()

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *authors;
@property (strong, nonatomic) NSMutableArray *genres;

@end

@implementation PGBMyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.myBookListTableView setDelegate:self];
    [self.myBookListTableView setDataSource:self];
    
    self.titles = [[NSMutableArray alloc]init];
    self.authors = [[NSMutableArray alloc]init];
    self.genres = [[NSMutableArray alloc]init];
    
    [self.titles addObject:@"Norwegian Wood"];
    [self.titles addObject:@"Kafka on the Shore"];
    
    [self.authors addObject:@"Haruki Murakami"];
    [self.authors addObject:@"Haruki Murakami"];
    
    [self.genres addObject:@"Fiction"];
    [self.genres addObject:@"Fiction"];
    
    [self.myBookListTableView registerNib:[UINib nibWithNibName:@"PGBBookCustomTableCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    
    self.myBookListTableView.rowHeight = 70;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.authorLabel.text = [self.authors objectAtIndex:indexPath.row];
    cell.genreLabel.text = [self.genres objectAtIndex:indexPath.row];
    
    return cell;
}
@end
