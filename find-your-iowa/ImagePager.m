#define VIEW_FOR_ZOOM_TAG (1)
#import "ImagePager.h"


@implementation ImagePager {
    UIScrollView* mainScrollView;
    UIButton* closeFullscreenButton;
    UIView* backDrop;
    
    BOOL isFullScreen;
}


-(id)initWithLocation: (Location*) location {
    
    if (self = [super init])
    {
        self.location = location;
    }
    return self;


}







- (void)viewDidLoad {
    [super viewDidLoad];
    
    isFullScreen = FALSE;
    
    backDrop = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    backDrop.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
    [self.view addSubview:backDrop];
    backDrop.hidden  = TRUE;

    //self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame: self.view.bounds ];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.clipsToBounds = TRUE;

    [self.view addSubview:mainScrollView];
    
    [self setupImagePages];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [mainScrollView addGestureRecognizer:singleTap];
    
    closeFullscreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeFullscreenButton.frame = CGRectMake(320-60, 0, 60, 60);
    closeFullscreenButton.imageView.image = [UIImage imageNamed:@"close-btn"];
    closeFullscreenButton.userInteractionEnabled = FALSE;
    closeFullscreenButton.hidden = TRUE;
    [self.view addSubview:closeFullscreenButton];

    [self collapseFullScreen];
    
}






-(void) setupImagePages {
    CGRect innerScrollFrame = self.view.bounds;
    
    for (NSInteger i = 0; i < [self.location.images count]; i++) {
        
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 3.0f;
        pageScrollView.bounces = FALSE;
        pageScrollView.delegate = self;
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        
        UIImageView *imageForZooming = [[UIImageView alloc] init] ;
        if (i>0){
            NSURL* image_url = [NSURL URLWithString:[self.location.images objectAtIndex:i]];
            [imageForZooming setImageWithURL: image_url
                            placeholderImage:[UIImage imageNamed:@"loading.png"]
                                     options:  SDWebImageProgressiveDownload
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                       imageForZooming.contentMode = UIViewContentModeScaleAspectFit;
                                       imageForZooming.center = self.view.center;
                                   }];
        }
        else{
            imageForZooming.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-large.jpg", self.location.uid]];
        }
        imageForZooming.frame = mainScrollView.bounds;
        imageForZooming.tag = VIEW_FOR_ZOOM_TAG;
        [pageScrollView addSubview:imageForZooming];
        [mainScrollView addSubview:pageScrollView];
        
        if (i < [self.location.images count]) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    mainScrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x , mainScrollView.bounds.size.height);
}




-(void) onTap:(id)sender {
    NSLog(@"on TAP");
    
    if (isFullScreen == FALSE){
        [self.view.superview bringSubviewToFront:self.view];
        [UIView animateWithDuration:1.0 animations:^{
            [self makeFullScreen];
        }completion:^(BOOL finished) {
            isFullScreen = TRUE;
        }];
    }
    else {
        
        
        [UIView animateWithDuration:1.0 animations:^{
            [self collapseFullScreen];
        }completion:^(BOOL finished) {
            isFullScreen = FALSE;
            closeFullscreenButton.hidden = TRUE;
            backDrop.hidden = TRUE;
            [self.view.superview sendSubviewToBack:self.view];
            
        }];
    }
    
}



-(void) collapseFullScreen {

    self.view.frame = CGRectMake(0, 0, 320, 200);
    mainScrollView.frame = self.view.frame;
    
    CGRect innerScrollFrame = self.view.bounds;
    for (NSInteger i = 0; i < [self.location.images count]; i++) {
        UIScrollView* page = [mainScrollView.subviews objectAtIndex:i];
        page.maximumZoomScale = 1.0;
        page.zoomScale = 1.0;
        page.frame = innerScrollFrame;
        for (UIImageView* img in page.subviews) {
            img.contentMode = UIViewContentModeScaleAspectFit;
            img.center = self.view.center;
        }
        if (i < [self.location.images count]) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    
    mainScrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x, mainScrollView.bounds.size.height);
    
    closeFullscreenButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    closeFullscreenButton.alpha = 0.0;
    backDrop.alpha = 0.0;

}

-(void) makeFullScreen {

    self.view.frame = [[UIScreen mainScreen] bounds];
    mainScrollView.frame = [[UIScreen mainScreen] bounds];
    
    CGRect innerScrollFrame = self.view.bounds;
    for (NSInteger i = 0; i < [self.location.images count]; i++) {
        UIScrollView* page = [mainScrollView.subviews objectAtIndex:i];
        page.frame = innerScrollFrame;
        page.maximumZoomScale = 3.0;
        for (UIImageView* img in page.subviews) {
            img.contentMode = UIViewContentModeScaleAspectFit;
            img.center = self.view.center;
        }
        if (i < [self.location.images count]) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
    }
    
    mainScrollView.contentSize = CGSizeMake(innerScrollFrame.origin.x, mainScrollView.bounds.size.height);
    
    closeFullscreenButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    closeFullscreenButton.hidden = FALSE;
    closeFullscreenButton.alpha = 1.0;
    backDrop.hidden = FALSE;
    backDrop.alpha = 1.0;
    
    

}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:VIEW_FOR_ZOOM_TAG];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
} 

- (BOOL)shouldAutorotate {
    return NO;
}


@end