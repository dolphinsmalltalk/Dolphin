"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.ClipboardTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ClipboardTest guid: (Core.GUID fromString: '{ea86f353-088f-4e28-b4db-bdb8b09e5e82}')!
UI.Tests.ClipboardTest comment: ''!
!UI.Tests.ClipboardTest methodsFor!

isUnattendedSession
	^SessionManager current isUnattended!

sampleAnsiString
	"Note that this starts with a null terminator, but should still round-trip through the clipboard"

	^Character byteCharacterSet!

sampleBitmap
	^Bitmap fromFile: 'Resources\Beach ball.bmp' usingLocator: FileLocator installRelative!

sampleDIBSection
	^Clipboard icon asMenuBitmap!

sampleRichText
	^RichText fromString: self sampleUnicodeString!

sampleUnicodeString
	^'aƒ1Библиотека🐬£€文字化け'!

setUp
	self skipUnless: [self isUnattendedSession not].
	Clipboard current empty!

tearDown
	Clipboard current empty!

testAnsiString
	"We no longer deal with CF_TEXT as it is largely obsolete, and these get copied/pasted as CF_UNICODETEXT instead. The system will make CF_TEXT available to any other application that might still need it."

	| actual expected |
	expected := self sampleAnsiString.
	expected copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #String).
	self assert: (Clipboard current isFormatIdAvailable: Win32Constants.CF_TEXT).
	self assert: (Clipboard current isFormatIdAvailable: Win32Constants.CF_LOCALE).
	actual := Clipboard current getRegisteredFormat: #String ifNone: ''.
	self assert: actual equals: expected!

testAvailableFormatsBitmaps
	| actual |
	self sampleBitmap copyToClipboard.
	actual := Clipboard current availableFormats.
	"Windows can convert between device bitmaps and DIBSections, but the native format should be listed first"
	self assert: actual equals: #(#Bitmap #DIBSection).
	self sampleDIBSection copyToClipboard.
	actual := Clipboard current availableFormats.
	self assert: actual equals: #(#DIBSection #Bitmap)!

testAvailableFormatsStrings
	| actual expected |
	self sampleUnicodeString copyToClipboard.
	actual := Clipboard current availableFormatIds.
	"For strings, we will always get both unicode and ansi string formats because Windows will convert, but the native format should be first"
	expected := {
				Win32Constants.CF_UNICODETEXT.
				Win32Constants.CF_LOCALE.
				Win32Constants.CF_TEXT.
				Win32Constants.CF_OEMTEXT
			}.
	self assert: actual equals: expected.
	self assert: Clipboard current availableFormats equals: #(#String).
	self sampleAnsiString copyToClipboard.
	actual := Clipboard current availableFormatIds.
	self assert: actual equals: expected.
	self assert: Clipboard current availableFormats equals: #(#String).
	"But Windows will not convert RTF to strings or vice versa"
	self sampleRichText copyToClipboard.
	actual := Clipboard current availableFormats.
	self assert: actual equals: #(#RichText)!

testBitmap
	| actual expected |
	expected := self sampleBitmap.
	expected copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #Bitmap).
	actual := Clipboard current getBitmap.
	self assert: actual isKindOf: Bitmap.
	self assert: actual asByteArray equals: expected asByteArray!

testDIBSection
	| actual expected |
	expected := self sampleDIBSection.
	expected copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #DIBSection).
	actual := Clipboard current getDIBSection.
	self assert: actual isKindOf: DIBSection.
	self assert: actual asByteArray equals: expected asByteArray!

testRichText
	| richText actual |
	richText := self sampleRichText.
	richText copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #RichText).
	self deny: (Clipboard current isFormatAvailable: #String).
	self deny: (Clipboard current isFormatIdAvailable: Win32Constants.CF_TEXT).
	actual := Clipboard current getRegisteredFormat: #RichText ifNone: [''].
	self assert: actual equals: richText.
	self assert: richText asString equals: self sampleUnicodeString!

testUtf16String
	| utf16 actual |
	utf16 := self sampleUnicodeString asUtf16String.
	utf16 copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #String).
	self assert: (Clipboard current isFormatIdAvailable: Win32Constants.CF_TEXT).
	self assert: (Clipboard current isFormatIdAvailable: Win32Constants.CF_LOCALE).
	actual := Clipboard current getText.
	self assert: actual encoding equals: #utf16le.
	self assert: actual equals: utf16!

testUtf8String
	| utf8 actual |
	utf8 := self sampleUnicodeString asUtf8String.
	utf8 copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #String).
	self assert: (Clipboard current isFormatIdAvailable: Win32Constants.CF_TEXT).
	self assert: (Clipboard current isFormatIdAvailable: Win32Constants.CF_LOCALE).
	"We'll get back UTF-16, but the content should be the same."
	actual := Clipboard current getText.
	self assert: actual encoding equals: #utf16le.
	self assert: actual equals: utf8! !
!UI.Tests.ClipboardTest categoriesForMethods!
isUnattendedSession!private!testing! !
sampleAnsiString!constants!private! !
sampleBitmap!constants!private! !
sampleDIBSection!constants!private! !
sampleRichText!constants!private! !
sampleUnicodeString!constants!private! !
setUp!private!running! !
tearDown!private!running! !
testAnsiString!public!unit tests! !
testAvailableFormatsBitmaps!public!unit tests! !
testAvailableFormatsStrings!public!unit tests! !
testBitmap!public!unit tests! !
testDIBSection!public!unit tests! !
testRichText!public!unit tests! !
testUtf16String!public!unit tests! !
testUtf8String!public!unit tests! !
!

