//
//  PGBChatTableViewCell.h
//  ProjectBook
//
//  Created by Lauren Reed on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGBChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookCover;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookChatTopic;

@end
