"Filed out from Dolphin Smalltalk"!

Graphics.Tests.SystemFontTest
	subclass: #'Graphics.Tests.UxThemeFontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.UxThemeFontTest guid: (Core.GUID fromString: '{9c30cbb9-247a-4903-88ae-6259c8ea2380}')!

Graphics.Tests.UxThemeFontTest comment: ''!

!Graphics.Tests.UxThemeFontTest methodsFor!

canonicalSubject
	^UxThemeFont iconTitle!

testAtDpi
	| subject subject150 sysDpi |
	subject := self canonicalSubject.
	sysDpi := SystemMetrics current dpi.
	self assert: subject dpi equals: sysDpi.
	self assert: (subject atDpi: sysDpi) identicalTo: subject.
	subject150 := subject atDpi: sysDpi * 1.5.
	self deny: subject150 identicalTo: subject.
	self assert: subject150 equals: subject.
	self assert: subject150 dpi equals: sysDpi * 1.5.
	self assert: (subject150 atDpi: sysDpi) identicalTo: subject.
	self assert: subject150 printString equals: subject printString.
	self assert: subject150 displayString equals: subject displayString.!

testCaption
	| subject captionFont |
	subject := UxThemeFont caption.
	captionFont := SystemMetrics current captionFont.
	self assert: captionFont logFont equals: subject logFont.
	self assert: captionFont equals: subject copy.
	self assert: subject printString equals: 'Graphics.UxThemeFont caption'!

testMenu
	| subject smFont |
	subject := UxThemeFont menu.
	smFont := SystemMetrics current menuFont.
	self assert: smFont logFont equals: subject logFont.
	self assert: smFont equals: subject copy.
	self assert: subject printString equals: 'Graphics.UxThemeFont menu'!

testMessage
	| subject smFont |
	subject := UxThemeFont messageBox.
	smFont := SystemMetrics current messageFont.
	self assert: smFont logFont equals: subject logFont.
	self assert: smFont equals: subject copy.
	self assert: subject printString equals: 'Graphics.UxThemeFont messageBox'!

testSmallCaption
	| subject smCaptionFont |
	subject := UxThemeFont smallCaption.
	smCaptionFont := SystemMetrics current smallCaptionFont.
	self assert: smCaptionFont logFont equals: subject logFont.
	self assert: smCaptionFont equals: subject copy.
	self assert: subject printString equals: 'Graphics.UxThemeFont smallCaption'!

testStatus
	| subject smFont |
	subject := UxThemeFont status.
	smFont := SystemMetrics current statusFont.
	self assert: smFont logFont equals: subject logFont.
	self assert: smFont equals: subject copy.
	self assert: subject printString equals: 'Graphics.UxThemeFont status'! !

!Graphics.Tests.UxThemeFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testCaption!public! !
testMenu!public! !
testMessage!public! !
testSmallCaption!public! !
testStatus!public! !
!

