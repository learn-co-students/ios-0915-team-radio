//
//  PGBDownloadHelper.h
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGBDownloadHelper : NSObject

//DOWNLOAD
//for downloading books from URL
+(void)download:(NSURL *)url withCompletion:(void (^)(BOOL success))completionBlock;


@end