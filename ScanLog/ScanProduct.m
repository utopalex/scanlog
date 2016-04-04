//
//  ScanProduct.m
//  ScanLog
//
//  Created by Alexander Lehmann on 03.04.16.
//  Copyright © 2016 Alexander Lehmann. All rights reserved.
//

#import "ScanProduct.h"

@implementation ScanProduct

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title": @"title",
             @"product_id": @"product_id",
             @"manufacturer": @"manufacturer",
             @"imageUrl" : @"image_url"
             };
}

+ (NSValueTransformer *)imageUrlTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
