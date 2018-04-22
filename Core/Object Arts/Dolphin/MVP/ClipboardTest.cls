"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ClipboardTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClipboardTest guid: (GUID fromString: '{ea86f353-088f-4e28-b4db-bdb8b09e5e82}')!
ClipboardTest comment: ''!
!ClipboardTest categoriesForClass!Unclassified! !
!ClipboardTest methodsFor!

setUp
	Clipboard current empty!

tearDown
	Clipboard current empty!

testAnsiString
	| actual expected |
	expected := Character byteCharacterSet copyFrom: 2.
	expected copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #String).
	self assert: (Clipboard current isFormatAvailable: #AnsiString).
	actual := Clipboard current getRegisteredFormat: #AnsiString ifNone: [''].
	self assert: actual isKindOf: AnsiString.
	self assert: actual equals: expected!

testBitmap
	| actual expected |
	expected := (Bitmap
				fromFile: 'Resources\Beach ball.bmp'
				usingLocator: FileLocator installRelative).
	expected copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #Bitmap).
	actual := Clipboard current getBitmap.
	self assert: actual isKindOf: Bitmap.
	self assert: actual asByteArray equals: expected asByteArray!

testDIBSection
	| actual expected |
	expected := Clipboard icon asMenuBitmap.
	expected copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #DIBSection).
	actual := Clipboard current getDIBSection.
	self assert: actual isKindOf: DIBSection.
	self assert: actual asByteArray equals: expected asByteArray!

testRichText
	| richText actual |
	richText := RichText fromString: self unicodeString.
	richText copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #RichText).
	self deny: (Clipboard current isFormatAvailable: #String).
	self deny: (Clipboard current isFormatAvailable: #AnsiString).
	actual := Clipboard current getRegisteredFormat: #RichText ifNone: [''].
	self assert: actual equals: richText.
	self assert: richText asString equals: self unicodeString!

testUtf16String
	| utf16 actual |
	utf16 := self unicodeString asUtf16String.
	utf16 copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #String).
	self assert: (Clipboard current isFormatAvailable: #AnsiString).
	actual := Clipboard current getText.
	self assert: actual equals: utf16!

testUtf8String
	| utf8 actual |
	utf8 := self unicodeString asUtf8String.
	utf8 copyToClipboard.
	self assert: (Clipboard current isFormatAvailable: #String).
	self assert: (Clipboard current isFormatAvailable: #AnsiString).
	"We'll get back UTF-16, but the content should be the same."
	actual := Clipboard current getText.
	self assert: actual equals: utf8!

unicodeString
	^'aƒ1Библиотека🐬£€文字化け'! !
!ClipboardTest categoriesFor: #setUp!private!running! !
!ClipboardTest categoriesFor: #tearDown!private!running! !
!ClipboardTest categoriesFor: #testAnsiString!public!unit tests! !
!ClipboardTest categoriesFor: #testBitmap!public!unit tests! !
!ClipboardTest categoriesFor: #testDIBSection!public!unit tests! !
!ClipboardTest categoriesFor: #testRichText!public!unit tests! !
!ClipboardTest categoriesFor: #testUtf16String!public!unit tests! !
!ClipboardTest categoriesFor: #testUtf8String!public!unit tests! !
!ClipboardTest categoriesFor: #unicodeString!constants!private! !

