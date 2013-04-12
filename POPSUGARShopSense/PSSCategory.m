//
//  PSSCategory.m
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

#import "PSSCategory.h"


@interface PSSProductCategory (PRIVATE_CATEGORY_EXT)

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary;

@end

@interface PSSCategory ()

@property (nonatomic, strong, readwrite) NSMutableOrderedSet *mutableChildCategorySet;
@property (nonatomic, copy, readwrite) NSString *parentId;

@end

@implementation PSSCategory

- (NSArray *)childCategories
{
	return [self.mutableChildCategorySet array];
}

- (NSMutableOrderedSet *)mutableChildCategorySet
{
	if (_mutableChildCategorySet != nil) {
		return _mutableChildCategorySet;
	}
	_mutableChildCategorySet = [[NSMutableOrderedSet alloc] init];
	return _mutableChildCategorySet;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	[encoder encodeObject:self.parentId forKey:@"parentId"];
	[encoder encodeObject:self.mutableChildCategorySet forKey:@"mutableChildCategorySet"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder])) {
		self.parentId = [decoder decodeObjectForKey:@"parentId"];
		self.mutableChildCategorySet = [decoder decodeObjectForKey:@"mutableChildCategorySet"];
	}
	return self;
}

#pragma mark - PSRemoteObject

+ (instancetype)instanceFromRemoteRepresentation:(NSDictionary *)representation
{
	if (representation.count == 0) {
		return nil;
	}
	PSSCategory *instance = [[PSSCategory alloc] init];
	[instance setPropertiesWithDictionary:representation];
	return instance;
}

@end
