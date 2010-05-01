//
//  JBMainWindowController.m
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBMainWindowController.h"
#import "JBArticle.h"
#import "JSON.h"

#define kHeadlineKey @"headline"
#define kLedeKey @"lede"
#define kAuthorNameKey @"author"
#define kByLineKey @"by_line"
#define kAltTextKey @"alt_text"
#define kBodyFileKey @"body_text" // not a bug!!
#define kSourceLinkKey @"source"
#define kCreatedAtKey @"created_at"
#define kUpdatedAtKey @"updated_at"


@implementation JBMainWindowController
@synthesize tableView = _tableView;
@synthesize textView = _textView;
@synthesize textField = _textField;
@synthesize arrayController = _arrayController;
@synthesize internalArrayOfArticles = _internalArrayOfArticles;

- (void)awakeFromNib {
	
	
	self.internalArrayOfArticles = [NSMutableArray array];
	[self loadArticlesFromDisk];
	
	
	
}


- (IBAction)addAction:(id)sender {
	NSLog(@"Add button pressed");
}


- (void)loadArticlesFromDisk {
	NSString *articlesDirectoryPath = @"/Users/jasonbrennan/web/app/articles/";
	
	NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
	
	NSError *error = nil;
	NSArray *articlesInDirectory = [fileManager contentsOfDirectoryAtPath:articlesDirectoryPath error:&error];
	
	if (nil == articlesInDirectory) {
		NSLog(@"The articles directory path returned a nil array. Error says: %@", [error localizedDescription]);
		return;
	}
	
	NSLog(@"%@", [articlesInDirectory description]);
	
	// Get all the .js files in the directory
	NSPredicate *jsPredicate = [NSPredicate predicateWithFormat:@"self LIKE '*.js'"];
	NSArray *filteredArray = [articlesInDirectory filteredArrayUsingPredicate:jsPredicate];
	
	NSLog(@"%@", [filteredArray description]);
	
	[fileManager changeCurrentDirectoryPath:articlesDirectoryPath];
	
	for (NSString *jsFileName in filteredArray) {
		NSError *fileReadingError = nil;
		NSString *jsonString = [NSString stringWithContentsOfFile:jsFileName encoding:NSUTF8StringEncoding error:&fileReadingError];
		
		if (nil == jsonString) {
			NSLog(@"There was an error reading in %@: %@", jsFileName, [fileReadingError localizedDescription]);
		}
		
		SBJSON *parser = [[[SBJSON alloc] init] autorelease];
		NSDictionary *articleDictionary = [parser objectWithString:jsonString];
		

		
		JBArticle *readArticle = [[JBArticle alloc] init];
		readArticle.headline = [articleDictionary objectForKey:kHeadlineKey];
		readArticle.lede = [articleDictionary objectForKey:kLedeKey];
		readArticle.authorName = [articleDictionary objectForKey:kAuthorNameKey];
		readArticle.byLine = [articleDictionary objectForKey:kByLineKey];
		readArticle.altText = [articleDictionary objectForKey:kAltTextKey];
		readArticle.bodyFile = [articleDictionary objectForKey:kBodyFileKey];
		readArticle.bodyText = [NSString stringWithContentsOfFile:readArticle.bodyFile encoding:NSUTF8StringEncoding error:NULL];
		readArticle.sourceLink = [articleDictionary objectForKey:kSourceLinkKey];
		
		readArticle.createdAtDate = [NSDate dateWithNaturalLanguageString:[articleDictionary objectForKey:kCreatedAtKey]];
		readArticle.updatedAtDate = [NSDate dateWithNaturalLanguageString:[articleDictionary objectForKey:kUpdatedAtKey]];
		
		[self.arrayController addObject:readArticle];
		
		[readArticle release];
	}
	
}


- (void)dealloc {
	
	self.tableView = nil;
	self.textView = nil;
	self.textField = nil;
	self.arrayController = nil;
	
	[super dealloc];
}


@end
