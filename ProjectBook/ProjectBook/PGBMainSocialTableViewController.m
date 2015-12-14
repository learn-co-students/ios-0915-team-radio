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
#import "DateTools.h"

@interface PGBMainSocialTableViewController ()

@property (strong, nonatomic) NSMutableArray *arrayOfOpenBookChats;
@property (weak, nonatomic) PGBChatRoom *chatRoom;
@property (strong, nonatomic) PGBChatRoom *createdChatRoom;
@property (strong, nonatomic) NSString *chatRoomId;
@property (strong, nonatomic) IBOutlet UITableView *chatTableView;

@end

@implementation PGBMainSocialTableViewController

- (void)sendNewChatToVC:(PGBChatRoom *)chatRoom{
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfOpenBookChats = [NSMutableArray new];
    self.chatTableView.rowHeight = 70;
    [self.tableView registerNib:[UINib nibWithNibName:@"PGBChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"bookWithChatCell"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"bookChat"];
    
    [query whereKeyExists:@"objectId"];
    [query addDescendingOrder:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (PGBChatRoom *chatRoom in objects) {
            [self.arrayOfOpenBookChats addObject:chatRoom];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
    [[PFInstallation currentInstallation] removeObjectForKey:@"channels"];
    [[PFInstallation currentInstallation] saveInBackground];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
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
    NSString *topic = [NSString stringWithFormat:@"Topic: %@", bookChat.topic];
    cell.chatTopicLabel.text = topic;
    NSString *timeAgo = [NSString stringWithFormat:@"Last Active: %@", bookChat.lastMessageAt.timeAgoSinceNow];
    cell.lastActiveLabel.text = timeAgo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"goToChat" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"goToChat"]) {
//        UINavigationController *navController = segue.destinationViewController;
//        PGBChatMessageVC *chatViewController = (PGBChatMessageVC *)navController.topViewController;
        PFUser *currentUser = [PFUser currentUser];
        if (!currentUser){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"You need to login to use this feature." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okayAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
        
        PGBChatMessageVC *chatViewController = (PGBChatMessageVC *)segue.destinationViewController;

        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        PGBChatRoom *currentChatRoom = self.arrayOfOpenBookChats[selectedIndexPath.row];
        
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"bookChat"];
        PFObject *notChatRoom = [query getObjectWithId:currentChatRoom.objectId];
        [notChatRoom addObject:currentUser.objectId forKey:@"usersInChat"];
        [notChatRoom saveInBackground];
        
        chatViewController.currentChatRoom = currentChatRoom;
    }
    
    }
}
- (IBAction)addButtonTapped:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"You need to login to use this feature." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okayAction];
        [self presentViewController:alert animated:YES completion:nil];
    
    } else {
    
    PGBNewChatViewController *newChatVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newChatVC"];
    newChatVC.delegate = self;
    [self presentViewController:newChatVC animated:YES completion:nil];

    }
}

- (void)didDismissPGBChatMessageVC:(PGBChatMessageVC *)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
