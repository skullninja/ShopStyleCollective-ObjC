//
//  PSProductImage.m
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

#import "PSProductImage.h"

@implementation PSProductImage

@synthesize height = _height;
@synthesize width = _width;
@synthesize sizeName = _sizeName;
@synthesize urlString = _urlString;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.height forKey:@"height"];
    [encoder encodeObject:self.sizeName forKey:@"sizeName"];
    [encoder encodeObject:self.urlString forKey:@"urlString"];
    [encoder encodeObject:self.width forKey:@"width"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.height = [decoder decodeObjectForKey:@"height"];
        self.sizeName = [decoder decodeObjectForKey:@"sizeName"];
        self.urlString = [decoder decodeObjectForKey:@"urlString"];
        self.width = [decoder decodeObjectForKey:@"width"];
    }
    return self;
}

+ (PSProductImage *)instanceFromDictionary:(NSDictionary *)aDictionary
{
    PSProductImage *instance = [[PSProductImage alloc] init];
    [instance setPropertiesWithDictionary:aDictionary];
    return instance;
}

- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary
{
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self setValuesForKeysWithDictionary:aDictionary];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"url"]) {
        [self setValue:value forKey:@"urlString"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.height) {
        [dictionary setObject:self.height forKey:@"height"];
    }
    if (self.sizeName) {
        [dictionary setObject:self.sizeName forKey:@"sizeName"];
    }
    if (self.urlString) {
        [dictionary setObject:self.urlString forKey:@"urlString"];
    }
    if (self.width) {
        [dictionary setObject:self.width forKey:@"width"];
    }
    return dictionary;
}

@end
