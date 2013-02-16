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

@implementation PSProduct

@synthesize brand = _brand;
@synthesize categories = _categories;
@synthesize buyUrlString = _buyUrlString;
@synthesize colors = _colors;
@synthesize currency = _currency;
@synthesize descriptionText = _descriptionText;
@synthesize extractDate = _extractDate;
@synthesize images = _images;
@synthesize inStock = _inStock;
@synthesize localeId = _localeId;
@synthesize maxSalePrice = _maxSalePrice;
@synthesize maxSalePriceLabel = _maxSalePriceLabel;
@synthesize name = _name;
@synthesize price = _price;
@synthesize priceLabel = _priceLabel;
@synthesize productId = _productId;
@synthesize retailer = _retailer;
@synthesize salePrice = _salePrice;
@synthesize salePriceLabel = _salePriceLabel;
@synthesize seeMoreLabel = _seeMoreLabel;
@synthesize seeMoreUrl = _seeMoreUrl;
@synthesize sizes = _sizes;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.brand forKey:@"brand"];
    [encoder encodeObject:self.categories forKey:@"categories"];
    [encoder encodeObject:self.buyUrlString forKey:@"buyUrlString"];
    [encoder encodeObject:self.colors forKey:@"colors"];
    [encoder encodeObject:self.currency forKey:@"currency"];
    [encoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    [encoder encodeObject:self.extractDate forKey:@"extractDate"];
    [encoder encodeObject:self.images forKey:@"images"];
    [encoder encodeObject:[NSNumber numberWithBool:self.inStock] forKey:@"inStock"];
    [encoder encodeObject:self.localeId forKey:@"localeId"];
    [encoder encodeObject:self.maxPrice forKey:@"maxPrice"];
    [encoder encodeObject:self.maxPriceLabel forKey:@"maxPriceLabel"];
    [encoder encodeObject:self.maxSalePrice forKey:@"maxSalePrice"];
    [encoder encodeObject:self.maxSalePriceLabel forKey:@"maxSalePriceLabel"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.priceLabel forKey:@"priceLabel"];
    [encoder encodeObject:self.productId forKey:@"productId"];
    [encoder encodeObject:self.retailer forKey:@"retailer"];
    [encoder encodeObject:self.salePrice forKey:@"salePrice"];
    [encoder encodeObject:self.salePriceLabel forKey:@"salePriceLabel"];
    [encoder encodeObject:self.seeMoreLabel forKey:@"seeMoreLabel"];
    [encoder encodeObject:self.seeMoreUrl forKey:@"seeMoreUrl"];
    [encoder encodeObject:self.sizes forKey:@"sizes"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.brand = [decoder decodeObjectForKey:@"brand"];
        self.categories = [decoder decodeObjectForKey:@"categories"];
        self.buyUrlString = [decoder decodeObjectForKey:@"buyUrlString"];
        self.colors = [decoder decodeObjectForKey:@"colors"];
        self.currency = [decoder decodeObjectForKey:@"currency"];
        self.descriptionText = [decoder decodeObjectForKey:@"descriptionText"];
        self.extractDate = [decoder decodeObjectForKey:@"extractDate"];
        self.images = [decoder decodeObjectForKey:@"images"];
        self.inStock = [(NSNumber *)[decoder decodeObjectForKey:@"inStock"] boolValue];
        self.localeId = [decoder decodeObjectForKey:@"localeId"];
        self.maxPrice = [decoder decodeObjectForKey:@"maxPrice"];
        self.maxPriceLabel = [decoder decodeObjectForKey:@"maxPriceLabel"];
        self.maxSalePrice = [decoder decodeObjectForKey:@"maxSalePrice"];
        self.maxSalePriceLabel = [decoder decodeObjectForKey:@"maxSalePriceLabel"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.priceLabel = [decoder decodeObjectForKey:@"priceLabel"];
        self.productId = [decoder decodeObjectForKey:@"productId"];
        self.retailer = [decoder decodeObjectForKey:@"retailer"];
        self.salePrice = [decoder decodeObjectForKey:@"salePrice"];
        self.salePriceLabel = [decoder decodeObjectForKey:@"salePriceLabel"];
        self.seeMoreLabel = [decoder decodeObjectForKey:@"seeMoreLabel"];
        self.seeMoreUrl = [decoder decodeObjectForKey:@"seeMoreUrl"];
        self.sizes = [decoder decodeObjectForKey:@"sizes"];
    }
    return self;
}

+ (PSProduct *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    PSProduct *instance = [[PSProduct alloc] init];
    [instance setPropertiesWithDictionary:aDictionary];
    return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self setValuesForKeysWithDictionary:aDictionary];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"brand"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.brand = [PSBrand instanceFromDictionary:value];
        }
    } else if ([key isEqualToString:@"categories"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                PSCategory *populatedMember = [PSCategory instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            self.categories = myMembers;
        }
    } else if ([key isEqualToString:@"colors"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
				if ([valueMember isKindOfClass:[NSDictionary class]] && [(NSDictionary *)valueMember valueForKey:@"name"] != nil) {
					[myMembers addObject:[(NSDictionary *)valueMember valueForKey:@"name"]];
				}
            }
            self.colors = myMembers;
        }
    } else if ([key isEqualToString:@"images"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                PSProductImage *populatedMember = [PSProductImage instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            self.images = myMembers;
        }
    } else if ([key isEqualToString:@"retailer"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.retailer = [PSRetailer instanceFromDictionary:value];
        }
    } else if ([key isEqualToString:@"sizes"]) {
        if ([value isKindOfClass:[NSArray class]]) {
			NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
			for (id valueMember in value) {
				if ([valueMember isKindOfClass:[NSDictionary class]] && [(NSDictionary *)valueMember valueForKey:@"name"] != nil) {
					[myMembers addObject:[(NSDictionary *)valueMember valueForKey:@"name"]];
				}
            }
            self.sizes = myMembers;
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"clickUrl"]) {
        [self setValue:value forKey:@"buyUrlString"];
    } else if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionText"];
    } else if ([key isEqualToString:@"locale"]) {
        [self setValue:value forKey:@"localeId"];
    } else if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"productId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.brand) {
        [dictionary setObject:self.brand forKey:@"brand"];
    }
    if (self.categories) {
        [dictionary setObject:self.categories forKey:@"categories"];
    }
    if (self.buyUrlString) {
        [dictionary setObject:self.buyUrlString forKey:@"buyUrlString"];
    }
    if (self.colors) {
        [dictionary setObject:self.colors forKey:@"colors"];
    }
    if (self.currency) {
        [dictionary setObject:self.currency forKey:@"currency"];
    }
    if (self.descriptionText) {
        [dictionary setObject:self.descriptionText forKey:@"descriptionText"];
    }
    if (self.extractDate) {
        [dictionary setObject:self.extractDate forKey:@"extractDate"];
    }
    if (self.images) {
        [dictionary setObject:self.images forKey:@"images"];
    }
    [dictionary setObject:[NSNumber numberWithBool:self.inStock] forKey:@"inStock"];
    if (self.localeId) {
        [dictionary setObject:self.localeId forKey:@"localeId"];
    }
    if (self.maxPrice) {
        [dictionary setObject:self.maxPrice forKey:@"maxPrice"];
    }
    if (self.maxPriceLabel) {
        [dictionary setObject:self.maxPriceLabel forKey:@"maxPriceLabel"];
    }
    if (self.maxSalePrice) {
        [dictionary setObject:self.maxSalePrice forKey:@"maxSalePrice"];
    }
    if (self.maxSalePriceLabel) {
        [dictionary setObject:self.maxSalePriceLabel forKey:@"maxSalePriceLabel"];
    }
    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }
    if (self.price) {
        [dictionary setObject:self.price forKey:@"price"];
    }
    if (self.priceLabel) {
        [dictionary setObject:self.priceLabel forKey:@"priceLabel"];
    }
    if (self.productId) {
        [dictionary setObject:self.productId forKey:@"productId"];
    }
    if (self.retailer) {
        [dictionary setObject:self.retailer forKey:@"retailer"];
    }
    if (self.salePrice) {
        [dictionary setObject:self.salePrice forKey:@"salePrice"];
    }
    if (self.salePriceLabel) {
        [dictionary setObject:self.salePriceLabel forKey:@"salePriceLabel"];
    }
    if (self.seeMoreLabel) {
        [dictionary setObject:self.seeMoreLabel forKey:@"seeMoreLabel"];
    }
    if (self.seeMoreUrl) {
        [dictionary setObject:self.seeMoreUrl forKey:@"seeMoreUrl"];
    }
    if (self.sizes) {
        [dictionary setObject:self.sizes forKey:@"sizes"];
    }
    return dictionary;
}

@end
