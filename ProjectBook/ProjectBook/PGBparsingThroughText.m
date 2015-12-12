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

-(instancetype)init
{
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
    
    NSMutableArray *mutableNestedArray = [self.nestedArrayOfAllInformation mutableCopy];
    NSMutableArray *arrayOfDictionaries = [[NSMutableArray alloc] init];
    
    /* 
     here we end up with an array full of arrays
     */
    
    for (NSUInteger i = 0; i < mutableNestedArray.count; i++)
    {
        NSMutableArray *informationArray = mutableNestedArray[i];
        
        for (NSUInteger j = 0; j < informationArray.count; j++)
        {
            /*
             the elements are all strings
             */
            NSMutableArray *arrayBeingLookedAt = informationArray[j];
            
            NSString *ebookNumbers = @"";
            NSString *eBookTitles = @"";
            NSString *ebookAuthors = @"";
            NSString *eBookFriendlyTitle = @"";
            NSString *eBookLanguage = @"";
            NSString *eBookGenre = @"";
    
            for (NSString *string in arrayBeingLookedAt)
            {
                /*
                 All eBooksNumbers have @"<pgterms:etext" as a prefix tag in the text file
                 If this string is there, all unusable characters are removed, and just the ebook numbers remain.  The same thing is done with strings, and all other book categories, each using similar formats
                 */

                if ([string hasPrefix:@"<pgterms:etext"])
                {
                    ebookNumbers = string;
                    NSString *eBookNumbersWithOutBeginning = [self getASubStringOfAString:ebookNumbers fromTheFirstCharacterOfACertainCharacter:@"\""];
                    ebookNumbers = [self getASubStringOfAString:eBookNumbersWithOutBeginning toTheFirstCharacterOfACertainCharacter:@"\""];
                }
                else if ([string hasPrefix:@"  <dc:title"])
                {
                    eBookTitles = string;
                    
                    NSString *eBookTitlesAfterFirstQuotationMark = [self getASubStringOfAString:eBookTitles fromTheFirstCharacterOfACertainCharacter:@"\""];
                    NSString *eBookTitlesAfterSecondQuoationMark = [self getASubStringOfAString:eBookTitlesAfterFirstQuotationMark fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookTitles = [self getASubStringOfAString:eBookTitlesAfterSecondQuoationMark toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                else if ([string hasPrefix:@"  <dc:creator"])
                {
                    ebookAuthors = string;
                    NSString *gettingRidOfPrefix = [self getASubStringOfAString:ebookAuthors fromTheFirstCharacterOfACertainCharacter:@">"];
                    ebookAuthors = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                
                else if ([string hasPrefix:@"  <pgterms:friendlytitle"]) {
                    eBookFriendlyTitle = string;
                    NSString *gettingRidOfPrefix = [self getASubStringOfAString:eBookFriendlyTitle fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookFriendlyTitle = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                else if ([string hasPrefix:@"  <dc:language>"])
                {
                    eBookLanguage = string;
                    
                    NSString *getRidOfBegining = [self getASubStringOfAString:eBookLanguage fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    NSString *getRidOfISONumber = [self getASubStringOfAString:getRidOfBegining fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    NSString *getRidOfRDFValue = [self getASubStringOfAString:getRidOfISONumber fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    eBookLanguage = [self getASubStringOfAString:getRidOfRDFValue toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                else if ([string hasPrefix:@"      <rdf:li><dcterms:LCSH"])
                {
                    eBookGenre = string;
                    
                    NSString *getRidOfFirstGreaterThanSign = [self getASubStringOfAString:eBookGenre fromTheFirstCharacterOfACertainCharacter:@">"];
                    NSString *getRidOfSecondGreaterThanSign = [self getASubStringOfAString:getRidOfFirstGreaterThanSign fromTheFirstCharacterOfACertainCharacter:@">"];
                    NSString *getRidOfThirdGreaterThanSign = [self getASubStringOfAString:getRidOfSecondGreaterThanSign fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookGenre = [self getASubStringOfAString:getRidOfThirdGreaterThanSign toTheFirstCharacterOfACertainCharacter:@"<"];
                }
            }
            /*
             Use all the informations from the arrays to generate a dictionary of books with all the correct information
             */
            NSDictionary *newDict = [self turnStringsIntoArrayOfDictionaryWithEBookNumbers:ebookNumbers eBookTitles:eBookTitles eBookAuthors:ebookAuthors eBookFriendlyTitles:eBookFriendlyTitle eBookLanguages:eBookLanguage eBookGenres:eBookGenre];
            
            [arrayOfDictionaries addObject:newDict];
        }
    }
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
                                                      eBookGenres:(NSString *)eBookGenres
{
    
    NSDictionary *newDictionary = @{@"eBookNumbers":eBookNumbers,
                                    @"eBookTitles":eBookTitles,
                                    @"eBookAuthors":eBookAuthors,
                                    @"eBookFriendlyTitles":eBookFriendlyTitles,
                                    @"eBookLanguages":eBookLanguages,
                                    @"eBookGenres":eBookGenres,
                                    };
    
    return newDictionary;
}

-(NSArray *)makeNestedArraysFromAnArrayOfStrings:(NSArray *)array AtASpecificCharater:(NSString *)string
{
    NSMutableArray *mutableCopy = [array mutableCopy];
    NSMutableArray *resultingArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
   
    for (NSUInteger i = 0; i < mutableCopy.count; i++)
    {
        if (![mutableCopy[i] isEqualToString:string])
        {
            [tempArray addObject:mutableCopy[i]];
           
        } else {
            [resultingArray addObject:[tempArray copy]];
            [tempArray removeAllObjects];
        }
    }
    return [resultingArray copy];
}

-(NSString *)getASubStringOfAString:(NSString *)string fromTheFirstCharacterOfACertainCharacter:(NSString *)character
{
    NSString *newString = @"";
    for (NSUInteger i = 0; i < string.length; i++)
    {
        unichar currentCharacter = [string characterAtIndex:i];
        if ([[NSString stringWithFormat:@"%C", currentCharacter] isEqualToString:character])
        {
            newString = [string substringFromIndex:i+1];
            break;
        }
    }
    return newString;
    
}

-(NSString *)getASubStringOfAString:(NSString *)string toTheFirstCharacterOfACertainCharacter:(NSString *)character
{
    NSString *newString = @"";
    for (NSUInteger i = 0; i < string.length; i++)
    {
        unichar currentCharacter = [string characterAtIndex:i];
        if ([[NSString stringWithFormat:@"%C", currentCharacter] isEqualToString:character])
        {
            newString = [string substringToIndex:i];
            break;
        }
    }
    return newString;
}




@end







