//
//  ScanlogTableViewController.m
//  ScanLog
//
//  Created by Alexander Lehmann on 04.04.16.
//  Copyright © 2016 Alexander Lehmann. All rights reserved.
//

#import "ScanlogTableViewController.h"
#import "ScanProduct.h"

@interface ScanlogTableViewController()

@property(nonatomic, strong) NSArray<ScanProduct*>* products;

@end

@implementation ScanlogTableViewController

static NSString* const kUrlFormat = @"https://e2213kres9.execute-api.us-west-2.amazonaws.com/prod/eventlog?uuid=a2bc87fb-3047-4f24-bdb7-20c3fe40da1d&ts=%lu";

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSUInteger limitTimestampEpochMilliseconds = round([[NSDate dateWithTimeIntervalSinceNow:(-(14*24*60*60))] timeIntervalSince1970] *1000);
        NSString* currentUrl = [NSString stringWithFormat:kUrlFormat, (unsigned long)limitTimestampEpochMilliseconds];
        NSURLSessionDataTask* task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithURL:[NSURL URLWithString:currentUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data && ! error) {
                NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                self.products = [MTLJSONAdapter modelsOfClass:ScanProduct.class fromJSONArray:array error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });

            }
        }];
        [task resume];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScanLogCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ScanLogCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.products[indexPath.row].title.length > 0) {
        cell.textLabel.text = self.products[indexPath.row].title;
    }
    else {
        cell.textLabel.text = self.products[indexPath.row].product_id;
    }
    if (self.products[indexPath.row].manufacturer.length > 0) {
        cell.detailTextLabel.text = self.products[indexPath.row].manufacturer;
    }
    else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

@end
