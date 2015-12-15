//
//  PGBChatRoom.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/8/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBChatRoom.h"

@implementation PGBChatRoom

@dynamic objectId;
@dynamic bookId;
@dynamic bookTitle;
@dynamic topic;
@dynamic lastMessageAt;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"bookChat";
}

@end



