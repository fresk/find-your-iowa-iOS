//
//  DetailViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//
#import <objc/runtime.h>
#import "DetailViewController.h"
#import "ImagePager.h"
#import "Location.h"
#import "AddToCollectionOverlay.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic)ImagePager* image_pager;
@property (strong, nonatomic) Location* location;


@end

@implementation DetailViewController {
    NSArray* _locations;
    AddToCollectionOverlay* _add_to_collection_menu;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.delegate = self;

    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _add_to_collection_menu = [sb instantiateViewControllerWithIdentifier:@"AddToCollection"];
    [self addChildViewController:_add_to_collection_menu];
    [self.view addSubview: _add_to_collection_menu.view];
    _add_to_collection_menu.view.hidden = TRUE;

}


-(void)setLocationID: (NSString*) uid {
    NSString* q = [NSString stringWithFormat:@"SELECT * FROM locations WHERE id == '%@'", uid];
    _locations = queryLocations(q);
    self.location = _locations[0];
    

    
    
}


-(void)favoriteBtnPressed:(id) sender{
    Location* location = objc_getAssociatedObject(sender, "location");
    NSLog(@"favorite: %@", location.name);
    objc_setAssociatedObject(_add_to_collection_menu, "location", location, OBJC_ASSOCIATION_ASSIGN);
    [_add_to_collection_menu show];
    _add_to_collection_menu.view.hidden = FALSE;
    
    UIButton* btn = (UIButton*) sender;
    [btn setImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
    btn.alpha =1.0;
}


-(void)viewWillAppear:(BOOL)animated {
    self.image_pager = [[ImagePager alloc] initWithLocation: self.location];
    self.image_pager.view.frame = CGRectMake(0,0,320,200);
    [self.scrollView addSubview:self.image_pager.view];
    [self addChildViewController:self.image_pager];
    
    [self.image_pager collapseFullScreen];
    
    
    UIButton* btn_favorite = [UIButton buttonWithType:UIButtonTypeCustom];
    if (FYIApp.userData[self.location.uid] == @"starred"){
        [btn_favorite setImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
    }
    else{
        [btn_favorite setImage:[UIImage imageNamed:@"star_grey"] forState:UIControlStateNormal];
        [btn_favorite addTarget:self action:@selector(favoriteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(btn_favorite, "location", self.location, OBJC_ASSOCIATION_ASSIGN);
        btn_favorite.alpha = 0.5;
    }
    btn_favorite.frame = CGRectMake(280, 79, 30, 30);
    [self.view addSubview:btn_favorite];
}



-(void)viewDidAppear:(BOOL)animated {
    [self loadDetailPage];
    
}


- (IBAction)goBack:(id)sender {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *detail_view = [sb instantiateViewControllerWithIdentifier:@"DiscoverView"];
    [self presentViewController:detail_view animated:TRUE completion:^{
    }];
}


-(void)loadDetailPage {
    //[self.previewImage setImageWithURL: self.location.previewImageURL];

    
    
    NSString* urlString = [NSString stringWithFormat:@"http://findyouriowa.com/render/location/%@", self.location.uid];
    //NSString* urlString = [NSString stringWithFormat:@"http://localhost:8000/render/location/%@", [location objectForKey:@"id"]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

    //[self.scrollView bringSubviewToFront:self.webView];
}



- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect newFrame = self.webView.frame;
    newFrame.size.height = self.webView.scrollView.contentSize.height;

    self.webView.frame = newFrame;
    self.webView.clipsToBounds = FALSE;
    self.webView.scrollView.scrollEnabled = FALSE;
    self.webView.scrollView.clipsToBounds = FALSE;
    
    NSLog(@"scrollVIEW: %f, %f", newFrame.size.width, newFrame.size.height+200);

    self.scrollView.contentSize = CGSizeMake(320, newFrame.size.height+244);
    //[self.scrollView bringSubviewToFront:self.webView];
    //[self.view bringSubviewToFront:self.scrollView];
}





@end
