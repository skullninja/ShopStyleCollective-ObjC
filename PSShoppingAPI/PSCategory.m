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

@implementation PSCategory

@synthesize categoryId = _categoryId;
@synthesize name = _name;
@synthesize parentId = _parentId;

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

+ (PSCategory *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    PSCategory *instance = [[PSCategory alloc] init];
    [instance setPropertiesWithDictionary:aDictionary];
    return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
	for (NSString *key in aDictionary) {
		id value = [aDictionary valueForKey:key];
		if ([key isEqualToString:@"id"]) {
			[self setValue:value forKey:@"categoryId"];
		} else {
			[self setValue:value forKey:key];
		}
	}
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
	PSDLog(@"Warning: Undefined Key Named '%@'", key);
}

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.categoryId];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.categoryId) {
        [dictionary setObject:self.categoryId forKey:@"categoryId"];
    }
    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }
    if (self.parentId) {
        [dictionary setObject:self.parentId forKey:@"parentId"];
    }
    return dictionary;
}

@end
