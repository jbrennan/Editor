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
	
	NSString *bodyFileName = self.bodyFile;
	
	if (nil == bodyFileName) {
		bodyFileName = [[[self.headline lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingString:@".md"];
	}
	
	NSString *directoryPath = [[[NSUserDefaults standardUserDefaults] stringForKey:@"articleDirectory"] stringByAppendingString:@"/"];
	NSString *bodyFilePath = [directoryPath stringByAppendingString:bodyFileName];
	
	// Save the body text out to the markdown file
	NSError *bodyFileError = nil;
	if (![self.bodyText writeToFile:bodyFilePath atomically:YES encoding:NSUTF8StringEncoding error:&bodyFileError]) {
		NSLog(@"There was an error writing the article's body to the markdown file. Headline: %@, Error: %@", self.headline, [bodyFileError localizedDescription]);
		return;
	}
	
	
	// The JS filename and path
	NSString *jsFileName = self.metaFile;
	if (nil == jsFileName) {
		jsFileName = [[[self.headline lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"] stringByAppendingString:@".js"];
	}
	
	NSString *jsFilePath = [directoryPath stringByAppendingString:jsFileName];
	
	// Create the Dictionary
	NSMutableDictionary *articleDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
	[articleDictionary setObject:self.headline ? self.headline : @"" forKey:kHeadlineKey];
	[articleDictionary setObject:self.lede ? self.lede : @"" forKey:kLedeKey];
	[articleDictionary setObject:self.byLine ? self.byLine : @"" forKey:kByLineKey];
	[articleDictionary setObject:self.altText ? self.altText : @"" forKey:kAltTextKey];
	[articleDictionary setObject:self.authorName ? self.authorName : @"" forKey:kAuthorNameKey];
	//[articleDictionary setObject:self.authorEmail forKey:kAuthorEmailKey];
	[articleDictionary setObject:self.sourceLink ? self.sourceLink : @"self" forKey:kSourceLinkKey];
	
	
	// Format the dates so they may be saved as a string
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
	
	NSString *createdAtString = [[dateFormatter stringFromDate:self.createdAtDate] stringByReplacingOccurrencesOfString:@"," withString:@""];
	NSString *updatedAtString = [[dateFormatter stringFromDate:self.updatedAtDate] stringByReplacingOccurrencesOfString:@"," withString:@""];
	
	[dateFormatter release];
	
	NSDate *testDate = [NSDate dateWithNaturalLanguageString:createdAtString];
	
	if ([testDate isEqualToDate:self.createdAtDate])
		NSLog(@"Round trip dates!!");
	
	//return;
	
	[articleDictionary setObject:createdAtString ? createdAtString : @"" forKey:kCreatedAtKey];
	[articleDictionary setObject:updatedAtString ? updatedAtString : @"" forKey:kUpdatedAtKey];
	[articleDictionary setObject:bodyFileName ? bodyFileName : @"" forKey:kBodyFileKey];
	
	
	// Create a JSON representation for the article
	SBJSON *articleJSON = [[SBJSON alloc] init];
	[articleJSON setHumanReadable:YES];
	NSString *jsonString = [articleJSON stringWithObject:articleDictionary];
	
	
	NSError *jsonFileError = nil;
	if (![jsonString writeToFile:jsFilePath atomically:YES encoding:NSUTF8StringEncoding error:&jsonFileError]) {
		NSLog(@"There was an error writing the JS file to disk. Headline: %@, error: %@", self.headline, [jsonFileError localizedDescription]);
		return;
	}
	
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
