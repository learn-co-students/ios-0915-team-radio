//
//  PGBMainSocialTableViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/4/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBMainSocialTableViewController.h"
#import "PGBChatTableViewCell.h"
#import "PGBNewChatViewController.h"
#import "PGBChatRoom.h"
#import "PGBChatMessageVC.h"

@interface PGBMainSocialTableViewController ()

@property (strong, nonatomic) NSMutableArray *arrayOfOpenBookChats;
@property (weak, nonatomic) PGBChatRoom *chatRoom;
@property (strong, nonatomic) NSString *chatRoomId;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"goToChat" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"goToChat"]) {
        PGBChatMessageVC *chatVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        PGBChatRoom *currentChatRoom = self.arrayOfOpenBookChats[selectedIndexPath.row];
        
        PFUser *currentUser = [PFUser currentUser];
        PFObject *notChatRoom = [PFObject objectWithClassName:@"bookChat"];
        [notChatRoom addObject:currentUser.objectId forKey:@"usersInChat"];
        [notChatRoom saveInBackground];
        chatVC.currentChatRoom = currentChatRoom;
    }
}


@end
