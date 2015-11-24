//
//  WriteBooksDictionaryFile.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/23/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "WriteBooksDictionaryFile.h"

@implementation WriteBooksDictionaryFile

+ (void)writeFileWithBookArrayOfDictioanries:(NSArray *)arrayOfDictionaries{
    NSURL *url = [NSURL fileURLWithPath:@"/Users/wojunfeng/Desktop/file.txt"];
    
    NSString *newFileContent = [NSString stringWithFormat:@"And here is the next text"];
    
    [newFileContent writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end

