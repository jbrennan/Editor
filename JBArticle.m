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


- (id)init {
	if (self = [super init]) {
		self.headline = @"New headline";
		self.updatedAtDate = [NSDate date];
		self.bodyText = @"This is a somewhat long string used to illustrate the bindings";
		// etcetera
	}
	
	return self;
}


- (void)dealloc {
	
	// oh bother
	
	[super dealloc];
}

@end
