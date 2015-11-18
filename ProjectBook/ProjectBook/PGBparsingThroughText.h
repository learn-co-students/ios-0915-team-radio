//
//  PGBparsingThroughText.h
//  ProjectBook
//
//  Created by Priyansh Chordia on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGBparsingThroughText : NSObject


@property (strong, nonatomic, readonly) NSMutableArray *parsedText;
@property (strong, nonatomic, readonly) NSMutableArray *arrayOfEverything;


@property (strong, nonatomic, readonly) NSMutableArray *alleBookNumbersInAnArray;
@property (strong, nonatomic, readonly) NSMutableArray *allBookTitlesInAnArray;
@property (strong, nonatomic, readonly) NSMutableArray *allBookAuthorsInAnArray;
@property (strong, nonatomic, readonly) NSMutableArray *allFriendlyTitlesInAnArray;
@property (strong, nonatomic, readonly) NSMutableArray *allLanguagesInAnArray;
@property (strong, nonatomic, readonly) NSMutableArray *allGenresInAnArray;


-(NSMutableArray *)parseATextFile;

-(NSMutableArray *)combineAlleBookNumberArrays;
-(NSMutableArray *)combineAllBookTitleArrays;
-(NSMutableArray *)combineAllBookAuthorsArrays;
-(NSMutableArray *)combineAllFriendlyTitlesArrays;
-(NSMutableArray *)combineAllLanguagesArrays;
-(NSMutableArray *)combineAllGenresArrays;

-(NSMutableArray *)cleanUpeBookNumbers;
-(NSMutableArray *)cleanUpBookTitles;
-(NSMutableArray *)cleanUpBookAuthors;
-(NSMutableArray *)cleanUpFriendlyTitles;
-(NSMutableArray *)cleanUpLanguages;
-(NSMutableArray *)cleanUpGenres;


-(NSArray *)turnArraysInDictionary;



@end
