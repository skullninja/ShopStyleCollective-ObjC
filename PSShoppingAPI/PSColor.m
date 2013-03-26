//
//  PSColor.m
//  iOS Example
//
//  Created by Anthony Prato on 2/15/13.
//  Copyright (c) 2013 POPSUGAR Inc. All rights reserved.
//

#import "PSColor.h"

@implementation PSColor

@synthesize name = _name;
@synthesize urlString = _urlString;
@synthesize colorId = _colorId;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.colorId forKey:@"colorId"];
    [encoder encodeObject:self.urlString forKey:@"urlString"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.colorId = [decoder decodeObjectForKey:@"colorId"];
        self.urlString = [decoder decodeObjectForKey:@"urlString"];
    }
    return self;
}

+ (PSColor *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    PSColor *instance = [[PSColor alloc] init];
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
			[self setValue:value forKey:@"colorId"];
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
	return [[super description] stringByAppendingFormat:@" %@: %@", self.name, self.colorId];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }
    if (self.colorId) {
        [dictionary setObject:self.colorId forKey:@"colorId"];
    }
    if (self.urlString) {
        [dictionary setObject:self.urlString forKey:@"urlString"];
    }
    return dictionary;
}

@end
