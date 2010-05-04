//
//  JBMainWindowController.h
//  Editor
//
//  Created by Jason Brennan on 10-04-28.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JBMainWindowController : NSWindowController {
	NSTableView *_tableView;
	NSTextView *_textView;
	NSTextField *_textField;
	
	NSArrayController *_arrayController;
	
	NSMutableArray *_internalArrayOfArticles;
}

@property (nonatomic, retain) IBOutlet NSTableView *tableView;
@property (nonatomic, retain) IBOutlet NSTextView *textView;
@property (nonatomic, retain) IBOutlet NSTextField *textField;
@property (nonatomic, retain) IBOutlet NSArrayController *arrayController;
@property (nonatomic, retain) NSMutableArray *internalArrayOfArticles;


- (IBAction)addNewArticle:(id)sender;
- (void)loadArticlesFromDisk;

@end
