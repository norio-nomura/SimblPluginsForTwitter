//
//  MobypictureImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "MobypictureImageService.h"

@implementation MobypictureImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    if ([[url.host lowercaseString]hasSuffix:@"moby.to"]) {
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
    urlComponents.path = [NSString stringWithFormat:@"/%@:full", [[urlComponents.path lastPathComponent]stringByDeletingPathExtension]];
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
    urlComponents.path = [NSString stringWithFormat:@"/%@:full", media.mediaID];
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(1024, 1024);
    media.mediumSize = CGSizeMake(600, 600);
    media.thumbSize = CGSizeMake(100, 100);
    media.smallSize = CGSizeMake(90, 90);
}

/*!
 *  See: http://developers.mobypicture.com/documentation/additional/inline-thumbnails/
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@:full", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@:view", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@:thumb", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/%@:square", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
