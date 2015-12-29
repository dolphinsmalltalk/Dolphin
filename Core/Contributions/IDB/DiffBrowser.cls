"Filed out from Dolphin Smalltalk X6"!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #toggleIndentGuides 8 'Indentation &Guides' 1 1 0 0 0 706 1 738 8 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 0 0 0 706 1 738 8 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 0 0 0 706 1 738 8 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 0 0 0 706 1 738 8 #toggleWrapping 8 '&Word Wrap' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 560 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 16 234 256 1120 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1282 1185 693 560 1218 8 #contextMenu: 98 1 672 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 90 1 0 0] 98 3 410 576 98 15 0 560 98 2 8 1140850688 131073 1440 0 482 512 0 7 0 0 0 1440 530 1 1 0 410 8 ##(Smalltalk.StaticText)  98 16 0 1440 98 2 8 1140850945 262145 1536 0 0 0 7 0 0 0 1536 0 8 4294902785 852486 ##(Smalltalk.NullConverter)  0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 301 1282 1185 41 1536 1218 8 #text: 98 1 8 '
' 1536 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 80 2 0 0 170 0 0 0] 98 0 1282 193 193 0 27 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 1440 98 2 8 1140920580 1025 1904 721990 2 ##(Smalltalk.ValueHolder)  0 32 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #equality 0 482 512 0 7 0 0 0 1904 0 388453147 1634 0 0 11 0 234 256 98 10 8 #lineNumber 1182726 ##(Smalltalk.ScintillaTextStyle)  67 0 0 1 0 0 0 0 2144 0 0 0 8 #diff 2162 5 0 196934 1 ##(Smalltalk.RGB)  16908287 3 0 0 0 0 2192 0 0 0 8 #normal 2162 1 0 0 1 0 0 0 0 2256 0 0 0 8 #indentGuide 2162 75 0 0 1 0 0 0 0 2288 0 0 0 8 #whitespace 2162 3 786694 ##(Smalltalk.IndexedColor)  33554445 0 1 0 0 0 0 2320 0 0 0 98 40 2272 2336 2208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2176 0 0 0 2304 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler)  98 0 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 2354 33554433 2354 33554471 1904 8 #circle 202 208 1120 0 63 0 0 0 0 0 2354 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 2112 0 0 0 0 1 0 0 1154 202 208 98 10 1218 1248 98 2 1282 1 1 1282 1185 301 1904 1218 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1904 1218 8 #isTextModified: 98 1 32 1904 1218 8 #modificationEventMask: 98 1 9215 1904 1218 8 #indicatorDefinitions: 98 1 98 3 1836038 ##(Smalltalk.ScintillaIndicatorDefinition)  1 1904 33554459 13 3026 3 1904 33423361 5 3026 5 1904 511 1 1904 1218 8 #wordWrap: 98 1 16 1904 1218 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 1904 49 3 32 1 3202 3 1904 1 1 32 67108863 3202 5 1904 1 1 32 1 1904 1218 8 #markers: 98 1 2576 1904 1218 8 #canHScroll: 98 1 32 1904 1218 8 #tabIndents: 98 1 16 1904 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 150 0 0 0] 98 0 1888 0 27 234 256 98 4 1536 8 'beforeTitle' 1904 8 'before' 0 1154 202 208 98 1 1218 1248 98 2 1282 1 1 1282 1185 341 1440 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 170 0 0 0] 98 2 1904 1536 1888 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 560 98 2 8 1140850688 1 3680 0 2226 66047 0 519 0 0 0 3680 1154 202 208 98 1 1218 1248 98 2 1282 1 341 1282 1185 11 3680 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 170 0 0 0 80 2 0 0 175 0 0 0] 98 0 1888 0 27 410 576 98 15 0 560 98 2 8 1140850688 131073 3936 0 482 512 0 7 0 0 0 3936 530 1 1 0 410 1552 98 16 0 3936 98 2 8 1140850945 262145 4032 0 0 0 7 0 0 0 4032 0 8 4294902785 1634 0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 303 1282 1185 41 4032 1218 1792 98 1 8 '
' 4032 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 151 0 0 0 80 2 0 0 171 0 0 0] 98 0 1888 0 27 0 0 410 1920 98 46 0 3936 98 2 8 1140920580 1025 4336 1986 0 32 2032 0 482 512 0 7 0 0 0 4336 0 388453147 1634 0 0 11 0 234 256 98 10 2144 2162 67 0 0 1 0 0 0 0 2144 0 0 0 2192 2162 5 0 2226 16908287 3 0 0 0 0 2192 0 0 0 2256 2162 1 0 0 1 0 0 0 0 2256 0 0 0 2288 2162 75 0 0 1 0 0 0 0 2288 0 0 0 2320 2162 3 2368 0 1 0 0 0 0 2320 0 0 0 98 40 4528 4560 4496 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4480 0 0 0 4544 0 0 2402 2432 234 256 98 2 2480 2498 1 1 2528 2544 4336 2560 202 208 1120 0 63 0 0 0 0 0 2592 0 0 0 0 0 0 2608 3 234 256 98 2 2656 4448 0 0 0 0 1 0 0 1154 202 208 98 10 1218 1248 98 2 1282 1 1 1282 1185 303 4336 1218 2800 98 1 2834 3 1 3 4336 1218 2880 98 1 32 4336 1218 2928 98 1 9215 4336 1218 2976 98 1 98 3 3026 1 4336 33554459 13 3026 3 4336 33423361 5 3026 5 4336 511 1 4336 1218 3104 98 1 16 4336 1218 3152 98 1 98 3 3202 1 4336 49 3 32 1 3202 3 4336 1 1 32 67108863 3202 5 4336 1 1 32 1 4336 1218 3280 98 1 4656 4336 1218 3328 98 1 32 4336 1218 3376 98 1 16 4336 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 151 0 0 0] 98 0 1888 0 27 234 256 98 4 4032 8 'afterTitle' 4336 8 'after' 0 1154 202 208 98 1 1218 1248 98 2 1282 1 351 1282 1185 343 3936 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 175 0 0 0 80 2 0 0 90 1 0 0] 98 2 4336 4032 1888 0 27 1888 0 27 234 256 98 2 560 8 'diffs' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 3 658 0 16 98 4 706 1 738 8 #selectUpper 8 'Select &upper' 1 1 0 0 0 706 1 738 8 #selectLower 8 'Select &lower' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 706 1 738 8 #exit 8 '&Close' 1 1 0 0 0 8 '&File' 0 1 0 0 33751 0 0 658 0 16 98 3 706 1 738 8 #character 8 '&Character' 1 1 0 0 0 706 1 738 8 #word 8 '&Word' 1 1 0 0 0 706 1 738 8 #line 8 '&Line' 1 1 0 0 0 8 '&Mode' 0 1 0 0 33759 0 0 658 0 16 98 1 706 1 738 8 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 33763 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1154 202 208 98 3 1218 1248 98 2 1282 2799 21 1282 1201 801 416 1218 1792 98 1 8 'Differences' 416 1218 8 #menuBar: 98 1 5584 416 1378 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 207 7 0 0 154 1 0 0] 98 1 560 1888 0 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #toggleIndentGuides 8 'Indentation &Guides' 1 1 0 0 0 706 1 738 8 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 0 0 0 706 1 738 8 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 0 0 0 706 1 738 8 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 0 0 0 706 1 738 8 #toggleWrapping 8 '&Word Wrap' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 560 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 32 234 256 1120 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 1282 1169 689 560 1218 8 #contextMenu: 98 1 672 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 88 1 0 0] 98 3 410 576 98 15 0 560 98 2 8 1140850688 131073 1440 0 482 512 0 7 0 0 0 1440 530 1 1 0 410 8 ##(Smalltalk.StaticText)  98 16 0 1440 98 2 8 1140850945 262145 1536 0 0 0 7 0 0 0 1536 0 8 4294903819 852486 ##(Smalltalk.NullConverter)  0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 649 1282 575 41 1536 1218 8 #text: 98 1 8 '
' 1536 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 68 1 0 0 31 1 0 0 88 1 0 0] 98 0 1282 193 193 0 27 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 1440 98 2 8 1140920580 1025 1904 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 482 512 0 7 0 0 0 1904 0 390950555 1634 0 0 11 0 234 256 98 10 8 #indentGuide 1182726 ##(Smalltalk.ScintillaTextStyle)  75 0 0 1 0 0 0 0 2112 0 0 0 8 #lineNumber 2130 67 0 0 1 0 0 0 0 2160 0 0 0 8 #diff 2130 5 0 196934 1 ##(Smalltalk.RGB)  16908287 3 0 0 0 0 2192 0 0 0 8 #whitespace 2130 3 786694 ##(Smalltalk.IndexedColor)  33554445 0 1 0 0 0 0 2256 0 0 0 8 #normal 2130 1 0 0 1 0 0 0 0 2320 0 0 0 98 40 2336 2272 2208 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2176 0 0 0 2144 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler)  98 0 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 2290 33554433 2290 33554471 1904 8 #circle 202 208 1120 0 63 0 0 0 0 0 2290 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 2080 0 0 0 0 1 0 0 1154 202 208 98 9 1218 1248 98 2 1282 1 1 1282 575 649 1904 1218 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1904 1218 8 #isTextModified: 98 1 32 1904 1218 8 #modificationEventMask: 98 1 9215 1904 1218 8 #indicatorDefinitions: 98 1 98 3 1836038 ##(Smalltalk.ScintillaIndicatorDefinition)  1 1904 33554459 13 2994 3 1904 33423361 5 2994 5 1904 511 1 1904 1218 8 #wordWrap: 98 1 16 1904 1218 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 1904 49 3 32 1 3170 3 1904 1 1 32 67108863 3170 5 1904 1 1 32 1 1904 1218 8 #canHScroll: 98 1 32 1904 1218 8 #tabIndents: 98 1 16 1904 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 1 0 0 68 1 0 0] 98 0 1888 0 27 234 256 98 4 1536 8 'beforeTitle' 1904 8 'before' 0 1154 202 208 98 1 1218 1248 98 2 1282 1 1 1282 575 689 1440 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 1 0 0 88 1 0 0] 98 2 1904 1536 1888 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 560 98 2 8 1140850688 1 3600 0 2226 66047 0 519 0 0 0 3600 1154 202 208 98 1 1218 1248 98 2 1282 575 1 1282 19 689 3600 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 1 0 0 0 0 0 0 40 1 0 0 88 1 0 0] 98 0 1888 0 27 410 576 98 15 0 560 98 2 8 1140850688 131073 3856 0 482 512 0 7 0 0 0 3856 530 1 1 0 410 1552 98 16 0 3856 98 2 8 1140850945 262145 3952 0 0 0 7 0 0 0 3952 0 8 4294903819 1634 0 0 0 1154 202 208 98 2 1218 1248 98 2 1282 1 649 1282 577 41 3952 1218 1792 98 1 8 '
' 3952 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 68 1 0 0 32 1 0 0 88 1 0 0] 98 0 1888 0 27 0 0 410 1920 98 46 0 3856 98 2 8 1140920580 1025 4256 1986 0 32 2032 0 482 512 0 7 0 0 0 4256 0 390950555 1634 0 0 11 0 234 256 98 10 2112 2130 75 0 0 1 0 0 0 0 2112 0 0 0 2160 2130 67 0 0 1 0 0 0 0 2160 0 0 0 2192 2130 5 0 2226 16908287 3 0 0 0 0 2192 0 0 0 2256 2130 3 2304 0 1 0 0 0 0 2256 0 0 0 2320 2130 1 0 0 1 0 0 0 0 2320 0 0 0 98 40 4480 4464 4432 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4416 0 0 0 4400 0 0 2370 2400 234 256 98 2 2448 2466 1 1 2496 2512 4256 2528 202 208 1120 0 63 0 0 0 0 0 2560 0 0 0 0 0 0 2576 3 234 256 98 2 2624 4368 0 0 0 0 1 0 0 1154 202 208 98 9 1218 1248 98 2 1282 1 1 1282 577 649 4256 1218 2768 98 1 2802 3 1 3 4256 1218 2848 98 1 32 4256 1218 2896 98 1 9215 4256 1218 2944 98 1 98 3 2994 1 4256 33554459 13 2994 3 4256 33423361 5 2994 5 4256 511 1 4256 1218 3072 98 1 16 4256 1218 3120 98 1 98 3 3170 1 4256 49 3 32 1 3170 3 4256 1 1 32 67108863 3170 5 4256 1 1 32 1 4256 1218 3248 98 1 32 4256 1218 3296 98 1 16 4256 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 32 1 0 0 68 1 0 0] 98 0 1888 0 27 234 256 98 4 3952 8 'afterTitle' 4256 8 'after' 0 1154 202 208 98 1 1218 1248 98 2 1282 593 1 1282 577 689 3856 1378 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 1 0 0 0 0 0 0 72 2 0 0 88 1 0 0] 98 2 4256 3952 1888 0 27 1888 0 27 234 256 98 2 560 8 'diffs' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 3 658 0 16 98 4 706 1 738 8 #selectUpper 8 'Select &upper' 1 1 0 0 0 706 1 738 8 #selectLower 8 'Select &lower' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 706 1 738 8 #exit 8 '&Close' 1 1 0 0 0 8 '&File' 0 1 0 0 33043 0 0 658 0 16 98 3 706 1 738 8 #character 8 '&Character' 1 1 0 0 0 706 1 738 8 #word 8 '&Word' 1 1 0 0 0 706 1 738 8 #line 8 '&Line' 1 1 0 0 0 8 '&Mode' 0 1 0 0 33051 0 0 658 0 16 98 1 706 1 738 8 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 33055 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1154 202 208 98 3 1218 1248 98 2 1282 2799 21 1282 1201 801 416 1218 1792 98 1 8 'Differences' 416 1218 8 #updateMenuBar 1120 416 1378 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 207 7 0 0 154 1 0 0] 98 1 560 1888 0 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

