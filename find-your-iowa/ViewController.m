//
//  ViewController.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/11/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.items = @[
                   @"feed",
                   @"aroundme",
                   @"collections",
                   
    ];
}


-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* item = [self.items objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Item" forIndexPath:indexPath];
    //cell.textLabel.text = item;
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn-%@", item]]];
    [cell.contentView addSubview:img];
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0){
        UIViewController* feature_view =[sb instantiateViewControllerWithIdentifier:@"DiscoverView"];
        [self.navigationController pushViewController:feature_view animated:TRUE];

    }
    if (indexPath.row == 1){
        UIViewController *map_view = [sb instantiateViewControllerWithIdentifier:@"MapView"];
        [self.navigationController pushViewController:map_view animated:TRUE];
    }
    if (indexPath.row == 2){
        UIViewController* feature_view =[sb instantiateViewControllerWithIdentifier:@"DiscoverView"];
        [self.navigationController pushViewController:feature_view animated:TRUE];
        
    }
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
