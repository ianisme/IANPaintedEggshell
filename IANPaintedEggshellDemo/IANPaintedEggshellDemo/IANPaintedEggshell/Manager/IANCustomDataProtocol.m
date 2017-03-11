//
//  IANCustomDataProtocol.m
//  IANPaintedEggshellDemo
//
//  Created by ian on 16/11/29.
//  Copyright © 2016年 ian. All rights reserved.
//

#import "IANCustomDataProtocol.h"
#import "IANAppMacros.h"
#import "IANNetworkLogModel.h"
#import "PaintedEggshellManager.h"
#import "IANUtil.h"

static NSString * const hasInitKey = @"IANCustomDataProtocolKey";

@interface IANCustomDataProtocol()

@property (nonatomic, strong) NSMutableData *ianResponseData;
@property (nonatomic, strong) NSURLConnection *ianConnection;
@property (nonatomic, strong) NSURLResponse *ianResponse;
@property (nonatomic, strong) NSURLRequest *ianRequest;

@end

@implementation IANCustomDataProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:hasInitKey inRequest:request]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //这边可用干你想干的事情。。更改地址，或者设置里面的请求头。。
    return mutableReqeust;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //做下标记，防止递归调用
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:mutableReqeust];
    
    //这边就随便你玩了。。可以直接返回本地的模拟数据，进行测试
    
    BOOL enableDebug = NO;
    
    if (enableDebug) {
        
        NSString *str = @"测试数据";
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
                                                            MIMEType:@"text/plain"
                                               expectedContentLength:data.length
                                                    textEncodingName:nil];
        [self.client URLProtocol:self
              didReceiveResponse:response
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    }
    else {
        self.ianConnection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
    }
}

- (void)stopLoading
{
    [self.ianConnection cancel];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.ianResponseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    self.ianResponse = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.ianResponseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)self.ianResponse;
    if ([self.ianResponse respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        if ([dictionary[@"Content-Type"] containsString:@"text"]) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.ianResponseData options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@",self.request.URL.absoluteString);
            NSLog(@"%@",self.request.HTTPMethod);
            NSLog(@"%@",[[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding]);
            // Unicode转码
            NSString *responseUnicode = dic.description;
            NSString *eggResponse = nil;
            if (responseUnicode) {
                eggResponse = [IANUtil replaceUnicode:responseUnicode];
            }
            NSLog(@"%@", eggResponse);
            
            NSString *paintedEggshellLogIsOpen = [[NSUserDefaults standardUserDefaults] stringForKey:PAINTED_EGGSHELL_LOG_ISOPEN];
            if ([paintedEggshellLogIsOpen isEqualToString:@"1"]) {
                IANNetworkLogModel *networkLogModel = [[IANNetworkLogModel alloc] init];
                
                networkLogModel.urlString = self.request.URL.absoluteString;
                networkLogModel.httpMethodString = self.request.HTTPMethod;
                networkLogModel.httpBodyString = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
                networkLogModel.responseString = [NSString stringWithFormat:@"%@",eggResponse];
                networkLogModel.classString = [NSString stringWithFormat:@"%@",NSStringFromClass([self.request class])];
                networkLogModel.timeString = [NSString stringWithFormat:@"%zd", (long)[[NSDate date] timeIntervalSince1970]];
                [[PaintedEggshellManager shareInstance].networkLogArray addObject:networkLogModel];
                
                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
                NSInteger intervalInt = round(interval);
                NSUInteger tempTimeStamp = [PaintedEggshellManager shareInstance].tempTimeStamp;
                
                if (intervalInt - tempTimeStamp > 5) {
                    [PaintedEggshellManager shareInstance].tempTimeStamp = interval;
                    [[PaintedEggshellManager shareInstance] savePaintedEggshellNetworkLogPlist];
                }
                
            }
            
        }
    }
}

@end
