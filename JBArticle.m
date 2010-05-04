//
//  JBArticle.m
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBArticle.h"
#import "JSON.h"

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
@synthesize articleUpdated = _articleUpdated;


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


- (void)saveIfNeeded {
	
	// Don't need to save. Fail
	if (!_articleUpdated)
		return;
	
	// Create a filename and filePath for the markdown/body text
	// NOTE CHECK THAT FILE NAME DONT OVERWRITE AN EXISTING FILE NAME RIGHT
	NSString *fileName = [[[self.headline lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingString:@".md"];
	NSString *directoryPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"articleDirectory"];
	NSString *filePath = [directoryPath stringByAppendingString:fileName];
	
	// Save the body text out to the markdown file
	NSError *bodyFileError = nil;
	if (![self.bodyText writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&bodyFileError]) {
		NSLog(@"There was an error writing the article's body to the markdown file. Headline: %@, Error: %@", self.headline, [bodyFileError localizedDescription]);
		return;
	}
	
	// Create the Dictionary
	NSMutableDictionary *articleDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
	[articleDictionary setObject:self.headline forKey:kHeadlineKey];
	[articleDictionary setObject:self.lede forKey:kLedeKey];
	[articleDictionary setObject:self.byLine forKey:kByLineKey];
	[articleDictionary setObject:self.altText forKey:kAltTextKey];
	[articleDictionary setObject:self.authorName forKey:kAuthorNameKey];
	//[articleDictionary setObject:self.authorEmail forKey:kAuthorEmailKey];
	[articleDictionary setObject:self.sourceLink forKey:kSourceLinkKey];
	[articleDictionary setObject:self.createdAtDate forKey:kCreatedAtKey];
	[articleDictionary setObject:self.updatedAtDate forKey:kUpdatedAtKey];
	[articleDictionary setObject:fileName forKey:kBodyFileKey];
	
	
	// Create a JSON representation for the article
	SBJSON *articleJSON = [[SBJSON alloc] init];
	[articleJSON setHumanReadable:YES];
	//[articleJSON stringWithObject:myDict];
	
	_articleUpdated = NO; // because we've saved, now the article can again be changed so we must track that
}


#pragma mark -
#pragma mark Custom accessors


- (void)setArticleUpdated:(BOOL)isUpdated {
	_articleUpdated = isUpdated;
	
	if (isUpdated) {
		[self setUpdatedAtDate:[NSDate date]];
	}
}

//- (void)setHeadline:(NSString *)newHeadline {
//	if ([_headline isEqualToString:newHeadline])
//		return;
//	
//	if (nil != _headline || nil != newHeadline)
//		_articleUpdated = YES;
//	
//		
//}



@end
