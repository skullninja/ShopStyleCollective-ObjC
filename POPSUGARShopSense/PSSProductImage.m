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

NSString * const kPSSProductImageSizeNamedSmall = @"Small";
NSString * const kPSSProductImageSizeNamedMedium = @"Medium";
NSString * const kPSSProductImageSizeNamedLarge = @"Large";
NSString * const kPSSProductImageSizeNamedOriginal = @"Original";
NSString * const kPSSProductImageSizeNamedIPhoneSmall = @"IPhoneSmall";
NSString * const kPSSProductImageSizeNamedIPhone = @"IPhone";

@interface PSSProductImage ()

@property (nonatomic, copy, readwrite) NSString *sizeName;
@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, copy, readwrite) NSNumber *maxWidth;
@property (nonatomic, copy, readwrite) NSNumber *maxHeight;

@end

@implementation PSSProductImage

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@(%@,%@): %@", self.sizeName, self.maxWidth, self.maxHeight, self.URL.absoluteString];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSDLog(@"Warning: Undefined Key Named '%@'", key);
}

- (NSUInteger)hash
{
	return self.URL.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.URL isEqual:[(PSSProductImage *)object URL]]);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.sizeName forKey:@"sizeName"];
	[encoder encodeObject:self.URL forKey:@"URL"];
	[encoder encodeObject:self.maxWidth forKey:@"maxWidth"];
	[encoder encodeObject:self.maxHeight forKey:@"maxHeight"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.sizeName = [decoder decodeObjectForKey:@"sizeName"];
		self.URL = [decoder decodeObjectForKey:@"URL"];
		self.maxWidth = [decoder decodeObjectForKey:@"maxWidth"];
		self.maxHeight = [decoder decodeObjectForKey:@"maxHeight"];
	}
	return self;
}

#pragma mark - PSRemoteObject

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
		if ([key isEqualToString:@"url"]) {
			if ([value isKindOfClass:[NSString class]]) {
				self.URL = [NSURL URLWithString:value];
			}
		} else if ([key isEqualToString:@"width"]) {
			[self setValue:value forKey:@"maxWidth"];
		} else if ([key isEqualToString:@"height"]) {
			[self setValue:value forKey:@"maxHeight"];
		} else {
			[self setValue:value forKey:key];
		}
	}
}

@end
