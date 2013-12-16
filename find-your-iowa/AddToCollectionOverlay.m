//
//  AddToCollectionOverlay.m
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/16/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//
#import <objc/runtime.h>
#import "AddToCollectionOverlay.h"
#import "Location.h"

@interface AddToCollectionOverlay ()
@property (weak, nonatomic) IBOutlet UIButton *collection_add_btn;
@property (weak, nonatomic) IBOutlet UILabel *header_label;
@property (weak, nonatomic) IBOutlet UIImageView *header_image;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* items;
@end

@implementation AddToCollectionOverlay

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	// Do any additional setup after loading the view.
    self.items = FYIApp.userData[@"collections"];
    
}
- (IBAction)new_collection_btn_pressed:(id)sender {
}


-(void) show{
    [self.parentViewController.view addSubview:self.view];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}


-(void) hide{
    //[self.parentViewController.view addSubview:self.view];
}


-(NSInteger)tableView: (UITableView*) tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* item = [self.items objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = item;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Location* location = objc_getAssociatedObject(self, "location");
    UITableViewCell* cell = [self.tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Collection: %@", cell.textLabel.text);
    
    NSLog(@"add %@ to %@ collection", location.name, cell.textLabel.text);
    FYIApp.userData[location.uid] = @"starred";
    if (FYIApp.userData[cell.textLabel.text]){
        NSMutableArray* collection_items = FYIApp.userData[cell.textLabel.text];
        [collection_items addObject:location.uid];
        FYIApp.userData[cell.textLabel.text] = collection_items;
    }
    else {
        NSMutableArray* collection_items = [[NSMutableArray alloc] init];
        [collection_items addObject:location.uid];
        FYIApp.userData[cell.textLabel.text] = collection_items;
    }
    
    [FYIApp saveUserData];
    self.view.hidden = TRUE;
    
}






@end
