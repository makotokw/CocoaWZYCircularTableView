//
//  RootViewController.m
//  CircularTableViewSample
//
//  Copyright (c) 2013 makoto_kw. All rights reserved.
//

#import "RootViewController.h"
#import "TableViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

{
    NSArray *_items;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"CircularTableView";
    
    _items = @[
                @{@"title": @"Normal"},
                @{@"title": @"Circler"},
                @{@"title": @"LeftAlign"},
                @{@"title": @"RightAlign"},
                @{@"title": @"ShortRadius"},
                ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *item = _items[indexPath.row];
    cell.textLabel.text = item[@"title"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"circularTableViewController"];
    
    NSDictionary *item = _items[indexPath.row];
    
    viewController.title = item[@"title"];
    switch (indexPath.row) {
        case 1:
            viewController.enableInfiniteScrolling = YES;
            break;
        case 2:
            viewController.enableInfiniteScrolling = YES;
            viewController.contentAlignment = WZYCircularTableViewContentAlignmentLeft;
            break;
        case 3:
            viewController.enableInfiniteScrolling = YES;
            viewController.contentAlignment = WZYCircularTableViewContentAlignmentRight;
            break;
        case 4:
            viewController.enableInfiniteScrolling = YES;
            viewController.contentAlignment = WZYCircularTableViewContentAlignmentLeft;
            viewController.radius = 120;
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
