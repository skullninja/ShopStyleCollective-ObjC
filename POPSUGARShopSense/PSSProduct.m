//
//  PSSProduct.m
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

#import "PSSProduct.h"
#import "PSSBrand.h"
#import "PSSProductCategory.h"
#import "PSSProductImage.h"
#import "PSSRetailer.h"

@interface PSSProduct ()

@property (nonatomic, copy, readwrite) NSNumber *productId;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *descriptionHTML;
@property (nonatomic, copy, readwrite) NSURL *buyURL;
@property (nonatomic, copy, readwrite) NSString *regularPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *regularPrice;
@property (nonatomic, copy, readwrite) NSString *maxRegularPriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *maxRegularPrice;
@property (nonatomic, copy, readwrite) NSString *salePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *salePrice;
@property (nonatomic, copy, readwrite) NSString *maxSalePriceLabel;
@property (nonatomic, copy, readwrite) NSNumber *maxSalePrice;
@property (nonatomic, copy, readwrite) NSString *currency;
@property (nonatomic, strong, readwrite) PSSBrand *brand;
@property (nonatomic, strong, readwrite) PSSRetailer *retailer;
@property (nonatomic, copy, readwrite) NSString *seeMoreLabel;
@property (nonatomic, copy, readwrite) NSURL *seeMoreURL;
@property (nonatomic, copy, readwrite) NSArray *categories;
@property (nonatomic, copy, readwrite) NSString *localeId;
@property (nonatomic, copy, readwrite) NSArray *colors;
@property (nonatomic, copy, readwrite) NSArray *sizes;
@property (nonatomic, assign, readwrite) BOOL inStock;
@property (nonatomic, copy, readwrite) NSString *extractDate;
@property (nonatomic, copy, readwrite) NSArray *images;
@property (nonatomic, copy, readwrite) NSString *nativeCurrency;
@property (nonatomic, copy, readwrite) NSString *nativePriceLabel;
@property (nonatomic, assign, readwrite) NSNumber *nativePrice;
@property (nonatomic, copy, readwrite) NSString *nativeMaxPriceLabel;
@property (nonatomic, assign, readwrite) NSNumber *nativeMaxPrice;
@property (nonatomic, copy, readwrite) NSString *nativeSalePriceLabel;
@property (nonatomic, assign, readwrite) NSNumber *nativeSalePrice;
@property (nonatomic, copy, readwrite) NSString *nativeMaxSalePriceLabel;
@property (nonatomic, assign, readwrite) NSNumber *nativeMaxSalePrice;

@property (nonatomic, strong) NSDictionary *imagesBySizeName;

@end

@implementation PSSProduct

#pragma mark - Pricing Helpers

- (BOOL)isOnSale
{
	return (self.salePrice != nil && self.salePrice.integerValue > 0);
}

- (BOOL)hasPriceRange
{
	return ([self currentMaxPrice] != nil);
}

- (BOOL)hasNativePrice
{
	return (self.nativeCurrency != nil);
}

- (NSString *)currentPriceLabel
{
	if (self.salePriceLabel != nil) {
		return self.salePriceLabel;
	}
	return self.regularPriceLabel;
}

- (NSNumber *)currentPrice
{
	if (self.salePrice != nil) {
		return self.salePrice;
	}
	return self.regularPrice;
}

- (NSString *)currentMaxPriceLabel
{
	if (self.maxSalePriceLabel != nil) {
		return self.maxSalePriceLabel;
	}
	return self.maxRegularPriceLabel;
}

- (NSNumber *)currentMaxPrice
{
	if (self.maxSalePrice != nil) {
		return self.maxSalePrice;
	}
	return self.maxRegularPrice;
}

#pragma mark - Product Image Helpers

- (NSArray *)orderedImageSizeNames
{
	return [NSArray arrayWithObjects:kPSSProductImageSizeNamedSmall, kPSSProductImageSizeNamedIPhoneSmall, kPSSProductImageSizeNamedMedium, kPSSProductImageSizeNamedLarge, kPSSProductImageSizeNamedIPhone, kPSSProductImageSizeNamedOriginal, nil];
}

- (void)orderAndMapImages:(NSArray *)images
{
	if (images == nil || images.count == 0) {
		self.images = nil;
		self.imagesBySizeName = nil;
	}
	NSMutableDictionary *mappedImages = [[NSMutableDictionary alloc] initWithCapacity:images.count];
	for (PSSProductImage *image in images) {
		[mappedImages setObject:image forKey:image.sizeName];
	}
	self.imagesBySizeName = mappedImages;
	NSMutableArray *sortedImages = [[NSMutableArray alloc] initWithCapacity:mappedImages.count];
	for (NSString *sizeName in [self orderedImageSizeNames]) {
		if ([self.imagesBySizeName objectForKey:sizeName] != nil) {
			[sortedImages addObject:[self.imagesBySizeName objectForKey:sizeName]];
		}
	}
	self.images = sortedImages;
}

- (PSSProductImage *)imageWithSizeName:(NSString *)imageSizeName
{
	return [self.imagesBySizeName objectForKey:imageSizeName];
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.productId];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@'", key);
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
	return ([self.productId isEqualToNumber:[(PSSProduct *)object productId]]);
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
	[encoder encodeObject:self.maxRegularPrice forKey:@"maxRegularPrice"];
	[encoder encodeObject:self.maxRegularPriceLabel forKey:@"maxRegularPriceLabel"];
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
	[encoder encodeObject:self.imagesBySizeName forKey:@"imagesBySizeName"];
	[encoder encodeObject:self.nativeCurrency forKey:@"nativeCurrency"];
	[encoder encodeObject:self.nativePriceLabel forKey:@"nativePriceLabel"];
	[encoder encodeObject:self.nativePrice forKey:@"nativePrice"];
	[encoder encodeObject:self.nativeMaxPriceLabel forKey:@"nativeMaxPriceLabel"];
	[encoder encodeObject:self.nativeMaxPrice forKey:@"nativeMaxPrice"];
	[encoder encodeObject:self.nativeSalePriceLabel forKey:@"nativeSalePriceLabel"];
	[encoder encodeObject:self.nativeSalePrice forKey:@"nativeSalePrice"];
	[encoder encodeObject:self.nativeMaxSalePriceLabel forKey:@"nativeMaxSalePriceLabel"];
	[encoder encodeObject:self.nativeMaxSalePrice forKey:@"nativeMaxSalePrice"];
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
		self.maxRegularPrice = [decoder decodeObjectForKey:@"maxRegularPrice"];
		self.maxRegularPriceLabel = [decoder decodeObjectForKey:@"maxRegularPriceLabel"];
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
		self.imagesBySizeName = [decoder decodeObjectForKey:@"imagesBySizeName"];
		self.nativeCurrency = [decoder decodeObjectForKey:@"nativeCurrency"];
		self.nativePriceLabel = [decoder decodeObjectForKey:@"nativePriceLabel"];
		self.nativePrice = [decoder decodeObjectForKey:@"nativePrice"];
		self.nativeMaxPriceLabel = [decoder decodeObjectForKey:@"nativeMaxPriceLabel"];
		self.nativeMaxPrice = [decoder decodeObjectForKey:@"nativeMaxPrice"];
		self.nativeSalePriceLabel = [decoder decodeObjectForKey:@"nativeSalePriceLabel"];
		self.nativeSalePrice = [decoder decodeObjectForKey:@"nativeSalePrice"];
		self.nativeMaxSalePriceLabel = [decoder decodeObjectForKey:@"nativeMaxSalePriceLabel"];
		self.nativeMaxSalePrice = [decoder decodeObjectForKey:@"nativeMaxSalePrice"];
	}
	return self;
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSProduct *instance = [[PSSProduct alloc] init];
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
		if ([key isEqualToString:@"clickUrl"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.buyURL = [NSURL URLWithString:value];
			}
		} else if ([key isEqualToString:@"seeMoreUrl"] && [value isKindOfClass:[NSString class]]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.seeMoreURL = [NSURL URLWithString:value];
			}
		} else if ([key isEqualToString:@"description"]) {
			self.descriptionHTML = [value description];
		} else if ([key isEqualToString:@"locale"]) {
			self.localeId = [value description];
		} else if ([key isEqualToString:@"id"]) {
			if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
				self.productId = [NSNumber numberWithInteger:[[value description] integerValue]];
			}
		} else if ([key isEqualToString:@"brand"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				self.brand = (PSSBrand *)[self remoteObjectForRelationshipNamed:@"brand" fromRepresentation:value];
			}
		} else if ([key isEqualToString:@"categories"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.categories = [self remoteObjectsForToManyRelationshipNamed:@"categories" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"colors"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.colors = [self remoteObjectsForToManyRelationshipNamed:@"colors" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"images"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				NSDictionary *imageMap = (NSDictionary *)value;
				[self orderAndMapImages:[self remoteObjectsForToManyRelationshipNamed:@"images" fromRepresentations:imageMap.allValues]];
			}
		} else if ([key isEqualToString:@"retailer"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				self.retailer = (PSSRetailer *)[self remoteObjectForRelationshipNamed:@"retailer" fromRepresentation:value];
			}
		} else if ([key isEqualToString:@"sizes"]) {
			if ([value isKindOfClass:[NSArray class]]) {
				self.sizes = [self remoteObjectsForToManyRelationshipNamed:@"sizes" fromRepresentations:value];
			}
		} else if ([key isEqualToString:@"price"]) {
			if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
				self.regularPrice = [NSNumber numberWithInteger:[[value description] integerValue]];
			}
		} else if ([key isEqualToString:@"priceLabel"]) {
			self.regularPriceLabel = [value description];
		} else if ([key isEqualToString:@"maxPrice"]) {
			if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
				self.maxRegularPrice = [NSNumber numberWithInteger:[[value description] integerValue]];
			}
		} else if ([key isEqualToString:@"maxPriceLabel"]) {
			self.maxRegularPriceLabel = [value description];
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

- (id<PSSRemoteObject>)remoteObjectForRelationshipNamed:(NSString *)relationshipName fromRepresentation:(NSDictionary *)representation
{
	if ([relationshipName isEqualToString:@"brand"]) {
		return [PSSBrand instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"categories"]) {
		return [PSSProductCategory instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"colors"]) {
		return [PSSProductColor instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"images"]) {
		return [PSSProductImage instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"retailer"]) {
		return [PSSRetailer instanceFromRemoteRepresentation:representation];
	} else if ([relationshipName isEqualToString:@"sizes"]) {
		return [PSSProductSize instanceFromRemoteRepresentation:representation];
	}
	return nil;
}

@end
