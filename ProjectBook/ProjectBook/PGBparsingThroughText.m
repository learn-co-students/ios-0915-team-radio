//
//  PGBparsingThroughText.m
//  ProjectBook
//
//  Created by Priyansh Chordia on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBparsingThroughText.h"

@implementation PGBparsingThroughText

-(NSMutableArray *)parseATextFile {
    
    
    self.arrayOfEverything = [NSMutableArray new];
    NSArray *bookInformationSets = @[@"bookInformationSet1",@"bookInformationSet2",
                                     @"bookInformationSet3",@"bookInformationSet4",
                                     @"bookInformationSet6",@"bookInformationSet7",
                                     @"bookInformationSet8",@"bookInformationSet9",
                                     @"bookInformationSet10",@"bookInformationSet11",
                                     @"bookInformationSet12",@"bookInformationSet13",
                                     @"bookInformationSet14",@"bookInformationSet15",
                                     @"bookInformationSet16"];
    
    
    for (NSUInteger j = 0; j<bookInformationSets.count; j++) {
        //NSLog(@"------ STARTING BOOK SET %ld", j);
        
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@", bookInformationSets[j]] withExtension:@"txt"];
        
        NSString *fileContents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
        
        
        NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
        
        NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineSet];
        
        self.parsedText = [lines mutableCopy];
        
        
        NSMutableArray *eBookNumbers = [[NSMutableArray alloc] init];
        NSMutableArray *bookTitles = [[NSMutableArray alloc] init];
        NSMutableArray *bookAuthor = [[NSMutableArray alloc] init];
        //NSMutableArray *friendlyTitle = [[NSMutableArray alloc] init];
        
        
        for (NSUInteger i = 0; i < self.parsedText.count; i++) {
            
            if ([self.parsedText[i] hasPrefix:@"<pgterms:etext"]) {
                
                [eBookNumbers addObject:self.parsedText[i]];
            }
            
            else if ([self.parsedText[i] hasPrefix:@"  <dc:title"]) {
                
                [bookTitles addObject:self.parsedText[i]];
            }
            
            else if ([self.parsedText[i] hasPrefix:@"  <dc:creator"]) {
                [bookAuthor addObject:self.parsedText[i]];
            }
            
            
        }
        [self.arrayOfEverything addObject:eBookNumbers];
        [self.arrayOfEverything addObject:bookTitles];
        [self.arrayOfEverything addObject:bookAuthor];
    }
    
    //NSLog(@"DONE");
    return self.arrayOfEverything;
    
    
}




@end
