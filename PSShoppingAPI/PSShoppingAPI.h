//
//  PSShoppingAPI.h
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

#import "AFNetworking.h"

#ifndef _PSShoppingAPI_
	#define _PSShoppingAPI_
	#import "PSShoppingAPIClient.h"
	#import "PSProductQuery.h"
	#import "PSProductFilter.h"
	#import "PSProduct.h"
	#import "PSBrand.h"
	#import "PSCategoryTree.h"
	#import "PSCategory.h"
	#import "PSProductImage.h"
	#import "PSProductSize.h"
	#import "PSProductColor.h"
	#import "PSProductCategory.h"
	#import "PSRetailer.h"
	#import "PSColor.h"
#endif

#ifdef _PSShoppingAPI_DEBUG_
	#define PSDLog(...) NSLog(@"%s(%p) %@", __PRETTY_FUNCTION__, self, [NSString stringWithFormat:__VA_ARGS__])
#else
	#define PSDLog(...)
#endif