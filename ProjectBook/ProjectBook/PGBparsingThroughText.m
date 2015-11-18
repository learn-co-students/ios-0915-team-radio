//
//  PGBparsingThroughText.m
//  ProjectBook
//
//  Created by Priyansh Chordia on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBparsingThroughText.h"

@interface PGBparsingThroughText ()

@property (strong, nonatomic, readwrite) NSMutableArray *parsedText;
@property (strong, nonatomic, readwrite) NSMutableArray *arrayOfEverything;

@property (strong, nonatomic, readwrite) NSMutableArray *alleBookNumbersInAnArray;
@property (strong, nonatomic, readwrite) NSMutableArray *allBookTitlesInAnArray;
@property (strong, nonatomic, readwrite) NSMutableArray *allBookAuthorsInAnArray;
@property (strong, nonatomic, readwrite) NSMutableArray *allFriendlyTitlesInAnArray;
@property (strong, nonatomic, readwrite) NSMutableArray *allLanguagesInAnArray;
@property (strong, nonatomic, readwrite) NSMutableArray *allGenresInAnArray;


@end




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
        NSMutableArray *friendlyTitle = [[NSMutableArray alloc] init];
        NSMutableArray *language = [[NSMutableArray alloc] init];
        NSMutableArray *genre = [[NSMutableArray alloc] init];
        
        
        
        
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
            
            else if ([self.parsedText[i] hasPrefix:@"  <pgterms:friendlytitle"]) {
                [friendlyTitle addObject:self.parsedText[i]];
            }
            
            else if ([self.parsedText[i] hasPrefix:@"  <dc:language>"]) {
                [language addObject:self.parsedText[i]];
            }
            
            else if ([self.parsedText[i] hasPrefix:@"      <rdf:li><dcterms:LCSH"]) {
                [genre addObject:self.parsedText[i]];
            }
            
        }
        [self.arrayOfEverything addObject:eBookNumbers];
        [self.arrayOfEverything addObject:bookTitles];
        [self.arrayOfEverything addObject:bookAuthor];
        [self.arrayOfEverything addObject:friendlyTitle];
        [self.arrayOfEverything addObject:language];
        [self.arrayOfEverything addObject:genre];
    }
    
    //NSLog(@"DONE");
    return self.parsedText;
    //return self.arrayOfEverything;
}


-(NSMutableArray *)combineAlleBookNumberArrays {
    
    [self parseATextFile];
    
    NSMutableArray *alleBookNumbers = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 0; i < self.arrayOfEverything.count; i++) {
        
        NSMutableArray *currentArrayInsideArrayOfEverything = self.arrayOfEverything[i];
        for (NSUInteger j = 0; j < currentArrayInsideArrayOfEverything.count; j++) {
            [alleBookNumbers addObject:self.arrayOfEverything[i][j]];
        }
        i += 5;
    }
    
    NSLog(@"%lu", (unsigned long)alleBookNumbers.count);
    [self.alleBookNumbersInAnArray addObject:alleBookNumbers];
    
    return alleBookNumbers;
    //return nil;
    
}


-(NSMutableArray *)combineAllBookTitleArrays {
    
    [self parseATextFile];
    
    
    NSMutableArray *allBookTitles = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 1; i < self.arrayOfEverything.count; i++) {
        
        NSMutableArray *currentArrayInsideArrayOfEverything = self.arrayOfEverything[i];
        for (NSUInteger j = 0; j < currentArrayInsideArrayOfEverything.count; j++) {
            [allBookTitles addObject:self.arrayOfEverything[i][j]];
        }
        i += 5;
    }
    
    NSLog(@"%lu", (unsigned long)allBookTitles.count);
    [self.allBookTitlesInAnArray addObject:allBookTitles];
    return allBookTitles;
    //return nil;
}

-(NSMutableArray *)combineAllBookAuthorsArrays {
    
    [self parseATextFile];
    
    
    NSMutableArray *allBookAuthors = [[NSMutableArray alloc] init];
    
    
    
    for (NSUInteger i = 2; i < self.arrayOfEverything.count; i++) {
        
        NSMutableArray *currentArrayInsideArrayOfEverything = self.arrayOfEverything[i];
        for (NSUInteger j = 0; j < currentArrayInsideArrayOfEverything.count; j++) {
            [allBookAuthors addObject:self.arrayOfEverything[i][j]];
        }
        i += 5;
    }
    
    NSLog(@"%lu", (unsigned long)allBookAuthors.count);
    [self.allBookAuthorsInAnArray addObject:allBookAuthors];
    return allBookAuthors;
    //return nil;
}

-(NSMutableArray *)combineAllFriendlyTitlesArrays {
    
    [self parseATextFile];
    
    
    NSMutableArray *allFriendlyTitles = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 3; i < self.arrayOfEverything.count; i++) {
        
        NSMutableArray *currentArrayInsideArrayOfEverything = self.arrayOfEverything[i];
        for (NSUInteger j = 0; j < currentArrayInsideArrayOfEverything.count; j++) {
            [allFriendlyTitles addObject:self.arrayOfEverything[i][j]];
        }
        i += 5;
    }
    
    NSLog(@"%lu", (unsigned long)allFriendlyTitles.count);
    [self.allFriendlyTitlesInAnArray addObject:allFriendlyTitles];
    return allFriendlyTitles;
    //return nil;
}

-(NSMutableArray *)combineAllLanguagesArrays {
    
    [self parseATextFile];
    
    
    NSMutableArray *allLanguages = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 4; i < self.arrayOfEverything.count; i++) {
        
        NSMutableArray *currentArrayInsideArrayOfEverything = self.arrayOfEverything[i];
        for (NSUInteger j = 0; j < currentArrayInsideArrayOfEverything.count; j++) {
            [allLanguages addObject:self.arrayOfEverything[i][j]];
        }
        i += 5;
    }
    
    NSLog(@"%lu", (unsigned long)allLanguages.count);
    [self.allLanguagesInAnArray addObject:allLanguages];
    return allLanguages;
    //return nil;
}

-(NSMutableArray *)combineAllGenresArrays {
    
    [self parseATextFile];
    
    
    NSMutableArray *allGenres = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 5; i < self.arrayOfEverything.count; i++) {
        
        NSMutableArray *currentArrayInsideArrayOfEverything = self.arrayOfEverything[i];
        for (NSUInteger j = 0; j < currentArrayInsideArrayOfEverything.count; j++) {
            [allGenres addObject:self.arrayOfEverything[i][j]];
        }
        i += 5;
    }
    
    NSLog(@"%lu", (unsigned long)allGenres.count);
    [self.allGenresInAnArray addObject:allGenres];
    return allGenres;
    //return nil;
}



-(NSMutableArray *)cleanUpeBookNumbers {
    
    NSMutableArray *eBookNumbersArray = [self combineAlleBookNumberArrays];
    
    NSMutableArray *cleanedUpEBookNumbers = [[NSMutableArray alloc] init];
    
    
    
    for (NSUInteger i = 0; i < eBookNumbersArray.count; i++) {
        
        //NSLog(@"this is logging also --------------");
        
        
        NSString *currentStringBeingChecked = eBookNumbersArray[i];
        NSMutableArray *indexOfFirstQuoatationMarkArray  = [[NSMutableArray alloc] init];
        NSUInteger indexOfFirstQuoationMark = 0;
        
        //NSLog(@"%lu", (unsigned long)indexOfFirstQuoationMark);
        
        NSUInteger indexOfSecondQuoationMark = currentStringBeingChecked.length-1;
        
        for (NSUInteger j = 0; j < indexOfSecondQuoationMark
             ; j++) {
            
            unichar currentLetter = [currentStringBeingChecked characterAtIndex:j];
            
            if ([[NSString stringWithFormat:@"%C", currentLetter] isEqualToString:@"\""]) {
                indexOfFirstQuoationMark = j;
                [indexOfFirstQuoatationMarkArray addObject:@(j)];
                break;
                //NSLog(@"this is j: %lu", j);
                
            }
        }
        //        NSLog(@"this is the array: %@", indexOfFirstQuoatationMarkArray);
        //        NSLog(@"this is the indexofthe first: %lu, this is the index of the second: %lu", (unsigned long)indexOfFirstQuoationMark, (unsigned long)indexOfSecondQuoationMark
        //              );
        
        [cleanedUpEBookNumbers addObject: [currentStringBeingChecked substringWithRange:NSMakeRange(indexOfFirstQuoationMark+1, indexOfSecondQuoationMark-indexOfFirstQuoationMark-2)]];
        
        
    }
    
    
    return cleanedUpEBookNumbers;
    
}






-(NSMutableArray *)cleanUpBookTitles {
    
    NSMutableArray *eBookTitlesArray = [self combineAllBookTitleArrays];
    
    NSMutableArray *cleanedUpEBookTitles = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < eBookTitlesArray.count; i++) {
        
        NSString *currentStringBeingChecked = eBookTitlesArray[i];
        NSMutableArray *indexOfFirstQuoatationMarkArray  = [[NSMutableArray alloc] init];
        NSUInteger indexOfFirstQuoationMark = 0;
        
        
        NSUInteger indexOfSecondQuoationMark = currentStringBeingChecked.length-1;
        
        for (NSUInteger j = 0; j < indexOfSecondQuoationMark
             ; j++) {
            
            unichar currentLetter = [currentStringBeingChecked characterAtIndex:j];
            
            if ([[NSString stringWithFormat:@"%C", currentLetter] isEqualToString:@">"]) {
                indexOfFirstQuoationMark = j;
                [indexOfFirstQuoatationMarkArray addObject:@(j)];
                break;
            }
        }
        
        
        [cleanedUpEBookTitles addObject: [currentStringBeingChecked substringWithRange:NSMakeRange(indexOfFirstQuoationMark+1, indexOfSecondQuoationMark-indexOfFirstQuoationMark)]];
    }
    
    for (NSUInteger n = 0; n < cleanedUpEBookTitles.count; n++ ) {
        
        NSString *string = cleanedUpEBookTitles[n];
        
        for (NSUInteger m = 0; m < string.length; m++) {
            
            unichar character = [string characterAtIndex:m];
            
            if ([[NSString stringWithFormat:@"%C", character] isEqualToString:@"<"]) {
                string = [string substringToIndex:m];
                cleanedUpEBookTitles[n] = string;
            }
        }
    }
    return cleanedUpEBookTitles;
    
}








-(NSMutableArray *)cleanUpBookAuthors {
    
    NSMutableArray *bookAuthorArray = [self combineAllBookAuthorsArrays];
    
    NSMutableArray *cleanedUpBookAuthor = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < bookAuthorArray.count; i++) {
        
        NSString *currentStringBeingChecked = bookAuthorArray[i];
        
        NSString *gettingRidOfPrefix = [self getASubStringOfAString:currentStringBeingChecked fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *withoutSuffix = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
        
        [cleanedUpBookAuthor addObject:withoutSuffix];
    }
    return cleanedUpBookAuthor;
    
    
}


-(NSMutableArray *)cleanUpFriendlyTitles {
    
    NSMutableArray *friendlyTitlesArray = [self combineAllFriendlyTitlesArrays];
    
    NSMutableArray *cleanedUpFriendlyTitles = [[NSMutableArray alloc] init];
    
    for (NSString *string in friendlyTitlesArray) {
        
        NSString *gettingRidOfPrefix = [self getASubStringOfAString:string fromTheFirstCharacterOfACertainCharacter:@">"];
        NSString *gettingRidOfSuffix = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:@"<"];
        
        [cleanedUpFriendlyTitles addObject:gettingRidOfSuffix];
        
    }
    return cleanedUpFriendlyTitles;
}



-(NSMutableArray *)cleanUpLanguages {
    
    NSMutableArray *languagesArray = [self combineAllLanguagesArrays];
    
    NSMutableArray *cleanedUpLanguages = [[NSMutableArray alloc] init];
    
    for (NSString *string in languagesArray) {
        
        NSString *getRidOfBegining = [self getASubStringOfAString:string fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *getRidOfISONumber = [self getASubStringOfAString:getRidOfBegining fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *getRidOfRDFValue = [self getASubStringOfAString:getRidOfISONumber fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *getRidOfEnding = [self getASubStringOfAString:getRidOfRDFValue toTheFirstCharacterOfACertainCharacter:@"<"];
        
        [cleanedUpLanguages addObject:getRidOfEnding];
    }
    return cleanedUpLanguages;
}

-(NSMutableArray *)cleanUpGenres {
    
    NSMutableArray *genresArray = [self combineAllGenresArrays];
    
    NSMutableArray *cleanedUpGenres = [[NSMutableArray alloc] init];
    
    for (NSString *string in genresArray) {
        
        NSString *getRidOfFirstGreaterThanSign = [self getASubStringOfAString:string fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *getRidOfSecondGreaterThanSign = [self getASubStringOfAString:getRidOfFirstGreaterThanSign fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *getRidOfThirdGreaterThanSign = [self getASubStringOfAString:getRidOfSecondGreaterThanSign fromTheFirstCharacterOfACertainCharacter:@">"];
        
        NSString *getRidOfEnding = [self getASubStringOfAString:getRidOfThirdGreaterThanSign toTheFirstCharacterOfACertainCharacter:@"<"];
        
        [cleanedUpGenres addObject:getRidOfEnding];
        
    }
    
    return cleanedUpGenres;
}


-(NSArray *)turnArraysInDictionary {
    
    NSLog(@"Starting to turn Arrays into Dictionary");
    
    NSMutableArray *eBookNumbers = [self cleanUpeBookNumbers];
    NSMutableArray *bookTitles = [self cleanUpBookTitles];
    NSMutableArray *bookAuthors = [self cleanUpBookAuthors];
    NSMutableArray *friendlyTitles = [self cleanUpFriendlyTitles];
    NSMutableArray *languages = [self cleanUpLanguages];
    NSMutableArray *genres = [self cleanUpGenres];
    
    NSUInteger eBookNumbersCount = eBookNumbers.count;
    NSUInteger bookTitlesCount = bookTitles.count;
    NSUInteger bookAuthorsCount = bookAuthors.count;
    NSUInteger friendlyTitlesCount = friendlyTitles.count;
    NSUInteger languagesCount = languages.count;
    NSUInteger genresCount = genres.count;
    
    NSMutableArray *arrayOfSizes = [[NSMutableArray alloc] init];
    [arrayOfSizes addObject:@(eBookNumbersCount)];
    [arrayOfSizes addObject:@(bookTitlesCount)];
    [arrayOfSizes addObject:@(bookAuthorsCount)];
    [arrayOfSizes addObject:@(friendlyTitlesCount)];
    [arrayOfSizes addObject:@(languagesCount)];
    [arrayOfSizes addObject:@(genresCount)];
    
    
    
    
    
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [arrayOfSizes sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    
    
    NSLog(@"Sorted Array of sizes ------ %@", arrayOfSizes);
    
    
    
    NSMutableArray *arrayOfDictionaryOfBooks = [[NSMutableArray alloc] init];
    
    
    for (NSUInteger i = 0; i < 40527; i++) {
        
        NSString *eBookNumberString = @"";
        NSString *eBookTitleString = @"";
        NSString *eBookAuthorString = @"";
        NSString *eBookFriendlyTitleString = @"";
        NSString *eBookLanguageString = @"";
        NSString *eBookGenreString = @"";
        
        if (i < eBookNumbersCount) {
            eBookNumberString = eBookNumbers[i];
        }
        
        else if (i >= eBookNumbersCount) {
            eBookNumberString = @"Empty";
        }
        
        
        if (i < bookTitlesCount) {
            eBookTitleString = bookTitles[i];
        }
        
        else if (i >= bookTitlesCount) {
            eBookTitleString = @"Empty";
        }
        
        if (i < bookAuthorsCount) {
            eBookAuthorString = bookAuthors[i];
        }
        
        else if (i >= bookAuthorsCount) {
            eBookAuthorString = @"Empty";
        }
        
        if (i < friendlyTitlesCount) {
            eBookFriendlyTitleString = friendlyTitles[i];
        }
        
        else if (i >= friendlyTitlesCount) {
            eBookFriendlyTitleString = @"Empty";
        }
        
        if (i < languagesCount) {
            eBookLanguageString = languages[i];
        }
        
        else if (i >= languagesCount) {
            eBookLanguageString = @"Empty";
        }
        
        
        if (i < genresCount) {
            eBookGenreString = genres[i];
        }
        
        else if (i >= genresCount) {
            eBookGenreString = @"Empty";
        }
        
        
        NSDictionary *dictionaryPerBook = [self addDictionaryValuesForEBookNumber:eBookNumberString eBookTitle:eBookTitleString eBookAuthor:eBookAuthorString eBookFriendlyTitle:eBookFriendlyTitleString eBookLanguage:eBookLanguageString eBookGenre:eBookGenreString];
        
        [arrayOfDictionaryOfBooks addObject:dictionaryPerBook];
    }
    
    return arrayOfDictionaryOfBooks;
}







/*
 
 
 ---------------------------Helper Methods--------------------------------------
 
 
 */




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

-(NSString *)getASubstringOfAString:(NSString *)string BetweenTheFirstCharacter:(NSString *)firstCharacter andSecondCharacter:(NSString *)secondCharacter {
    
    
    NSString *gettingRidOfPrefix = [self getASubStringOfAString:string toTheFirstCharacterOfACertainCharacter:firstCharacter];
    
    NSString *gettingRidOfSuffix = [self getASubStringOfAString:gettingRidOfPrefix toTheFirstCharacterOfACertainCharacter:secondCharacter];
    
    return gettingRidOfSuffix;
}




-(NSDictionary *)addDictionaryValuesForEBookNumber:(NSString *)eBookNumber eBookTitle:(NSString *)eBookTitle eBookAuthor:(NSString *)eBookAuthor eBookFriendlyTitle:(NSString *)eBookFriendlyTitle eBookLanguage:(NSString *)eBookLanguage eBookGenre:(NSString *)eBookGenre {
    
    NSDictionary *dictionary = @{@"eBook Number":eBookNumber,
                                 @"eBook Title":eBookTitle,
                                 @"eBook Author":eBookAuthor,
                                 @"eBook Friendly Title":eBookFriendlyTitle,
                                 @"eBook Language":eBookLanguage,
                                 @"eBook Genre":eBookGenre,
                                 };
    
    
    return dictionary;
    
    
    
    
    
}


-(void)combineFirstArray:(NSMutableArray *)firstArray withSecondArray:(NSMutableArray *)secondArray {
    
    for (NSUInteger i = 0; i < secondArray.count; i++) {
        
        id currentElement = secondArray[i];
        [firstArray addObject:currentElement];
    }
    
}




@end
