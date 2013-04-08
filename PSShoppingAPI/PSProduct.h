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
@class PSProductImage;

/** A product on shopstyle.com. */

@interface PSProduct : NSObject <NSCoding, PSRemoteObject>

/** The unique identifier of the receiver. */
@property (nonatomic, copy, readonly) NSNumber *productId;

/** A name to display for the receiver. This often includes the brand's name as well. */
@property (nonatomic, copy, readonly) NSString *name;

/** The retailer's description of the receiver. This string may or may not contain HTML tags. */
@property (nonatomic, copy, readonly) NSString *descriptionHTML;

/** The click-through URL to purchase the receiver, which will take a user to the retailer's web page where the product 
 may be purchased. */
@property (nonatomic, copy, readonly) NSURL *buyURL;

/** A string representation of the `regularPrice`. */
@property (nonatomic, copy, readonly) NSString *regularPriceLabel;

/** The regular price in the currency of the receiver.
 
 The price of the product when not on sale. If the product isOnSale use salePrice for the price. */
@property (nonatomic, copy, readonly) NSNumber *regularPrice;

/** A string representation of the `maxRegularPrice`. */
@property (nonatomic, copy, readonly) NSString *maxRegularPriceLabel;

/** The maximum price in the currency of the receiver when priced in a range.  
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the regularPrice contains the lower end of the range.  If the product is not priced as
 a range this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *maxRegularPrice;

/** A string representation of the `salePrice`. */
@property (nonatomic, copy, readonly) NSString *salePriceLabel;

/** The product's sale price.  
 
 If the product is not priced on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *salePrice;

/** A string representation of the `maxSalePrice`. */
@property (nonatomic, copy, readonly) NSString *maxSalePriceLabel;

/** The product's maximum sale price when on sale and priced in a range.  
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the salePrice contains the lower end of the range.  If the product is not priced 
 as a range or is not on sale this property is nil.
 */
@property (nonatomic, copy, readonly) NSNumber *maxSalePrice;

/** The currency of the price. Examples are USD, GBP, and EUR. */
@property (nonatomic, copy, readonly) NSString *currency;

/** The brand of the receiver. */
@property (nonatomic, strong, readonly) PSBrand *brand;

/** The retailer of the receiver. */
@property (nonatomic, strong, readonly) PSRetailer *retailer;

/** A label that can be used for a control that takes the user to more products like the receiver.  
 
 Example:  "See more Dresses by Bebe" */
@property (nonatomic, copy, readonly) NSString *seeMoreLabel;

/** A shopstyle.com URL that shows more products like the receiver. */
@property (nonatomic, copy, readonly) NSURL *seeMoreURL;

/** All categories on shopstyle.com that contain the receiver.
 
 @return An array of `PSProductCategory` objects representing all categories on shopstyle.com that contain this product. */
@property (nonatomic, copy, readonly) NSArray *categories;

/** The locale of the retailer. */
@property (nonatomic, copy, readonly) NSString *localeId;

/** The colors available at the retailer.
 
 @return An array of `PSProductColor` objects representing the available colors at the retailer. */
@property (nonatomic, copy, readonly) NSArray *colors;

/** The sizes available at the retailer.
 
 @return An array of `PSProductSize` objects representing the available sizes at the retailer. */
@property (nonatomic, copy, readonly) NSArray *sizes;

/** The receiver was in stock the last poll of the retailer's website.
 
 Out of stock products should not be returned by product searches but my be returned by other methods such as getting a product by it's identifier.
 
 @returns YES if the product is currently in stock. */
@property (nonatomic, assign, readonly) BOOL inStock;

/** The date this product was first extracted from the retailer's website and added to shopstyle.com. */
@property (nonatomic, copy, readonly) NSString *extractDate;

/** Images of the receiver.
 
 @return An array of `PSProductImage` objects. */
@property (nonatomic, copy, readonly) NSArray *images;

/**---------------------------------------------------------------------------------------
 * @name Pricing Helpers
 *  ---------------------------------------------------------------------------------------
 */

/** The receiver was on sale the last poll of the retailer's website.
 
 @return YES if the product is on sale. */
- (BOOL)isOnSale;

/** The product's price should be displayed as a price range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the `currentPrice` contains the lower end of the range and the `currentMaxPrice` contains the upper end of the range.
 
 @return YES if the product price should be displayed as a price range.
 */
- (BOOL)hasPriceRange;

/** A string representation of the `currentPrice`. */
- (NSString *)currentPriceLabel;

/** The current price in the currency of the receiver. The current low price when priced in a range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the `currentMaxPrice` contains the higher end of the range.
 
 @return The salePrice if there is one, otherwise returns the regularPrice. */
- (NSNumber *)currentPrice;

/** A string representation of the `currentMaxPrice`. */
- (NSString *)currentMaxPriceLabel;

/** The current max price in the currency of the receiver when priced in a range.
 
 Some products are price as a range (e.g., sets of sheets that come in different sizes).  If the product
 is priced as a range, the `currentPrice` contains the lower end of the range.  If the product is not priced as
 a range this property is nil.
 
 @return The maxSalePrice if there is one, otherwise returns the maxRegularPrice. If the receiver does not have a price range returns nil.
 */
- (NSNumber *)currentMaxPrice;

/**---------------------------------------------------------------------------------------
 * @name Product Image Helpers
 *  ---------------------------------------------------------------------------------------
 */

/** A product image matching the size name. See `PSProductImage` for size name constants.
 
 @return A `PSProductImage` or nil if not found for the given imageSizeName. */
- (PSProductImage *)imageWithSizeName:(NSString *)imageSizeName;

@end
