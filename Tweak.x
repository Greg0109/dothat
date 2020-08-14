#import "NSTask.h"
#import <UIKit/UIKit.h>

@interface PCSimpleTimer : NSObject
@property(assign, nonatomic) BOOL disableSystemWaking;
-(instancetype)initWithTimeInterval:(double)arg1 serviceIdentifier:(NSString *)arg2 target:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5;
-(void)scheduleInRunLoop:(id)arg1;
-(void)invalidate;
-(BOOL)isValid;
@end

@interface SpringBoard
-(void)_simulateHomeButtonPress;
-(NSString *)checkDay:(int)fix;
-(BOOL)check;
-(void)dothatalert:(int)mode;
@end

@interface SBApplication
@property (nonatomic,readonly) NSString * bundleIdentifier;                                                                                     //@synthesize bundleIdentifier=_bundleIdentifier - In the implementation block
@property (nonatomic,readonly) NSString * iconIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end

PCSimpleTimer *timer;
int timeinterval;

%hook SpringBoard
-(void)frontDisplayDidChange:(SBApplication *)arg1 {
  //NSLog(@"DoThat: %i", timeinterval);
  if ([self check]) {
    if (timer) {
      //NSLog(@"DoThat: Timer invalidated");
      [timer invalidate];
      timer = nil;
    }
    NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.greg0109.dothatapplist"];
    if ([[applist valueForKey:arg1.bundleIdentifier] boolValue]) {
      timer = [[%c(PCSimpleTimer) alloc] initWithTimeInterval:timeinterval serviceIdentifier:@"com.greg0109.dothattimer" target:self selector:@selector(timerFinished) userInfo:nil];
      timer.disableSystemWaking = NO;
      [timer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
      %orig;
    } else if ([arg1.bundleIdentifier length] == 0) {
      %orig;
    } else if ([arg1.bundleIdentifier isEqualToString:@"com.apple.Preferences"]) { //So that you can always access settings, in case of error
      %orig;
    } else {
      [self dothatalert:0];
    }
  } else {
    %orig;
  }
}

%new
-(void)timerFinished {
  //NSLog(@"DoThat: Timer finished");
  if (timer) {
    [timer invalidate];
    timer = nil;
  }
  [self dothatalert:1];
  [[NSUserDefaults standardUserDefaults] setValue:[self checkDay:0] forKey:@"DoThat-Date"];
  [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"DoThat-Status"];
}

%new
-(void)dothatalert:(int)mode {
  NSString *message;
  if (mode == 0) {
    message = @"Please, do what you are supposed to do";
  } else {
    message = @"Timer finished";
  }
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DoThat" message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    if (mode == 0) {
      [self _simulateHomeButtonPress];
    }
  }];
  [alertController addAction:cancelAction];
  [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:^{}]; // For when theres no uiview
}

%new
-(NSString *)checkDay:(int)fix {
  //NSLog(@"DoThat: Run Check 3");
  NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
  NSDate *currDate = [NSDate date];
  NSDateComponents *comp = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay ) fromDate:currDate];
  int dayInt = 0;
  if (fix == 0) {
    dayInt = [comp day];
  } else {
    dayInt = [comp day] + fix;
  }
  return [NSString stringWithFormat:@"%i", dayInt];
}

%new
-(BOOL)check {
  //NSLog(@"DoThat: Run Check 1");
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Date"] length]  == 0) {
    [[NSUserDefaults standardUserDefaults] setValue:[self checkDay:-1] forKey:@"DoThat-Date"];
  }
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Status"] length]  == 0) {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DoThat-Status"];
  }
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Status"] isEqual:@"1"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Date"] isEqualToString:[self checkDay:0]]) {
    //NSLog(@"DoThat: Run Check 2");
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DoThat-Status"];
    return TRUE;
  } else {
    return FALSE;
  }
}
%end

%ctor {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.dothatprefs.plist"];
  BOOL enabled = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : NO;
  CGFloat timeintervalfloat = prefs[@"timeinterval"] ? [prefs[@"timeinterval"] floatValue] : 10;
  timeinterval = ceil(timeintervalfloat) * 60;
  if (timer) {
    [timer invalidate];
    timer = nil;
  }
  [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DoThat-Status"];
  if (enabled) {
    %init();
  }
}
