//
//  EditorAppDelegate.m
//  Editor
//
//  Created by Jason Brennan on 10-04-04.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import "EditorAppDelegate.h"
#import "JBPreferencesWindowController.h"
#import "JBMainWindowController.h"

@implementation EditorAppDelegate

@synthesize preferencesController = _preferencesController;
@synthesize mainWindowController = _mainWindowController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	// Create the main window controller and order it front
	_mainWindowController = [[JBMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
	
	[[_mainWindowController window] makeKeyWindow];
}


- (JBPreferencesWindowController *)preferencesController {
	if (nil != _preferencesController)
		return _preferencesController;
	
	_preferencesController = [[JBPreferencesWindowController alloc] initWithWindowNibName:@"JBEditorPreferences"];
	
	return _preferencesController;
}


- (IBAction)showPreferences:(id)sender {
	[[self preferencesController] showWindow:self];
}


- (IBAction)saveAction:(id)sender {
	[[self mainWindowController] saveAction:self];
}


- (IBAction)publish:(id)sender {
	[self saveAction:self];
	
	NSString *launchPath = @"/usr/local/git/bin/git";
	NSString *directoryPath = [[NSUserDefaults standardUserDefaults] stringForKey:@"articleDirectory"];
	
	NSTask *task;
	task = [[NSTask alloc] init];
	[task setLaunchPath: @"/usr/local/git/bin/git"];
	[task setCurrentDirectoryPath:directoryPath];
	
	NSArray *arguments;
	arguments = [NSArray arrayWithObjects: @"add", @".", nil];
	[task setArguments: arguments];
	
	[task launch];
	[task waitUntilExit];
	
	NSTask *commitTask = [[NSTask alloc] init];
	[commitTask setLaunchPath:launchPath];
	[commitTask setCurrentDirectoryPath:directoryPath];
	
	[commitTask setArguments:[NSArray arrayWithObjects:@"commit", @"-m", @"\"`date`\"", nil]];
	
	[commitTask launch];
	[commitTask waitUntilExit];
	
	NSTask *pushTask = [[NSTask alloc] init];
	[pushTask setLaunchPath:launchPath];
	[pushTask setCurrentDirectoryPath:directoryPath];
	[pushTask setArguments:[NSArray arrayWithObjects:@"push", nil]];
	
	[pushTask launch];
	[pushTask waitUntilExit];
	
	[task release];
	[commitTask release];
	[pushTask release];
	
}


- (void)dealloc {
	self.preferencesController = nil;
	[super dealloc];
}

@end
