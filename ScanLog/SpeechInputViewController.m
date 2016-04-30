//
//  SpeechInputViewController.m
//  ScanLog
//
//  Created by Federico on 30/04/16.
//  Copyright © 2016 Alexander Lehmann. All rights reserved.
//

#import "SpeechInputViewController.h"
#import <SpeechKit/SpeechKit.h>

#import "ScanLog-Swift.h"

static NSString* const SKSServerUrl = @"nmsps://NMDPTRIAL_federico_mendez_offerista_com20160430050839@sslsandbox.nmdp.nuancemobility.net:443";
static NSString* const SKSAppKey = @"ba274267cf24d93df5550d0b79972949943188744369b2b6315b6d82b58ae46fb126d6814aafbe3f04cb4b7d6374c7f7a64f6be9b81ea0ea790d6c2e97509e49";

@interface SpeechInputViewController()<SKTransactionDelegate>

@property (strong, nonatomic) SKSession* session;
@property (strong, nonatomic) SKTransaction* transaction;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (strong, nonatomic) CrazyClass* crazy;

@end

@implementation SpeechInputViewController

-(void)viewDidLoad
{
    self.session = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];
    self.crazy = [[CrazyClass alloc] init];
    [self resetSession];
}

-(void)resetSession
{
    self.transaction = [self.session recognizeWithType:SKTransactionSpeechTypeDictation detection:SKTransactionEndOfSpeechDetectionNone language:@"deu-DEU" delegate:self];
}

- (IBAction)stopSession:(id)sender
{
    [self.transaction stopRecording];
}

- (IBAction)deleteSession:(id)sender
{
    self.inputField.text = @"";
    [self resetSession];
}

- (IBAction)sendToServer:(id)sender
{
    NSMutableArray* nouns = [[NSMutableArray alloc] init];
    for (ScanLogTaggedToken* token in [self.crazy tagTokensInText:self.inputField.text]) {
        if([token.tag isEqualToString:@"Noun"]) {
            [nouns addObject:token.token];
        }
    }
    
    if (nouns.count > 0) {
        [self putElement:nouns.firstObject];
    }
    
    [self resetSession];
}

-(void)putElement:(NSString*)text
{
    NSURL* url = [NSURL URLWithString:@"https://e2213kres9.execute-api.us-west-2.amazonaws.com/prod/shopping_list"];
    NSString* uuid = @"8DACBDFB-8AC8-4644-853B-8EA088E4579D";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];

    [request setURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PATCH"];
    
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: text, @"text",
                             uuid, @"uuid",
                             nil];

    NSError* error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Here we are!");
    }];
    
    [postDataTask resume];
}

#pragma mark SKTransactionDelegate

- (void)transactionDidBeginRecording:(SKTransaction *)transaction {}
- (void)transactionDidFinishRecording:(SKTransaction *)transaction {}

- (void)transaction:(SKTransaction *)transaction didReceiveRecognition:(SKRecognition *)recognition
{
    //Take the best result
    NSString* topRecognitionText = [recognition text];
    
    self.inputField.text = topRecognitionText;
    
    //Or iterate through the NBest list
    NSArray* nBest = [recognition details];
    for (SKRecognizedPhrase* phrase in nBest) {
        NSString* text = [phrase text];
        int confidence = [phrase confidence];
    }
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error
         suggestion:(NSString *)suggestion {}

@end
