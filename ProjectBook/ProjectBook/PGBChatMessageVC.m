//
//  PGBChatMessageVC.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/3/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBChatMessageVC.h"
#import "JSQMessage.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessagesTimestampFormatter.h"
#import "JSQPhotoMediaItem.h"
#import "JSQMessagesTypingIndicatorFooterView.h"
#import "UIImage+JSQMessages.h"
#import "JSQSystemSoundPlayer+JSQMessages.h"
#import "PGBBookViewController.h"
#import "PGBRealmBook.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PGBChatMessageVC ()

@property(strong, nonatomic) NSMutableArray *messagesInConversation;
@property (strong, nonatomic) NSDictionary *messageContent;

@property (nonatomic, strong) NSMutableArray *locallySentMessages; // ones to be cleared when we get a push notification

@property (nonatomic) BOOL tookOverASecond;

@end

@implementation PGBChatMessageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    PFUser *currentPerson = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"bookChat"];

    self.tookOverASecond = YES;
    
    [self performSelector:@selector(startProgressHud)
               withObject:nil
               afterDelay:1.0];

    [query getObjectInBackgroundWithId:self.currentChatRoom.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        
        PFObject *notChatRoom = object;
        [notChatRoom addObject:currentPerson.objectId forKey:@"usersInChat"];
        
        [notChatRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            
            self.tookOverASecond = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];

        }];
    }];
    
    self.messagesInConversation = [NSMutableArray new];
    self.locallySentMessages = [NSMutableArray new];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    NSString *channelName = [NSString stringWithFormat:@"chat-%@", self.currentChatRoom.objectId];
    [[PFInstallation currentInstallation] addUniqueObject:channelName forKey:@"channels"];
    [[PFInstallation currentInstallation] saveInBackground];
    
    self.title = self.currentChatRoom.topic;
    
    NSString *senderParseId = currentPerson.objectId;
    NSString *senderUserName = currentPerson.username;
    self.senderId = senderParseId;
    self.senderDisplayName = senderUserName;
    
    [self loadPastMessagesFromPriorToEnteringChat];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"NewMessage" object:nil];
}

- (void)startProgressHud {
    
    if (self.tookOverASecond) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    
}

- (void)animateAlphaOfView {
    
    [UIView animateWithDuration:2.0
                     animations:^{
                         
                         self.view.alpha = 1.0;
                         
                     }];
}



- (void)loadPastMessagesFromPriorToEnteringChat {
    
    NSMutableArray *gotMessages = [NSMutableArray new];
    PFQuery *query = [PFQuery queryWithClassName:@"bookChatMessages"];
    [query whereKey:@"bookChatId" equalTo:self.currentChatRoom.objectId];
    [query orderByDescending:@"createdAt"];
    [query setLimit:100];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects.", objects.count);
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                
                JSQMessage *latestMessage = [[JSQMessage alloc] initWithSenderId:object[@"senderId"]
                                                               senderDisplayName:object[@"senderDisplayName"]
                                                                            date:object.createdAt
                                                                            text:object[@"text"]];
                
                
                [gotMessages addObject:latestMessage];
            }
            
            NSLog(@"got messages array>>> %@", gotMessages);
            [self removeLocallySentMessagesAndMergeNewMessages:gotMessages];
            [self finishReceivingMessageAnimated:YES];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(viewBook:)];
    
}

- (void)closePressed:(UIBarButtonItem *)sender {
    [[PFInstallation currentInstallation] removeObjectForKey:@"channels"];
    [[PFInstallation currentInstallation] saveInBackground];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewBook:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"bookDetailFun" sender:self];
}

- (JSQMessage *)messageCreatedAt:(NSDate *)date withText:(NSString *)text {
    for(JSQMessage *message in self.messagesInConversation) {
        if([message.date isEqual:date] && [message.text isEqualToString:text]) {
            return message;
        }
    }
    
    return nil;
}

- (void)removeLocallySentMessagesAndMergeNewMessages:(NSArray *)messages {
    [self.messagesInConversation removeObjectsInArray:self.locallySentMessages];
    [self.locallySentMessages removeAllObjects];
    
    for(JSQMessage *message in messages) {
        if([self messageCreatedAt:message.date withText:message.text]) {
            continue;
        }
        
        [self.messagesInConversation addObject:message];
    }
    
    [self.messagesInConversation sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES] ]];
}

- (void) receiveNotification:(NSNotification *) notification {
    
    NSMutableArray *gotMessages = [NSMutableArray new];
    
    if (![[notification name] isEqualToString:@"NewMessage"]) {
        NSLog(@"receiveNotification: error: notification name invalid; name=%@; expected=dGWeFofcrQ", notification.name);
        return;
    }
    [self scrollToBottomAnimated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"bookChatMessages"];
    [query whereKey:@"bookChatId" equalTo:self.currentChatRoom.objectId];
    [query orderByDescending:@"createdAt"];
    [query setLimit:100];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu objects.", objects.count);
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                
                JSQMessage *latestMessage = [[JSQMessage alloc] initWithSenderId:object[@"senderId"]
                                                               senderDisplayName:object[@"senderDisplayName"]
                                                                            date:object.createdAt
                                                                            text:object[@"text"]];
                
                
                [gotMessages addObject:latestMessage];
            }
            
            NSLog(@"got messages array>>> %@", gotMessages);
            [self removeLocallySentMessagesAndMergeNewMessages:gotMessages];
            [self finishReceivingMessageAnimated:YES];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
}

- (void)pushMainViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:nc.topViewController animated:YES];
}

- (void)configureWithEllipsisColor:(UIColor *)ellipsisColor messageBubbleColor:(UIColor *)messageBubbleColor shouldDisplayOnLeft:(BOOL)shouldDisplayOnLeft forCollectionView:(UICollectionView *)collectionView {
    
}



-(void)didPressSendButton:(UIButton *)button
          withMessageText:(NSString *)text
                 senderId:(NSString *)senderId
        senderDisplayName:(NSString *)senderDisplayName
                     date:(NSDate *)date {
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.locallySentMessages addObject:message];
    
    [self.messagesInConversation addObject:message];
    PFObject *bookChatMessage = [PFObject objectWithClassName:@"bookChatMessages"];
    bookChatMessage[@"text"] = message.text;
    bookChatMessage[@"senderId"] = message.senderId;
    bookChatMessage[@"senderDisplayName"] = message.senderDisplayName;
    bookChatMessage[@"bookChatId"] = self.currentChatRoom.objectId;
    [bookChatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            // The object has been saved.
            NSLog(@"bookChatMessage saved");
        } else {
            
            
            // There was a problem, check error.description
            NSLog(@"Problem saving: %@", error.description);
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"bookChat"];
    [query getObjectInBackgroundWithId:self.currentChatRoom.objectId block:^(PFObject * _Nullable bookChat, NSError * _Nullable error) {
        
        bookChat[@"lastMessageAt"] = [NSDate date];
        [bookChat saveInBackground];
        [self.delegate newMessageUpdateTableView:self.currentChatRoom];
    }];
    [self finishSendingMessageAnimated:YES];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messagesInConversation objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messagesInConversation removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    JSQMessagesBubbleImage *outgoingBubbleImage = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];
    
    
    JSQMessagesBubbleImage *incomingBubbleImage = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed:0 green:136.0f/255.0f blue:62.0f/255.0 alpha:1.0]];
    
    
    
    JSQMessage *message = [self.messagesInConversation objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return outgoingBubbleImage;
    }
    
    return incomingBubbleImage;
}


// TODO: set avatars off of users profile picture...
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messagesInConversation objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messagesInConversation objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messagesInConversation objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.messagesInConversation count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messagesInConversation objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender {
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messagesInConversation objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messagesInConversation objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender {
    if ([UIPasteboard generalPasteboard].image) {
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messagesInConversation addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PGBBookViewController *destVC = segue.destinationViewController;
    
    PGBRealmBook *bookFromRealm = [PGBRealmBook generateBooksWitheBookID:self.currentChatRoom.bookId];
    destVC.book = bookFromRealm;
}


@end
