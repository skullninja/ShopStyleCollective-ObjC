//
//  PSSProductFilter.m
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

#import "PSSProductFilter.h"

@interface PSSProductFilter ()

@property (nonatomic, assign, readwrite) PSSProductFilterType type;
@property (nonatomic, copy, readwrite) NSNumber *filterId;

@end

NSString * NSStringFromPSSProductFilterType(PSSProductFilterType filterType)
{
	// FIXME: Localize
	switch (filterType) {
		case PSSProductFilterTypeBrand:
			return @"Brand";
		case PSSProductFilterTypeRetailer:
			return @"Retailer";
		case PSSProductFilterTypePrice:
			return @"Price";
		case PSSProductFilterTypeDiscount:
			return @"Discount";
		case PSSProductFilterTypeSize:
			return @"Size";
		case PSSProductFilterTypeColor:
			return @"Color";
		default:
			return nil;
	}
}

@implementation PSSProductFilter

#pragma mark - Init

+ (instancetype)filterWithType:(PSSProductFilterType)type filterId:(NSNumber *)filterId
{
	PSSProductFilter *filter = [[PSSProductFilter alloc] initWithType:type filterId:filterId];
	return filter;
}

- (id)initWithType:(PSSProductFilterType)type filterId:(NSNumber *)filterId
{
	NSParameterAssert(filterId != nil);
	self = [super init];
	if (self) {
		_filterId = [filterId copy];
		_type = type;
	}
	return self;
}

#pragma mark - Conversion to URL Query Parameters

- (NSString *)queryParameterRepresentation
{
	// Filter prefixes are:
	// b - brand
	// r - retailer
	// p - price
	// d - discount
	// s - size
	// c - color
	NSString *prefix = @"";
	switch (self.type) {
		case PSSProductFilterTypeBrand:
			prefix = @"b";
			break;
		case PSSProductFilterTypeRetailer:
			prefix = @"r";
			break;
		case PSSProductFilterTypePrice:
			prefix = @"p";
			break;
		case PSSProductFilterTypeDiscount:
			prefix = @"d";
			break;
		case PSSProductFilterTypeSize:
			prefix = @"s";
			break;
		case PSSProductFilterTypeColor:
			prefix = @"c";
			break;
			
		default:
			break;
	}
	return [prefix stringByAppendingFormat:@"%d", self.filterId.integerValue];
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@", [self queryParameterRepresentation]];
}

- (NSUInteger)hash
{
	return ((self.filterId.hash << sizeof(PSSProductFilterType)) ^ self.type);
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.filterId isEqualToNumber:[(PSSProductFilter *)object filterId]] && self.type == [(PSSProductFilter *)object type]);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.filterId forKey:@"filterId"];
	[encoder encodeObject:self.browseURLString forKey:@"browseURLString"];
	[encoder encodeInteger:self.type forKey:@"type"];
	[encoder encodeObject:self.productCount forKey:@"productCount"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.filterId = [decoder decodeObjectForKey:@"filterId"];
		self.browseURLString = [decoder decodeObjectForKey:@"browseURLString"];
		self.type = [decoder decodeIntegerForKey:@"type"];
		self.productCount = [decoder decodeObjectForKey:@"productCount"];
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] allocWithZone:zone] init];
	copy.filterId = self.filterId;
	copy.type = self.type;
	copy.name = self.name;
	copy.browseURLString = self.browseURLString;
	copy.productCount = self.productCount;
	return copy;
}

@end