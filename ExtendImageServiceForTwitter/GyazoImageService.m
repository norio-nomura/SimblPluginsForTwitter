//
//  GyazoImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "GyazoImageService.h"

@implementation GyazoImageService

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
    if ([lowercaseHost isEqualToString:@"gyazo.com"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] == 2;
    } else if ([lowercaseHost isEqualToString:@"i.gyazo.com"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] == 2 && [components[1]hasSuffix:@".png"] ;
    }
    return NO;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/%@.png", [[urlComponents.path lastPathComponent]stringByDeletingPathExtension]];
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
    urlComponents.path = [NSString stringWithFormat:@"/%@.png", media.mediaID];
    media.mediaURL = urlComponents.URL;
    // no fixed size exists, but set dummies.
    media.largeSize = CGSizeMake(640, 480);
    media.mediumSize = CGSizeMake(320, 240);
    media.thumbSize = CGSizeMake(320, 240);
    media.smallSize = CGSizeMake(320, 240);
}

/*!
 *  See: https://github.com/gyazo/Gyazo/blob/master/Server/upload.cgi
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@.png", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@.png", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@.png", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@.png", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
