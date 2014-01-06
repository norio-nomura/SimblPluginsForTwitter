//
//  ImageServiceManager.h
//  SimblPluginsForTwitter
//

#import <Foundation/Foundation.h>
#import "TwitterMacProtocols.h"

@protocol ImageService;
@protocol SimblPluginsForTwitter_TwitterEntityMedia;

@interface ImageServiceManager : NSObject

/**
 * @return the single static instance of the manager object
 */
+ (instancetype) manager;

/*!
 *  Add ImageServie to manager
 *
 *  @param service for adding
 */
+ (void)addService:(id<ImageService>)service;

/*!
 *  return service for url
 *
 *  @param url target url
 *
 *  @return ImageService
 */
+ (id<ImageService>)serviceForURL:(NSURL*)url;

/*!
 *  called from +[TwitterEntitySet entitiesWithDict:]
 *
 *  @param urlInfo dictionary
 *
 *  @return mediaInfo dictionary
 */
+ (NSDictionary*)mediaInfoFromUrlInfo:(NSDictionary*)urlInfo;

/*!
 *  called from -[TwitterEntityMedia parseDict:]
 *
 *  @param dict  media dictionary
 *  @param media TwitterEntityMedia.
 */
+ (void)parseDict:(NSDictionary*)dict forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;

/*!
 *  return URL for image
 *
 *  @param media TwitterEntityMedia
 *
 *  @return URL for image
 */
+ (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
+ (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
+ (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
+ (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;

@end

@protocol ImageService
/*!
 *  return Yes if service can handle url.
 *
 *  @param url target url
 *
 *  @return Yes if service can handle url.
 */
- (BOOL)canHandleURL:(NSURL*)url;

/*!
 *  called from -[ImageServiceManager mediaInfoFromUrlInfo:]
 *
 *  @param urlInfo urlDictionary
 *
 *  @return media dictionary must have {
 *    "media_url": <url string>
 *    "media_url_https": <url string>
 *  }
 */
- (NSDictionary*)mediaInfoFromUrlInfo:(NSDictionary*)urlInfo;

/*!
 *  called from -[ImageServiceManager parseDict:forTwitterEntityMedia:]
 *
 *  @param dict  media dictionary
 *  @param media TwitterEntityMedia
 */
- (void)parseDict:(NSDictionary*)dict forTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;

/*!
 *  return URL for image
 *
 *  @param media TwitterEntityMedia
 *
 *  @return URL for image
 */
- (NSURL*)largeURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
- (NSURL*)mediumURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
- (NSURL*)smallURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;
- (NSURL*)thumbURLForTwitterEntityMedia:(id<SimblPluginsForTwitter_TwitterEntityMedia>)media;

@optional

@end