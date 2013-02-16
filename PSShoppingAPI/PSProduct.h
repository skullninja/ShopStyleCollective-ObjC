//
//  PSProduct.h
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

#import <Foundation/Foundation.h>

@class PSBrand;
@class PSRetailer;

@interface PSProduct : NSObject <NSCoding>

@property (nonatomic, strong) PSBrand *brand;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSString *buyUrlString;
@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *extractDate;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) BOOL inStock;
@property (nonatomic, copy) NSString *localeId;
@property (nonatomic, copy) NSNumber *maxPrice;
@property (nonatomic, copy) NSString *maxPriceLabel;
@property (nonatomic, copy) NSNumber *maxSalePrice;
@property (nonatomic, copy) NSString *maxSalePriceLabel;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSString *priceLabel;
@property (nonatomic, copy) NSNumber *productId;
@property (nonatomic, strong) PSRetailer *retailer;
@property (nonatomic, copy) NSNumber *salePrice;
@property (nonatomic, copy) NSString *salePriceLabel;
@property (nonatomic, copy) NSString *seeMoreLabel;
@property (nonatomic, copy) NSString *seeMoreUrl;
@property (nonatomic, copy) NSArray *sizes;

+ (PSProduct *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
