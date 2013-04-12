//
//  PSSProductQuery.m
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

#import "PSSProductQuery.h"

@interface PSSProductQuery ()

@property (nonatomic, strong) NSMutableSet *productFilterSet;

- (NSSet *)productFilterSetOfType:(PSSProductFilterType)filterType;

@end

@implementation PSSProductQuery

#pragma mark - init

+ (instancetype)productQueryWithSearchTerm:(NSString *)searchTearm
{
	PSSProductQuery *instance = [[PSSProductQuery alloc] init];
	instance.searchTerm = searchTearm;
	return instance;
}

+ (instancetype)productQueryWithCategoryId:(NSString *)productCategoryId
{
	PSSProductQuery *instance = [[PSSProductQuery alloc] init];
	instance.productCategoryId = productCategoryId;
	return instance;
}

- (id)init
{
	self = [super init];
	if (self) {
		_productFilterSet = [[NSMutableSet alloc] init];
	}
	return self;
}

#pragma mark - Product Filters

- (void)addProductFilter:(PSSProductFilter *)newFilter
{
	[self.productFilterSet addObject:newFilter];
}

- (void)addProductFilters:(NSArray *)newFilters
{
	[self.productFilterSet addObjectsFromArray:newFilters];
}

- (void)removeProductFilter:(PSSProductFilter *)filter
{
	[self.productFilterSet removeObject:filter];
}

- (NSArray *)productFilters
{
	return self.productFilterSet.allObjects;
}

- (NSSet *)productFilterSetOfType:(PSSProductFilterType)filterType
{
	NSSet *filteredSet = [self.productFilterSet objectsPassingTest:^BOOL(id obj, BOOL *stop) {
		if ([(PSSProductFilter *)obj type] == filterType) {
			return YES;
		}
		return NO;
	}];
	return filteredSet;
}

- (NSArray *)productFiltersOfType:(PSSProductFilterType)filterType
{
	return [[self productFilterSetOfType:filterType] allObjects];
}

- (void)clearProductFilters
{
	[self.productFilterSet removeAllObjects];
}

- (void)clearProductFiltersOfType:(PSSProductFilterType)filterType
{
	[self.productFilterSet minusSet:[self productFilterSetOfType:filterType]];
}

#pragma mark - Conversion to URL Query Parameters

- (NSDictionary *)queryParameterRepresentation
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	
	if (self.searchTerm && self.searchTerm.length > 0) {
		[dictionary setObject:self.searchTerm forKey:@"fts"];
	}
	if (self.productCategoryId && self.productCategoryId.length > 0) {
		[dictionary setObject:self.productCategoryId forKey:@"cat"];
	}
	
	if (self.productFilterSet.count > 0) {
		NSArray *allFilters = [self productFilters];
		for (PSSProductFilter *filter in allFilters) {
			[dictionary setObject:filter.queryParameterRepresentation forKey:@"fl"];
		}
	}
	
	if (self.priceDropDate) {
		NSNumber *numberRep = [NSNumber numberWithDouble:[self.priceDropDate timeIntervalSince1970]];
		[dictionary setObject:numberRep forKey:@"pdd"];
	}
	
	if (self.sort == PSSProductQuerySortPriceLoHi) {
		[dictionary setObject:@"PriceLoHi" forKey:@"sort"];
	} else if (self.sort == PSSProductQuerySortPriceHiLo) {
		[dictionary setObject:@"PriceHiLo" forKey:@"sort"];
	} else if (self.sort == PSSProductQuerySortRecency) {
		[dictionary setObject:@"Recency" forKey:@"sort"];
	} else if (self.sort == PSSProductQuerySortPopular) {
		[dictionary setObject:@"Popular" forKey:@"sort"];
	}
	
	return dictionary;
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@", [self queryParameterRepresentation]];
}

- (NSUInteger)hash
{
	// a very simple hash
	NSUInteger hash = 0;
	hash ^= self.productFilterSet.hash;
	hash ^= self.searchTerm.hash;
	hash ^= self.productCategoryId.hash;
	hash ^= self.priceDropDate.hash;
	hash ^= self.sort;
	return hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return [self isEqualToProductQuery:object];
}

- (BOOL)isEqualToProductQuery:(PSSProductQuery *)productQuery
{
	NSParameterAssert(productQuery != nil);
	if (productQuery == self) {
		return YES;
	}
	
	if (![productQuery.productFilterSet isEqualToSet:self.productFilterSet]) {
		return NO;
	}
	if (![productQuery.searchTerm isEqualToString:self.searchTerm]) {
		return NO;
	}
	if (![productQuery.productCategoryId isEqualToString:self.productCategoryId]) {
		return NO;
	}
	if (![productQuery.priceDropDate isEqualToDate:self.priceDropDate]) {
		return NO;
	}
	if (productQuery.sort != self.sort) {
		return NO;
	}
	
	return YES;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.searchTerm forKey:@"searchTerm"];
	[encoder encodeObject:self.productCategoryId forKey:@"productCategoryId"];
	[encoder encodeObject:self.priceDropDate forKey:@"priceDropDate"];
	[encoder encodeInteger:self.sort forKey:@"sort"];
	[encoder encodeObject:self.productFilterSet forKey:@"productFilterSet"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.searchTerm = [decoder decodeObjectForKey:@"searchTerm"];
		self.productCategoryId = [decoder decodeObjectForKey:@"productCategoryId"];
		self.priceDropDate = [decoder decodeObjectForKey:@"priceDropDate"];
		self.sort = [decoder decodeIntegerForKey:@"sort"];
		self.productFilterSet = [decoder decodeObjectForKey:@"productFilterSet"];
	}
	return self;
}

@end
