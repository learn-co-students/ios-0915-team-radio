//
//  PGBparsingThroughText.h
//  ProjectBook
//
//  Created by Priyansh Chordia on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGBparsingThroughText : NSObject


@property (strong, nonatomic) NSMutableArray *parsedText;
@property (strong, nonatomic) NSMutableArray *arrayOfEverything;

-(NSMutableArray *)parseATextFile;




@end
