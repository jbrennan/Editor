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


- (void)dealloc {
	self.preferencesController = nil;
	[super dealloc];
}

@end
