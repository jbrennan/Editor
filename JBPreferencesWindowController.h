//
//  JBPreferencesWindowController.h
//  Editor
//
//  Created by Jason Brennan on 10-04-06.
//  Copyright 2010 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface JBPreferencesWindowController : NSWindowController {
	NSTextField *pathTextField;
}

@property (nonatomic, retain) IBOutlet NSTextField *pathTextField;

- (IBAction)browse:(id)sender;

@end
