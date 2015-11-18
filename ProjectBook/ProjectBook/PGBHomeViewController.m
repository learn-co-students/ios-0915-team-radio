//
//  PGBHomeViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/18/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBHomeViewController.h"
#import "BookTableViewCell.h"

@interface PGBHomeViewController ()

@end

@implementation PGBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.bookTableView setDelegate:self];
    [self.bookTableView setDataSource:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookTableViewCell *cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil];
        cell = [nibArray objectAtIndex:0];
        
    }
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
