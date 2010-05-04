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




@interface JBMainWindowController ()
- (void)startObservingArticle:(JBArticle *)article;
@end


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


- (IBAction)addNewArticle:(id)sender {
	JBArticle *newArticle = [[JBArticle alloc] initNewArticle];
	
	[self startObservingArticle:newArticle];
	
	[self.arrayController addObject:newArticle];
	
	[newArticle release];
}


- (IBAction)saveAction:(id)sender {
	[(NSArray *)[self.arrayController arrangedObjects] makeObjectsPerformSelector:@selector(saveIfNeeded)];
}


- (void)startObservingArticle:(JBArticle *)article {
	
	[article addObserver:self 
				 forKeyPath:@"headline" 
					options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
					context:NULL];
	
	[article addObserver:self 
				 forKeyPath:@"source" 
					options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
					context:NULL];
	
	[article addObserver:self 
				 forKeyPath:@"bodyText" 
					options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
					context:NULL];
	
	[article addObserver:self 
				 forKeyPath:@"altText" 
					options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
					context:NULL];
	
	[article addObserver:self 
				 forKeyPath:@"createdAtDate" 
					options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
					context:NULL];
	
	//[article addObserver:self 
//				 forKeyPath:@"updatedAtDate" 
//					options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) 
//					context:NULL];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
	if ([object isKindOfClass:[JBArticle class]]) {
		//[(JBArticle *)object setUpdatedAtDate:[NSDate date]];
		[(JBArticle *)object setArticleUpdated:YES];
		NSLog(@"Got KVO notification for an Article, have marked it as updated and changed the time");
	}
    // be sure to call the super implementation
    // if the superclass implements it
    //[super observeValueForKeyPath:keyPath
//						 ofObject:object
//						   change:change
//						  context:context];
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
		readArticle.metaFile = jsFileName;
		readArticle.sourceLink = [articleDictionary objectForKey:kSourceLinkKey];
		
		readArticle.createdAtDate = [NSDate dateWithNaturalLanguageString:[articleDictionary objectForKey:kCreatedAtKey]];
		readArticle.updatedAtDate = [NSDate dateWithNaturalLanguageString:[articleDictionary objectForKey:kUpdatedAtKey]];
		
		[self startObservingArticle:readArticle]; // Start observing AFTER everything has been initially set.
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
