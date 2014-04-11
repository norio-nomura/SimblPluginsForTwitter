//
//  DermandarImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "DermandarImageService.h"

@implementation DermandarImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    NSString *lowercaseHost = [url.host lowercaseString];
    if ([lowercaseHost isEqualToString:@"pnr.ma"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] == 2;
    } else if ([lowercaseHost isEqualToString:@"www.dermandar.com"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] == 3 && [components[1] isEqualToString:@"p"];
    }
    return NO;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.host = @"static.dermandar.com";
    urlComponents.query = [NSString stringWithFormat:@"epid=%@&equi=1&h=512", [urlComponents.path lastPathComponent]];
    urlComponents.path = @"/php/getimage.php";
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
    urlComponents.host = @"static.dermandar.com";
    urlComponents.query = [NSString stringWithFormat:@"epid=%@&equi=1&h=512", media.mediaID];
    urlComponents.path = @"/php/getimage.php";
    media.mediaURL = urlComponents.URL;
    // no fixed size exists, but set dummies.
    media.largeSize = CGSizeMake(2048, 512);
    media.mediumSize = CGSizeMake(1024, 128);
    media.thumbSize = CGSizeMake(200, 120);
    media.smallSize = CGSizeMake(420, 70);
}

/*!
 *  See: http://www.dermandar.com (no documentation available.)
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = [NSString stringWithFormat:@"epid=%@&equi=1&h=512&", media.mediaID];
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = [NSString stringWithFormat:@"epid=%@&equi=1&h=128&", media.mediaID];
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = [NSString stringWithFormat:@"epid=%@&equi=1&w=200&h=120&", media.mediaID];
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.query = [NSString stringWithFormat:@"epid=%@&equi=1&h=70&w=420&", media.mediaID];
    return mediaURLComponents.URL;
}

@end
