//
//  MstrInImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "MstrInImageService.h"

@protocol ImageService;

@implementation MstrInImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    if ([[url.host lowercaseString]hasSuffix:@"mstr.in"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] > 2 && [components[1] isEqualToString:@"photos"];
    }
    return NO;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.host = @"pic.mstr.in";
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/images/%@.jpg", [[urlComponents.path lastPathComponent]stringByDeletingPathExtension]];
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
    urlComponents.host = @"pic.mstr.in";
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/images/%@.jpg", media.mediaID];
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(960, 960);
    media.mediumSize = CGSizeMake(960, 960);
    media.thumbSize = CGSizeMake(960, 960);
    media.smallSize = CGSizeMake(960, 960);
}

/*!
 *  See: https://mstr.in/about
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"pic.mstr.in";
    mediaURLComponents.path = [NSString stringWithFormat:@"/images/%@.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"pic.mstr.in";
    mediaURLComponents.path = [NSString stringWithFormat:@"/images/%@.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"pic.mstr.in";
    mediaURLComponents.path = [NSString stringWithFormat:@"/images/%@.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"pic.mstr.in";
    mediaURLComponents.path = [NSString stringWithFormat:@"/images/%@.jpg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
