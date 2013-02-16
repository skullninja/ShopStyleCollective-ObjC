//
//  PSProductFilter.m
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

#import "PSProductFilter.h"

@interface PSProductFilter ()

@property (nonatomic, assign, readwrite) PSProductFilterType type;
@property (nonatomic, copy, readwrite) NSNumber *filterId;

@end

@implementation PSProductFilter

@synthesize type = _type;
@synthesize filterId = _filterId;
@synthesize name = _name;
@synthesize urlString = _urlString;
@synthesize productCount = _productCount;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.filterId forKey:@"filterId"];
    [encoder encodeObject:self.urlString forKey:@"urlString"];
	[encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeObject:self.productCount forKey:@"productCount"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.filterId = [decoder decodeObjectForKey:@"filterId"];
        self.urlString = [decoder decodeObjectForKey:@"urlString"];
		self.type = [decoder decodeIntegerForKey:@"type"];
        self.productCount = [decoder decodeObjectForKey:@"productCount"];
    }
    return self;
}

+ (PSProductFilter *)filterWithType:(PSProductFilterType)type filterId:(NSNumber *)filterId
{
	PSProductFilter *filter = [[PSProductFilter alloc] initWithType:type filterId:filterId];
	return filter;
}

- (id)initWithType:(PSProductFilterType)type filterId:(NSNumber *)filterId
{
	NSParameterAssert(filterId != nil);
    self = [super init];
    if (self) {
        _filterId = [filterId copy];
		_type = type;
    }
    return self;
}

- (NSString *)description
{
	// Filter prefixes are:
	// b - brand
	// r - retailer
	// p - price
	// d - sale
	// s - size
	// c - color
	NSString *prefix = @"";
	switch (self.type) {
		case PSProductFilterTypeBrand:
			prefix = @"b";
			break;
		case PSProductFilterTypeRetailer:
			prefix = @"r";
			break;
		case PSProductFilterTypePrice:
			prefix = @"p";
			break;
		case PSProductFilterTypeSale:
			prefix = @"d";
			break;
		case PSProductFilterTypeSize:
			prefix = @"s";
			break;
		case PSProductFilterTypeColor:
			prefix = @"c";
			break;
			
		default:
			break;
	}
	return [prefix stringByAppendingString:self.filterId.stringValue];
}

@end