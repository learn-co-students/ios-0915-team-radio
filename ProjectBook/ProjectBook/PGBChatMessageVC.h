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

- (void)didDismissPGBChatMessageVC:(PGBChatMessageVC *)vc;

@end

@interface PGBChatMessageVC : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>

@property (weak, nonatomic) id<PGBChatMessageVCDelegate> delegateModal;

@property (strong, nonatomic) NSMutableArray *randomArray;
@property (strong, nonatomic) PGBChatRoom *currentChatRoom;

- (void) closePressed:(UIBarButtonItem *)sender;

@end
