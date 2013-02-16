//
//  PSShopSenseAPIClient.h
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
#import "PSProductFilter.h"
@class PSProduct;
@class PSProductQuery;
@class PSCategory;

@interface PSShoppingAPIClient : AFHTTPClient

+ (PSShoppingAPIClient *)sharedClient;

@property (nonatomic, copy) NSString *partnerId;

#pragma mark - Products

- (void)getProductByID:(NSNumber *)productId success:(void (^)(PSProduct *product))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)searchProductsWithTerm:(NSString *)searchTerm offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)getProductsWithQuery:(PSProductQuery *)queryOrNil offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getProductHistogramWithQuery:(PSProductQuery *)queryOrNil filterType:(PSProductFilterType)filterType floor:(NSNumber *)floorOrNil success:(void (^)(NSArray *filters))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Brands

- (void)getBrandsSuccess:(void (^)(NSArray *brands))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Retailers

- (void)getRetailersSuccess:(void (^)(NSArray *retailers))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Colors

- (void)getColorsSuccess:(void (^)(NSArray *colors))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Categories

- (void)getCategoriesFromCategory:(PSCategory *)categoryOrNil depth:(NSNumber *)depthOrNil success:(void (^)(NSArray *categories))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
