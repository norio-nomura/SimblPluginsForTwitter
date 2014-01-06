//
//  TwitPicImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "TwitPicImageService.h"

@implementation TwitPicImageService

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
    
    return NSOrderedSame == [url.host compare:@"twitpic.com" options:NSCaseInsensitiveSearch] && ([components count] == 2 ||
                                                   ([components count] > 1 && [components[1] isEqualToString:@"show"]));
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    NSString *imageID = [urlComponents.path lastPathComponent];
    urlComponents.path = [@"/show/full/" stringByAppendingPathComponent:imageID];
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
    urlComponents.path = [@"/show/full/" stringByAppendingPathComponent:media.mediaID];
    urlComponents.query = @"";
    media.mediaURL = urlComponents.URL;
    media.largeSize = CGSizeMake(640, 640);
    media.mediumSize = CGSizeMake(306, 306);
    media.smallSize = CGSizeMake(150, 150);
    media.thumbSize = CGSizeMake(75, 75);
}

/*!
 *  See: http://dev.twitpic.com/docs/thumbnails/
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    NSString *imageID = [mediaURLComponents.path lastPathComponent];
    // "/show/full/" is undocumented api of TwitPic
    mediaURLComponents.path = [@"/show/full/" stringByAppendingPathComponent:imageID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    NSString *imageID = [mediaURLComponents.path lastPathComponent];
    // "/show/large/" is undocumented api of TwitPic
    mediaURLComponents.path = [@"/show/large/" stringByAppendingPathComponent:imageID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    NSString *imageID = [mediaURLComponents.path lastPathComponent];
    mediaURLComponents.path = [@"/show/thumb/" stringByAppendingPathComponent:imageID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    NSString *imageID = [mediaURLComponents.path lastPathComponent];
    mediaURLComponents.path = [@"/show/mini/" stringByAppendingPathComponent:imageID];
    mediaURLComponents.query = @"";
    return mediaURLComponents.URL;
}

@end
