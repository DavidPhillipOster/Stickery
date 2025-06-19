//
//  StickTextView.m
//  Stuckery
//
//  Created by david on 7/3/24.
//

#import "StickTextView.h"

/// Return a copy of the attributed string with all references to NSBackgroundColorAttributeName removed.
NSAttributedString *_Nullable StickRemoveBackgroundColor(NSAttributedString *_Nullable sIn) {
  if (nil == sIn){ return nil; }
  NSMutableAttributedString *s = [sIn mutableCopy];
  [sIn enumerateAttributesInRange:NSMakeRange(0, sIn.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> *attrs, NSRange range, BOOL *stop) {
    if (nil != attrs[NSBackgroundColorAttributeName]) {
      NSMutableDictionary *newAttrs = [attrs mutableCopy];
      newAttrs[NSBackgroundColorAttributeName] = nil;
      [s setAttributes:newAttrs range:range];
    }
  }];
  return s;
}

@implementation StickTextView

/// Override reading the pasteboard by passing super a new pasteboard with modified contents.
 - (BOOL)readSelectionFromPasteboard:(NSPasteboard *)pboard type:(NSPasteboardType)type {
  if ([type isEqual:@"NeXT Rich Text Format v1.0 pasteboard type"]) {
    NSArray *a = [pboard readObjectsForClasses:@[ [NSAttributedString class] ] options:nil];
    if (a.count == 1) {
      NSPasteboard *myBoard = [NSPasteboard pasteboardWithUniqueName];
      NSAttributedString *newString = StickRemoveBackgroundColor(a[0]);
      [myBoard writeObjects:@[newString]];
      return [super readSelectionFromPasteboard:myBoard type:type];
    }
  }
  return [super readSelectionFromPasteboard:pboard type:type];
}


/*
In a paste, the overrides are NOT called.:
- (void)replaceCharactersInRange:(NSRange)range withRTF:(NSData *)rtfData
- (void)replaceCharactersInRange:(NSRange)range withRTF:(NSData *)rtfData;
Rich text is coming through with a type, found by examination.
 */
// 7/03/2024 - the following also works, but the temp pasteboard implementation seems cleaner to me.
//
//- (BOOL)readSelectionFromPasteboard:(NSPasteboard *)pboard type:(NSPasteboardType)type {
//  if ([type isEqual:@"NeXT Rich Text Format v1.0 pasteboard type"]) {
//    NSArray *a = [pboard readObjectsForClasses:@[ [NSAttributedString class] ] options:nil];
//    if (a.count == 1) {
//      NSAttributedString *newString = StickRemoveBackgroundColor(a[0]);
//      NSUInteger oldStart = self.selectedRange.location;
//      NSAttributedString *oldString = [self.textStorage attributedSubstringFromRange:self.selectedRange];
//      [self stickUndoablyPasteAt:oldStart oldAString:oldString newAString:newString];
//      [[self undoManager] setActionName:@"Paste"];
//      return YES;
//    }
//  }
//  return [super readSelectionFromPasteboard:pboard type:type];
//}
//
//- (void)stickUndoablyPasteAt:(NSUInteger)location oldAString:(NSAttributedString *)oldString  newAString:(NSAttributedString *)newString {
//  [[[self undoManager] prepareWithInvocationTarget:self] stickUndoablyPasteAt:location oldAString:newString newAString:oldString];
//  [[self textStorage] replaceCharactersInRange:NSMakeRange(location, oldString.length) withAttributedString:newString];
//  if ([[self undoManager] isUndoing]) {
//    [self setSelectedRange:NSMakeRange(location, newString.length)];
//  } else {
//    [self setSelectedRange:NSMakeRange(location + newString.length, 0)];
//  }
//}



@end
