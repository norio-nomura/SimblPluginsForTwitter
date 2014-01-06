//
//  CameraPlusImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "CameraPlusImageService.h"

@implementation CameraPlusImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    NSArray *components = [url.path componentsSeparatedByString:@"/"];
    
    return NSOrderedSame == [url.host compare:@"campl.us" options:NSCaseInsensitiveSearch] && [components count] == 2;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.query = @"";
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
    urlComponents.query = @"";
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(800, 800);
    media.mediumSize = CGSizeMake(480, 480);
    media.thumbSize = CGSizeMake(120, 120);
    media.smallSize = CGSizeMake(120, 120);
}

/*!
 *  See: http://api.camerapl.us/web-api
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [mediaURLComponents.path stringByAppendingString:@":800px"];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [mediaURLComponents.path stringByAppendingString:@":480px"];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [mediaURLComponents.path stringByAppendingString:@":120px"];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [mediaURLComponents.path stringByAppendingString:@":120px"];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
