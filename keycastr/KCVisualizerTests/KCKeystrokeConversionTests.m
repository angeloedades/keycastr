//  Copyright (c) 2020-2024 Andrew Kitchen
//
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  *    Redistributions of source code must retain the above copyright notice, this
//      list of conditions and the following disclaimer.
//  *    Redistributions in binary form must reproduce the above copyright notice,
//      this list of conditions and the following disclaimer in the documentation
//      and/or other materials provided with the distribution.
//  *    Neither the name KeyCastr nor the names of its contributors may be used to
//      endorse or promote products derived from this software without specific
//      prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THKCVisualizerTestsE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <XCTest/XCTest.h>
#import "KCKeystroke.h"

/**
 NOTE: This is not a comprehensive set of tests, but serves as a sanity check for handling letters vs. numbers when certain modifiers are applied.

 These tests were written assuming a US-English layout. They may break when run in other locales unless the keyboard layout is overridden.

 The correct ordering for printing out modifiers should be Control-Option-Shift-Command, according to how they're displayed in menus within Apple's apps.
 */
@interface KCKeystrokeConversionTests : XCTestCase

@end

@implementation KCKeystrokeConversionTests

- (KCKeystroke *)keystrokeWithKeyCode:(unsigned short)keyCode modifiers:(NSEventModifierFlags)modifiers characters:(NSString *)characters charactersIgnoringModifiers:(NSString *)charactersIgnoringModifiers {
    NSEvent *fakeEvent = [NSEvent keyEventWithType:NSEventTypeKeyDown
                                          location:NSZeroPoint
                                     modifierFlags:modifiers
                                         timestamp:NSDate.timeIntervalSinceReferenceDate
                                      windowNumber:0
                                           context:nil
                                        characters:characters
                       charactersIgnoringModifiers:charactersIgnoringModifiers
                                         isARepeat:NO
                                           keyCode:keyCode];
    return [[KCKeystroke alloc] initWithNSEvent:fakeEvent];
}

#pragma mark - Numbers

- (void)test_KCKeystroke_convertsCtrlNumberToNumber {
    // ctrl-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:26 modifiers:262401 characters:@"7" charactersIgnoringModifiers:@"7"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃7");
}

- (void)test_KCKeystroke_convertsShiftNumberToShiftNumber {
    // shift-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:26 modifiers:131330 characters:@"&" charactersIgnoringModifiers:@"&"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⇧7");
}

- (void)test_KCKeystroke_convertsCtrlShiftNumberToNumber {
    // ctrl-shift-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:26 modifiers:393475 characters:@"7" charactersIgnoringModifiers:@"&"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃⇧7");
}

- (void)test_KCKeystroke_convertsCmdNumberToNumber {
    // cmd-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:26 modifiers:1048840 characters:@"7" charactersIgnoringModifiers:@"7"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌘7");
}

- (void)test_KCKeystroke_convertsCmdShiftNumberToNumber {
    // cmd-shift-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:26 modifiers:1179914 characters:@"7" charactersIgnoringModifiers:@"&"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⇧⌘7");
}

- (void)test_KCKeystroke_convertsCmdOptNumberToNumber {
    // cmd-opt-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode: 26 modifiers: 1573160 characters:@"¶" charactersIgnoringModifiers:@"7"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌥⌘7");
}

- (void)test_KCKeystroke_convertsShiftOptionNumberToNumber {
    // shift-opt-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:26 modifiers:655650 characters:@"»" charactersIgnoringModifiers:@"7"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌥⇧7");
}

- (void)test_KCKeystroke_convertsCmdOptShiftNumberToShiftedNumber {
    // cmd-opt-shift-7
    KCKeystroke *keystroke = [self keystrokeWithKeyCode: 26 modifiers: 1704234 characters:@"‡" charactersIgnoringModifiers:@"&"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌥⇧⌘7");
}


#pragma mark - Letters

- (void)test_KCKeystroke_convertsCtrlLetterToUppercaseLetter {
    // ctrl-A
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:0 modifiers:262401 characters:@"\\^A" charactersIgnoringModifiers:@"a"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃A");
}

- (void)test_KCKeystroke_convertsCtrlShiftLetterToLetter {
    // ctrl-shift-A
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:0 modifiers:393475 characters:@"\\^A" charactersIgnoringModifiers:@"a"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃⇧A");
}

- (void)test_KCKeystroke_convertsCtrlShiftCmdLetterToLetter {
    // ctrl-shift-cmd-A
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:0 modifiers:1442059 characters:@"\\^A" charactersIgnoringModifiers:@"A"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃⇧⌘A");
}

- (void)test_KCKeystroke_convertsCtrlOptLetterToUppercaseLetter {
    // crtl-opt-A
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:0 modifiers:786721 characters:@"\\^A" charactersIgnoringModifiers:@"a"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃⌥A");
}

- (void)test_KCKeystroke_convertsCtrlOptShiftLetterToLetter {
    // ctrl-opt-shift-A
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:0 modifiers:917795 characters:@"\\^A" charactersIgnoringModifiers:@"A"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌃⌥⇧A");
}

- (void)test_KCKeystroke_convertsOptLetterToShiftedLetter {
    // opt-U
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:32 modifiers:524576 characters:@"" charactersIgnoringModifiers:@"u"];
    XCTAssertEqualObjects(keystroke.convertToString, @"⌥u");
}

#pragma mark - Function Row

- (void)test_KCKeystroke_convertsFnF1ToBrightnessDecrease {
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:145 modifiers:8388864 characters:@"" charactersIgnoringModifiers:@""];
    XCTAssertEqualObjects(keystroke.convertToString, @"🔅");
}

- (void)test_KCKeystroke_convertsFnF2ToBrightnessIncrease {
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:144 modifiers:8388864 characters:@"" charactersIgnoringModifiers:@""];
    XCTAssertEqualObjects(keystroke.convertToString, @"🔆");
}

- (void)test_KCKeystroke_convertsFnF3ToMissionControl {
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:160 modifiers:8388864 characters:@"" charactersIgnoringModifiers:@""];
    XCTAssertEqualObjects(keystroke.convertToString, @"🖥");
}

- (void)test_KCKeystroke_convertsFnF4ToLauncher {
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:131 modifiers:8388864 characters:@"" charactersIgnoringModifiers:@""];
    XCTAssertEqualObjects(keystroke.convertToString, @"🚀");
}

#pragma mark - JIS layout

- (void)test_KCKeystroke_convertsEisūKey {
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:102 modifiers:0 characters:@"" charactersIgnoringModifiers:@""];
    XCTAssertEqualObjects(keystroke.convertToString, @"英数");
}

- (void)test_KCKeystroke_convertsKanaKey {
    KCKeystroke *keystroke = [self keystrokeWithKeyCode:104 modifiers:0 characters:@"" charactersIgnoringModifiers:@""];
    XCTAssertEqualObjects(keystroke.convertToString, @"かな");
}

@end
