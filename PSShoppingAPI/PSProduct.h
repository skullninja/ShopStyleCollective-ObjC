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

/** A product on shopstyle.com. */

@interface PSProduct : NSObject <NSCoding, PSRemoteObject>

/** The product's unique identifier. */
@property (nonatomic, copy, readonly) NSNumber *productId;

/** The product's name.  This often includes the brand name as well. */
@property (nonatomic, copy, readonly) NSString *name;

/** The product's description. This string may or may not contain HTML tags. */
@property (nonatomic, copy, readonly) NSString *descriptionHTML;

/** The product's click-through URL, which will take a user to the retailer's web page where the product 
 may be purchased. */
@property (nonatomic, copy, readonly) NSURL *buyURL;

/** A string representation of the product's price. */
@property (nonatomic, copy, readonly) NSString *priceLabel;

/** The product's price. */
@property (nonatomic, copy, readonly) NSNumber *price;

/** A string representation of the product's maximum price.  
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the price contains the lower end of the range.  If the product is not priced as
 a range, this property is nil.
 */
@property (nonatomic, copy, readonly) NSString *maxPriceLabel;

/** The product's maximum price.  
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the price contains the lower end of the range.  If the product is not priced as
 a range this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *maxPrice;

/** A string representation of the product's sale price.  
 If the product is not priced on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSString *salePriceLabel;

/** The product's sale price.  
 If the product is not priced on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *salePrice;

/** A string representation of the product's maximum sale price.  
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the sale price contains the lower end of the range.  If the product is not priced 
 as a range or is not on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSString *maxSalePriceLabel;

/** The product's maximum sale price.  
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the sale price contains the lower end of the range.  If the product is not priced 
 as a range or is not on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *maxSalePrice;

/** The currency of the price. Examples are USD, GBP, and EUR. */
@property (nonatomic, copy, readonly) NSString *currency;

/** The name of the product's brand.  
 Returns nil for Products without brand information. */
@property (nonatomic, strong, readonly) PSBrand *brand;

/** The name of the product's retailer. */
@property (nonatomic, strong, readonly) PSRetailer *retailer;

/** A label that can be used for a control that takes the user to more products like the receiver.  
 Example:  "See more Dresses by Bebe" */
@property (nonatomic, copy, readonly) NSString *seeMoreLabel;

/** A shopstyle.com URL that shows more products like the receiver. */
@property (nonatomic, copy, readonly) NSURL *seeMoreURL;

/** An array of `PSCategory` objects representing all categories on shopstyle.com that contain this product. */
@property (nonatomic, copy, readonly) NSArray *categories;

/** The locale of this product's retailer. */
@property (nonatomic, copy, readonly) NSString *localeId;

/** An array of `PSProductColor` objects representing the available colors at the retailer. */
@property (nonatomic, copy, readonly) NSArray *colors;

/** An array of `PSProductSize` objects representing the available sizes at the retailer. */
@property (nonatomic, copy, readonly) NSArray *sizes;

/** Returns YES if the product is currently in stock. */
@property (nonatomic, assign, readonly) BOOL inStock;

/** The date this product was first extracted from the retailer and added to shopstyle.com. */
@property (nonatomic, copy, readonly) NSString *extractDate;

/** An array of `PSProductImage` objects of various sizes. */
@property (nonatomic, copy, readonly) NSArray *images;

/** Returns YES if the product is on sale. */
@property (nonatomic, assign, readonly) BOOL isOnSale;

@end
