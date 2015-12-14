//
//  PGBChatRoom.h
//  ProjectBook
//
//  Created by Lauren Reed on 12/8/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface PGBChatRoom : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *bookId;
@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSDate *lastMessageAt;

//+ (NSString *)parseClassName;

@end
