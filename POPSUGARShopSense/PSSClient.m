//
//  PSSClient.m
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

#import "PSSClient.h"
#import "AFJSONRequestOperation.h"
#import "PSSProduct.h"
#import "PSSProductQuery.h"
#import "PSSBrand.h"
#import "PSSRetailer.h"
#import "PSSColor.h"
#import "PSSCategory.h"
#import "PSSCategoryTree.h"

static NSString * const kPSSBaseURLString = @"http://api.shopstyle.com/api/v2/";

@interface PSSClient ()

- (void)makeRequestForEntity:(NSString *)entity parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation PSSClient

@synthesize partnerId = _partnerId;

#pragma mark - Shared Client

+ (instancetype)sharedClient
{
	static PSSClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[PSSClient alloc] initWithBaseURL:[NSURL URLWithString:kPSSBaseURLString]];
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
				failure(operation, [self errorForBadResponse]);
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

- (void)getProductByID:(NSNumber *)productId success:(void (^)(PSSProduct *product))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSParameterAssert(productId != nil);
	NSString *entity = [NSString stringWithFormat:@"products/%d",productId.integerValue];
	[self makeRequestForEntity:entity parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if (success) {
			PSSProduct *product = (PSSProduct *)[self remoteObjectForEntityNamed:@"product" fromRepresentation:responseObject];
			success(product);
		}
	} failure:failure];
}

- (void)searchProductsWithTerm:(NSString *)searchTerm offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSParameterAssert(searchTerm != nil && searchTerm.length > 0);
	[self searchProductsWithQuery:[PSSProductQuery productQueryWithSearchTerm:searchTerm] offset:offset limit:limit success:success failure:failure];
}

- (void)searchProductsWithQuery:(PSSProductQuery *)queryOrNil offset:(NSNumber *)offset limit:(NSNumber *)limit success:(void (^)(NSUInteger totalCount, NSArray *products))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
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
				NSArray *products = [self remoteObjectsForEntityNamed:@"product" fromRepresentations:productsRepresentation];
				NSUInteger totalCount = products.count;
				NSDictionary *metadata = [responseObject objectForKey:@"metadata"];
				if ([[metadata objectForKey:@"total"] isKindOfClass:[NSNumber class]]) {
					totalCount = [[metadata objectForKey:@"total"] integerValue];
				}
				success(totalCount,products);
			}
			
		} else {
			if (failure) {
				failure(operation, [self errorForBadResponse]);
			}
		}
	} failure:failure];
}

- (void)productHistogramWithQuery:(PSSProductQuery *)queryOrNil filterType:(PSSProductFilterType)filterType floor:(NSNumber *)floorOrNil success:(void (^)(NSArray *filters))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	NSString *filterResponseKey = nil;
	switch (filterType) {
		case PSSProductFilterTypeBrand:
			[params setValue:@"Brand" forKey:@"filters"];
			filterResponseKey = @"brandHistogram";
			break;
		case PSSProductFilterTypeRetailer:
			[params setValue:@"Retailer" forKey:@"filters"];
			filterResponseKey = @"retailerHistogram";
			break;
		case PSSProductFilterTypeColor:
			[params setValue:@"Color" forKey:@"filters"];
			filterResponseKey = @"colorHistogram";
			break;
		case PSSProductFilterTypePrice:
			[params setValue:@"Price" forKey:@"filters"];
			filterResponseKey = @"priceHistogram";
			break;
		case PSSProductFilterTypeSale:
			[params setValue:@"Discount" forKey:@"filters"];
			filterResponseKey = @"discountHistogram";
			break;
		case PSSProductFilterTypeSize:
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
					if ([filterRep isKindOfClass:[NSDictionary class]] && [filterRep objectForKey:@"id"] != nil) {
						PSSProductFilter *filter = [PSSProductFilter filterWithType:filterType filterId:[filterRep objectForKey:@"id"]];
						filter.browseURLString = [filterRep objectForKey:@"url"];
						filter.name = [filterRep objectForKey:@"name"];
						filter.productCount = [filterRep objectForKey:@"count"];
						[filters addObject:filter];
					}
				}
				if (filters.count > 0) {
					success(filters);
					return;
				}
				success(nil);
			}
		} else {
			if (failure) {
				failure(operation, [self errorForBadResponse]);
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
				NSArray *brands = [self remoteObjectsForEntityNamed:@"brand" fromRepresentations:brandsRepresentation];
				success(brands);
			}
		} else {
			if (failure) {
				failure(operation, [self errorForBadResponse]);
			}
		}
	} failure:failure];
}

#pragma mark - Retailers

- (void)getRetailersSuccess:(void (^)(NSArray *retailers))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSString *entity = @"retailers";
	[self makeRequestForEntity:entity parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:@"retailers"] isKindOfClass:[NSArray class]]) {
			if (success) {
				NSArray *retailersRepresentation = [responseObject objectForKey:@"retailers"];
				NSArray *retailers = [self remoteObjectsForEntityNamed:@"retailer" fromRepresentations:retailersRepresentation];
				success(retailers);
			}
		} else {
			if (failure) {
				failure(operation, [self errorForBadResponse]);
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
				NSArray *colors = [self remoteObjectsForEntityNamed:@"color" fromRepresentations:colorsRepresentation];
				success(colors);
			}
		} else {
			if (failure) {
				failure(operation, [self errorForBadResponse]);
			}
		}
	} failure:failure];
}

#pragma mark - Categories

- (void)categoryTreeFromCategoryId:(NSString *)categoryIdOrNil depth:(NSNumber *)depthOrNil success:(void (^)(PSSCategoryTree *categoryTree))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	if (depthOrNil != nil && depthOrNil.integerValue <= 0) {
		if (success) {
			success(nil);
		}
		return;
	}
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	if (categoryIdOrNil != nil && categoryIdOrNil.length > 0) {
		[params setValue:categoryIdOrNil forKey:@"cat"];
	}
	if (depthOrNil != nil) {
		[params setValue:depthOrNil forKey:@"depth"];
	}
	if (params.count == 0) {
		params = nil;
	}
	NSString *entity = @"categories";
	[self makeRequestForEntity:entity parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		if ([[responseObject objectForKey:@"categories"] isKindOfClass:[NSArray class]] && [[responseObject objectForKey:@"metadata"] isKindOfClass:[NSDictionary class]]) {
			NSArray *categoriesRepresentation = [responseObject objectForKey:@"categories"];
			NSArray *categories = [self remoteObjectsForEntityNamed:@"category" fromRepresentations:categoriesRepresentation];
			NSString *rootId = nil;
			NSDictionary *metadata = [responseObject objectForKey:@"metadata"];
			if ([[metadata objectForKey:@"root"] isKindOfClass:[NSDictionary class]]) {
				NSDictionary *rootCat = [metadata objectForKey:@"root"];
				if ([rootCat objectForKey:@"id"]) {
					rootId = [rootCat objectForKey:@"id"];
				}
			}
			if (categories.count > 0 && rootId.length > 0) {
				if (success) {
					PSSCategoryTree *categoryTree = [[PSSCategoryTree alloc] initWithRootId:rootId categories:categories];
					success(categoryTree);
				}
			} else {
				if (failure) {
					failure(operation, [self errorForBadResponse]);
				}
			}
		} else {
			if (failure) {
				failure(operation, [self errorForBadResponse]);
			}
		}
	} failure:failure];
}

#pragma mark - Standard Errors

- (NSError *)errorForBadResponse
{
	return [NSError errorWithDomain:NSStringFromClass([self class]) code:500 userInfo:@{NSLocalizedDescriptionKey : @"Malformed Response From Server"}];
}

#pragma mark - PSSRemoteObject Conversion

- (NSArray *)remoteObjectsForEntityNamed:(NSString *)entityName fromRepresentations:(NSArray *)representations
{
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[representations count]];
	for (id valueMember in representations) {
		if ([valueMember isKindOfClass:[NSDictionary class]] && [(NSDictionary *)valueMember count] > 0) {
			id remoteObject = [self remoteObjectForEntityNamed:entityName fromRepresentation:valueMember];
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

- (id<PSSRemoteObject>)remoteObjectForEntityNamed:(NSString *)entityName fromRepresentation:(NSDictionary *)representation
{
	if ([entityName isEqualToString:@"brand"]) {
		return [PSSBrand instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"category"]) {
		return [PSSCategory instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"color"]) {
		return [PSSColor instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"product"]) {
		return [PSSProduct instanceFromRemoteRepresentation:representation];
	} else if ([entityName isEqualToString:@"retailer"]) {
		return [PSSRetailer instanceFromRemoteRepresentation:representation];
	}
	return nil;
}

@end
