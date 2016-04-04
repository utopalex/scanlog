//
//  ScanProduct.h
//  ScanLog
//
//  Created by Alexander Lehmann on 03.04.16.
//  Copyright © 2016 Alexander Lehmann. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ScanProduct : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSDate* created_at;
@property (nonatomic, copy, readonly) NSString* product_id;
@property (nonatomic, copy, readonly) NSString* title;
@property (nonatomic, copy, readonly) NSString* manufacturer;
@property (nonatomic, copy, readonly) NSURL* imageUrl;

@end
