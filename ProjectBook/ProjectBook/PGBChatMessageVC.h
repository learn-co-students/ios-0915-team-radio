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
@interface PGBChatMessageVC : JSQMessagesViewController

@property (strong, nonatomic) NSMutableArray *randomArray;
@property (strong, nonatomic) PGBChatRoom *currentChatRoom;

@end
