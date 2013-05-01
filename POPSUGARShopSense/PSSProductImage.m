//
//  PSSProductImage.m
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

#import "PSSProductImage.h"
#import "POPSUGARShopSense.h"

static NSString * const kOriginalImageURLKey = @"Original";

@interface PSSProductImage ()

@property (nonatomic, copy, readwrite) NSString *imageId;
@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, strong) NSMutableDictionary *imageURLsBySizeName;

@end

NSString * NSStringFromPSSProductImageSizeName(PSSProductImageSize size)
{
	switch (size) {
		case PSSProductImageSizeSmall:
			return @"Small";
		case PSSProductImageSizeIPhoneSmall:
			return @"IPhoneSmall";
		case PSSProductImageSizeMedium:
			return @"Medium";
		case PSSProductImageSizeLarge:
			return @"Large";
		case PSSProductImageSizeIPhone:
			return @"IPhone";
		default:
			return nil;
	}
}

CGSize CGSizeFromPSSProductImageSize(PSSProductImageSize size)
{
	switch (size) {
		case PSSProductImageSizeSmall:
			return CGSizeMake(32, 40);
		case PSSProductImageSizeIPhoneSmall:
			return CGSizeMake(100, 125);
		case PSSProductImageSizeMedium:
			return CGSizeMake(112, 140);
		case PSSProductImageSizeLarge:
			return CGSizeMake(164, 205);
		case PSSProductImageSizeIPhone:
			return CGSizeMake(288, 360);
		default:
			return CGSizeZero;
	}
}

@implementation PSSProductImage

#pragma mark - Resized Images

- (NSURL *)imageURLWithSize:(PSSProductImageSize)size
{
	return [self.imageURLsBySizeName objectForKey:NSStringFromPSSProductImageSizeName(size)];
}

#pragma mark - Product Image Helpers

- (NSArray *)orderedImageSizeNames
{
	return [NSArray arrayWithObjects:NSStringFromPSSProductImageSizeName(PSSProductImageSizeSmall),
			NSStringFromPSSProductImageSizeName(PSSProductImageSizeIPhoneSmall),
			NSStringFromPSSProductImageSizeName(PSSProductImageSizeMedium),
			NSStringFromPSSProductImageSizeName(PSSProductImageSizeLarge),
			NSStringFromPSSProductImageSizeName(PSSProductImageSizeIPhone), nil];
}

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.imageId, self.URL.absoluteString];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSSDLog(@"Warning: Undefined Key Named '%@'", key);
}

- (NSUInteger)hash
{
	return self.imageId.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.imageId isEqualToString:[(PSSProductImage *)object imageId]]);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.imageURLsBySizeName forKey:@"imageURLsBySizeName"];
	[encoder encodeObject:self.URL forKey:@"URL"];
	[encoder encodeObject:self.imageId forKey:@"imageId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.imageURLsBySizeName = [decoder decodeObjectForKey:@"imageURLsBySizeName"];
		self.URL = [decoder decodeObjectForKey:@"URL"];
		self.imageId = [decoder decodeObjectForKey:@"imageId"];
	}
	return self;
}

#pragma mark - PSSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSProductImage *instance = [[PSSProductImage alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.imageId = [value description];
			}
		} else if ([key isEqualToString:@"sizes"]) {
			if ([value isKindOfClass:[NSDictionary class]] && [(NSDictionary *)value count] > 0) {
				NSDictionary *imageURLData = value;
				id originalData = [imageURLData valueForKey:kOriginalImageURLKey];
				if ([originalData isKindOfClass:[NSDictionary class]] && [(NSDictionary *)originalData count] > 0) {
					self.URL = [self imageURLFromRepresentation:originalData];
				}
				for (NSString *sizeName in [self orderedImageSizeNames]) {
					id sizeData = [imageURLData valueForKey:sizeName];
					if ([sizeData isKindOfClass:[NSDictionary class]] && [(NSDictionary *)sizeData count] > 0) {
						NSURL *sizeURL = [self imageURLFromRepresentation:sizeData];
						if (sizeURL != nil) {
							[self.imageURLsBySizeName setValue:sizeURL forKey:sizeName];
						}
					}
				}
			}
		} else {
			[self setValue:value forKey:key];
		}
	}
}

- (NSURL *)imageURLFromRepresentation:(NSDictionary *)representation
{
	NSURL *imageURL = nil;
	id imageURLString = [representation objectForKey:@"url"];
	if ([imageURLString isKindOfClass:[NSString class]]) {
		imageURL = [NSURL URLWithString:imageURLString];
	}
	return imageURL;
}

@end
