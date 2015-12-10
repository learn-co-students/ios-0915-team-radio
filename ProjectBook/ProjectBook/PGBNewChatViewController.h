//
//  PGBNewChatViewController.h
//  ProjectBook
//
//  Created by Lauren Reed on 12/4/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <Parse/Parse.h>
@class PGBChatRoom;

@interface PGBNewChatViewController : UIViewController

@property (nonatomic, strong) PGBChatRoom *chatRoom;

@end
