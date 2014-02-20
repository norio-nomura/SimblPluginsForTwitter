//
//  ImgurImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "ImgurImageService.h"

@implementation ImgurImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    if ([[url.host lowercaseString]hasSuffix:@"imgur.com"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] > 0;
    }
    return NO;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.query = @"";
    urlComponents.host = @"i.imgur.com";
    urlComponents.path = [NSString stringWithFormat:@"/%@.jpg", [[urlComponents.path lastPathComponent]stringByDeletingPathExtension]];
    NSString *media_url = [urlComponents.URL absoluteString];
    urlComponents.scheme = @"https";
    NSString *media_url_https = [urlComponents.URL absoluteString];
    return @{@"media_url": media_url, @"media_url_https": media_url_https};
}

- (void)parseDict:(NSDictionary*)dict forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSString *expanded_url = dict[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    media.mediaID = [[urlComponents.path lastPathComponent]stringByDeletingPathExtension];
    urlComponents.query = @"";
    urlComponents.host = @"i.imgur.com";
    urlComponents.path = [NSString stringWithFormat:@"/%@.jpg", media.mediaID];
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(1024, 1024);
    media.mediumSize = CGSizeMake(640, 640);
    media.thumbSize = CGSizeMake(320, 320);
    media.smallSize = CGSizeMake(160, 160);
}

/*!
 *  See: imgur.com does not publish official api for thumnail redirecting. But you should see http://api.imgur.com
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"i.imgur.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@h.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"i.imgur.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@l.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"i.imgur.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@m.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"i.imgur.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@t.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
