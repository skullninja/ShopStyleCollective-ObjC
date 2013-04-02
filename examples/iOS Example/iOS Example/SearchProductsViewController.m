//
//  SearchProductsViewController.m
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

#import "SearchProductsViewController.h"

@interface SearchProductsViewController ()

@property (nonatomic, strong) NSArray *products;

@end

@implementation SearchProductsViewController

@synthesize products = _products;

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Search: 'Red Dress'";
	
	__weak typeof(self) weakSelf = self;
	[[PSShoppingAPIClient sharedClient] searchProductsWithTerm:@"Red Dress" offset:nil limit:nil success:^(NSUInteger totalCount, NSArray *products) {
		weakSelf.products = products;
		[weakSelf.tableView reloadData];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Request failed with error: %@", error);
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	PSProduct *thisProduct = [self.products objectAtIndex:indexPath.row];
	cell.textLabel.text = thisProduct.name;
	cell.textLabel.numberOfLines = 0;
	if (thisProduct.salePriceLabel) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Now %@! (was %@)", thisProduct.salePriceLabel, thisProduct.priceLabel];
	} else {
		cell.detailTextLabel.text = thisProduct.priceLabel;
	}
	if (thisProduct.images.count > 0) {
		PSProductImage *productImage = [thisProduct.images lastObject];
		[cell.imageView setImageWithURL:productImage.URL placeholderImage:[UIImage imageNamed:@"Placeholder"]];
	} else {
		cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
	}
	cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
