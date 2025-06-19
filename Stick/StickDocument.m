//  StickDocument.m
//  Stick
//
//  Created by David Phillip Oster on 3/24/24. Apache License.
//

#import "StickDocument.h"

#import "StickColoredView.h"
#import "StickTextView.h"
#import "StickTitleBarView.h"

@interface StickDocument () <NSWindowDelegate>
@property(nonatomic) IBOutlet NSTextView *textView;
@property(nonatomic) IBOutlet StickColoredView *colorView;
@property(nonatomic) IBOutlet StickTitleBarView *titleBarView;
@property NSString *colorName;
@end

@implementation StickDocument {
  // we read before the window exists. Save contents here until it does.
  NSAttributedString *_earlyAS;
  CGSize _earlySize;
  int changeCount;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _colorName = @"Yellow";
    // Needed for NSTextView dark mode support.
    [NSApp addObserver:self forKeyPath:@"effectiveAppearance" options:0 context:(void *)self];
  }
  return self;
}

- (void)dealloc {
  [NSApp removeObserver:self forKeyPath:@"effectiveAppearance" context:(void *)self];
}

+ (BOOL)autosavesInPlace {
  return YES;
}


/// @return the nib file name of the document
- (NSString *)windowNibName {
  return @"Document";
}

/// currently, rtf documents only.
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
  NSTextStorage *textStorage = self.textView.textStorage;
  NSRange range = NSMakeRange(0, [textStorage length]);
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  dict[NSDocumentTypeDocumentAttribute] = NSRTFTextDocumentType;
  NSMutableArray *keys = [NSMutableArray array];
  if (_colorName) {
    [keys addObject:[NSString stringWithFormat:@"color=%@", _colorName]];
  }
  CGSize frameSize = self.windowForSheet.frame.size;
  if (1 < frameSize.width && 1 < frameSize.height) {
    [keys addObject:[NSString stringWithFormat:@"size=%d,%d", (int)frameSize.width, (int)frameSize.height]];
  }
  if (0 < keys.count) {
    dict[NSKeywordsDocumentAttribute] = keys;
  }
  NSData *data = [textStorage dataFromRange:range documentAttributes:dict error:outError];
  return data;
}


/// currently, rtf documents only.
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
  NSDictionary *dict = nil;
  NSAttributedString *as = [[NSAttributedString alloc] initWithData:data options:@{} documentAttributes:&dict error:outError];
  as = StickRemoveBackgroundColor(as);
  NSArray<NSString *> *keywords = dict[NSKeywordsDocumentAttribute];
  for (NSString *keyword in keywords) {
    if ([keyword hasPrefix:@"color="]) {
      _colorName = [keyword substringFromIndex:6];
    } else if ([keyword hasPrefix:@"size="]) {
      NSScanner *scanner = [NSScanner scannerWithString:[keyword substringFromIndex:5]];
      NSInteger x = 0, y = 0;
      if ([scanner scanInteger:&x] && [scanner scanString:@"," intoString:nil] && [scanner scanInteger:&y]) {
        _earlySize = CGSizeMake(x, y);
      }
    }
  }
  if (as) {
    NSTextStorage *textStorage = self.textView.textStorage;
    if (textStorage){
      [textStorage replaceCharactersInRange:NSMakeRange(0, [textStorage length]) withAttributedString:as];
      _earlyAS = nil;
    } else {
      _earlyAS = as;
    }
  }
  return YES;
}

- (void)makeWindowControllers {
  [super makeWindowControllers];
  if (1 < _earlySize.width && 1 < _earlySize.height) {
    CGRect frame = self.windowForSheet.frame;
    frame.size = _earlySize;
    [self.windowForSheet setFrame:frame display:YES];
  }
}

- (void)setTextView:(NSTextView *)textView {
  _textView = textView;
  if (textView) {
    textView.usesAdaptiveColorMappingForDarkAppearance = YES; // this line appears to do nothing.
    NSTextStorage *textStorage = self.textView.textStorage;
    if(_earlyAS) {
      [textStorage replaceCharactersInRange:NSMakeRange(0, [textStorage length]) withAttributedString:_earlyAS];
      _earlyAS = nil;
    }
  }
}

- (void)setWindow:(nullable NSWindow *)window {
  [super setWindow:window];
  if (window) {
    window.delegate = self;
    // disable fullscreen.
    if (@available(macOS 13.0, *)) {
      window.collectionBehavior = NSWindowCollectionBehaviorPrimary | NSWindowCollectionBehaviorFullScreenNone;
    }
    // disable the zoom button.
    NSButton *button = [window standardWindowButton:NSWindowZoomButton];
    [button setEnabled: NO];
  }
}

- (void)setTitleBarView:(StickTitleBarView *)titleBarView {
  _titleBarView = titleBarView;
  if (titleBarView) {
    NSColor *color = [NSColor colorNamed:_colorName ?: @"Yellow"];
    if (nil == color) {
      color = [NSColor colorNamed:@"Yellow"];
    }
    titleBarView.backColor = color;
  }
}

- (void)setColorView:(StickColoredView *)colorView {
  _colorView = colorView;
  if (colorView) {
    NSColor *color = [NSColor colorNamed:_colorName ?: @"Yellow"];
    if (nil == color) {
      color = [NSColor colorNamed:@"Yellow"];
    }
    colorView.backColor = color;
  }
}

// Needed for NSTextView dark mode support.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if ([keyPath isEqual:@"effectiveAppearance"] && (__bridge id)context == self) {
    self.textView.appearance = NSApp.effectiveAppearance;
    [self.titleBarView setNeedsDisplay:YES];
  }
}

- (IBAction)backColor:(NSMenuItem *)sender {
  if ([sender isKindOfClass:[NSMenuItem class]]) {
    NSColor *color = [[sender.attributedTitle attributesAtIndex:0 effectiveRange:nil] objectForKey:NSForegroundColorAttributeName];
    NSString *name = color.colorNameComponent;
    if (name) {
      self.colorName = name;
    }
    self.colorView.backColor = color;
    self.titleBarView.backColor = color;
  }
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
  SEL action = [item action];
  if (action == @selector(backColor:)) {
    // set the checkmark to the current color.
    NSColor *color = [[item.attributedTitle attributesAtIndex:0 effectiveRange:nil] objectForKey:NSForegroundColorAttributeName];
    NSString *name = color.colorNameComponent;
    item.state = [name isEqual:self.colorName];
  }
  return [super validateMenuItem:item];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
  [self.titleBarView setNeedsDisplay:YES];
}

- (void)windowDidResignKey:(NSNotification *)notification {
  [self.titleBarView setNeedsDisplay:YES];
}

- (BOOL)windowShouldClose:(NSWindow *)sender {
  return !self.documentEdited;
}

@end
