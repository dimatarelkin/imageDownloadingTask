//
//  Downloader.h
//  asyncDownloadingtest
//
//  Created by Dmitriy Tarelkin on 31/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Downloader : NSObject
@property (weak, nonatomic) NSArray<NSURL*>* arrayOfURLS;

- (void)downloadImageWithURL:(NSURL*)url withCompletion:(void(^_Nullable)(UIImage*))completion;
+ (void)downloadThroughDispatchGroup:(NSArray*)arrayOFURL withCompletion: (void(^_Nullable)(NSDictionary*))completion;
@end
