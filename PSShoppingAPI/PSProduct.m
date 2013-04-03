//
//  PSProduct.m
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

#import "PSProduct.h"
#import "PSBrand.h"
#import "PSCategory.h"
#import "PSProductImage.h"
#import "PSRetailer.h"

@interface PSProduct ()

@property (nonatomic, copy, readwrite) NSNumber *productId;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *descriptionHTML;
@property (nonatomic, copy, readwrite) NSURL *buyURL;
@property (nonatomic, copy, readwrite) NSString *regularPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *regularPrice;
@property (nonatomic, copy, readwrite) NSString *maxPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *maxPrice;
@property (nonatomic, copy, readwrite) NSString *salePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *salePrice;
@property (nonatomic, copy, readwrite) NSString *maxSalePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *maxSalePrice;
@property (nonatomic, copy, readwrite) NSString *currency;
@property (nonatomic, strong, readwrite) PSBrand *brand;
@property (nonatomic, strong, readwrite) PSRetailer *retailer;
@property (nonatomic, copy, readwrite) NSString *seeMoreLabel;
@property (nonatomic, copy, readwrite) NSURL *seeMoreURL;
@property (nonatomic, copy, readwrite) NSArray *categories;
@property (nonatomic, copy, readwrite) NSString *localeId;
@property (nonatomic, copy, readwrite) NSArray *colors;
@property (nonatomic, copy, readwrite) NSArray *sizes;
@property (nonatomic, assign, readwrite) BOOL inStock;
@property (nonatomic, copy, readwrite) NSString *extractDate;
@property (nonatomic, copy, readwrite) NSArray *images;

@end

@implementation PSProduct

#pragma mark - Accessors

- (BOOL)isOnSale
{
	return (self.salePrice != nil && self.salePrice.integerValue > 0);
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.productId];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSDLog(@"Warning: Undefined Key Named '%@'", key);
}

- (NSUInteger)hash
{
	return self.productId.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.productId isEqualToNumber:[(PSProduct *)object productId]]);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.brand forKey:@"brand"];
	[encoder encodeObject:self.categories forKey:@"categories"];
	[encoder encodeObject:self.buyURL forKey:@"buyURL"];
	[encoder encodeObject:self.colors forKey:@"colors"];
	[encoder encodeObject:self.currency forKey:@"currency"];
	[encoder encodeObject:self.descriptionHTML forKey:@"descriptionHTML"];
	[encoder encodeObject:self.extractDate forKey:@"extractDate"];
	[encoder encodeObject:self.images forKey:@"images"];
	[encoder encodeObject:[NSNumber numberWithBool:self.inStock] forKey:@"inStock"];
	[encoder encodeObject:self.localeId forKey:@"localeId"];
	[encoder encodeObject:self.maxPrice forKey:@"maxPrice"];
	[encoder encodeObject:self.maxPriceLabel forKey:@"maxPriceLabel"];
	[encoder encodeObject:self.maxSalePrice forKey:@"maxSalePrice"];
	[encoder encodeObject:self.maxSalePriceLabel forKey:@"maxSalePriceLabel"];
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.regularPrice forKey:@"price"];
	[encoder encodeObject:self.regularPriceLabel forKey:@"regularPriceLabel"];
	[encoder encodeObject:self.productId forKey:@"productId"];
	[encoder encodeObject:self.retailer forKey:@"retailer"];
	[encoder encodeObject:self.salePrice forKey:@"salePrice"];
	[encoder encodeObject:self.salePriceLabel forKey:@"salePriceLabel"];
	[encoder encodeObject:self.seeMoreLabel forKey:@"seeMoreLabel"];
	[encoder encodeObject:self.seeMoreURL forKey:@"seeMoreURL"];
	[encoder encodeObject:self.sizes forKey:@"sizes"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.brand = [decoder decodeObjectForKey:@"brand"];
		self.categories = [decoder decodeObjectForKey:@"categories"];
		self.buyURL = [decoder decodeObjectForKey:@"buyURL"];
		self.colors = [decoder decodeObjectForKey:@"colors"];
		self.currency = [decoder decodeObjectForKey:@"currency"];
		self.descriptionHTML = [decoder decodeObjectForKey:@"descriptionHTML"];
		self.extractDate = [decoder decodeObjectForKey:@"extractDate"];
		self.images = [decoder decodeObjectForKey:@"images"];
		self.inStock = [(NSNumber *)[decoder decodeObjectForKey:@"inStock"] boolValue];
		self.localeId = [decoder decodeObjectForKey:@"localeId"];
		self.maxPrice = [decoder decodeObjectForKey:@"maxPrice"];
		self.maxPriceLabel = [decoder decodeObjectForKey:@"maxPriceLabel"];
		self.maxSalePrice = [decoder decodeObjectForKey:@"maxSalePrice"];
		self.maxSalePriceLabel = [decoder decodeObjectForKey:@"maxSalePriceLabel"];
		self.name = [decoder decodeObjectForKey:@"name"];
		self.regularPrice = [decoder decodeObjectForKey:@"regularPrice"];
		self.regularPriceLabel = [decoder decodeObjectForKey:@"regularPriceLabel"];
		self.productId = [decoder decodeObjectForKey:@"productId"];
		self.retailer = [decoder decodeObjectForKey:@"retailer"];
		self.salePrice = [decoder decodeObjectForKey:@"salePrice"];
		self.salePriceLabel = [decoder decodeObjectForKey:@"salePriceLabel"];
		self.seeMoreLabel = [decoder decodeObjectForKey:@"seeMoreLabel"];
		self.seeMoreURL = [decoder decodeObjectForKey:@"seeMoreURL"];
		self.sizes = [decoder decodeObjectForKey:@"sizes"];
	}
	return self;
}

#pragma mark - PSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSProduct *instance = [[PSProduct alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	if (![aDictionary isKindOfClass:[NSDictionary class]]) {
		return;
	}
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"clickUrl"] && [value isKindOfClass:[NSString class]]) {
			self.buyURL = [NSURL URLWithString:value];
		} else if ([key isEqualToString:@"seeMoreUrl"] && [value isKindOfClass:[NSString class]]) {
			self.seeMoreURL = [NSURL URLWithString:value];
		} else if ([key isEqualToString:@"description"]) {
			self.descriptionHTML = [value description];
		} else if ([key isEqualToString:@"locale"]) {
			self.localeId = [value description];
		} else if ([key isEqualToString:@"id"] && ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])) {
			self.productId = [NSNumber numberWithInteger:[[value description] integerValue]];
		} else if ([key isEqualToString:@"brand"] && [value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
			self.brand = (PSBrand *)[self remoteObjectForRelationshipNamed:@"brand" fromRepresentation:value];
		} else if ([key isEqualToString:@"categories"] && [value isKindOfClass:[NSArray class]]) {
			self.categories = [self remoteObjectsForToManyRelationshipNamed:@"categories" fromRepresentations:value];
		} else if ([key isEqualToString:@"colors"] && [value isKindOfClass:[NSArray class]]) {
			self.colors = [self remoteObjectsForToManyRelationshipNamed:@"colors" fromRepresentations:value];
		} else if ([key isEqualToString:@"images"] && [value isKindOfClass:[NSArray class]]) {
			self.images = [self remoteObjectsForToManyRelationshipNamed:@"images" fromRepresentations:value];
		} else if ([key isEqualToString:@"retailer"] && [value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
			self.retailer = (PSRetailer *)[self remoteObjectForRelationshipNamed:@"retailer" fromRepresentation:value];
		} else if ([key isEqualToString:@"sizes"] && [value isKindOfClass:[NSArray class]]) {
			self.sizes = [self remoteObjectsForToManyRelationshipNamed:@"sizes" fromRepresentations:value];
		} else if ([key isEqualToString:@"price"] && ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])) {
			self.regularPrice = [NSNumber numberWithInteger:[[value description] integerValue]];
		} else if ([key isEqualToString:@"priceLabel"]) {
			self.regularPriceLabel = [value description];
		} else {
			[self setValue:value forKey:key];
		}
	}
}

- (NSArray *)remoteObjectsForToManyRelationshipNamed:(NSString *)relationshipName fromRepresentations:(NSArray *)representations
{
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[representations count]];
	for (id valueMember in representations) {
		if ([valueMember isKindOfClass:[NSDictionary class]] && [(NSDictionary *)valueMember count] > 0) {
			id remoteObject = [self remoteObjectForRelationshipNamed:relationshipName fromRepresentation:valueMember];
			if (remoteObject != nil) {
				[objects addObject:remoteObject];
			}
		}
	}
	if (objects.count > 0) {
		return objects;
	}
	return nil;
}

- (id<PSRemoteObject>)remoteObjectForRelationshipNamed:(NSString *)relationshipName fromRepresentation:(NSDictionary *)representation
{
	if ([relationshipName isEqualToString:@"brand"]) {
		return [PSBrand instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"categories"]) {
		return [PSCategory instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"colors"]) {
		return [PSProductColor instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"images"]) {
		return [PSProductImage instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"retailer"]) {
		return [PSRetailer instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"sizes"]) {
		return [PSProductSize instanceFromRemoteRepresentation:representation];
	}
	return nil;
}

@end
