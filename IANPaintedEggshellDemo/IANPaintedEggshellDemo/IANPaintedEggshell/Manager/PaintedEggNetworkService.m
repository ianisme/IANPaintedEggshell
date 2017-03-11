//
//  PaintedEggNetworkService.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 2017/3/9.
//  Copyright © 2017年 ian. All rights reserved.
//

#import "PaintedEggNetworkService.h"

@implementation PaintedEggNetworkService

+ (instancetype)shareInstance
{
    static PaintedEggNetworkService *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedClient = [[PaintedEggNetworkService alloc] init];
    });
    return sharedClient;
}

- (void)appPost:(NSString *)url parametersString:(NSString *)paramstersStr handler:(void(^)(BOOL successful, id response))handler
{
    NSString *urlString = url;
    NSURL *newUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:newUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSData *bodyData = [paramstersStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = bodyData;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            handler(NO , connectionError);
            //            NSLog(@"Httperror:%@%ld", connectionError.localizedDescription,(long)connectionError.code);
        }else{
            //            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            //
            //            NSDictionary *responseDic = (NSDictionary *)json;
            handler(YES,dic.description);
            //            NSLog(@"HttpResponseCode:%ld", (long)responseCode);
        }
    }];
}

- (void)appGet:(NSString *)url handler:(void(^)(BOOL successful, id response))handler
{
    NSURL *newUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:newUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            handler(NO , connectionError);
            //            NSLog(@"Httperror:%@%ld", connectionError.localizedDescription,(long)connectionError.code);
        }else{
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSDictionary *responseDic = (NSDictionary *)responseString;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            handler(YES,dic.description);
            //            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            //            NSLog(@"HttpResponseCode:%ld", (long)responseCode);
        }
    }];
}

@end
