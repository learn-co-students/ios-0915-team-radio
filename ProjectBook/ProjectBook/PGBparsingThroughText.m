//
//  PGBparsingThroughText.m
//  ProjectBook
//
//  Created by Priyansh Chordia on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBparsingThroughText.h"

@interface PGBparsingThroughText ()

@property (strong, nonatomic, readwrite) NSMutableArray *nestedArrayOfAllInformation;


@end


@implementation PGBparsingThroughText

-(instancetype)init {
    
    self = [super init];
    _nestedArrayOfAllInformation = [[NSMutableArray alloc] init];
    
    return self;
}


-(NSArray *)parseATextFile:(NSString *)file {
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:file withExtension:@"txt"];
    
    NSString *fileContents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineSet];
    
    
    
    
    NSArray *newArray = [self makeNestedArraysFromAnArrayOfStrings:lines AtASpecificCharater:@""];
    
    return newArray;
}

-(void)informationFromAllBooks {
    
    //[self.nestedArrayOfAllInformation addObject:[self parseATextFile:@"bookInformationSet1"]];
    
    NSArray *informationArray1 = [self parseATextFile:@"bookInformationSet1"];
    
    NSArray *informationArray2 = [self parseATextFile:@"bookInformationSet2"];
    NSArray *informationArray3 = [self parseATextFile:@"bookInformationSet3"];
    NSArray *informationArray4 = [self parseATextFile:@"bookInformationSet4"];
    NSArray *informationArray5 = [self parseATextFile:@"bookInformationSet5"];
    NSArray *informationArray6 = [self parseATextFile:@"bookInformationSet6"];
    NSArray *informationArray7 = [self parseATextFile:@"bookInformationSet7"];
    NSArray *informationArray8 = [self parseATextFile:@"bookInformationSet8"];
    NSArray *informationArray9 = [self parseATextFile:@"bookInformationSet9"];
    NSArray *informationArray10 = [self parseATextFile:@"bookInformationSet10"];
    NSArray *informationArray11 = [self parseATextFile:@"bookInformationSet11"];
    NSArray *informationArray12 = [self parseATextFile:@"bookInformationSet12"];
    NSArray *informationArray13 = [self parseATextFile:@"bookInformationSet13"];
    NSArray *informationArray14 = [self parseATextFile:@"bookInformationSet14"];
    NSArray *informationArray15 = [self parseATextFile:@"bookInformationSet15"];
    NSArray *informationArray16 = [self parseATextFile:@"bookInformationSet16"];
    NSArray *informationArray17 = [self parseATextFile:@"bookInformationSet17"];
    NSArray *informationArray18 = [self parseATextFile:@"bookInformationSet18"];
    NSArray *informationArray19 = [self parseATextFile:@"bookInformationSet19"];
    NSArray *informationArray20 = [self parseATextFile:@"bookInformationSet20"];
    
    [self.nestedArrayOfAllInformation addObject:informationArray1];
    [self.nestedArrayOfAllInformation addObject:informationArray2];
    [self.nestedArrayOfAllInformation addObject:informationArray3];
    [self.nestedArrayOfAllInformation addObject:informationArray4];
    [self.nestedArrayOfAllInformation addObject:informationArray5];
    [self.nestedArrayOfAllInformation addObject:informationArray6];
    [self.nestedArrayOfAllInformation addObject:informationArray7];
    [self.nestedArrayOfAllInformation addObject:informationArray8];
    [self.nestedArrayOfAllInformation addObject:informationArray9];
    [self.nestedArrayOfAllInformation addObject:informationArray10];
    [self.nestedArrayOfAllInformation addObject:informationArray11];
    [self.nestedArrayOfAllInformation addObject:informationArray12];
    [self.nestedArrayOfAllInformation addObject:informationArray13];
    [self.nestedArrayOfAllInformation addObject:informationArray14];
    [self.nestedArrayOfAllInformation addObject:informationArray15];
    [self.nestedArrayOfAllInformation addObject:informationArray16];
    [self.nestedArrayOfAllInformation addObject:informationArray17];
    [self.nestedArrayOfAllInformation addObject:informationArray18];
    [self.nestedArrayOfAllInformation addObject:informationArray19];
    [self.nestedArrayOfAllInformation addObject:informationArray20];
    
    
}

-(NSDictionary *)cleanUpArrays {
    
    [self informationFromAllBooks];
    
    //NSLog(@"Starting--------------");
    
    NSMutableArray *mutableNestedArray = [self.nestedArrayOfAllInformation mutableCopy];
    NSMutableArray *arrayOfDictionaries = [[NSMutableArray alloc] init];
    
    //NSLog(@"Starting First For Loop");
    
    
    for (NSUInteger i = 0; i < mutableNestedArray.count; i++) {
        NSMutableArray *informationArray = mutableNestedArray[i]; //an array full of arrays
        
        //NSLog(@"Logging the mutableArray %@", mutableNestedArray);
        
        //NSLog(@"Starting second for loop");
        
        for (NSUInteger j = 0; j < informationArray.count; j++) {
            NSMutableArray *arrayBeingLookedAt = informationArray[j]; //contains NSStrings
            
            //NSLog(@"%@", informationArray);
            
            NSString *ebookNumbers = @"";
            NSString *eBookTitles = @"";
            NSString *ebookAuthors = @"";
            NSString *eBookFriendlyTitle = @"";
            NSString *eBookLanguage = @"";
            NSString *eBookGenre = @"";
            
            //NSLog(@"starting for in loop");
            
            for (NSString *string in arrayBeingLookedAt) {
                
                //NSLog(@"%@", string);
                
                if ([string hasPrefix:@"<pgterms:etext"]) {
                    ebookNumbers = string;
                    NSString *eBookNumbersWithOutBeginning = [self getASubStringOfAString:ebookNumbers fromTheFirstCharacterOfACertainCharacter:@"\""];
                    ebookNumbers = [self getASubStringOfAString:eBookNumbersWithOutBeginning toTheFirstCharacterOfACertainCharacter:@"\""];
                    //ebookNumbers = [ebookNumbers stringByAppendingString:@"Priyansh"];
                    
                }
                else if ([string hasPrefix:@"  <dc:title"]) {
                    eBookTitles = string;
                    
                    NSString *eBookTitlesAfterFirstQuotationMark = [self getASubStringOfAString:eBookTitles fromTheFirstCharacterOfACertainCharacter:@"\""];
                    NSString *eBookTitlesAfterSecondQuoationMark = [self getASubStringOfAString:eBookTitlesAfterFirstQuotationMark fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookTitles = [self getASubStringOfAString:eBookTitlesAfterSecondQuoationMark toTheFirstCharacterOfACertainCharacter:@"<"];
                    //eBookTitles = [eBookTitles stringByAppendingString:@"Priyansh"];
                    
                }
                
                else if ([string hasPrefix:@"  <dc:creator"]) {
                    ebookAuthors = string;
                    NSString *gettingRidOfPrefix = [self getASubStringOfAString:ebookAuthors fromTheFirstCharacterOfACertainCharacter:@">"];
                    ebookAuthors = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
                    //ebookAuthors = [ebookAuthors stringByAppendingString:@"Priyansh"];
                }
                
                else if ([string hasPrefix:@"  <pgterms:friendlytitle"]) {
                    eBookFriendlyTitle = string;
                    NSString *gettingRidOfPrefix = [self getASubStringOfAString:eBookFriendlyTitle fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookFriendlyTitle = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
                    //eBookFriendlyTitle = [eBookFriendlyTitle stringByAppendingString:@"Priyansh"];
                    
                }
                else if ([string hasPrefix:@"  <dc:language>"]) {
                    eBookLanguage = string;
                    
                    NSString *getRidOfBegining = [self getASubStringOfAString:eBookLanguage fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    NSString *getRidOfISONumber = [self getASubStringOfAString:getRidOfBegining fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    NSString *getRidOfRDFValue = [self getASubStringOfAString:getRidOfISONumber fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    eBookLanguage = [self getASubStringOfAString:getRidOfRDFValue toTheFirstCharacterOfACertainCharacter:@"<"];
                    //eBookLanguage = [eBookLanguage stringByAppendingString:@"Priyansh"];
                    
                    
                    
                }
                else if ([string hasPrefix:@"      <rdf:li><dcterms:LCSH"]) {
                    eBookGenre = string;
                    
                    NSString *getRidOfFirstGreaterThanSign = [self getASubStringOfAString:eBookGenre fromTheFirstCharacterOfACertainCharacter:@">"];
                    NSString *getRidOfSecondGreaterThanSign = [self getASubStringOfAString:getRidOfFirstGreaterThanSign fromTheFirstCharacterOfACertainCharacter:@">"];
                    NSString *getRidOfThirdGreaterThanSign = [self getASubStringOfAString:getRidOfSecondGreaterThanSign fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookGenre = [self getASubStringOfAString:getRidOfThirdGreaterThanSign toTheFirstCharacterOfACertainCharacter:@"<"];
                    //eBookGenre = [eBookGenre stringByAppendingString:@"Priyansh"];
                    
                }
                
                
            }
            
            //NSLog(@"Ending for in Loop");
            
            NSDictionary *newDict = [self turnStringsIntoArrayOfDictionaryWithEBookNumbers:ebookNumbers eBookTitles:eBookTitles eBookAuthors:ebookAuthors eBookFriendlyTitles:eBookFriendlyTitle eBookLanguages:eBookLanguage eBookGenres:eBookGenre];
            
            [arrayOfDictionaries addObject:newDict];
            
        } //NSLog(@"Ending Second For Loop");
        
    } //NSLog(@"Ending First For Loop");
    
    //NSLog(@"Done with Loops");
    return [arrayOfDictionaries copy];
    
    
}




/*
 
 
 ------------------------Helper Functions----------------------------------------
 
 
 */

-(NSDictionary *)turnStringsIntoArrayOfDictionaryWithEBookNumbers:(NSString *)eBookNumbers
                                                      eBookTitles:(NSString *)eBookTitles
                                                     eBookAuthors:(NSString *)eBookAuthors
                                              eBookFriendlyTitles:(NSString *)eBookFriendlyTitles
                                                   eBookLanguages:(NSString *)eBookLanguages
                                                      eBookGenres:(NSString *)eBookGenres {
    
    NSDictionary *newDictionary = @{@"eBookNumbers":eBookNumbers,
                                    @"eBookTitles":eBookTitles,
                                    @"eBookAuthors":eBookAuthors,
                                    @"eBookFriendlyTitles":eBookFriendlyTitles,
                                    @"eBookLanguages":eBookLanguages,
                                    @"eBookGenres":eBookGenres,
                                    };
    
    NSLog(@"This is the new Dictionary --------------- \n %@", newDictionary);
    return newDictionary;
}

-(NSArray *)makeNestedArraysFromAnArrayOfStrings:(NSArray *)array AtASpecificCharater:(NSString *)string {
    //NSLog(@"starting");
    NSMutableArray *mutableCopy = [array mutableCopy];
    NSMutableArray *resultingArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    //NSLog(@"Starting For Loop");
    for (NSUInteger i = 0; i < mutableCopy.count; i++) {
        if (![mutableCopy[i] isEqualToString:string]) {
            [tempArray addObject:mutableCopy[i]];
            //NSLog(@"%@", tempArray);
        } else {
            [resultingArray addObject:[tempArray copy]];
            //NSLog(@"%@", resultingArray);
            [tempArray removeAllObjects];
        }
    }
    return [resultingArray copy];
}

-(NSString *)getASubStringOfAString:(NSString *)string fromTheFirstCharacterOfACertainCharacter:(NSString *)character {
    NSString *newString = @"";
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar currentCharacter = [string characterAtIndex:i];
        if ([[NSString stringWithFormat:@"%C", currentCharacter] isEqualToString:character]) {
            newString = [string substringFromIndex:i+1];
            break;
        }
    }
    return newString;
    
}

-(NSString *)getASubStringOfAString:(NSString *)string toTheFirstCharacterOfACertainCharacter:(NSString *)character {
    NSString *newString = @"";
    for (NSUInteger i = 0; i < string.length; i++) {
        unichar currentCharacter = [string characterAtIndex:i];
        if ([[NSString stringWithFormat:@"%C", currentCharacter] isEqualToString:character]) {
            newString = [string substringToIndex:i];
            break;
        }
    }
    return newString;
}




@end








//-(NSArray *)parseATextFile {
//
//
//    NSMutableArray *resultingNestedArray = [[NSMutableArray alloc] init];
//
//    NSArray *bookInformationSets = @[@"bookInformationSet1",@"bookInformationSet2",
//                                     @"bookInformationSet5",@"bookInformationSet6",
//                                     @"bookInformationSet7",@"bookInformationSet8",
//                                     @"bookInformationSet9",@"bookInformationSet10",
//                                     @"bookInformationSet11",@"bookInformationSet12",
//                                     @"bookInformationSet13",@"bookInformationSet14",
//                                     @"bookInformationSet15",@"bookInformationSet16",
//                                     @"bookInformationSet17",@"bookInformationSet18",
//                                     @"bookInformationSet19",@"bookInformationSet20",
//                                     ];
//
//
//
//    for (NSString *bookInfoTitle in bookInformationSets) {
//        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:bookInfoTitle
//                                                 withExtension:@"txt"];
//        NSLog(@"%@", bookInfoTitle);
//        NSString *fileContents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
//
//
//        NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
//
//        NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineSet];
//
//
//        [resultingNestedArray addObject:[self makeNestedArraysFromAnArrayOfStrings:lines AtASpecificCharater:@""]];
//        NSLog(@"%@", resultingNestedArray);
//
//    }
//    return resultingNestedArray;
//}

