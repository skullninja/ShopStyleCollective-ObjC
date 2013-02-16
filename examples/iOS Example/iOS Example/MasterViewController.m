//
//  MasterViewController.m
//
//  Copyright (c) 2013 POPSUGAR Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
#import "MasterViewController.h"

#import "BrandsViewController.h"
#import "RetailersViewController.h"
#import "ColorsViewController.h"
#import "CategoriesViewController.h"
#import "SearchProductsViewController.h"
#import "ProductHistogramViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"POPSUGAR Shopping";
		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		    self.clearsSelectionOnViewWillAppear = NO;
		    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
		}
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    _objects = [[NSMutableArray alloc] initWithObjects:@"Search: 'Red Dress'", @"Brand Histogram: 'Red Dress'", @"Brands", @"Retailers", @"Colors", @"Categories", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

	NSDate *object = _objects[indexPath.row];
	cell.textLabel.text = [object description];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            SearchProductsViewController *searchVC = [[SearchProductsViewController alloc] initWithNibName:@"SearchProductsViewController" bundle:nil];
            searchVC.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:searchVC animated:YES];
            break;
        }
        case 1: {
            ProductHistogramViewController *histogramVC = [[ProductHistogramViewController alloc] initWithNibName:@"ProductHistogramViewController" bundle:nil];
            histogramVC.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;;
            [self.navigationController pushViewController:histogramVC animated:YES];
            break;
        }
        case 2: {
            BrandsViewController* brandsVC = [[BrandsViewController alloc] initWithNibName:@"BrandsViewController_iPhone" bundle:nil];
            brandsVC.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:brandsVC animated:YES];
            break;
        } case 3: {
            RetailersViewController *retailersVC = [[RetailersViewController alloc] initWithNibName:@"RetailersViewController" bundle:nil];
            retailersVC.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:retailersVC animated:YES];
            break;
        } case 4: {
            ColorsViewController *colorsVC = [[ColorsViewController alloc] initWithNibName:@"ColorsViewController" bundle:nil];
            colorsVC.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:colorsVC animated:YES];
            break;
        } case 5: {
            CategoriesViewController *categoriesVC = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
            categoriesVC.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:categoriesVC animated:YES];
            break;
        }
    
        default:
            break;
    }
}

@end
