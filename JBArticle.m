//
//  JBArticle.m
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBArticle.h"


@implementation JBArticle
@synthesize headline = _headline;
@synthesize lede = _lede;
@synthesize byLine = _byLine;
@synthesize altText = _altText;
@synthesize authorName = _authorName;
@synthesize authorEmail = _authorEmail;
@synthesize sourceLink = _sourceLink;
@synthesize bodyFile = _bodyFile;
@synthesize metaFile = _metaFile;
@synthesize createdAtDate = _createdAtDate;
@synthesize updatedAtDate = _updatedAtDate;
@synthesize bodyText = _bodyText;


#pragma mark -
#pragma mark Object Lifecycle

- (id)init {
	if (self = [super init]) {
		_articleUpdated = NO;
	}
	
	return self;
}


- (id)initNewArticle {
	if (self = [super init]) {
		_articleUpdated = YES;
		self.createdAtDate = [NSDate date];
		self.updatedAtDate = [NSDate date];
	}
	
	return self;
}


- (void)dealloc {
	
	// oh bother
	
	[super dealloc];
}


- (void)save {
	_articleUpdated = NO; // because we've saved, now the article can again be changed so we must track that
}


#pragma mark -
#pragma mark Custom accessors

- (void)setUpdatedAtDate:(NSDate *)newUpdatedDate {
	if ([newUpdatedDate isEqualToDate:_updatedAtDate])
		return;
	
	[_updatedAtDate release];
	_updatedAtDate = [_updatedAtDate retain];
	
	if (nil != newUpdatedDate)
		_articleUpdated = YES;
}


@end
