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

@protocol PGBNewChatVCDelegate <NSObject>

- (void)sendNewChatToVC:(PGBChatRoom *)chatRoom;

@end

@interface PGBNewChatViewController : UIViewController

@property (nonatomic, assign) id <PGBNewChatVCDelegate> delegate;
@property (nonatomic, strong) PGBChatRoom *chatRoom;

- (IBAction)creatChatTouched:(id)sender;


@end
