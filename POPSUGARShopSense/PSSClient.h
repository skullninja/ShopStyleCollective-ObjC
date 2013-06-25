//
//  PSSClient.h
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

#import "AFHTTPClient.h"
#import "PSSProductFilter.h"

@class PSSProduct;
@class PSSProductQuery;
@class PSSCategoryTree;

extern NSString * const PSSInvalidPartnerException;
extern NSString * const PSSInvalidLocaleException;
extern NSString * const PSSMalformedResponseErrorDomain;
extern NSString * const PSSInvalidRepresentationErrorDomain;
extern NSString * const PSSServerResponseErrorDomain;

typedef enum {
    PSSHistogramFilterNone		= 0,
    PSSHistogramFilterBrand		= 1 << 0,
    PSSHistogramFilterRetailer	= 1 << 1,
    PSSHistogramFilterPrice		= 1 << 2,
    PSSHistogramFilterDiscount	= 1 << 3,
    PSSHistogramFilterSize		= 1 << 4,
    PSSHistogramFilterColor		= 1 << 5
} PSSHistogramFilterOptions;

/** A singleton subclass of AFHTTPClient that wraps the ShopSense API web services and converts the response into native Objective-C objects.  
 
 ## Usage:
 1. Get the client by calling the sharedClient class method.
 2. Set the partnerID parameter with your API_KEY you were assigned when signing up for ShopSense
 3. Call any of the methods to get data.
 
 @warning before calling any methods don't forget to set partnerID!
 */

@interface PSSClient : AFHTTPClient <NSCopying, NSCoding>

/**---------------------------------------------------------------------------------------
 * @name Setting up the Client
 *  ---------------------------------------------------------------------------------------
 */

/** The ShopSense API Base URL */
+ (NSURL *)defaultBaseURL;

/** Returns the shared client object. */
+ (instancetype)sharedClient;

/** Unique API_KEY string that is assigned to the caller. This parameter must be present before making any requests.  
 Your Partner ID can be found on the https://shopsense.shopstyle.com/ API page. */
@property (nonatomic, copy) NSString *partnerID;

/**---------------------------------------------------------------------------------------
 * @name International Support
 *  ---------------------------------------------------------------------------------------
 */

/** The ShopSense Default Locale */
+ (NSLocale *)defaultLocale;

/** The locales supported by ShopSense */
+ (NSArray *)supportedLocales;

/** Test if a particular locale is supported by ShopSense */
+ (BOOL)isSupportedLocale:(NSLocale *)locale;

/** Returns a suggestion for a supported locale given any valid local */
+ (NSLocale *)supportedLocaleForLocale:(NSLocale *)locale;

/** Change the locale of all future requests made by the receiver and optionally cancel any pending operations */
- (void)setLocale:(NSLocale *)newLocale cancelAllOperations:(BOOL)cancelAllOperations;

/** The current locale in use by the receiver */
@property (nonatomic, copy, readonly) NSLocale *currentLocale;

/**---------------------------------------------------------------------------------------
 * @name Finding Products
 *  ---------------------------------------------------------------------------------------
 */

/** Returns a single product object matching a supplied product identifier.
 
 @param productID The product identifier.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: a `PSSProduct` object matching the productID or nil.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)getProductByID:(NSNumber *)productID success:(void (^)(PSSProduct *product))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** Returns an array of products that match a query specified by the parameters below.
 
 @param searchTerm Text search term, as a user would enter in a "Search:" field.
 @param offset The index of the first product to return, or 0 (zero) if not specified. A client can use this to implement paging through large result sets.
 @param limit The maximum number of results to return, or 100 if not specified. The maximum value is 100. Combine with the offset parameter to implement paging.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes three arguments: the total count of products that match the provided criteria, available histogram filter options for products that match the provided criteria and an array of `PSSProduct` objects within the offset and limit parameters.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)searchProductsWithTerm:(NSString *)searchTerm offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, PSSHistogramFilterOptions availableFilterOptions, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** Returns an array of products that match a query specified by the parameters below.
 
 @param queryOrNil A `PSSProductQuery` to define which products to return.
 @param offset The index of the first product to return, or 0 (zero) if not specified. A client can use this to implement paging through large result sets.
 @param limit The maximum number of results to return, or 100 if not specified. The maximum value is 100. Combine with the offset parameter to implement paging.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes three arguments: the total count of products that match the provided criteria , available histogram filter options for products that match the provided criteria and an array of `PSSProduct` objects within the offset and limit parameters.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)searchProductsWithQuery:(PSSProductQuery *)queryOrNil offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, PSSHistogramFilterOptions availableFilterOptions, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** This method returns a list of filters and product counts that describe the results of a given product query. The query is specified using the parameters below.
 
 Possible values for filter options are:  
 PSSHistogramFilterBrand  
 PSSHistogramFilterRetailer  
 PSSHistogramFilterPrice  
 PSSHistogramFilterDiscount  
 PSSHistogramFilterSize  
 PSSHistogramFilterColor  
 
 @param queryOrNil A `PSSProductQuery` to define which products are used in the calculation.
 @param filterType The type of filter to return on success. 
 @param floorOrNil The minimum count of products required for an entry to be included in the histogram.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `PSSProductFilter` objects.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)productHistogramWithQuery:(PSSProductQuery *)queryOrNil filterOptions:(PSSHistogramFilterOptions)filterOptions floor:(NSNumber *)floorOrNil success:(void (^)(NSDictionary *filters))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**---------------------------------------------------------------------------------------
 * @name Getting Lookup Values
 *  ---------------------------------------------------------------------------------------
 */

/** Returns a list of brands that have live products. Brands that have very few products will be omitted.
 
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `PSSBrand` objects.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)getBrandsSuccess:(void (^)(NSArray *brands))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** Returns an array of retailers that have live products.
 
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `PSSRetailer` objects.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)getRetailersSuccess:(void (^)(NSArray *retailers))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** Returns the list of canonical colors available.
 
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: an array of `PSSColor` objects.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)getColorsSuccess:(void (^)(NSArray *colors))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** Returns a tree of the categories available. 
 
 @param categoryIDOrNil The identifier of the category to use as the starting point. By default, the global root of the category tree is used.
 @param depthOrNil The number of levels from the root to include in the response. By default all the levels are included.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes one argument: a `PSSCategoryTree` object.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes two arguments:, the created request operation and the `NSError` object describing the network or parsing error that occurred.
 */
- (void)categoryTreeFromCategoryID:(NSString *)categoryIDOrNil depth:(NSNumber *)depthOrNil success:(void (^)(PSSCategoryTree *categoryTree))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

/** Objects that provide a local representation of a remote object. */

@protocol PSSRemoteObject <NSObject>

/** Creates an instance of the receiver from a remote representation of the object. 
 
 @param representation A dictionary representation of an object from a ShopSense API.
 */
+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation;

@end
