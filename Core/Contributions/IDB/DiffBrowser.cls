"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #DiffBrowser
	instanceVariableNames: 'diffsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DiffBrowser guid: (GUID fromString: '{C45E4FF1-7CB1-4EC9-88B4-595B06AE410C}')!
DiffBrowser comment: 'See [DolphinImageFolder]/Ian Bartholomew/Documentation for details

(C) 2002 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DiffBrowser categoriesForClass!IDB Goodies!MVP-Presenters! !
!DiffBrowser methodsFor!

about
	"Display the about view"

	self 
		about: '
Difference Browser
for
Dolphin Smalltalk 6.x

Version 6b
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

about: aString 
	"Display the about view"

	| edit |
	(Shell create view)
		layoutManager: BorderLayout new;
		hasMaximize: false;
		hasMinimize: false;
		isResizable: false;
		position: self view position + self view cursorPosition;
		extent: 200 @ 180;
		caption: 'About';
		addSubView: (edit := MultilineTextEdit new);
		show.
	edit
		arrangement: #center;
		isReadOnly: true;
		canVScroll: false;
		font: (Font name: 'Arial' pointSize: 10);
		alignment: #center;
		text: aString!

character
	self mode: #character!

compare: upperString id: upperIdString and: lowerString id: lowerIdString
	diffsPresenter
		beforeTitle: upperIdString;
		afterTitle: lowerIdString;
		compare: upperString with: lowerString!

createComponents
	super createComponents.
	diffsPresenter := self add: DifferencesPresenter new name: 'diffs'!

line
	self mode: #line!

mode: aSymbol 
	diffsPresenter comparisonMode: aSymbol!

onViewOpened
	super onViewOpened.
	#('before' 'after') 
		do: [:each | (diffsPresenter view viewNamed: each) setFont: SmalltalkWorkspace actualFont]!

queryCommand: aCommandQuery 
	(#(#character #word #line) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: diffsPresenter comparisonMode == aCommandQuery command.
			^true].
	^super queryCommand: aCommandQuery!

readTextFrom: filename 
	| stream |
	stream := FileStream read: filename.
	^[stream contents] ensure: [stream close]!

selectLower
	FileOpenDialog showModal ifNotNil: 
			[:arg | 
			diffsPresenter
				afterText: (self readTextFrom: arg);
				afterTitle: arg;
				refresh]!

selectUpper
	FileOpenDialog showModal ifNotNil: 
			[:arg | 
			diffsPresenter
				beforeText: (self readTextFrom: arg);
				beforeTitle: arg;
				refresh]!

word
	self mode: #word! !
!DiffBrowser categoriesFor: #about!commands!public! !
!DiffBrowser categoriesFor: #about:!commands!public! !
!DiffBrowser categoriesFor: #character!commands!public! !
!DiffBrowser categoriesFor: #compare:id:and:id:!operations!public! !
!DiffBrowser categoriesFor: #createComponents!initializing!public! !
!DiffBrowser categoriesFor: #line!commands!public! !
!DiffBrowser categoriesFor: #mode:!commands!public! !
!DiffBrowser categoriesFor: #onViewOpened!event handling!public! !
!DiffBrowser categoriesFor: #queryCommand:!commands!public! !
!DiffBrowser categoriesFor: #readTextFrom:!helpers!public! !
!DiffBrowser categoriesFor: #selectLower!commands!public! !
!DiffBrowser categoriesFor: #selectUpper!commands!public! !
!DiffBrowser categoriesFor: #word!commands!public! !

!DiffBrowser class methodsFor!

compare: aString1 with: aString2
	^self show
		compare: aString1 id: 'A' and: aString2 id: 'B';
		yourself!

displayOn: aStream
	aStream nextPutAll: 'Difference Browser'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 560 0 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #toggleIndentGuides 8 'Indentation &Guides' 1 1 0 0 0 706 1 738 8 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 0 0 0 706 1 738 8 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 0 0 0 706 1 738 8 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 0 0 0 706 1 738 8 #toggleWrapping 8 '&Word Wrap' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 560 1180166 ##(Smalltalk.ProportionalLayout) 234 240 98 0 16 234 256 1120 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 1282 1169 683 560 1218 8 #contextMenu: 98 1 672 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 98 3 410 576 98 15 0 560 98 2 8 1140850688 131073 1440 0 482 512 0 7 0 0 0 1440 530 1 1 0 410 8 ##(Smalltalk.StaticText) 98 16 0 1440 98 2 8 1140850945 262145 1536 0 0 0 7 0 0 0 1536 0 8 4294904577 852486 ##(Smalltalk.NullConverter) 0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 297 1282 1169 41 1536 1218 8 #text: 98 1 8 '
' 1536 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 98 0 1282 193 193 0 27 0 0 410 8 ##(Smalltalk.ScintillaView) 98 50 0 1440 98 2 8 1140920580 1025 1904 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 482 512 0 7 0 0 0 1904 0 8 4294906441 1634 0 0 11 0 234 256 98 12 8 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 0 0 1 0 0 0 0 2128 0 0 0 8 #indentGuide 2146 75 0 0 1 0 0 0 0 2176 0 0 0 8 #normal 2146 1 0 0 1 0 0 0 0 2208 0 0 0 8 #callTip 2146 77 786694 ##(Smalltalk.IndexedColor) 33554457 2274 33554471 1 0 0 0 0 2240 0 0 0 8 #diff 2146 5 0 196934 1 ##(Smalltalk.RGB) 16908287 3 0 0 0 0 2320 0 1401 0 8 #whitespace 2146 3 2274 33554445 0 1 0 0 0 0 2384 0 0 0 98 40 2224 2400 2336 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2160 0 0 0 2192 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 98 0 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 1904 8 #circle 0 0 0 0 0 0 202 208 1120 0 63 9215 0 0 0 0 2274 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 2096 0 0 0 0 1 0 234 256 98 6 8 'indicator2' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 5 1904 511 1 32 0 0 0 0 0 0 0 8 'indicator1' 2738 3 1904 33423361 5 32 0 0 0 0 0 0 0 8 'indicator0' 2738 1 1904 33554459 13 32 0 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 2146 1029 0 2354 31185883 1 0 0 0 0 2864 0 0 0 8 #Error 2146 1031 2354 335 2354 31317503 1 0 0 0 0 2912 0 0 0 8 #Warning 2146 1027 2354 60239 2354 31326207 1 0 0 0 0 2976 0 0 0 0 1154 202 208 98 11 1218 1248 98 2 1282 1 1 1282 1169 297 1904 1218 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 1904 1218 8 #isTextModified: 98 1 32 1904 1218 8 #modificationEventMask: 98 1 9215 1904 1218 8 #secondaryCaretForecolor: 98 1 2354 16711423 1904 1218 8 #caretPeriod: 98 1 1061 1904 1218 8 #wordWrap: 98 1 16 1904 1218 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 1904 49 3 32 1 15 3554 3 1904 1 1 32 67108863 15 3554 5 1904 1 1 32 1 15 1904 1218 8 #canHScroll: 98 1 32 1904 1218 8 #tabIndents: 98 1 16 1904 1218 8 #areAdditionalCaretsVisible: 98 1 16 1904 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 98 0 1888 0 29 234 256 98 4 1904 8 'before' 1536 8 'beforeTitle' 0 1154 202 208 98 1 1218 1248 98 2 1282 1 1 1282 1169 337 1440 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 98 2 1904 1536 1888 0 27 410 8 ##(Smalltalk.Splitter) 98 12 0 560 98 2 8 1140850688 1 4032 0 2354 66047 0 519 0 0 0 4032 1154 202 208 98 1 1218 1248 98 2 1282 1 337 1282 1169 11 4032 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 98 0 1888 0 27 410 576 98 15 0 560 98 2 8 1140850688 131073 4288 0 482 512 0 7 0 0 0 4288 530 1 1 0 410 1552 98 16 0 4288 98 2 8 1140850945 262145 4384 0 0 0 7 0 0 0 4384 0 8 4294904577 1634 0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 297 1282 1169 41 4384 1218 1792 98 1 8 '
' 4384 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 98 0 1888 0 27 0 0 410 1920 98 50 0 4288 98 2 8 1140920580 1025 4688 1986 0 32 2032 0 482 512 0 7 0 0 0 4688 0 8 4294906441 1634 0 0 11 0 234 256 98 12 2128 2146 67 0 0 1 0 0 0 0 2128 0 0 0 2176 2146 75 0 0 1 0 0 0 0 2176 0 0 0 2208 2146 1 0 0 1 0 0 0 0 2208 0 0 0 2240 2146 77 2288 2304 1 0 0 0 0 2240 0 0 0 2320 2146 5 0 2354 16908287 3 0 0 0 0 2320 0 1401 0 2384 2146 3 2416 0 1 0 0 0 0 2384 0 0 0 98 40 4880 4944 4912 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4848 0 0 0 4864 0 0 2450 2480 234 256 98 2 2528 2546 1 0 0 0 4688 2576 0 0 0 0 0 0 202 208 1120 0 63 9215 0 0 0 0 2608 0 0 65 0 0 0 2624 3 234 256 98 2 2672 4816 0 0 0 0 1 0 234 256 98 6 8 'indicator0' 2738 1 4688 33554459 13 32 0 0 0 0 0 0 0 8 'indicator2' 2738 5 4688 511 1 32 0 0 0 0 0 0 0 8 'indicator1' 2738 3 4688 33423361 5 32 0 0 0 0 0 0 0 0 0 234 256 98 6 2864 2146 1029 0 2354 31185883 1 0 0 0 0 2864 0 0 0 2912 2146 1031 2354 335 2354 31317503 1 0 0 0 0 2912 0 0 0 2976 2146 1027 2354 60239 2354 31326207 1 0 0 0 0 2976 0 0 0 0 1154 202 208 98 11 1218 1248 98 2 1282 1 1 1282 1169 297 4688 1218 3168 98 1 3202 3 1 3 4688 1218 3248 98 1 32 4688 1218 3296 98 1 9215 4688 1218 3344 98 1 2354 16711423 4688 1218 3408 98 1 1061 4688 1218 3456 98 1 16 4688 1218 3504 98 1 98 3 3554 1 4688 49 3 32 1 15 3554 3 4688 1 1 32 67108863 15 3554 5 4688 1 1 32 1 15 4688 1218 3632 98 1 32 4688 1218 3680 98 1 16 4688 1218 3728 98 1 16 4688 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 98 0 1888 0 29 234 256 98 4 4384 8 'afterTitle' 4688 8 'after' 0 1154 202 208 98 1 1218 1248 98 2 1282 1 347 1282 1169 337 4288 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 98 2 4688 4384 1888 0 27 1888 0 27 234 256 98 2 560 8 'diffs' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 3 658 0 16 98 4 706 1 738 8 #selectUpper 8 'Select &upper' 1 1 0 0 0 706 1 738 8 #selectLower 8 'Select &lower' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 706 1 738 8 #exit 8 '&Close' 1 1 0 0 0 8 '&File' 0 1 0 0 27209 0 0 658 0 16 98 3 706 1 738 8 #character 8 '&Character' 1 1 0 0 0 706 1 738 8 #word 8 '&Word' 1 1 0 0 0 706 1 738 8 #line 8 '&Line' 1 1 0 0 0 8 '&Mode' 0 1 0 0 27217 0 0 658 0 16 98 1 706 1 738 8 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 27221 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1154 202 208 98 3 1218 1248 98 2 1282 3839 21 1282 1201 801 416 1218 1792 98 1 8 'Differences' 416 1218 8 #updateMenuBar 1120 416 1378 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 1 560 1888 0 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 560 0 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #toggleIndentGuides 8 'Indentation &Guides' 1 1 0 0 0 706 1 738 8 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 0 0 0 706 1 738 8 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 0 0 0 706 1 738 8 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 0 0 0 706 1 738 8 #toggleWrapping 8 '&Word Wrap' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 560 1180166 ##(Smalltalk.ProportionalLayout) 234 240 98 0 32 234 256 1120 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 1 1282 1169 683 560 1218 8 #contextMenu: 98 1 672 560 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 98 3 410 576 98 15 0 560 98 2 8 1140850688 131073 1440 0 482 512 0 7 0 0 0 1440 530 1 1 0 410 8 ##(Smalltalk.StaticText) 98 16 0 1440 98 2 8 1140850945 262145 1536 0 0 0 7 0 0 0 1536 0 8 4294904577 852486 ##(Smalltalk.NullConverter) 0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 643 1282 579 41 1536 1218 8 #text: 98 1 8 '
' 1536 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 98 0 1282 193 193 0 27 0 0 410 8 ##(Smalltalk.ScintillaView) 98 50 0 1440 98 2 8 1140920580 1025 1904 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 482 512 0 7 0 0 0 1904 0 8 4294906441 1634 0 0 11 0 234 256 98 12 8 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 0 0 1 0 0 0 0 2128 0 0 0 8 #indentGuide 2146 75 0 0 1 0 0 0 0 2176 0 0 0 8 #normal 2146 1 0 0 1 0 0 0 0 2208 0 0 0 8 #callTip 2146 77 786694 ##(Smalltalk.IndexedColor) 33554457 2274 33554471 1 0 0 0 0 2240 0 0 0 8 #diff 2146 5 0 196934 1 ##(Smalltalk.RGB) 16908287 3 0 0 0 0 2320 0 1401 0 8 #whitespace 2146 3 2274 33554445 0 1 0 0 0 0 2384 0 0 0 98 40 2224 2400 2336 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2160 0 0 0 2192 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 98 0 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 1904 8 #circle 0 0 0 0 0 0 202 208 1120 0 63 9215 0 0 0 0 2274 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 2096 0 0 0 0 1 0 234 256 98 6 8 'indicator2' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 5 1904 511 1 32 0 0 0 0 0 0 0 8 'indicator1' 2738 3 1904 33423361 5 32 0 0 0 0 0 0 0 8 'indicator0' 2738 1 1904 33554459 13 32 0 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 2146 1029 0 2354 31185883 1 0 0 0 0 2864 0 0 0 8 #Error 2146 1031 2354 335 2354 31317503 1 0 0 0 0 2912 0 0 0 8 #Warning 2146 1027 2354 60239 2354 31326207 1 0 0 0 0 2976 0 0 0 0 1154 202 208 98 11 1218 1248 98 2 1282 1 1 1282 579 643 1904 1218 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 1904 1218 8 #isTextModified: 98 1 32 1904 1218 8 #modificationEventMask: 98 1 9215 1904 1218 8 #secondaryCaretForecolor: 98 1 2354 16711423 1904 1218 8 #caretPeriod: 98 1 1061 1904 1218 8 #wordWrap: 98 1 16 1904 1218 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 1904 49 3 32 1 15 3554 3 1904 1 1 32 67108863 15 3554 5 1904 1 1 32 1 15 1904 1218 8 #canHScroll: 98 1 32 1904 1218 8 #tabIndents: 98 1 16 1904 1218 8 #areAdditionalCaretsVisible: 98 1 16 1904 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 98 0 1888 0 29 234 256 98 4 1904 8 'before' 1536 8 'beforeTitle' 0 1154 202 208 98 1 1218 1248 98 2 1282 1 1 1282 579 683 1440 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 98 2 1904 1536 1888 0 27 410 8 ##(Smalltalk.Splitter) 98 12 0 560 98 2 8 1140850688 1 4032 0 2354 66047 0 519 0 0 0 4032 1154 202 208 98 1 1218 1248 98 2 1282 579 1 1282 11 683 4032 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 98 0 1888 0 27 410 576 98 15 0 560 98 2 8 1140850688 131073 4288 0 482 512 0 7 0 0 0 4288 530 1 1 0 410 1552 98 16 0 4288 98 2 8 1140850945 262145 4384 0 0 0 7 0 0 0 4384 0 8 4294904577 1634 0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 643 1282 581 41 4384 1218 1792 98 1 8 '
' 4384 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 98 0 1888 0 27 0 0 410 1920 98 50 0 4288 98 2 8 1140920580 1025 4688 1986 0 32 2032 0 482 512 0 7 0 0 0 4688 0 8 4294906441 1634 0 0 11 0 234 256 98 12 2128 2146 67 0 0 1 0 0 0 0 2128 0 0 0 2176 2146 75 0 0 1 0 0 0 0 2176 0 0 0 2208 2146 1 0 0 1 0 0 0 0 2208 0 0 0 2240 2146 77 2288 2304 1 0 0 0 0 2240 0 0 0 2320 2146 5 0 2354 16908287 3 0 0 0 0 2320 0 1401 0 2384 2146 3 2416 0 1 0 0 0 0 2384 0 0 0 98 40 4880 4944 4912 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4848 0 0 0 4864 0 0 2450 2480 234 256 98 2 2528 2546 1 0 0 0 4688 2576 0 0 0 0 0 0 202 208 1120 0 63 9215 0 0 0 0 2608 0 0 65 0 0 0 2624 3 234 256 98 2 2672 4816 0 0 0 0 1 0 234 256 98 6 8 'indicator0' 2738 1 4688 33554459 13 32 0 0 0 0 0 0 0 8 'indicator1' 2738 3 4688 33423361 5 32 0 0 0 0 0 0 0 8 'indicator2' 2738 5 4688 511 1 32 0 0 0 0 0 0 0 0 0 234 256 98 6 2864 2146 1029 0 2354 31185883 1 0 0 0 0 2864 0 0 0 2912 2146 1031 2354 335 2354 31317503 1 0 0 0 0 2912 0 0 0 2976 2146 1027 2354 60239 2354 31326207 1 0 0 0 0 2976 0 0 0 0 1154 202 208 98 11 1218 1248 98 2 1282 1 1 1282 581 643 4688 1218 3168 98 1 3202 3 1 3 4688 1218 3248 98 1 32 4688 1218 3296 98 1 9215 4688 1218 3344 98 1 2354 16711423 4688 1218 3408 98 1 1061 4688 1218 3456 98 1 16 4688 1218 3504 98 1 98 3 3554 1 4688 49 3 32 1 15 3554 3 4688 1 1 32 67108863 15 3554 5 4688 1 1 32 1 15 4688 1218 3632 98 1 32 4688 1218 3680 98 1 16 4688 1218 3728 98 1 16 4688 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 98 0 1888 0 29 234 256 98 4 4384 8 'afterTitle' 4688 8 'after' 0 1154 202 208 98 1 1218 1248 98 2 1282 589 1 1282 581 683 4288 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 98 2 4688 4384 1888 0 27 1888 0 27 234 256 98 2 560 8 'diffs' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 3 658 0 16 98 4 706 1 738 8 #selectUpper 8 'Select &upper' 1 1 0 0 0 706 1 738 8 #selectLower 8 'Select &lower' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 706 1 738 8 #exit 8 '&Close' 1 1 0 0 0 8 '&File' 0 1 0 0 31163 0 0 658 0 16 98 3 706 1 738 8 #character 8 '&Character' 1 1 0 0 0 706 1 738 8 #word 8 '&Word' 1 1 0 0 0 706 1 738 8 #line 8 '&Line' 1 1 0 0 0 8 '&Mode' 0 1 0 0 31171 0 0 658 0 16 98 1 706 1 738 8 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 31175 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1154 202 208 98 3 1218 1248 98 2 1282 3839 21 1282 1201 801 416 1218 1792 98 1 8 'Differences' 416 1218 8 #updateMenuBar 1120 416 1378 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 98 1 560 1888 0 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

