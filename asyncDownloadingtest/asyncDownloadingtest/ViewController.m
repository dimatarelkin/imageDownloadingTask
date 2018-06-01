//
//  ViewController.m
//  asyncDownloadingtest
//
//  Created by Dmitriy Tarelkin on 31/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import "ViewController.h"
#import "Downloader.h"

@interface ViewController ()

@property (assign, nonatomic) CGRect firstViewRect;
@property (assign, nonatomic) CGRect secondViewRect;
@property (assign, nonatomic) CGRect thirdViewRect;
@property (assign, nonatomic) CGRect fourthViewRect;

@property (assign, nonatomic) CGRect firstSubViewRect;
@property (assign, nonatomic) CGRect secondSubViewRect;
@property (assign, nonatomic) CGRect thirdSubViewRect;

@property (assign, nonatomic) CGRect buttonRect;

@property (retain, nonatomic) NSMutableArray* arrayOfURLS;
@property (retain, nonatomic) NSMutableArray* arrayOfRects;
@property (retain, nonatomic) NSMutableArray* arrayOfURLSSUB;
@property (retain, nonatomic) NSMutableArray* arrayOfSubRects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //layouting
    int frameQuantity = 5;
    int offsetQuantity = frameQuantity - 1;
    CGFloat offset  = 20;
    CGFloat height  = (CGRectGetMaxY(self.view.frame) - offsetQuantity * offset) / frameQuantity;
    CGFloat minY    = CGRectGetMinY(self.view.frame) + offset;
    CGFloat firstY  = minY + offset + height;
    CGFloat secondY = firstY + offset + height;
    CGFloat thirdY  = secondY + offset + height;
    CGFloat fourthY = thirdY + offset + height;
    
    //rects for first frames
    self.firstViewRect  = CGRectMake(CGRectGetMinX(self.view.frame), minY,
                                     CGRectGetMaxX(self.view.frame), height);
    //2
    self.secondViewRect = CGRectMake(CGRectGetMinX(self.view.frame), firstY,
                                     CGRectGetMaxX(self.view.frame), height);
    //3
    self.thirdViewRect  = CGRectMake(CGRectGetMinX(self.view.frame), secondY,
                                     CGRectGetMaxX(self.view.frame), height);
    //4
    self.fourthViewRect = CGRectMake(CGRectGetMinX(self.view.frame), thirdY,
                                     CGRectGetMaxX(self.view.frame), height);
    
    //5 subrects for images in 4th rect
    //rect for view1
    self.firstSubViewRect = CGRectMake(self.fourthViewRect.origin.x,
                               self.fourthViewRect.origin.y,
                               self.fourthViewRect.size.width / 3,
                               self.fourthViewRect.size.height);
    //rect for view1
    self.secondSubViewRect = CGRectMake(self.fourthViewRect.size.width / 3,
                               self.fourthViewRect.origin.y,
                               self.fourthViewRect.size.width / 3,
                               self.fourthViewRect.size.height);
    //rect for view1
    self.thirdSubViewRect = CGRectMake(self.fourthViewRect.size.width * 2 / 3,
                               self.fourthViewRect.origin.y,
                               self.fourthViewRect.size.width / 3,
                               self.fourthViewRect.size.height);
    
    //for button
    self.buttonRect     = CGRectMake(CGRectGetMinX(self.view.frame) + 60, fourthY,
                                     CGRectGetMaxX(self.view.frame) - 120, height - 90);
    
    // Do any additional setup after loading the view, typically from a nib
    UIButton* downloadFileButton = [[UIButton alloc] initWithFrame:_buttonRect];
    [downloadFileButton setTitle:@"refresh" forState:UIControlStateNormal];
    [downloadFileButton setBackgroundColor:[UIColor redColor]];
    [downloadFileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downloadFileButton.layer setCornerRadius:12];
    [downloadFileButton addTarget:self action:@selector(handleDownloadImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadFileButton];
    
    [self createSubViews];
}

- (void)createSubViews {
    //2 DOWNLOADING
    self.arrayOfURLS  = [NSMutableArray arrayWithObjects:
                        [NSURL URLWithString:@"https://static.alphacoders.com/alpha_system_360.png"],
                        [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/03/02/13/59/bird-1232416__480.png"],
                        [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/03/03/17/15/fruit-1234657__480.png"],nil];
    
    self.arrayOfRects  = [NSMutableArray arrayWithObjects:
                         [NSValue valueWithCGRect:self.firstViewRect],
                         [NSValue valueWithCGRect:self.secondViewRect],
                         [NSValue valueWithCGRect:self.thirdViewRect],
                         [NSValue valueWithCGRect:self.fourthViewRect],
                         nil];
    //download 4th imageView with 3 images
    self.arrayOfURLSSUB = [NSMutableArray arrayWithObjects:
                           [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2017/02/04/22/37/panther-2038656__480.png"],
                           [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2017/09/23/11/11/butterfly-2778491__480.png"],
                           [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/02/04/13/49/the-earth-1179212__480.png"],
                           nil];
    
    self.arrayOfSubRects = [NSMutableArray arrayWithObjects:
                           [NSValue valueWithCGRect:self.firstSubViewRect],
                           [NSValue valueWithCGRect:self.secondSubViewRect],
                           [NSValue valueWithCGRect:self.thirdSubViewRect],
                            nil];
    
}

- (void)handleDownloadImageAction:(UIButton*)button {
//1 ANIMATION
    //animate button
    [self changeButton:button forState:UIControlStateHighlighted animated:YES];
    [self changeButton:button forState:UIControlStateNormal animated:YES];
    
    NSLog(@"Subviews before delete: %i!",self.view.subviews.count);
    if ([self.view subviews]) {
        for(int i = 1; self.view.subviews.count > i; i++) {
            [self.view.subviews[i] removeFromSuperview];
        }
    }
    NSLog(@"Subviews after delete: %i!",self.view.subviews.count);

//download first 3 images
    [self downloadImageWithArrayOfURLS:self.arrayOfURLS
                withCompletion:^(NSMutableArray* imageArray) {
                    [self presentImageDetailsScreenWithImage:imageArray andArrayOFRects:_arrayOfRects];
                }];
    
//3 DOWNLOADING using dispatch_group

    [Downloader downloadThroughDispatchGroup:_arrayOfURLSSUB withCompletion:^(NSDictionary * dictionary) {
        NSMutableArray* arrayOFImages = [NSMutableArray arrayWithArray:dictionary.allValues];
        [self presentImageDetailsScreenWithImage:arrayOFImages andArrayOFRects:_arrayOfSubRects];
    }];

}

//1
- (void)changeButton:(UIButton*)button forState:(UIControlState)state animated:(BOOL)isAnimated {
    
    if (isAnimated) {
        [UIView animateWithDuration:1 animations:^{
            
            if (state == UIControlStateNormal) {
                button.backgroundColor = UIColor.redColor;
                
            } else {
                button.backgroundColor = UIColor.greenColor;
            }
        }];
    }
}

//2
-(void)downloadImageWithArrayOfURLS:(NSMutableArray<NSURL*>*)urlArray withCompletion:(void(^_Nullable)(NSMutableArray*))completion {
    NSMutableArray* imagesArray = [NSMutableArray array];
    
        //background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSURL* url in urlArray) {
               
                NSData* imageData = [NSData dataWithContentsOfURL:url];
                UIImage *newImage = [UIImage imageWithData:imageData];
                [imagesArray addObject:newImage];

            }
            //call completion on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(imagesArray);
            });
        });
    
}



//4
- (void)presentImageDetailsScreenWithImage:(NSMutableArray<UIImage*>*)imageArray andArrayOFRects:(NSMutableArray*)rectsArray {
 
    
    for (int i = 0; imageArray.count > i; i++) {
        //new image
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        imgView.frame = [[rectsArray objectAtIndex:i] CGRectValue];
        imgView.layer.backgroundColor = UIColor.lightGrayColor.CGColor;
        imgView.layer.contentsGravity = kCAGravityResizeAspect;
        [self.view addSubview:imgView];

        //releasing
        [imgView release];
    }
    NSLog(@"ALL subViews %i",[self.view  subviews].count);
}


- (void)dealloc {
    [_arrayOfURLS release];
    [_arrayOfRects release];
    [_arrayOfSubRects release];
    [_arrayOfURLSSUB release];
    [super dealloc];
}

@end
