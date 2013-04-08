//
//  PSProductQuery.h
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
#import "PSProductFilter.h"

typedef enum {
	PSProductQuerySortDefault = 0,
	PSProductQuerySortPriceLoHi,
	PSProductQuerySortPriceHiLo,
	PSProductQuerySortRecency,
	PSProductQuerySortPopular
} PSProductQuerySort;

/**
 The ShopSense API is made up of several methods to return product data, including an array of products 
 and a product histogram. A `PSProductFilter` can be used to further refine the results from these requests.
 */

@interface PSProductQuery : NSObject <NSCoding>

/**---------------------------------------------------------------------------------------
 * @name Creating Product Queries
 *  ---------------------------------------------------------------------------------------
 */

/** A convenience method to great a PSProductFilter initialized with a search term. */
+ (instancetype)productQueryWithSearchTerm:(NSString *)searchTearm;

/** A convenience method to great a PSProductFilter initialized with a product category identifier. */
+ (instancetype)productQueryWithCategoryId:(NSString *)productCategoryId;

/**---------------------------------------------------------------------------------------
 * @name Query Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** Text search term, as a user would enter in a "Search:" field.  
 
 This is also known as `fts` on the ShopSense API documentation. */
@property (nonatomic, copy) NSString *searchTerm;

/** A product category identifier. Only products within the category will be returned. This should be a `PSProductCategory categoryId`.  
 
  This is also known as `cat` on the ShopSense API documentation. */
@property (nonatomic, copy) NSString *productCategoryId;

/** A price drop date, if present, limits the results to products whose price has dropped since the given date.  
 
 This is also known as `pdd` on the ShopSense API documentation.  */
@property (nonatomic, copy) NSDate *priceDropDate;

/** The sort algorithm to use. 
 
 Possible values are:
 
 `PSProductQuerySortDefault`
 The most relevant products to the product query are listed first.
 
 `PSProductQuerySortPriceLoHi`
 Sort by price in ascending order.
 
 `PSProductQuerySortPriceHiLo`
 Sort by price in descending order.
 
 `PSProductQuerySortRecency`
 Sort by the recency of the products.
 
 `PSProductQuerySortPopular`
 Sort by the popularity of the products.
 
 This is also known as `sort` on the ShopSense API documentation.  */
@property (nonatomic, assign) PSProductQuerySort sort;

/**---------------------------------------------------------------------------------------
 * @name Managing Product Filters
 *  ---------------------------------------------------------------------------------------
 */

/** All filters that are part of the receiver.
 
 These are also known as `fl` parameters on the ShopSense API documentation. 
 
 @return An array of all `PSProductFilter` objects.
 */
- (NSArray *)productFilters;

/** All filters that are part of the receiver matching filterType.
 
 @param filterType The type of filters to return.
 @return An array of all `PSProductFilter` objects of a specific `PSProductFilterType` that are part of the receiver. */
- (NSArray *)productFiltersOfType:(PSProductFilterType)filterType;

/** Add a `PSProductFilter` object to the receiver. 
 
 If the filter exists it will not be added again.
 
 @param newFilter The `PSProductFilter` to add.
 */
- (void)addProductFilter:(PSProductFilter *)newFilter;

/** Add an array of `PSProductFilter` objects to the receiver. 
 
 If an individual filter exists it will not be added again.
 
 @param newFilters An array of `PSProductFilter` objects to add.
 */
- (void)addProductFilters:(NSArray *)newFilters;

/** Remove a `PSProductFilter` objects from the receiver that matches the filter parameter.
 
 @param filter A `PSProductFilter` to remove if found.
 */
- (void)removeProductFilter:(PSProductFilter *)filter;

/** Clears all `PSProductFilter` objects that are part of the receiver. */
- (void)clearProductFilters;

/** Clears all `PSProductFilter` objects of a specific `PSProductFilterType` that are part of the receiver. 
 
 @param filterType The type of filters to remove.
 */
- (void)clearProductFiltersOfType:(PSProductFilterType)filterType;

/**---------------------------------------------------------------------------------------
 * @name Converting to URL Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** A representation of the receiver used to create URL query parameters when making a product request on the ShopSense API */
- (NSDictionary *)queryParameterRepresentation;


/**---------------------------------------------------------------------------------------
 * @name Comparing Product Queries
 *  ---------------------------------------------------------------------------------------
 */

/** Returns a Boolean value that indicates whether a given `PSProductQuery` is equal to the receiver using an isEqual: test on all properties. */
- (BOOL)isEqualToProductQuery:(PSProductQuery *)productQuery;

@end
