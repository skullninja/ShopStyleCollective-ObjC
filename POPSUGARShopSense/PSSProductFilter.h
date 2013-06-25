//
//  PSSProductFilter.h
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

typedef enum {
	PSSProductFilterTypeBrand = 1,
	PSSProductFilterTypeRetailer = 2,
	PSSProductFilterTypePrice = 3,
	PSSProductFilterTypeDiscount = 4,
	PSSProductFilterTypeSize = 5,
	PSSProductFilterTypeColor = 6
} PSSProductFilterType;

extern NSString * NSStringFromPSSProductFilterType(PSSProductFilterType filterType);

/** A filter used to refine a product query or understand a product histogram.
 
 Filters are created with a filter type and identifier unique to that filter type.
 
 Filter types are defined as:
 
	 typedef enum {
		 PSSProductFilterTypeBrand = 1,
		 PSSProductFilterTypeRetailer = 2,
		 PSSProductFilterTypePrice = 3,
		 PSSProductFilterTypeDiscount = 4,
		 PSSProductFilterTypeSize = 5,
		 PSSProductFilterTypeColor = 6
	 } PSSProductFilterType;
 
 You can convert a filter type to a string with:
 
 `NSString * NSStringFromPSSProductFilterType(PSSProductFilterType filterType);`
 */

@interface PSSProductFilter : NSObject <NSCoding, NSCopying>

/**---------------------------------------------------------------------------------------
 * @name Filter Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** The identifier in the receiver's `type`. 
 
 You must combine with `type` to uniquely identify the receiver. */
@property (nonatomic, copy, readonly) NSNumber *filterID;

/** The filter type of the receiver. Combine with `filterID` to uniquely identify the receiver.
 
 The currently supported types are:
 
 `PSSProductFilterTypeBrand`
 Filter by brand.
 
 `PSSProductFilterTypeRetailer`
 Filter by retailer.
 
 `PSSProductFilterTypePrice`
 Filter by price range.
 
 `PSSProductFilterTypeDiscount`
 Filter by discount amount.
 
 `PSSProductFilterTypeSize`
 Filter by size.

 `PSSProductFilterTypeColor`
 Filter by color.
 
 A filter type can be converted to it's string representation using:
 
 `NSString * NSStringFromPSSProductFilterType(PSSProductFilterType filterType);`
 */
@property (nonatomic, assign, readonly) PSSProductFilterType type;

/** A name to display for the receiver. */
@property (nonatomic, copy) NSString *name;

/**---------------------------------------------------------------------------------------
 * @name Histogram Result Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** A shopstyle.com URL that shows more products like the receiver. */
@property (nonatomic, copy) NSString *browseURLString;

/** A count of the products that would be found if the receiver was used to further filter the result set.
 
 If the reciever was not returned by a product histogram query this value will be nil. */
@property (nonatomic, copy) NSNumber *productCount;

/**---------------------------------------------------------------------------------------
 * @name Creating Product Filters
 *  ---------------------------------------------------------------------------------------
 */

/** Creating a `PSSProductFilter` requires the type and filterID. */
- (id)initWithType:(PSSProductFilterType)type filterID:(NSNumber *)filterID;

/** A convenience method as an alternative to alloc and `initWithType:filterID:`
 
 @see initWithType:filterID:
 */
+ (instancetype)filterWithType:(PSSProductFilterType)type filterID:(NSNumber *)filterID;

/**---------------------------------------------------------------------------------------
 * @name Converting to URL Parameters
 *  ---------------------------------------------------------------------------------------
 */

/** A representation of the receiver used to create an URL query parameter when making a product request on the ShopSense API */
- (NSString *)queryParameterRepresentation;

@end
