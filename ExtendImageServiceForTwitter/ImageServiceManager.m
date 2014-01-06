//
//  ImageServiceManager.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"

@implementation ImageServiceManager{
    NSMutableArray *_services;
}
/**
 * @return the single static instance of the plugin object
 */
+ (instancetype) manager;
{
    static dispatch_once_t onceToken;
    static id plugin = nil;
    
    dispatch_once(&onceToken, ^{
        plugin = [[self alloc] init];
    });
    
    return plugin;
}

- (id)init
{
    self = [super init];
    if (self) {
        _services = [NSMutableArray array];
    }
    return self;
}

+ (void)addService:(id<ImageService>)service;
{
    [[self manager]addService:service];
}

- (void)addService:(id<ImageService>)service;
{
    [_services addObject:service];
}

+ (id<ImageService>)serviceForURL:(NSURL*)url;
{
    return [[self manager]serviceForURL:url];
}

- (id<ImageService>)serviceForURL:(NSURL*)url;
{
    id result = nil;
    for(id<ImageService>service in _services) {
        if ([service canHandleURL:url]) {
            result = service;
            break;
        }
    }
    return result;
}

+ (NSDictionary*)mediaInfoFromUrlInfo:(NSDictionary*)urlInfo;
{
    return [[self manager]mediaInfoFromUrlInfo:urlInfo];
}

- (NSDictionary*)mediaInfoFromUrlInfo:(NSDictionary*)urlInfo;
{
    NSMutableDictionary *result = nil;
    NSString *expanded_url = urlInfo[@"expanded_url"];
    if (expanded_url) {
        NSURL *url = [NSURL URLWithString:expanded_url];
        id<ImageService>service = [self serviceForURL:url];
        result = [[service mediaInfoFromUrlInfo:urlInfo]mutableCopy];
        if (result) {
            result[@"expanded_url"] = urlInfo[@"expanded_url"];
            result[@"display_url"] = urlInfo[@"display_url"];
            result[@"url"] = urlInfo[@"url"];
            result[@"indices"] = urlInfo[@"indices"];
        }
    }
    return result;
}

+ (void)parseDict:(NSDictionary*)dict forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    [[self manager]parseDict:dict forTwitterEntityMedia:media];
}

- (void)parseDict:(NSDictionary*)dict forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSString *expanded_url = dict[@"expanded_url"];
    if (expanded_url) {
        NSURL *url = [NSURL URLWithString:expanded_url];
        id<ImageService>service = [self serviceForURL:url];
        [service parseDict:dict forTwitterEntityMedia:media];
    }
}

+ (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    return [[self manager]largeURLForTwitterEntityMedia:media];
}

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    id<ImageService>service = [self serviceForURL:media.mediaURL];
    return [service largeURLForTwitterEntityMedia:media];
}

+ (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    return [[self manager]mediumURLForTwitterEntityMedia:media];
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    id<ImageService>service = [self serviceForURL:media.mediaURL];
    return [service mediumURLForTwitterEntityMedia:media];
}

+ (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    return [[self manager]smallURLForTwitterEntityMedia:media];
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    id<ImageService>service = [self serviceForURL:media.mediaURL];
    return [service smallURLForTwitterEntityMedia:media];
}

+ (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    return [[self manager]thumbURLForTwitterEntityMedia:media];
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    id<ImageService>service = [self serviceForURL:media.mediaURL];
    return [service thumbURLForTwitterEntityMedia:media];
}

@end
