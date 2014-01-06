//
//  TwitterMacProtocols.h
//  SimblPluginsForTwitter
//

#import <Foundation/Foundation.h>

@protocol SimblPluginsForTwitter_ABHTTPRequest

@property(copy, nonatomic) NSURL *url;
- (void)startRequest;
- (void)setValue:(id)arg1 forHTTPHeaderField:(id)arg2;

@end

@protocol SimblPluginsForTwitter_TwitterEntityMedia

@property(retain, nonatomic) NSString *mediaID;
@property(retain, nonatomic) NSURL *mediaURL;
@property(nonatomic) int mediaType;
@property(nonatomic) struct CGSize largeSize;
@property(nonatomic) struct CGSize mediumSize;
@property(nonatomic) struct CGSize thumbSize;
@property(nonatomic) struct CGSize smallSize;
- (id)largeURL;
- (id)mediumURL;
- (id)smallURL;
- (id)thumbURL;
- (void)parseDict:(id)arg1;

@end

@protocol SimblPluginsForTwitter_TwitterEntitySet

@property(readonly, nonatomic) id<SimblPluginsForTwitter_TwitterEntityMedia> media;
+ (id)entitiesWithDict:(NSDictionary*)dict;

@end

@protocol SimblPluginsForTwitter_TwitterStatus

@property(retain, nonatomic) id<SimblPluginsForTwitter_TwitterEntitySet> entities;

@end

@protocol SimblPluginsForTwitter_TMStatusCell

@property(retain, nonatomic) id<SimblPluginsForTwitter_TwitterStatus> status;

@end

@protocol SimblPluginsForTwitter_TMDetailedStatusCell<SimblPluginsForTwitter_TMStatusCell>

- (void)didDownloadPhoto:(NSData*)data info:(id)arg2;

@end
