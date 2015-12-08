//
//  PGBMainSocialTableViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/4/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBMainSocialTableViewController.h"
#import "PGBChatTableViewCell.h"
#import "PGBChatRoom.h"

@interface PGBMainSocialTableViewController ()

@property (strong, nonatomic) NSMutableArray *arrayOfOpenBookChats;
@property (weak, nonatomic) PGBChatRoom *chatRoom;
@end

@implementation PGBMainSocialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfOpenBookChats = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PGBChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"bookWithChatCell"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"bookChat"];
    
    [query whereKeyExists:@"objectId"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PGBChatRoom *chatRoom in objects) {
            [self.arrayOfOpenBookChats addObject:chatRoom];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfOpenBookChats.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookWithChatCell" forIndexPath:indexPath];
//    tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    PGBChatTableViewCell *cell = (PGBChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"bookWithChatCell" forIndexPath:indexPath];
    
    PGBChatRoom *bookChat = self.arrayOfOpenBookChats[indexPath.row];
    cell.titleLabel.text = bookChat.bookTitle;
    cell.chatTopicLabel.text = bookChat.topic;
    
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
