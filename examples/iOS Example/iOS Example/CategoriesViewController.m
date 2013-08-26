//
//  CategoriesViewController.m
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

#import "CategoriesViewController.h"

@interface CategoriesViewController ()

@property (nonatomic, strong) NSArray *categories;

@end

@implementation CategoriesViewController

- (id)initWithCategories:(NSArray *)categoriesOrNil
{
    self = [super init];
    if (self) {
        _categories = categoriesOrNil;
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.categories == nil) {
		self.title = @"Categories";
		
		__weak typeof(self) weakSelf = self;
		[[PSSClient sharedClient] categoryTreeFromCategoryID:nil depth:nil success:^(PSSCategoryTree *categoryTree) {
			weakSelf.categories = categoryTree.rootCategory.childCategories;
			[weakSelf.tableView reloadData];
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"Request failed with error: %@", error);
		}];
	}
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	PSSCategory *thisCategory = self.categories[indexPath.row];
	cell.textLabel.text = thisCategory.shortName;
	if (thisCategory.childCategories.count > 0) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	PSSCategory *thisCategory = self.categories[indexPath.row];
	if (thisCategory.childCategories.count > 0) {
		CategoriesViewController *detailVC = [[CategoriesViewController alloc] initWithCategories:thisCategory.childCategories];
		detailVC.title = thisCategory.name;
		[self.navigationController pushViewController:detailVC animated:YES];
	}
}

@end
