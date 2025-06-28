//  StickAppDelegate.m
//  Stick
//
//  Created by David Phillip Oster on 3/24/24. Apache License.
//

#import "StickAppDelegate.h"

#import "StickDocument.h"

/// @return the first menuitem with tag that matches.
static NSMenuItem *ItemHasTag(NSArray<NSMenuItem *> *a, int tag){
  for (NSMenuItem *item in a) {
    if (item.tag == tag) {
      return item;
    }
  }
  return nil;
}

@implementation StickAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self setupColorMenu];
  [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"NSQuitAlwaysKeepsWindows"];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

- (void)setupColorMenu {
  NSMenu *mainMenu = NSApp.mainMenu;
  NSArray *items = [mainMenu itemArray];
  NSMenuItem *colorMenuItem = ItemHasTag(items, 999);
  NSMenu *colorMenu = colorMenuItem.submenu;
  NSArray *colorList = @[
    @"Yellow",
    @"Blue",
    @"Green",
    @"Pink",
    @"Purple"
  ];
  for (NSString *color in colorList) {
    NSDictionary *attr = @{
      NSFontAttributeName: [NSFont menuFontOfSize:0]
    };
    NSString *color1 = [NSString stringWithFormat:@" %@", NSLocalizedString(color, @"")];
    NSAttributedString *name = [[NSAttributedString alloc] initWithString:color1 attributes:attr];
    NSDictionary *attr1 = @{
      NSFontAttributeName: [NSFont menuFontOfSize:0],
      NSForegroundColorAttributeName: [NSColor colorNamed:color]
    };
    // the hex is 3 copies of full box draw character, in UTF-8 █
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:@"\xE2\x96\x88\xE2\x96\x88\xE2\x96\x88" attributes:attr1];
    [as appendAttributedString:name];
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.attributedTitle = as;
    menuItem.action = @selector(backColor:);
    [colorMenu addItem:menuItem];
  }
}


@end
