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
            
            NSString *eBookNumbers = @"";
            NSString *eBookTitles = @"";
            NSString *eBookAuthors = @"";
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
                    eBookNumbers = string;
                    NSString *eBookNumbersWithOutBeginning = [self getASubStringOfAString:eBookNumbers fromTheFirstCharacterOfACertainCharacter:@"\""];
                    eBookNumbers = [self getASubStringOfAString:eBookNumbersWithOutBeginning toTheFirstCharacterOfACertainCharacter:@"\""];
                
                }
                else if ([string hasPrefix:@"  <dc:title"])
                {
                    eBookTitles = string;
                    
                    NSString *eBookTitlesAfterFirstQuotationMark = [self getASubStringOfAString:eBookTitles fromTheFirstCharacterOfACertainCharacter:@"\""];
                    
                    
                    NSString *eBookTitlesAfterSecondQuoationMark = [self getASubStringOfAString:eBookTitlesAfterFirstQuotationMark fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    //LEO - this is cutting off the title / some titles go beyond more than 1 line!!
                    if ([eBookTitlesAfterSecondQuoationMark containsString:@"<"]) {
                        eBookTitles = [self getASubStringOfAString:eBookTitlesAfterSecondQuoationMark toTheFirstCharacterOfACertainCharacter:@"<"];
                    } else {
                        eBookTitles = eBookTitlesAfterSecondQuoationMark;
                    }

                }
                else if ([string hasPrefix:@"  <dc:creator"])
                {
                    eBookAuthors = string;
                    NSString *gettingRidOfPrefix = [self getASubStringOfAString:eBookAuthors fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookAuthors = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                
                else if ([string hasPrefix:@"  <pgterms:friendlytitle"]) {
                    eBookFriendlyTitle = string;
                    NSString *gettingRidOfPrefix = [self getASubStringOfAString:eBookFriendlyTitle fromTheFirstCharacterOfACertainCharacter:@">"];
                    eBookFriendlyTitle = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                else if ([string hasPrefix:@"  <dc:language>"])
                {
                    //LEO - works but is this reliable?
                    eBookLanguage = string;
                    
                    NSString *getRidOfBegining = [self getASubStringOfAString:eBookLanguage fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    NSString *getRidOfISONumber = [self getASubStringOfAString:getRidOfBegining fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    NSString *getRidOfRDFValue = [self getASubStringOfAString:getRidOfISONumber fromTheFirstCharacterOfACertainCharacter:@">"];
                    
                    eBookLanguage = [self getASubStringOfAString:getRidOfRDFValue toTheFirstCharacterOfACertainCharacter:@"<"];
                }
                else if ([string hasPrefix:@"      <rdf:li><dcterms:LCSH"])
                {
                    //LEO - works but is this reliable?
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
            
            //only generate dictionary for data with title and ebook number
            if (eBookTitles.length && eBookNumbers.length && eBookAuthors.length) {
                
                eBookNumbers = [eBookNumbers stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
                eBookTitles = [eBookTitles stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
                eBookAuthors = [eBookAuthors stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
                eBookFriendlyTitle = [eBookFriendlyTitle stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
                eBookLanguage = [eBookLanguage stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
                eBookGenre = [eBookGenre stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:nil];
                
                NSMutableString *result = [eBookGenre mutableCopy];
                [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                                           options:NSStringEnumerationByWords
                                        usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                            [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                                  withString:[[substring substringToIndex:1] uppercaseString]];
                                        }];
                eBookGenre = result;
                
                
                eBookTitles = [eBookTitles stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                eBookTitles = [eBookTitles stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                eBookFriendlyTitle = [eBookFriendlyTitle stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                eBookFriendlyTitle = [eBookFriendlyTitle stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                
                if ([eBookLanguage isEqualToString:@"en"]){
                    eBookLanguage = @"English";
                } else if ([eBookLanguage isEqualToString:@"de"]){
                    eBookLanguage = @"German";
                } else if ([eBookLanguage isEqualToString:@"fr"]){
                    eBookLanguage = @"French";
                } else if ([eBookLanguage isEqualToString:@"it"]){
                    eBookLanguage = @"Italian";
                } else if ([eBookLanguage isEqualToString:@"fi"]){
                    eBookLanguage = @"Finnish";
                } else if ([eBookLanguage isEqualToString:@"zh"]){
                    eBookLanguage = @"Chinese";
                } else if ([eBookLanguage isEqualToString:@"es"]){
                    eBookLanguage = @"Spanish";
                } else if ([eBookLanguage isEqualToString:@"pt"]){
                    eBookLanguage = @"Portuguese";
                } else if ([eBookLanguage isEqualToString:@"tr"]){
                    eBookLanguage = @"Turkish";
                } else if ([eBookLanguage isEqualToString:@"el"]){
                    eBookLanguage = @"Greek";
                }  else if ([eBookLanguage isEqualToString:@"eo"]){
                    eBookLanguage = @"Esperanto";
                }  else if ([eBookLanguage isEqualToString:@"la"]){
                    eBookLanguage = @"Latin";
                }  else if ([eBookLanguage isEqualToString:@"hu"]){
                    eBookLanguage = @"Hungarian";
                } else if ([eBookLanguage isEqualToString:@"ru"]){
                    eBookLanguage = @"Russian";
                }  else if ([eBookLanguage isEqualToString:@"nl"]){
                    eBookLanguage = @"Dutch";
                }  else if ([eBookLanguage isEqualToString:@"pl"]){
                    eBookLanguage = @"Polish";
                }   else if ([eBookLanguage isEqualToString:@"tl"]){
                    eBookLanguage = @"Tagalog";
                }  else if ([eBookLanguage isEqualToString:@"ca"]){
                    eBookLanguage = @"Catalan";
                }  else if ([eBookLanguage isEqualToString:@"da"]){
                    eBookLanguage = @"Danish";
                }  else if ([eBookLanguage isEqualToString:@"no"]){
                    eBookLanguage = @"Norwegian";
                }  else if ([eBookLanguage isEqualToString:@"ja"]){
                    eBookLanguage = @"Japanese";
                }  else if ([eBookLanguage isEqualToString:@"sl"]){
                    eBookLanguage = @"Slovenian";
                }  else if ([eBookLanguage isEqualToString:@"bg"]){
                    eBookLanguage = @"Bulgarian";
                }  else if ([eBookLanguage isEqualToString:@"sv"]){
                    eBookLanguage = @"Swedish";
                }  else if ([eBookLanguage isEqualToString:@"cs"]){
                    eBookLanguage = @"Czech";
                }  else if ([eBookLanguage isEqualToString:@"ia"]){
                    eBookLanguage = @"Interlingua";
                }  else if ([eBookLanguage isEqualToString:@"ilo"]){
                    eBookLanguage = @"Iloko";
                }  else if ([eBookLanguage isEqualToString:@"he"]){
                    eBookLanguage = @"Hebrew";
                }  else if ([eBookLanguage isEqualToString:@"te"]){
                    eBookLanguage = @"Telugu";
                }  else if ([eBookLanguage isEqualToString:@"is"]){
                    eBookLanguage = @"Icelandic";
                }  else if ([eBookLanguage isEqualToString:@"lt"]){
                    eBookLanguage = @"Lithuanian";
                }  else if ([eBookLanguage isEqualToString:@"br"]){
                    eBookLanguage = @"Breton";
                }  else if ([eBookLanguage isEqualToString:@"cy"]){
                    eBookLanguage = @"Welsh";
                }  else if ([eBookLanguage isEqualToString:@"af"]){
                    eBookLanguage = @"Afrikaans";
                }  else if ([eBookLanguage isEqualToString:@"gla"]){
                   eBookLanguage = @"Gaelic, Scottish";
                } else if ([eBookLanguage isEqualToString:@"ro"]){
                    eBookLanguage = @"Romanian";
                } else if ([eBookLanguage isEqualToString:@"arp"]){
                    eBookLanguage = @"Arapaho";
                } else if ([eBookLanguage isEqualToString:@"fur"]){
                    eBookLanguage = @"Friulian";
                } else if ([eBookLanguage isEqualToString:@"oc"]){
                    eBookLanguage = @"Occitan";
                } else if ([eBookLanguage isEqualToString:@"yi"]){
                    eBookLanguage = @"Yiddish";
                } else if ([eBookLanguage isEqualToString:@"gl"]){
                    eBookLanguage = @"Galician";
                } else if ([eBookLanguage isEqualToString:@"enm"]){
                    eBookLanguage = @"Middle English";
                } else if ([eBookLanguage isEqualToString:@"oji"]){
                    eBookLanguage = @"Ojibwa";
                } else if ([eBookLanguage isEqualToString:@"yi"]){
                    eBookLanguage = @"Yiddish";
                } else {
//                    NSLog (@"language needs to be changed: %@", eBookLanguage);
                }
                
                //create dictionary of processed data
                NSDictionary *newDict = [self turnStringsIntoArrayOfDictionaryWithEBookNumbers:eBookNumbers eBookTitles:eBookTitles eBookAuthors:eBookAuthors eBookFriendlyTitles:eBookFriendlyTitle eBookLanguages:eBookLanguage eBookGenres:eBookGenre];
                
                [arrayOfDictionaries addObject:newDict];
            }
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







