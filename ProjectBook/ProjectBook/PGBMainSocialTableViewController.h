//
//  PGBMainSocialTableViewController.h
//  ProjectBook
//
//  Created by Lauren Reed on 12/4/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PGBNewChatViewController.h"
#import "PGBChatMessageVC.h"

@interface PGBMainSocialTableViewController : UITableViewController <PGBNewChatVCDelegate, PGBChatMessageVCDelegate>
@end
