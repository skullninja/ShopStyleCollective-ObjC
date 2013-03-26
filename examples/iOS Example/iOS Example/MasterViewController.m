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

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation MasterViewController

@synthesize menuItems = _menuItems;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"POPSUGAR Shopping";
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:NULL];
	self.menuItems = [[NSArray alloc] initWithObjects:@"Search", @"Brand Histogram", @"Brands", @"Retailers", @"Colors", @"Categories", nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.textLabel.text = self.menuItems[indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0: {
			SearchProductsViewController *searchVC = [[SearchProductsViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:searchVC animated:YES];
			break;
		}
		case 1: {
			ProductHistogramViewController *histogramVC = [[ProductHistogramViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:histogramVC animated:YES];
			break;
		}
		case 2: {
			BrandsViewController* brandsVC = [[BrandsViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:brandsVC animated:YES];
			break;
		} case 3: {
			RetailersViewController *retailersVC = [[RetailersViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:retailersVC animated:YES];
			break;
		} case 4: {
			ColorsViewController *colorsVC = [[ColorsViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:colorsVC animated:YES];
			break;
		} case 5: {
			CategoriesViewController *categoriesVC = [[CategoriesViewController alloc] initWithStyle:UITableViewStylePlain];
			[self.navigationController pushViewController:categoriesVC animated:YES];
			break;
		}
			
		default:
			break;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
