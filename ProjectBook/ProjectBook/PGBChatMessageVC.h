//
//  PGBChatMessageVC.h
//  ProjectBook
//
//  Created by Lauren Reed on 12/3/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <JSQSystemSoundPlayer/JSQSystemSoundPlayer.h>
#import <Parse/Parse.h>
#import "PGBChatRoom.h"

@class PGBChatMessageVC;

@protocol PGBChatMessageVCDelegate <NSObject>

- (void)newMessageUpdateTableView:(PGBChatRoom *)updatedChatRoom;

@end

@interface PGBChatMessageVC : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>

@property (assign, nonatomic) id<PGBChatMessageVCDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *randomArray;
@property (strong, nonatomic) PGBChatRoom *currentChatRoom;

- (void) closePressed:(UIBarButtonItem *)sender;

@end
