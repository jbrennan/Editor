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

@implementation JBMainWindowController
@synthesize tableView = _tableView;
@synthesize textView = _textView;
@synthesize textField = _textField;
@synthesize arrayController = _arrayController;
@synthesize internalArrayOfArticles = _internalArrayOfArticles;

- (void)awakeFromNib {
	
	
	self.internalArrayOfArticles = [NSMutableArray array];
	[self loadArticlesFromDisk];
	
	JBArticle *a1 = [[JBArticle alloc] init];
	JBArticle *a2 = [[JBArticle alloc] init];
	
	a1.headline = @"Wickedsweet first headline";
	
	//[self.arrayController addObject:a1];
	//[self.arrayController addObject:a2];
	
	
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
		readArticle.headline = [articleDictionary objectForKey:@"headline"];
		readArticle.lede = [articleDictionary objectForKey:@"lede"];
		readArticle.authorName = [articleDictionary objectForKey:@"author"];
		readArticle.byLine = [articleDictionary objectForKey:@"by_line"];
		readArticle.altText = [articleDictionary objectForKey:@"alt_text"];
		readArticle.bodyFile = [articleDictionary objectForKey:@"body_text"];
		readArticle.bodyText = [NSString stringWithContentsOfFile:readArticle.bodyFile encoding:NSUTF8StringEncoding error:NULL];
		readArticle.sourceLink = [articleDictionary objectForKey:@"source"];
		
		readArticle.createdAtDate = [NSDate dateWithNaturalLanguageString:[articleDictionary objectForKey:@"created_at"]];
		readArticle.updatedAtDate = [NSDate dateWithNaturalLanguageString:[articleDictionary objectForKey:@"updated_at"]];
		
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
