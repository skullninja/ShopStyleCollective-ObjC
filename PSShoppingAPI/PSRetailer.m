//
//  PSRetailer.m
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

#import "PSRetailer.h"

@implementation PSRetailer

@synthesize name = _name;
@synthesize urlString = _urlString;
@synthesize retailerId = _retailerId;


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.retailerId forKey:@"retailerId"];
    [encoder encodeObject:self.urlString forKey:@"urlString"];
    [encoder encodeObject:[NSNumber numberWithBool:self.deeplinkSupport] forKey:@"deeplinkSupport"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.retailerId = [decoder decodeObjectForKey:@"retailerId"];
        self.urlString = [decoder decodeObjectForKey:@"urlString"];
        self.deeplinkSupport = [(NSNumber *)[decoder decodeObjectForKey:@"deeplinkSupport"] boolValue];
    }
    return self;
}

+ (PSRetailer *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    PSRetailer *instance = [[PSRetailer alloc] init];
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
			[self setValue:value forKey:@"retailerId"];
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
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.retailerId];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithBool:self.deeplinkSupport] forKey:@"deeplinkSupport"];
    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }
    if (self.retailerId) {
        [dictionary setObject:self.retailerId forKey:@"retailerId"];
    }
    if (self.urlString) {
        [dictionary setObject:self.urlString forKey:@"urlString"];
    }
    return dictionary;
}

@end
