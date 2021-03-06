//
//  MiilImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "MiilImageService.h"

@implementation MiilImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    return NSOrderedSame == [url.host compare:@"miil.me" options:NSCaseInsensitiveSearch] && [url.path hasPrefix:@"/p/"];
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.path = [urlComponents.path stringByAppendingString:@".jpeg"];
    urlComponents.query = @"size=640";
    NSString *media_url = [urlComponents.URL absoluteString];
    urlComponents.scheme = @"https";
    NSString *media_url_https = [urlComponents.URL absoluteString];
    return @{@"media_url": media_url, @"media_url_https": media_url_https};
}

- (void)parseDict:(NSDictionary*)dict forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSString *expanded_url = dict[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    media.mediaID = [urlComponents.path lastPathComponent];
    urlComponents.path = [urlComponents.path stringByAppendingString:@".jpeg"];
    urlComponents.query = @"size=640";
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(640, 640);
    media.mediumSize = CGSizeMake(306, 306);
    media.thumbSize = CGSizeMake(150, 150);
    media.smallSize = CGSizeMake(150, 150);
}

/*!
 *  See: https://github.com/FrogAppsDev/miil-apis/tree/master/Japanese
 *  Instagram.com returns incorrect media redirect url if UserAgent contains "Twitter".
 *  So, ExtendImageServiceForTwitter replace UserAgent.
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = @"size=640";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = @"size=306";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = @"size=150";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = @"size=150";
    return mediaURLComponents.URL;
}

@end
