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
#import "POPSUGARShopSense.h"

NSString * const PSSInvalidPartnerException = @"com.shopstyle.shopsense:InvalidPartnerException";
NSString * const PSSInvalidLocaleException = @"com.shopstyle.shopsense:InvalidLocaleException";

static NSString * const kShopSenseBaseURLString = @"http://api.shopstyle.com/api/v2/";
static NSString * const kPListPartnerIDKey = @"ShopSensePartnerID";
static NSString * const kDefaultLocaleIdentifier = @"en_US";
static NSString * const kUSLocaleIdentifier = @"en_US";
static NSString * const kUSSiteIdentifier = @"www.shopstyle.com";
static NSString * const kUKLocaleIdentifier = @"en_GB";
static NSString * const kUKSiteIdentifier = @"www.shopstyle.co.uk";
static NSString * const kFRLocaleIdentifier = @"fr_FR";
static NSString * const kFRSiteIdentifier = @"www.shopstyle.fr";
static NSString * const kDELocaleIdentifier = @"de_DE";
static NSString * const kDESiteIdentifier = @"www.shopstyle.de";
static NSString * const kJPLocaleIdentifier = @"ja_JP";
static NSString * const kJPSiteIdentifier = @"www.shopstyle.co.jp";
static NSString * const kAULocaleIdentifier = @"en_AU";
static NSString * const kAUSiteIdentifier = @"www.shopstyle.com.au";
static NSString * const kCALocaleIdentifier = @"en_CA";
static NSString * const kCASiteIdentifier = @"www.shopstyle.ca";

@interface PSSClient ()

@property (nonatomic, copy, readwrite) NSLocale *currentLocale;

- (void)makeRequestForEntityAtPath:(NSString *)entityPath parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation PSSClient

#pragma mark - Default Base URL

+ (NSURL *)defaultBaseURL
{
	return [NSURL URLWithString:kShopSenseBaseURLString];
}

#pragma mark - Shared Client

+ (instancetype)sharedClient
{
	static PSSClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSURL *baseURL = [self defaultBaseURL];
#ifdef _POPSUGARShopSense_BASE_URL_
		NSURL *definedBaseURL = [NSURL URLWithString:_POPSUGARShopSense_BASE_URL_];
		if (definedBaseURL != nil) {
			baseURL = definedBaseURL;
		}
#endif
		_sharedClient = [[PSSClient alloc] initWithBaseURL:baseURL];
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
	
	[self sharedInit];
	
	return self;
}

- (void)sharedInit
{
	[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	
	// Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	
	_currentLocale = [[self class] defaultLocale];
}

- (NSString *)description
{
	NSString *superString = [super description];
	return [superString stringByReplacingCharactersInRange:NSMakeRange(superString.length - 1, 1) withString:[NSString stringWithFormat:@", partnerId: %@, currentLocal: %@>", self.partnerId, self.currentLocale.localeIdentifier]];
}

#pragma mark - Locales

+ (NSLocale *)defaultLocale
{
	return [[NSLocale alloc] initWithLocaleIdentifier:kDefaultLocaleIdentifier];
}

+ (NSArray *)supportedLocales
{
	return [NSArray arrayWithObjects:[[NSLocale alloc] initWithLocaleIdentifier:kUSLocaleIdentifier], [[NSLocale alloc] initWithLocaleIdentifier:kUKLocaleIdentifier], [[NSLocale alloc] initWithLocaleIdentifier:kFRLocaleIdentifier], [[NSLocale alloc] initWithLocaleIdentifier:kDELocaleIdentifier], [[NSLocale alloc] initWithLocaleIdentifier:kJPLocaleIdentifier], [[NSLocale alloc] initWithLocaleIdentifier:kAULocaleIdentifier], [[NSLocale alloc] initWithLocaleIdentifier:kCALocaleIdentifier], nil];
}

+ (BOOL)isSupportedLocale:(NSLocale *)locale
{
	if (locale == nil) {
		return NO;
	}
	if ([[self supportedLocales] indexOfObject:locale] != NSNotFound) {
		return YES;
	}
	return NO;
}

+ (NSLocale *)supportedLocaleForLocale:(NSLocale *)locale
{
	if (locale == nil) {
		return [self defaultLocale];
	}
	
	if ([self isSupportedLocale:locale]) {
		return locale;
	}
	
	// we prefer the default locale if the language matches
	NSString *language = [locale objectForKey:NSLocaleLanguageCode];
	if ([[[self defaultLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:language]) {
		return [self defaultLocale];
	}
	for (NSLocale *supportedLocale in [self supportedLocales]) {
		if ([[supportedLocale objectForKey:NSLocaleLanguageCode] isEqualToString:language]) {
			return supportedLocale;
		}
	}
	return [self defaultLocale];
}

+ (NSString *)siteIdentifierForLocale:(NSLocale *)locale
{
	if (locale == nil) {
		return nil;
	}
	if ([locale.localeIdentifier isEqualToString:kUSLocaleIdentifier]) {
		return kUSSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kUKLocaleIdentifier]) {
		return kUKSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kFRLocaleIdentifier]) {
		return kFRSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kDELocaleIdentifier]) {
		return kDESiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kJPLocaleIdentifier]) {
		return kJPSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kAULocaleIdentifier]) {
		return kAUSiteIdentifier;
	} else if ([locale.localeIdentifier isEqualToString:kCALocaleIdentifier]) {
		return kCASiteIdentifier;
	}
	return nil;
}

- (void)setLocale:(NSLocale *)newLocale cancelAllOperations:(BOOL)cancelAllOperations
{
	if ([[self class] isSupportedLocale:newLocale] == NO) {
		[[NSException exceptionWithName:PSSInvalidLocaleException
								 reason:@"Locale must be one of supportedLocales."
							   userInfo:nil]
		 raise];
	}
	self.currentLocale = newLocale;
	if (cancelAllOperations) {
		[self.operationQueue cancelAllOperations];
	}
}

#pragma mark - partnerId

- (NSString *)partnerId
{
	if (_partnerId == nil) {
		NSBundle* bundle = [NSBundle mainBundle];
        _partnerId = [bundle objectForInfoDictionaryKey:kPListPartnerIDKey];
	}
	return _partnerId;
}

#pragma mark - Base API Request

- (void)makeRequestForEntityAtPath:(NSString *)entityPath parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	if (self.partnerId == nil) {
		[[NSException exceptionWithName:PSSInvalidPartnerException
								 reason:[NSString stringWithFormat:@"%@: No Partner ID provided; either set partnerID or add a string valued key with the appropriate id named %@ to the bundle *.plist", NSStringFromClass([self class]), kPListPartnerIDKey]
							   userInfo:nil]
		 raise];
	}
	
	NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] init];
	[mutableParameters addEntriesFromDictionary:parameters];
	[mutableParameters setValue:self.partnerId forKey:@"pid"];
	[mutableParameters setValue:@"true" forKey:@"suppressResponseCode"];
	if ([self.currentLocale isEqual:[[self class] defaultLocale]] == NO && [[self class] siteIdentifierForLocale:self.currentLocale] != nil) {
		[mutableParameters setValue:[[self class] siteIdentifierForLocale:self.currentLocale] forKey:@"site"];
	}
	
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:entityPath parameters:mutableParameters];
	// ShopSense does not support the [] notation when using multiple parameters
	NSString *urlString = request.URL.absoluteString;
	for (NSString *key in mutableParameters.allKeys) {
		urlString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@[]=", key] withString:[key stringByAppendingString:@"="]];
		urlString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@%%5B%%5D=", key] withString:[key stringByAppendingString:@"="]];
	}
	NSURL *newURL = [NSURL URLWithString:urlString];
	if (newURL != nil) {
		request.URL = newURL;
	}
	
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
	NSString *entityPath = [NSString stringWithFormat:@"products/%d",productId.integerValue];
	[self makeRequestForEntityAtPath:entityPath parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
	NSString *entityPath = @"products";
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
	[self makeRequestForEntityAtPath:entityPath parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		
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

- (PSSProductFilter *)productFilterForHistogramResponseKey:(NSString *)key represention:(NSDictionary *)representation
{
	if ([representation objectForKey:@"id"] == nil) {
		return nil;
	}
	
	PSSProductFilterType filterType;
	if ([key isEqualToString:@"brandHistogram"]) {
		filterType = PSSProductFilterTypeBrand;
	} else if ([key isEqualToString:@"retailerHistogram"]) {
		filterType = PSSProductFilterTypeRetailer;
	} else if ([key isEqualToString:@"colorHistogram"]) {
		filterType = PSSProductFilterTypeColor;
	} else if ([key isEqualToString:@"priceHistogram"]) {
		filterType = PSSProductFilterTypePrice;
	} else if ([key isEqualToString:@"discountHistogram"]) {
		filterType = PSSProductFilterTypeDiscount;
	} else if ([key isEqualToString:@"sizeHistogram"]) {
		filterType = PSSProductFilterTypeSize;
	} else {
		PSSDLog(@"Unknown Histogram Response Key: %@", key);
		return nil;
	}
	PSSProductFilter *filter = [PSSProductFilter filterWithType:filterType filterId:[representation objectForKey:@"id"]];
	filter.browseURLString = [representation objectForKey:@"url"];
	filter.name = [representation objectForKey:@"name"];
	filter.productCount = [representation objectForKey:@"count"];
	return filter;
}

- (void)productHistogramWithQuery:(PSSProductQuery *)queryOrNil filterOptions:(PSSHistogramFilterOptions)filterOptions floor:(NSNumber *)floorOrNil success:(void (^)(NSDictionary *filters))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	NSMutableArray *filterResponseKeys = [NSMutableArray array];
	NSMutableArray *filterParameters = [NSMutableArray array];
	if ((filterOptions & PSSHistogramFilterBrand) == PSSHistogramFilterBrand) {
		[filterResponseKeys addObject:@"brandHistogram"];
		[filterParameters addObject:@"Brand"];
	}
	if ((filterOptions & PSSHistogramFilterRetailer) == PSSHistogramFilterRetailer) {
		[filterResponseKeys addObject:@"retailerHistogram"];
		[filterParameters addObject:@"Retailer"];
	}
	if ((filterOptions & PSSHistogramFilterPrice) == PSSHistogramFilterPrice) {
		[filterResponseKeys addObject:@"priceHistogram"];
		[filterParameters addObject:@"Price"];
	}
	if ((filterOptions & PSSHistogramFilterDiscount) == PSSHistogramFilterDiscount) {
		[filterResponseKeys addObject:@"discountHistogram"];
		[filterParameters addObject:@"Discount"];
	}
	if ((filterOptions & PSSHistogramFilterSize) == PSSHistogramFilterSize) {
		[filterResponseKeys addObject:@"sizeHistogram"];
		[filterParameters addObject:@"Size"];
	}
	if ((filterOptions & PSSHistogramFilterColor) == PSSHistogramFilterColor) {
		[filterResponseKeys addObject:@"colorHistogram"];
		[filterParameters addObject:@"Color"];
	}
	NSAssert(filterParameters.count > 0, @"You must provide at least on filter option to get a histogram");
	[params setValue:[filterParameters componentsJoinedByString:@","] forKey:@"filters"];

	if (floorOrNil != nil) {
		[params setValue:floorOrNil forKey:@"floor"];
	}
	if (queryOrNil != nil) {
		NSDictionary *queryParams = [queryOrNil queryParameterRepresentation];
		[params addEntriesFromDictionary:queryParams];
	}
	NSString *entityPath = @"products/histogram";
	[self makeRequestForEntityAtPath:entityPath parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		NSMutableDictionary *histograms = [NSMutableDictionary dictionary];
		for (NSString *filterResponseKey in filterResponseKeys) {
			if ([[responseObject objectForKey:filterResponseKey] isKindOfClass:[NSArray class]]) {
				NSArray *filtersRepresentation = [responseObject objectForKey:filterResponseKey];
				NSMutableArray *filters = [NSMutableArray arrayWithCapacity:[filtersRepresentation count]];
				for (id filterRep in filtersRepresentation) {
					if ([filterRep isKindOfClass:[NSDictionary class]]) {
						PSSProductFilter *filter = [self productFilterForHistogramResponseKey:filterResponseKey represention:filterRep];
						if (filter != nil) {
							[filters addObject:filter];
						}
					}
				}
				if (filters.count > 0) {
					NSString *key = NSStringFromPSSProductFilterType([(PSSProductFilter *)[filters lastObject] type]);
					histograms[key] = filters;
				}
			}
		}
		if (histograms.count > 0) {
			if (success) {
				success(histograms);
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
	NSString *entityPath = @"brands";
	[self makeRequestForEntityAtPath:entityPath parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
	NSString *entityPath = @"retailers";
	[self makeRequestForEntityAtPath:entityPath parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
	NSString *entityPath = @"colors";
	[self makeRequestForEntityAtPath:entityPath parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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
	NSString *entityPath = @"categories";
	[self makeRequestForEntityAtPath:entityPath parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
	
	[self sharedInit];
	
    self.partnerId = [aDecoder decodeObjectForKey:@"partnerId"];
    self.currentLocale = [aDecoder decodeObjectForKey:@"currentLocale"];
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.partnerId forKey:@"partnerId"];
    [aCoder encodeObject:self.currentLocale forKey:@"currentLocale"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    PSSClient *client = [super copyWithZone:zone];
	client.currentLocale = self.currentLocale;
	client.partnerId = self.partnerId;
    return client;
}

@end
