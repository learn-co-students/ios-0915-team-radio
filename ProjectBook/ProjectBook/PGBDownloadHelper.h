//
//  PGBDownloadHelper.h
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGBDownloadHelper : NSObject

//READ
//for opening files in iBooks
//@property (nonatomic) UIDocumentInteractionController *docController;


//DOWNLOAD
//for downloading books from URL
-(void)download:(NSURL *)url;


@end