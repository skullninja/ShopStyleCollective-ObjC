//
//  PSProductQuery.m
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

#import "PSProductQuery.h"

@interface PSProductQuery ()

@property (nonatomic, strong) NSMutableSet *productFilterSet;

- (NSSet *)productFilterSetOfType:(PSProductFilterType)filterType;

@end

@implementation PSProductQuery

@synthesize searchTerm = _searchTerm;
@synthesize productCategory = _productCategory;
@synthesize priceDropDate = _priceDropDate;
@synthesize productFilterSet = _productFilterSet;
@synthesize sort = _sort;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.searchTerm forKey:@"searchTerm"];
    [encoder encodeObject:self.productCategory forKey:@"productCategory"];
    [encoder encodeObject:self.priceDropDate forKey:@"priceDropDate"];
	[encoder encodeInteger:self.sort forKey:@"sort"];
    [encoder encodeObject:self.productFilterSet forKey:@"productFilterSet"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.searchTerm = [decoder decodeObjectForKey:@"searchTerm"];
        self.productCategory = [decoder decodeObjectForKey:@"productCategory"];
        self.priceDropDate = [decoder decodeObjectForKey:@"priceDropDate"];
		self.sort = [decoder decodeIntegerForKey:@"sort"];
        self.productFilterSet = [decoder decodeObjectForKey:@"productFilterSet"];
    }
    return self;
}

+ (instancetype)productQueryWithSearchTerm:(NSString *)searchTearm
{
	PSProductQuery *instance = [[PSProductQuery alloc] init];
	instance.searchTerm = searchTearm;
	return instance;
}

+ (instancetype)productQueryWithCategory:(NSString *)productCategory
{
	PSProductQuery *instance = [[PSProductQuery alloc] init];
	instance.productCategory = productCategory;
	return instance;
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        _productFilterSet = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Product Filters

- (void)addProductFilter:(PSProductFilter *)newFilter
{
	[self.productFilterSet addObject:newFilter];
}

- (void)addProductFilters:(NSArray *)newFilters
{
	[self.productFilterSet addObjectsFromArray:newFilters];
}

- (void)removeProductFilter:(PSProductFilter *)filter
{
	[self.productFilterSet removeObject:filter];
}

- (NSArray *)productFilters
{
	return self.productFilterSet.allObjects;
}

- (NSSet *)productFilterSetOfType:(PSProductFilterType)filterType
{
	NSSet *filteredSet = [self.productFilterSet objectsPassingTest:^BOOL(id obj, BOOL *stop) {
		if ([(PSProductFilter *)obj type] == filterType) {
			return YES;
		}
		return NO;
	}];
	return filteredSet;
}

- (NSArray *)productFiltersOfType:(PSProductFilterType)filterType
{
	return [[self productFilterSetOfType:filterType] allObjects];
}

- (void)clearProductFilters
{
	[self.productFilterSet removeAllObjects];
}

- (void)clearProductFiltersOfType:(PSProductFilterType)filterType
{
	[self.productFilterSet minusSet:[self productFilterSetOfType:filterType]];
}

#pragma mark -

- (NSDictionary *)queryParameterRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
    if (self.searchTerm && self.searchTerm.length > 0) {
        [dictionary setObject:self.searchTerm forKey:@"fts"];
    }
    if (self.productCategory && self.productCategory.length > 0) {
        [dictionary setObject:self.productCategory forKey:@"cat"];
    }
	
	if (self.productFilterSet.count > 0) {
		NSArray *allFilters = [self productFilters];
		for (PSProductFilter *filter in allFilters) {
			[dictionary setObject:filter.description forKey:@"fl"];
		}
	}
	
    if (self.priceDropDate) {
		NSNumber *numberRep = [NSNumber numberWithDouble:[self.priceDropDate timeIntervalSince1970]];
        [dictionary setObject:numberRep forKey:@"pdd"];
    }
	
	if (self.sort == PSProductQuerySortPriceLoHi) {
		[dictionary setObject:@"PriceLoHi" forKey:@"sort"];
	} else if (self.sort == PSProductQuerySortPriceHiLo) {
		[dictionary setObject:@"PriceHiLo" forKey:@"sort"];
	} else if (self.sort == PSProductQuerySortRecency) {
		[dictionary setObject:@"Recency" forKey:@"sort"];
	} else if (self.sort == PSProductQuerySortPopular) {
		[dictionary setObject:@"Popular" forKey:@"sort"];
	}
	
    return dictionary;
}

@end
