//
//  MovapicImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "MovapicImageService.h"

@implementation MovapicImageService

+(void)load;
{
    /*!
     *  register InstagramImageService to ImageServiceManager
     */
    [ImageServiceManager addService:[[self alloc]init]];
}

- (BOOL)canHandleURL:(NSURL *)url;
{
    if ([[url.host lowercaseString]hasSuffix:@"movapic.com"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] > 2 && [components[1] isEqualToString:@"pic"];
    }
    return NO;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.host = @"image.movapic.com";
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/pic/m_%@.jpeg", [[urlComponents.path lastPathComponent]stringByDeletingPathExtension]];
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
    urlComponents.host = @"image.movapic.com";
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/pic/m_%@.jpeg", media.mediaID];
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(640, 480);
    media.mediumSize = CGSizeMake(320, 240);
    media.thumbSize = CGSizeMake(320, 240);
    media.smallSize = CGSizeMake(320, 240);
}

/*!
 *  See: http://movapic.com but no API
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"image.movapic.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/pic/m_%@.jpeg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"image.movapic.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/pic/s_%@.jpeg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"image.movapic.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/pic/s_%@.jpeg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.host = @"image.movapic.com";
    mediaURLComponents.path = [NSString stringWithFormat:@"/pic/s_%@.jpeg", media.mediaID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
