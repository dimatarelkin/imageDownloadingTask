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
@property (assign, nonatomic) CGRect buttonRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    //layouting
    int frameQuantity = 5;
    int offsetQuantity = frameQuantity - 1;
    CGFloat offset  = 15;
    CGFloat height  = (CGRectGetMaxY(self.view.frame) - offsetQuantity* offset) / frameQuantity;
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
    //for button
    // Do any additional setup after loading the view, typically from a nib
    UIButton* downloadFileButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.frame) + 60, fourthY,
                                                                              CGRectGetMaxX(self.view.frame) - 120, height - 90)];
    [downloadFileButton setTitle:@"refresh" forState:UIControlStateNormal];
    [downloadFileButton setBackgroundColor:[UIColor redColor]];
    [downloadFileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downloadFileButton.layer setCornerRadius:12];
    [downloadFileButton addTarget:self action:@selector(handleDownloadImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadFileButton];
}


- (void)handleDownloadImageAction:(UIButton*)button {
    
    //animate button
    [self changeButton:button forState:UIControlStateHighlighted animated:YES];
    [self changeButton:button forState:UIControlStateNormal animated:YES];
    
    //download first image
    [self downloadImageWithURL:[NSURL URLWithString:@"https://static.alphacoders.com/alpha_system_360.png"]
                withCompletion:^(UIImage * image) {
                    [self presentImageDetailsScreenWithImage:image andRect:_firstViewRect];
                }];
    
    //download second image
    [self downloadImageWithURL: [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/03/02/13/59/bird-1232416__480.png"]
                withCompletion:^(UIImage * image) {
                    [self presentImageDetailsScreenWithImage:image andRect:_secondViewRect];
                }];
    
    //download third image
    [self downloadImageWithURL: [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/03/03/17/15/fruit-1234657__480.png"]
                withCompletion:^(UIImage * image) {
                    [self presentImageDetailsScreenWithImage:image andRect:_thirdViewRect];
                }];
    
    
    //download 4th imageView with 4 images
    NSArray* arrayOfURLS = [NSArray arrayWithObjects:
                            [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2017/02/04/22/37/panther-2038656__480.png"],
                            [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2017/09/23/11/11/butterfly-2778491__480.png"],
                            [NSURL URLWithString:@"https://cdn.pixabay.com/photo/2016/02/04/13/49/the-earth-1179212__480.png"], nil];
    
    Downloader* downloader = [[Downloader alloc] init];
    [downloader downloadThroughDispatchGroup:arrayOfURLS withCompletion:^(NSDictionary * dictionary) {
    [self presentImageDetailsScreenWithDictionary:dictionary withRect:_fourthViewRect];
    }];
}



-(void)downloadImageWithURL:(NSURL*)url withCompletion:(void(^_Nullable)(UIImage*))completion {
    
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

- (void)presentImageDetailsScreenWithImage:(UIImage*)image andRect:(CGRect)rect {
    //new image
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = rect;
    imgView.layer.backgroundColor = UIColor.lightGrayColor.CGColor;
    imgView.layer.contentsGravity = kCAGravityResizeAspect;
    [self.view addSubview:imgView];
    
    //releasing
    [imgView release];
}

- (void)presentImageDetailsScreenWithDictionary:(NSDictionary*)dictionary withRect:(CGRect)rect {
    UIView *subViewWithImages = [[UIView alloc] initWithFrame:rect];
    subViewWithImages.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:subViewWithImages];
    
    
    //rect for view1
    CGRect v1rect = CGRectMake(rect.origin.x,
                               rect.origin.y,
                               rect.size.width / 3,
                               rect.size.height);
    //rect for view1
    CGRect v2rect = CGRectMake(rect.size.width / 3,
                               rect.origin.y,
                               rect.size.width / 3,
                               rect.size.height);
    //rect for view1
    CGRect v3rect = CGRectMake(rect.size.width * 2 / 3,
                               rect.origin.y,
                               rect.size.width / 3,
                               rect.size.height);
    

    UIImage* image1 = [dictionary objectForKey:@"https://cdn.pixabay.com/photo/2017/02/04/22/37/panther-2038656__480.png"];
    [self presentImageDetailsScreenWithImage:image1 andRect:v1rect];
    
    UIImage* image2 = [dictionary objectForKey:@"https://cdn.pixabay.com/photo/2017/09/23/11/11/butterfly-2778491__480.png"];
    [self presentImageDetailsScreenWithImage:image2 andRect:v2rect];
    
    UIImage* image3 = [dictionary objectForKey:@"https://cdn.pixabay.com/photo/2016/02/04/13/49/the-earth-1179212__480.png"];
    [self presentImageDetailsScreenWithImage:image3 andRect:v3rect];
    
    //releasing
    [subViewWithImages release];
}

@end
