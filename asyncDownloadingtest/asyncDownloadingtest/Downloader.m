//
//  Downloader.m
//  asyncDownloadingtest
//
//  Created by Dmitriy Tarelkin on 31/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import "Downloader.h"

@interface Downloader ()

@end

@implementation Downloader


- (void)downloadImageWithURL:(NSURL*)url withCompletion:(void(^_Nullable)(UIImage*))completion {
    
    //background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* imageData = [NSData dataWithContentsOfURL:url];
        UIImage *newImage = [UIImage imageWithData:imageData];
        
        //main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(newImage);
        });
    });
}


+ (void)downloadThroughDispatchGroup:(NSArray*)arrayOFURL withCompletion: (void(^_Nullable)(NSDictionary*))completion {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t groupQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSURL* url in arrayOFURL) {
        dispatch_group_async(group, groupQueue, ^ {
            
            NSData* imageData = [NSData dataWithContentsOfURL:url];
            UIImage *newImg = [UIImage imageWithData:imageData];

            [dictionary setObject:newImg forKey:url.absoluteString];
        });
    }
    
    dispatch_group_notify(group, groupQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            completion([dictionary copy]);
        });
    });
    
    dispatch_release(group);
}


@end
