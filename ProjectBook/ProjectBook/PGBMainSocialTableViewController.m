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

//TODO:

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfOpenBookChats = [NSMutableArray new];
    self.chatTableView.rowHeight = 70;
    [self.tableView registerNib:[UINib nibWithNibName:@"PGBChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"bookWithChatCell"];
    [self getArrayOfBookChatsFromParse];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.40 green:0.74 blue:0.33 alpha:1.0];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadTableViewWithBackgroundUpdatesFromParse)
                  forControlEvents:UIControlEventValueChanged];
    
    // TODO: Ask tim about this...
//    [[PFInstallation currentInstallation] removeObjectForKey:@"channels"];
//    [[PFInstallation currentInstallation] saveInBackground];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)reloadTableViewWithBackgroundUpdatesFromParse {
    
    [self getArrayOfBookChatsFromParse];
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
    [self.refreshControl endRefreshing];
}

- (void)getArrayOfBookChatsFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"bookChat"];
    
    //    [query whereKeyExists:@"objectId"];
    [query addDescendingOrder:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.arrayOfOpenBookChats removeAllObjects];
        for (PGBChatRoom *chatRoom in objects) {
            [self.arrayOfOpenBookChats addObject:chatRoom];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self resortChatsAndReloadTable];
        }];
    }];
}

-(void)newMessageUpdateTableView:(PGBChatRoom *)currentChatRoom{
    [self resortChatsAndReloadTable];
}

-(void) resortChatsAndReloadTable{
    NSSortDescriptor *byDate = [NSSortDescriptor sortDescriptorWithKey:@"lastMessageAt" ascending:NO];
    
    [self.arrayOfOpenBookChats sortUsingDescriptors:@[byDate]];
    [self.tableView reloadData];
}

- (void)sendNewChatToVC:(PGBChatRoom *)createdChatRoom{
    
    [self.arrayOfOpenBookChats insertObject:createdChatRoom atIndex:0];
    [self.chatTableView reloadData];
    NSIndexPath *ipOfNewBookChat = [NSIndexPath indexPathForItem:0 inSection:0];
    [self tableView:self.chatTableView didSelectRowAtIndexPath:ipOfNewBookChat];
}

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
        
        PFUser *currentUser = [PFUser currentUser];
        if (!currentUser){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"You need to login to use this feature." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okayAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                
                PGBChatMessageVC *chatViewController = (PGBChatMessageVC *)segue.destinationViewController;
            
                
                NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
                PGBChatRoom *currentChatRoom = self.arrayOfOpenBookChats[selectedIndexPath.row];
            chatViewController.currentChatRoom = currentChatRoom;
            chatViewController.delegate = self;
            
               
//                chatViewController.delegate = self;
//                chatViewController.currentChatRoom = currentChatRoom;
            
            
            
                // hide MBProgressHUD
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            });
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                });
//            });
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
