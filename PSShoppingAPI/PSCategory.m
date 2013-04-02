//
//  PSCategory.m
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

#import "PSCategory.h"

@interface PSCategory ()

@property (nonatomic, copy, readwrite) NSString *categoryId;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *parentId;

@end

@implementation PSCategory

#pragma mark - NSObject

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.categoryId];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSDLog(@"Warning: Undefined Key Named '%@'", key);
}

- (NSUInteger)hash
{
	return self.categoryId.hash;
}

- (BOOL)isEqual:(id)object
{
	if (object == self) {
		return YES;
	}
	if (object == nil || ![object isKindOfClass:[self class]]) {
		return NO;
	}
	return ([self.categoryId isEqualToString:[(PSCategory *)object categoryId]]);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.categoryId forKey:@"categoryId"];
	[encoder encodeObject:self.name forKey:@"name"];
	[encoder encodeObject:self.parentId forKey:@"parentId"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		self.categoryId = [decoder decodeObjectForKey:@"categoryId"];
		self.name = [decoder decodeObjectForKey:@"name"];
		self.parentId = [decoder decodeObjectForKey:@"parentId"];
	}
	return self;
}

#pragma mark - PSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSCategory *instance = [[PSCategory alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"] && [value isKindOfClass:[NSString class]]) {
			self.categoryId = value;
		} else {
			[self setValue:value forKey:key];
		}
	}
}

@end
