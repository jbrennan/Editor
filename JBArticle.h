//
//  JBArticle.h
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kHeadlineKey @"headline"
#define kLedeKey @"lede"
#define kAuthorNameKey @"author"
#define kByLineKey @"by_line"
#define kAltTextKey @"alt_text"
#define kBodyFileKey @"body_text" // not a bug!!
#define kSourceLinkKey @"source"
#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"

@interface JBArticle : NSObject {
	NSString *_headline;
	NSString *_lede;
	NSString *_byLine;
	NSString *_altText;
	NSString *_authorName;
	NSString *_authorEmail;
	NSString *_sourceLink;
	NSString *_bodyFile;
	NSString *_metaFile;
	NSDate *_createdAtDate;
	NSDate *_updatedAtDate;
	
	NSString *_bodyText;
	
	BOOL _articleUpdated;
	
}

@property (nonatomic, copy) NSString *headline;
@property (nonatomic, copy) NSString *lede;
@property (nonatomic, copy) NSString *byLine;
@property (nonatomic, copy) NSString *altText;
@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorEmail;
@property (nonatomic, copy) NSString *sourceLink;
@property (nonatomic, copy) NSString *bodyFile;
@property (nonatomic, copy) NSString *metaFile;
@property (nonatomic, retain) NSDate *createdAtDate;
@property (nonatomic, retain) NSDate *updatedAtDate;
@property (nonatomic, copy) NSString *bodyText;
@property (getter=isArticleUpdated) BOOL articleUpdated;


- (id)initNewArticle;
- (void)saveIfNeeded;

@end
