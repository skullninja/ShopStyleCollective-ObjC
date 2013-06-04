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

NSString * NSStringFromPSSProductQuerySort(PSSProductQuerySort sort)
{
	// FIXME: Localize
	switch (sort) {
		case PSSProductQuerySortDefault:
			return @"Relevance";
		case PSSProductQuerySortPriceLoHi:
			return @"Price Low to High";
		case PSSProductQuerySortPriceHiLo:
			return @"Price High to Low";
		case PSSProductQuerySortRecency:
			return @"Recent Additions";
		case PSSProductQuerySortPopular:
			return @"Most Popular";
		default:
			return nil;
	}
}

@implementation PSSProductQuery

#pragma mark - init

+ (instancetype)productQueryWithSearchTerm:(NSString *)searchTearm
{
	PSSProductQuery *instance = [[PSSProductQuery alloc] init];
	instance.searchTerm = searchTearm;
	return instance;
}

+ (instancetype)productQueryWithCategoryID:(NSString *)productCategoryID
{
	PSSProductQuery *instance = [[PSSProductQuery alloc] init];
	instance.productCategoryID = productCategoryID;
	return instance;
}

- (id)init
{
	self = [super init];
	if (self) {
		_productFilterSet = [[NSMutableSet alloc] init];
		_showInternationalProducts = NO;
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
		dictionary[@"fts"] = self.searchTerm;
	}
	if (self.productCategoryID && self.productCategoryID.length > 0) {
		dictionary[@"cat"] = self.productCategoryID;
	}
	
	if (self.productFilterSet.count > 0) {
		dictionary[@"fl"] = [[self productFilters] valueForKey:@"queryParameterRepresentation"];
	}
	
	if (self.priceDropDate) {
		NSNumber *numberRep = [NSNumber numberWithDouble:[self.priceDropDate timeIntervalSince1970]];
		dictionary[@"pdd"] = numberRep;
	}
	
	switch (self.sort) {
		case PSSProductQuerySortPriceLoHi:
			dictionary[@"sort"] = @"PriceLoHi";
			break;
		case PSSProductQuerySortPriceHiLo:
			dictionary[@"sort"] = @"PriceHiLo";
			break;
		case PSSProductQuerySortRecency:
			dictionary[@"sort"] = @"Recency";
			break;
		case PSSProductQuerySortPopular:
			dictionary[@"sort"] = @"Popular";
			break;
		case PSSProductQuerySortDefault:
			break;
		default:
			break;
	}
	
	if (self.showInternationalProducts) {
		dictionary[@"locales"] = @"all";
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
	hash ^= self.productCategoryID.hash;
	hash ^= self.priceDropDate.hash;
	hash ^= self.sort;
	hash ^= self.showInternationalProducts ? 1 : 0;
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
	if ((productQuery.searchTerm != nil || self.searchTerm != nil) && ![productQuery.searchTerm isEqualToString:self.searchTerm]) {
		return NO;
	}
	if ((productQuery.productCategoryID != nil || self.productCategoryID != nil) && ![productQuery.productCategoryID isEqualToString:self.productCategoryID]) {
		return NO;
	}
	if ((productQuery.priceDropDate != nil || self.priceDropDate != nil) && ![productQuery.priceDropDate isEqualToDate:self.priceDropDate]) {
		return NO;
	}
	if (productQuery.sort != self.sort) {
		return NO;
	}
	if (productQuery.showInternationalProducts != self.showInternationalProducts) {
		return NO;
	}
	
	return YES;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.searchTerm forKey:@"searchTerm"];
	[encoder encodeObject:self.productCategoryID forKey:@"productCategoryID"];
	[encoder encodeObject:self.priceDropDate forKey:@"priceDropDate"];
	[encoder encodeInteger:self.sort forKey:@"sort"];
	[encoder encodeObject:self.productFilterSet forKey:@"productFilterSet"];
	[encoder encodeBool:self.showInternationalProducts forKey:@"showInternationalProducts"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.searchTerm = [decoder decodeObjectForKey:@"searchTerm"];
		self.productCategoryID = [decoder decodeObjectForKey:@"productCategoryID"];
		self.priceDropDate = [decoder decodeObjectForKey:@"priceDropDate"];
		self.sort = [decoder decodeIntegerForKey:@"sort"];
		self.productFilterSet = [decoder decodeObjectForKey:@"productFilterSet"];
		self.showInternationalProducts = [decoder decodeBoolForKey:@"showInternationalProducts"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.searchTerm = self.searchTerm;
	copy.productCategoryID = self.productCategoryID;
	copy.priceDropDate = self.priceDropDate;
	copy.sort = self.sort;
	copy.productFilterSet = [[NSMutableSet alloc] initWithSet:self.productFilterSet copyItems:YES];
	copy.showInternationalProducts = self.showInternationalProducts;
	return copy;
}

@end
