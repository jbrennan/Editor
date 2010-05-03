//
//  JBPreferencesWindowController.m
//  Editor
//
//  Created by Jason Brennan on 10-04-06.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "JBPreferencesWindowController.h"


@implementation JBPreferencesWindowController
@synthesize pathTextField;

- (IBAction)browse:(id)sender {
	NSLog(@"Browse");
	
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
	
	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (NSFileHandlingPanelOKButton == result) {
			[[NSUserDefaults standardUserDefaults] setObject:[[openPanel URL] path] forKey:@"articleDirectory"];
		}
	}];
}


@end
