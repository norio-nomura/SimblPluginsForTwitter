//
//  PhotozouImageService.m
//  SimblPluginsForTwitter
//

#import "ImageServiceManager.h"
#import "PhotozouImageService.h"

@implementation PhotozouImageService

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
    if ([lowercaseHost isEqualToString:@"photozou.jp"]) {
        NSArray *components = [url.path componentsSeparatedByString:@"/"];
        return [components count] == 5 && [components[1] isEqualToString:@"photo"] && [components[2] isEqualToString:@"show"];
    }
    return NO;
}

- (NSDictionary *)mediaInfoFromUrlInfo:(NSDictionary *)urlInfo;
{
    NSString *expanded_url = urlInfo[@"expanded_url"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:expanded_url];
    urlComponents.host = @"photozou.jp";
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/p/img/%@", [urlComponents.path lastPathComponent]];
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
    urlComponents.host = @"photozou.jp";
    urlComponents.query = @"";
    urlComponents.path = [NSString stringWithFormat:@"/p/img/%@", [urlComponents.path lastPathComponent]];
    media.mediaURL = urlComponents.URL;
    // no fixed size exists, but set dummies.
    media.largeSize = CGSizeMake(450, 450);
    media.mediumSize = CGSizeMake(450, 450);
    media.thumbSize = CGSizeMake(120, 120);
    media.smallSize = CGSizeMake(120, 120);
}

/*!
 *  See: http://photozou.jp/basic/api#shortened_api
 */

- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/p/img/%@", [mediaURLComponents.path lastPathComponent]];
    return mediaURLComponents.URL;
}

- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/p/img/%@", [mediaURLComponents.path lastPathComponent]];
    return mediaURLComponents.URL;
}

- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/p/thumb/%@", [mediaURLComponents.path lastPathComponent]];
    return mediaURLComponents.URL;
}

- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
{
    NSURLComponents *mediaURLComponents = [NSURLComponents componentsWithURL:media.mediaURL resolvingAgainstBaseURL:YES];
    mediaURLComponents.path = [NSString stringWithFormat:@"/p/thumb/%@", [mediaURLComponents.path lastPathComponent]];
    return mediaURLComponents.URL;
}

@end
