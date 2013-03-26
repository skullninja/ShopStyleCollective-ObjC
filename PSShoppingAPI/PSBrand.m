//
//  PSBrand.m
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

#import "PSBrand.h"

@implementation PSBrand

@synthesize name = _name;
@synthesize urlString = _urlString;
@synthesize brandId = _brandId;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.brandId forKey:@"brandId"];
    [encoder encodeObject:self.urlString forKey:@"urlString"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.brandId = [decoder decodeObjectForKey:@"brandId"];
        self.urlString = [decoder decodeObjectForKey:@"urlString"];
    }
    return self;
}

+ (PSBrand *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    PSBrand *instance = [[PSBrand alloc] init];
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
			[self setValue:value forKey:@"brandId"];
		} else if ([key isEqualToString:@"url"] && [value isKindOfClass:[NSString class]]) {
			[self setValue:value forKey:@"urlString"];
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
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.brandId];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }
    if (self.brandId) {
        [dictionary setObject:self.brandId forKey:@"brandId"];
    }
    if (self.urlString) {
        [dictionary setObject:self.urlString forKey:@"urlString"];
    }
    return dictionary;
}

@end
