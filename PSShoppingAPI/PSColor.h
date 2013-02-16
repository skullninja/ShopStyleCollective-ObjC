//
//  PSColor.h
//  iOS Example
//
//  Created by Anthony Prato on 2/15/13.
//  Copyright (c) 2013 POPSUGAR Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSColor : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *colorId;
@property (nonatomic, copy) NSString *urlString;

+ (PSColor *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setPropertiesWithDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
