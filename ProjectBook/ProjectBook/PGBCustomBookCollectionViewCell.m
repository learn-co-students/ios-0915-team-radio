//
//  PGBCustomBookCollectionViewCell.m
//  ProjectBook
//
//  Created by Olivia Lim on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBCustomBookCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PGBCustomBookCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleTV.editable = NO;
    self.titleTV.selectable = NO;
    
    self.overlayView.layer.borderColor = [UIColor blackColor].CGColor;
    self.overlayView.layer.borderWidth = 3.0f;
}

@end
