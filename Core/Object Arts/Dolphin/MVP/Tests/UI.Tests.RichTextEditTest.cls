"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractMultilineTextEditTest
	subclass: #'UI.Tests.RichTextEditTest'
	instanceVariableNames: 'savedLocale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.RichTextEditTest guid: (Core.GUID fromString: '{bc34bf3f-4b1c-44a8-9c0c-b25db1e72469}')!

UI.Tests.RichTextEditTest comment: ''!

!UI.Tests.RichTextEditTest methodsFor!

classToTest
	^RichTextEdit!

margins
	^0 @ 1!

nonProportionalFont
	^Font name: 'Consolas'!

setUp
	super setUp.
	savedLocale := Locale userDefault.
	Locale userDefault: (Locale named: 'en-US')!

tearDown
	savedLocale ifNotNil: [Locale userDefault: savedLocale. savedLocale := nil].
	super tearDown!

testCharNearestPosition
	| text point char |
	#'1551'.
	text := (FileStream read: SourceManager default sourcesFileName) next: 100000.
	presenter text: text.
	{1.
		presenter view positionAtLine: 2.
		presenter view positionAtLine: 1000.
		presenter view positionAtLine: (presenter view lineFromPosition: text size // 2).
		presenter view positionAtLine: (presenter view lineFromPosition: text size)} do: 
				[:each |
				point := presenter view positionOfChar: each.
				char := presenter view charNearestPosition: point.
				self assert: char equals: each]!

testStreamInAnsiText
	| text ansi rtf actual |
	"The control asks for the text in blocks of just under 4k, so provide a little more to ensure the buffer it provides is insufficiently large to hold all the text."
	text := AnsiString writeStream: 4200.
	[text size < 4100] whileTrue: 
			[text
				nextPutAll: 'The quick brown fox jumped over the lazy dog';
				cr].
	ansi := text contents.
	presenter text: ansi.
	actual := presenter ansiText.
	self assert: actual equals: ansi.
	presenter text: ''.
	presenter ansiText: ansi.
	actual := presenter ansiText.
	self assert: actual equals: ansi.
	rtf := presenter rtfText.
	presenter text: ''.
	presenter rtfText: rtf.
	self assert: presenter rtfText equals: rtf.

	"Check selection"
	rtf := presenter rtfText.
	presenter selectAll.
	actual := presenter selectionRtf.
	self assert: actual equals: rtf.
	presenter selectLine: 10.
	self assert: (presenter selectionRtf endsWith: presenter selection , '}
').

	"Now stream in the ANSI RTF"
	rtf := presenter rtfText.
	presenter text: ''.
	presenter rtfText: rtf.
	actual := presenter ansiText.
	self assert: actual equals: ansi.
	presenter rtfText: rtf!

testStreamInUtfText
	| text rtf actual ansi |
	"The control asks for the text in blocks of just under 4k, so provide a little more to ensure the buffer it provides is insufficiently large to hold all the text."
	text := Utf8String writeStream: 4200.
	[text size < 4100] whileTrue: 
			[text
				nextPutAll: self text;
				cr].
	text := text contents.
	"This has to be converted to UTF-16 on the way in"
	presenter utfText: text.
	actual := presenter utfText.
	self assert: actual equals: text.

	"Now via UTF, which can pass UTF8 directly"
	rtf := presenter urtfText.
	"If it contains bad characters, then the stream out didn't maintain the encoded bytes correctly"
	self deny: (rtf includes: Character replacement).
	presenter
		text: '';
		rtfText: rtf.
	actual := presenter utfText.
	self assert: actual equals: text.
	actual := presenter urtfText.
	"The RTF itself may vary slightly depending on the whim of the RTE, so may not be exactly equal. It should have the same result, however. Repeat"
	presenter rtfText: rtf.
	actual := presenter utfText.
	self assert: actual equals: text.
	rtf := presenter urtfText.

	"Check selection"
	presenter selectAll.
	actual := presenter selectionUrtf.
	self assert: actual equals: rtf.
	presenter selectLine: 10.
	actual := presenter selectionUrtf.
	"This test is locale sensitive and may need revision"
	rtf := '{\urtf1\ansi\ansicpg<1d>\deff0{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset238 Segoe UI;}}
\uc1\pard\lang<2d>\f0\fs<3d> ĉṓɲṩḙċ\f1 ť\f0 ᶒțûɾ ấɖḯƥĭṩ\f1 čį\f0 ɳġ ḝ\f1 łį\f0 ʈ}
'
				expandMacrosWith: Character.AnsiCodePage
				with: Locale systemDefault lcid
				with: presenter view actualFont pointSize * 2.
	self assert: actual equals: rtf.

	"Check round-trip as ANSI RTF (which has an escape syntax to preserve international characters)"
	presenter text: text.
	rtf := presenter rtfText.
	presenter
		text: '';
		rtfText: rtf.
	actual := presenter utfText.
	self assert: actual equals: text.
	actual := presenter rtfText.
	self assert: actual equals: rtf!

text
	"As of v2.0 of the RichEdit control, it strips out CRs internally, and so positions will be out relative to the original text"

	^'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ'!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	self view plainText: self printString.
	self assert: (self view instVarNamed: 'teFlags') equals: TextEdit.WantTabMask.
	self assert: (self view instVarAt: RichTextEdit instSize) isKindOf: OS.EDITSTREAM! !

!UI.Tests.RichTextEditTest categoriesForMethods!
classToTest!helpers!private! !
margins!private!unit tests! !
nonProportionalFont!constants!private! !
setUp!private!unit tests! !
tearDown!private!running! !
testCharNearestPosition!public!unit tests! !
testStreamInAnsiText!public!unit tests! !
testStreamInUtfText!public!unit tests! !
text!constants!public! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.RichTextEditTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.RichTextEdit)  98 18 0 0 98 2 8 1140920644 1025 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 594 1 626 8 #bePlain 8 '&Plain' 1 1 0 0 0 594 1 626 8 #toggleBold 8 '&Bold' 1 1 0 0 0 594 1 626 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 594 1 626 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 690 4097 546 0 16 98 3 594 1025 626 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 594 1025 626 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 594 1025 626 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 690 4097 594 1 626 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 416 0 8 1833025437 852486 ##(Smalltalk.NullConverter)  0 0 9 0 655622 ##(Smalltalk.EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 48 0 132 1] 983302 ##(Smalltalk.MessageSequence)  202 208 98 6 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 1554 421 351 416 1490 8 #contextMenu: 98 1 560 416 1490 8 #text: 98 1 524550 ##(Smalltalk.RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 416 1490 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 1490 8 #isTextModified: 98 1 32 416 1490 8 #resetCharFormat 98 0 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 73 6 0 0 185 0 0 0] 98 0 1554 193 193 0 27 )!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.RichTextEdit) 34 18 nil nil 34 2 8 1140920644 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 562 1 594 #bePlain 8 '&Plain' 1 1 nil nil nil 562 1 594 #toggleBold 8 '&Bold' 1 1 nil nil nil 562 1 594 #toggleItalic 8 '&Italic' 1 1 nil nil nil 562 1 594 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 642 4097 514 nil true 34 3 562 1025 594 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 562 1025 594 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 562 1025 594 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 642 4097 562 1 594 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 416 nil 8 2063088144 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 16 0 13 4] 983302 ##(Smalltalk.MessageSequence) 138 144 34 5 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 1362 421 351 416 1314 #contextMenu: 34 1 528 416 1314 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22\par
}
' 416 1314 #textLimit: 8 #(1073741823) 416 1314 #resetCharFormat 8 #() 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 81 8 0 0 185 0 0 0] 8 #() 1362 193 193 nil 27 )!

resource_Default_view_D8_13
	"A copy of the ealier stbVersion 13 Dolphin 8 RichTextPresenter default view, prior to the introduction of the updateMode inst var in the TextEdit superclass. STB version is the same as D7, but now in STL5 format.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view_D8_13)

	DO NOT EDIT, as doing so will invalidate the test. Revert any changes from rename refactorings too.
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.RichTextEdit} 34 18 nil nil 34 2 8 1140920644 1025 416 nil 917510 #{Graphics.Color} #default nil 7 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 562 1 594 #bePlain 8 '&Plain' 1 1 nil nil nil 562 1 594 #toggleBold 8 '&Bold' 1 1 nil nil nil 562 1 594 #toggleItalic 8 '&Italic' 1 1 nil nil nil 562 1 594 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 642 4097 514 nil true 34 3 562 1025 594 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 562 1025 594 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 562 1025 594 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 642 4097 562 1 594 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 416 nil 8 1559970672 1049094 #{UI.NullConverter} nil nil 9 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 32 0 198 4] 1310982 #{Core.MessageSequence} 34 4 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 6143 21 1346 421 351 416 1298 #text: 34 1 721158 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22\par
}
' 416 1298 #textLimit: 8 #(1073741823) 416 1298 #resetCharFormat 8 #() 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 209 12 0 0 185 0 0 0] 8 #() 1346 193 193 nil 27)! !

!UI.Tests.RichTextEditTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
resource_Default_view_D8_13!public!resources-views! !
!

