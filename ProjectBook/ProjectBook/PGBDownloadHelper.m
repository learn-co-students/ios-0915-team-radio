//
//  PGBDownloadHelper.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBDownloadHelper.h"

#import <AFNetworking/AFNetworking.h>
#import <AFOAuth2Manager/AFOAuth2Manager.h>

@implementation PGBDownloadHelper

+ (void)download:(NSURL *)url withCompletion:(void (^)(BOOL success))completionBlock {
    //using AFNetworking to download file
    NSLog(@"download method is called & book downloaded");
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *tempDirectory = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        return [tempDirectory URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        if (!error && filePath) {
            completionBlock(YES);
        } else {
            completionBlock(NO);
            NSLog(@"download error %@",error.localizedDescription);
        }
        
    }];
    
    [downloadTask resume];
}

@end


