//
//  JBMainWindowController.m
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBMainWindowController.h"
#import "JBArticle.h"

@implementation JBMainWindowController
@synthesize tableView = _tableView;
@synthesize textView = _textView;
@synthesize textField = _textField;
@synthesize arrayController = _arrayController;
@synthesize internalArrayOfArticles = _internalArrayOfArticles;

- (void)awakeFromNib {
	self.internalArrayOfArticles = [NSMutableArray array];
	
	
	JBArticle *a1 = [[JBArticle alloc] init];
	JBArticle *a2 = [[JBArticle alloc] init];
	
	a1.headline = @"Wickedsweet first headline";
	
	[self.arrayController addObject:a1];
	[self.arrayController addObject:a2];
	
	
}

- (IBAction)addAction:(id)sender {
	NSLog(@"Add button pressed");
}


- (void)dealloc {
	
	self.tableView = nil;
	self.textView = nil;
	self.textField = nil;
	self.arrayController = nil;
	
	[super dealloc];
}


@end
