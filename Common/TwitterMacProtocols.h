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

@protocol SimblPluginsForTwitter_TwitterEntitySet

+ (id)entitiesWithDict:(NSDictionary*)dict;

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

