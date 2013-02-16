//
//  PSShoppingAPIClient.m
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

#import "PSShoppingAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "PSProduct.h"
#import "PSProductQuery.h"
#import "PSBrand.h"
#import "PSRetailer.h"
#import "PSColor.h"
#import "PSCategory.h"

static NSString * const kPSShoppingBaseURLString = @"http://api.shopstyle.com/api/v2/";
// http://api.shopstyle.com/api/v2/products?pid=uid2436-7580206-43&fts=red+dress&offset=0&limit=10

@interface PSShoppingAPIClient ()

- (void)makeRequestForEntity:(NSString *)entity parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation PSShoppingAPIClient

@synthesize partnerId = _partnerId;

#pragma mark - Shared Client

+ (PSShoppingAPIClient *)sharedClient
{
    static PSShoppingAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PSShoppingAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kPSShoppingBaseURLString]];
    });
    
    return _sharedClient;
}

#pragma mark - AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - Base API Request

- (void)makeRequestForEntity:(NSString *)entity parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSAssert(self.partnerId != nil, @"You must provide your Partner ID before making API requests.");
	
	NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
	[mutableParameters addEntriesFromDictionary:parameters];
	[mutableParameters setValue:self.partnerId forKey:@"pid"];
	[mutableParameters setValue:@"true" forKey:@"suppressResponseCode"];
	
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:entity parameters:mutableParameters];
    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
			if ([responseObject objectForKey:@"errorCode"] != nil || [responseObject objectForKey:@"errorName"] != nil || [responseObject objectForKey:@"errorMessage"] != nil) {
				if (failure) {
					NSNumber *errorCode = [responseObject objectForKey:@"errorCode"] ?: [NSNumber numberWithInt:500];
					NSString *errorName = [responseObject objectForKey:@"errorName"] ?: @"";
					NSString *errorMessage = [responseObject objectForKey:@"errorMessage"] ?: @"";
					NSString *errorDesc = [NSString stringWithFormat:@"%@ %@", errorName, errorMessage];
					NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:[errorCode integerValue] userInfo:@{NSLocalizedDescriptionKey : errorDesc}];
					failure(operation, badResponse);
				}
			} else if (success) {
                success(operation, responseObject);
            }
        } else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
        }
        
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (failure) {
			failure(operation, error);
		}
	}];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Getting Products

- (void)getProductByID:(NSNumber *)productId success:(void (^)(PSProduct *product))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSParameterAssert(productId != nil);
	NSString *entity = [NSString stringWithFormat:@"products/%d",productId.integerValue];
	[self makeRequestForEntity:entity parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if (success) {
			PSProduct *product = [PSProduct instanceFromDictionary:responseObject];
			success(product);
		}
	} failure:failure];
}

- (void)searchProductsWithTerm:(NSString *)searchTerm offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSParameterAssert(searchTerm != nil && searchTerm.length > 0);
	[self getProductsWithQuery:[PSProductQuery productQueryWithSearchTerm:searchTerm] offset:offset limit:limit success:success failure:failure];
}

- (void)getProductsWithQuery:(PSProductQuery *)queryOrNil offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSString *entity = @"products";
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if (offset != nil) {
		[params setValue:offset forKey:@"offset"];
	}
	if (limit != nil) {
		[params setValue:limit forKey:@"limit"];
	}
	if (queryOrNil != nil) {
		NSDictionary *queryParams = [queryOrNil queryParameterRepresentation];
		[params addEntriesFromDictionary:queryParams];
	}
	if (params.count == 0) {
		params = nil;
	}
	[self makeRequestForEntity:entity parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		
		if ([[responseObject objectForKey:@"metadata"] isKindOfClass:[NSDictionary class]] && [[responseObject objectForKey:@"products"] isKindOfClass:[NSArray class]]) {
			
			if (success) {
				NSArray *productsRepresentation = [responseObject objectForKey:@"products"];
				NSMutableArray *products = [NSMutableArray arrayWithCapacity:[productsRepresentation count]];
				for (id productRepresentation in productsRepresentation) {
					PSProduct *product = [PSProduct instanceFromDictionary:productRepresentation];
					[products addObject:product];
				}
				NSUInteger totalCount = products.count;
				NSDictionary *metadata = [responseObject objectForKey:@"metadata"];
				if ([[metadata objectForKey:@"total"] isKindOfClass:[NSNumber class]]) {
					totalCount = [[metadata objectForKey:@"total"] integerValue];
				}
				success(totalCount,products);
			}
			
		} else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
		}
	} failure:failure];
}

- (void)getProductHistogramWithQuery:(PSProductQuery *)queryOrNil filterType:(PSProductFilterType)filterType floor:(NSNumber *)floorOrNil success:(void (^)(NSArray *filters))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	NSString *filterResponseKey = nil;
	switch (filterType) {
		case PSProductFilterTypeBrand:
			[params setValue:@"Brand" forKey:@"filters"];
			filterResponseKey = @"brandHistogram";
			break;
		case PSProductFilterTypeRetailer:
			[params setValue:@"Retailer" forKey:@"filters"];
			filterResponseKey = @"retailerHistogram";
			break;
		case PSProductFilterTypeColor:
			[params setValue:@"Color" forKey:@"filters"];
			filterResponseKey = @"colorHistogram";
			break;
		case PSProductFilterTypePrice:
			[params setValue:@"Price" forKey:@"filters"];
			filterResponseKey = @"priceHistogram";
			break;
		case PSProductFilterTypeSale:
			[params setValue:@"Discount" forKey:@"filters"];
			filterResponseKey = @"discountHistogram";
			break;
		case PSProductFilterTypeSize:
			[params setValue:@"Size" forKey:@"filters"];
			filterResponseKey = @"sizeHistogram";
			break;
			
		default:
			break;
	}
	NSAssert(params.count > 0, @"You must provide a filter type to get a histogram");
	if (floorOrNil != nil) {
		[params setValue:floorOrNil forKey:@"floor"];
	}
	if (queryOrNil != nil) {
		NSDictionary *queryParams = [queryOrNil queryParameterRepresentation];
		[params addEntriesFromDictionary:queryParams];
	}
	NSString *entity = @"products/histogram";
	[self makeRequestForEntity:entity parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:filterResponseKey] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *filtersRepresentation = [responseObject objectForKey:filterResponseKey];
				NSMutableArray *filters = [NSMutableArray arrayWithCapacity:[filtersRepresentation count]];
				for (id filterRep in filtersRepresentation) {
					PSProductFilter *filter = [PSProductFilter filterWithType:filterType filterId:[filterRep objectForKey:@"id"]];
					filter.urlString = [filterRep objectForKey:@"url"];
					filter.name = [filterRep objectForKey:@"name"];
					filter.productCount = [filterRep objectForKey:@"count"];
					[filters addObject:filter];
				}
				success(filters);
			}
		} else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
		}
	} failure:failure];
}

#pragma mark - Brands

- (void)getBrandsSuccess:(void (^)(NSArray *brands))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSString *entity = @"brands";
	[self makeRequestForEntity:entity parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:@"brands"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *brandsRepresentation = [responseObject objectForKey:@"brands"];
				NSMutableArray *brands = [NSMutableArray arrayWithCapacity:[brandsRepresentation count]];
				for (id brandRepresentation in brandsRepresentation) {
					PSBrand *brand = [PSBrand instanceFromDictionary:brandRepresentation];
					[brands addObject:brand];
				}
				success(brands);
			}
		} else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
		}
	} failure:failure];
}

#pragma mark - Brands

- (void)getRetailersSuccess:(void (^)(NSArray *retailers))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSString *entity = @"retailers";
	[self makeRequestForEntity:entity parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:@"retailers"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *retailersRepresentation = [responseObject objectForKey:@"retailers"];
				NSMutableArray *retailers = [NSMutableArray arrayWithCapacity:[retailersRepresentation count]];
				for (id retailerRepresentation in retailersRepresentation) {
					PSRetailer *retailer = [PSRetailer instanceFromDictionary:retailerRepresentation];
					[retailers addObject:retailer];
				}
				success(retailers);
			}
		} else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
		}
	} failure:failure];
}

#pragma mark - Colors

- (void)getColorsSuccess:(void (^)(NSArray *colors))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSString *entity = @"colors";
	[self makeRequestForEntity:entity parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:@"colors"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *colorsRepresentation = [responseObject objectForKey:@"colors"];
				NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[colorsRepresentation count]];
				for (id colorRepresentation in colorsRepresentation) {
					PSColor *color = [PSColor instanceFromDictionary:colorRepresentation];
					[colors addObject:color];
				}
				success(colors);
			}
		} else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
		}
	} failure:failure];
}

#pragma mark - Categories

- (void)getCategoriesFromCategory:(PSCategory *)categoryOrNil depth:(NSNumber *)depthOrNil success:(void (^)(NSArray *categories))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if (categoryOrNil != nil) {
		[params setValue:categoryOrNil.categoryId forKey:@"depth"];
	}
	if (depthOrNil != nil) {
		[params setValue:depthOrNil forKey:@"depth"];
	}
	if (params.count == 0) {
		params = nil;
	}
	NSString *entity = @"categories";
	[self makeRequestForEntity:entity parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:@"categories"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *categoriesRepresentation = [responseObject objectForKey:@"categories"];
				NSMutableArray *categories = [NSMutableArray arrayWithCapacity:[categoriesRepresentation count]];
				for (id categoryRepresentation in categoriesRepresentation) {
					PSCategory *color = [PSCategory instanceFromDictionary:categoryRepresentation];
					[categories addObject:color];
				}
				success(categories);
			}
		} else {
            if (failure) {
                NSError *badResponse = [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
                failure(operation, badResponse);
            }
		}
	} failure:failure];
}

@end
