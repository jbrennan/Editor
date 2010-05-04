//
//  EditorAppDelegate.h
//  Editor
//
//  Created by Jason Brennan on 10-04-04.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JBPreferencesWindowController;
@class JBMainWindowController;
@interface EditorAppDelegate : NSObject <NSApplicationDelegate> {

	
	JBPreferencesWindowController *_preferencesController;
	
	JBMainWindowController *_mainWindowController;
}

@property (nonatomic, retain) JBPreferencesWindowController *preferencesController;
@property (nonatomic, retain) JBMainWindowController *mainWindowController;

- (IBAction)showPreferences:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
