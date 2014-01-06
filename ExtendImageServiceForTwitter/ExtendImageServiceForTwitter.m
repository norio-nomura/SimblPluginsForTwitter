//
//  ExtendImageServiceForTwitter.m
//  SimblPluginsForTwitter
//

#import <objc/runtime.h>
#import "TwitterMacProtocols.h"
#import "ExtendImageServiceForTwitter.h"
#import "ImageServiceManager.h"

@implementation NSObject(ExtendImageServiceForTwitter)

#pragma mark - TwitterEntitySet

+ (id)ExtendImageServiceForTwitter_entitiesWithDict:(NSDictionary*)dict;
{
    if (!dict[@"media"]) {
        NSDictionary *media = nil;
        NSMutableArray *newUrls = [NSMutableArray array];
        NSArray *urls = dict[@"urls"];
        for(NSDictionary *urlInfo in urls) {
            // Support one Media only
            if (media) {
                [newUrls addObject:urlInfo];
            } else {
                media = [ImageServiceManager mediaInfoFromUrlInfo:urlInfo];
            }
        }
        // If supported
        if (media) {
            NSMutableDictionary *newDict = [dict mutableCopy];
            newDict[@"media"] = @[media];
            newDict[@"urls"] = newUrls;
            dict = newDict;
        }
    }
    
    id result = [self ExtendImageServiceForTwitter_entitiesWithDict:dict];
    return result;
}

#pragma mark - TwitterEntityMedia

- (void)ExtendImageServiceForTwitter_parseDict:(NSDictionary*)dict;
{
    [self ExtendImageServiceForTwitter_parseDict:dict];
    [ImageServiceManager parseDict:(NSDictionary*)dict
             forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)self];
}

- (id)ExtendImageServiceForTwitter_largeURL;
{
    id url = nil;
    id<SimblPluginsForTwitter_TwitterEntityMedia>media = (id<SimblPluginsForTwitter_TwitterEntityMedia>)self;
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    if ([mediaURLComponents.host hasSuffix:@"instagram.com"]) {
        mediaURLComponents.query = @"size=l";
        url = mediaURLComponents.URL;
    } else {
        url = [self ExtendImageServiceForTwitter_largeURL];
    }
    return url;
}

- (id)ExtendImageServiceForTwitter_mediumURL;
{
    id url = nil;
    id<SimblPluginsForTwitter_TwitterEntityMedia>media = (id<SimblPluginsForTwitter_TwitterEntityMedia>)self;
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    if ([mediaURLComponents.host hasSuffix:@"instagram.com"]) {
        mediaURLComponents.query = @"size=m";
        url = mediaURLComponents.URL;
    } else {
        url = [self ExtendImageServiceForTwitter_largeURL];
    }
    return url;
}

- (id)ExtendImageServiceForTwitter_smallURL;
{
    id url = nil;
    id<SimblPluginsForTwitter_TwitterEntityMedia>media = (id<SimblPluginsForTwitter_TwitterEntityMedia>)self;
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    if ([mediaURLComponents.host hasSuffix:@"instagram.com"]) {
        mediaURLComponents.query = @"size=t";
        url = mediaURLComponents.URL;
    } else {
        url = [self ExtendImageServiceForTwitter_largeURL];
    }
    return url;
}

- (id)ExtendImageServiceForTwitter_thumbURL;
{
    id url = nil;
    id<SimblPluginsForTwitter_TwitterEntityMedia>media = (id<SimblPluginsForTwitter_TwitterEntityMedia>)self;
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    if ([mediaURLComponents.host hasSuffix:@"instagram.com"]) {
        mediaURLComponents.query = @"size=t";
        url = mediaURLComponents.URL;
    } else {
        url = [self ExtendImageServiceForTwitter_largeURL];
    }
    return url;
}

#pragma mark - ABHTTPRequest

- (void)ExtendImageServiceForTwitter_startRequest;
{
    id<SimblPluginsForTwitter_ABHTTPRequest> request = (id<SimblPluginsForTwitter_ABHTTPRequest>)self;
    if ([ImageServiceManager serviceForURL:request.url]) {
        /*!
         *  Instagram.com returns incorrect media redirect url if UserAgent contains "Twitter".
         *  So, ExtendImageServiceForTwitter replace UserAgent.
         */
        static NSString *userAgent = nil;
        if (!userAgent) {
            NSDictionary *infoDictionary = [[NSBundle bundleForClass:[ExtendImageServiceForTwitter class]] infoDictionary];
            userAgent = [NSString stringWithFormat:@"ExtendImageService/%@", infoDictionary[@"CFBundleShortVersionString"]];
        }
        [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
    [self ExtendImageServiceForTwitter_startRequest];
}

@end

#pragma mark - TMDetailedStatusCell

@implementation NSObject (TMDetailedStatusCell)

- (void)ExtendImageServiceForTwitter_didDownloadPhoto:(NSData*)data info:(id)arg2;
{
    id<SimblPluginsForTwitter_TMDetailedStatusCell>cell = (id<SimblPluginsForTwitter_TMDetailedStatusCell>)self;
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    cell.status.entities.media.largeSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    
    [self ExtendImageServiceForTwitter_didDownloadPhoto:data info:arg2];
    
    CGImageRelease(image);
    CFRelease(source);
}

@end

@implementation ExtendImageServiceForTwitter

/*!
 * A special method called by SIMBL once the application has started and all classes are initialized.
 */
+ (void) load
{
    id plugin = [self sharedInstance];
    // ... do whatever
    if (plugin) {
        Class from = objc_getClass("TwitterEntitySet");
        Class to = objc_getClass("NSObject");
        method_exchangeImplementations(class_getClassMethod(from, @selector(entitiesWithDict:)),
                                       class_getClassMethod(to, @selector(ExtendImageServiceForTwitter_entitiesWithDict:)));
        from = objc_getClass("TwitterEntityMedia");
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(parseDict:)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_parseDict:)));
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(largeURL)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_largeURL)));
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(mediumURL)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_mediumURL)));
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(smallURL)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_smallURL)));
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(thumbURL)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_thumbURL)));
        from = objc_getClass("ABHTTPRequest");
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(startRequest)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_startRequest)));
        from = objc_getClass("TMDetailedStatusCell");
        method_exchangeImplementations(class_getInstanceMethod(from, @selector(didDownloadPhoto:info:)),
                                       class_getInstanceMethod(to, @selector(ExtendImageServiceForTwitter_didDownloadPhoto:info:)));
    }
}


/*!
 * @return the single static instance of the plugin object
 */
+ (instancetype) sharedInstance;
{
    static id plugin = nil;
    
    if (plugin == nil)
        plugin = [[self alloc] init];
    
    return plugin;
}

@end
