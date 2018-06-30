"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #DiffBrowser
	instanceVariableNames: 'diffsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DiffBrowser guid: (GUID fromString: '{c45e4ff1-7cb1-4ec9-88b4-595b06ae410c}')!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 544 nil 466 496 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 674 1 706 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 674 1 706 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 674 1 706 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 674 1 706 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 544 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 1008 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1154 1169 683 544 1106 #contextMenu: 34 1 640 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 544 34 2 8 1140850688 131073 1296 nil 466 496 nil 7 nil nil nil 1296 514 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1296 34 2 8 1140850945 262145 1392 nil nil nil 7 nil nil nil 1392 nil 8 1905942624 852486 ##(Smalltalk.NullConverter) nil nil nil 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 297 1154 1169 41 1392 1106 #text: 34 1 8 '
' 1392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1296 34 2 8 1140920580 1025 1728 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 496 nil 7 nil nil nil 1728 nil 8 1894170044 1474 nil nil 11 nil 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1970 33554471 1 nil nil nil nil #callTip nil nil nil #whitespace 1938 3 1970 33554445 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1938 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1938 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1938 5 nil 196934 1 ##(Smalltalk.RGB) 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1938 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 2064 2016 2080 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2048 nil nil nil 2128 nil nil 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1728 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1008 nil 170 176 1008 9215 nil nil nil nil 1970 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1904 nil nil nil nil 1 nil 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 1728 33554459 13 false nil nil nil nil nil nil nil 8 'indicator1' 2418 3 1728 33423361 5 false nil nil nil nil nil nil nil 8 'indicator2' 2418 5 1728 511 1 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1938 1027 2098 60239 2098 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1938 1031 2098 335 2098 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1938 1029 nil 2098 31185883 1 nil nil nil nil #Notification nil nil nil nil 1042 138 144 34 9 1106 #createAt:extent: 34 2 1154 1 1 1154 1169 297 1728 1106 #textLimit: 8 #(1073741823) 1728 1106 #modificationEventMask: 8 #(4607) 1728 1106 #caretPeriod: 8 #(530) 1728 1106 #wordWrap: 8 #(true) 1728 1106 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1728 49 3 nil nil nil nil 2962 3 1728 1 nil nil 67108863 nil nil 2962 5 1728 1 nil nil nil nil nil 1728 1106 #canHScroll: 8 #(false) 1728 1106 #maxCompletionListHeight: 8 #(9) 1728 1106 #sciSetCodePage: 8 #(65001) 1728 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1712 nil 29 170 192 34 4 1728 8 'before' 1392 8 'beforeTitle' nil 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 1 1154 1169 337 1296 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 34 2 1728 1392 1712 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 544 34 2 8 1140850688 1 3392 nil 2098 66047 nil 519 nil nil nil 3392 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 337 1154 1169 11 3392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 8 #() 1712 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 544 34 2 8 1140850688 131073 3632 nil 466 496 nil 7 nil nil nil 3632 514 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3632 34 2 8 1140850945 262145 3728 nil nil nil 7 nil nil nil 3728 nil 8 1905942624 1474 nil nil nil 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 297 1154 1169 41 3728 1106 #text: 34 1 8 '
' 3728 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1712 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3632 34 2 8 1140920580 1025 4032 1794 nil false 1840 nil 466 496 nil 7 nil nil nil 4032 nil 8 1894170044 1474 nil nil 11 nil 170 192 34 12 #callTip 1938 77 1984 2000 1 nil nil nil nil #callTip nil nil nil #whitespace 1938 3 2032 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1938 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1938 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1938 5 nil 2098 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1938 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 4240 4208 4256 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 4224 nil nil nil 4288 nil nil 2162 2192 170 192 34 2 #default 2242 1 nil nil nil 4032 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1008 nil 170 176 1008 9215 nil nil nil nil 2304 nil nil 65 nil nil nil 2320 3 170 192 34 2 #container 4160 nil nil nil nil 1 nil 170 192 34 6 8 'indicator1' 2418 3 4032 33423361 5 false nil nil nil nil nil nil nil 8 'indicator0' 2418 1 4032 33554459 13 false nil nil nil nil nil nil nil 8 'indicator2' 2418 5 4032 511 1 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1938 1027 2098 60239 2098 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1938 1031 2098 335 2098 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1938 1029 nil 2098 31185883 1 nil nil nil nil #Notification nil nil nil nil 1042 138 144 34 9 1106 #createAt:extent: 34 2 1154 1 1 1154 1169 297 4032 1106 #textLimit: 8 #(1073741823) 4032 1106 #modificationEventMask: 8 #(4607) 4032 1106 #caretPeriod: 8 #(530) 4032 1106 #wordWrap: 8 #(true) 4032 1106 #margins: 34 1 34 3 2962 1 4032 49 3 nil nil nil nil 2962 3 4032 1 nil nil 67108863 nil nil 2962 5 4032 1 nil nil nil nil nil 4032 1106 #canHScroll: 8 #(false) 4032 1106 #maxCompletionListHeight: 8 #(9) 4032 1106 #sciSetCodePage: 8 #(65001) 4032 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1712 nil 29 170 192 34 4 3728 8 'afterTitle' 4032 8 'after' nil 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 347 1154 1169 337 3632 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 34 2 4032 3728 1712 nil 27 1712 nil 27 170 192 34 2 544 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 626 nil true 34 4 674 1 706 #selectUpper 8 'Select &upper' 1 1 nil nil nil 674 1 706 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 674 1 706 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 31561 nil nil 626 nil true 34 3 674 1 706 #character 8 '&Character' 1 1 nil nil nil 674 1 706 #word 8 '&Word' 1 1 nil nil nil 674 1 706 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 31569 nil nil 626 nil true 34 1 674 1 706 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 31573 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 1154 3839 21 1154 1201 801 416 1106 #text: 34 1 8 'Differences' 416 1106 #updateMenuBar 1008 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 544 1712 nil 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 544 nil 466 496 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 674 1 706 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 674 1 706 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 674 1 706 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 674 1 706 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 544 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 1008 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1154 1169 683 544 1106 #contextMenu: 34 1 640 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 544 34 2 8 1140850688 131073 1296 nil 466 496 nil 7 nil nil nil 1296 514 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1296 34 2 8 1140850945 262145 1392 nil nil nil 7 nil nil nil 1392 nil 8 1905942624 852486 ##(Smalltalk.NullConverter) nil nil nil 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 643 1154 579 41 1392 1106 #text: 34 1 8 '
' 1392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 8 #() 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1296 34 2 8 1140920580 1025 1728 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 496 nil 7 nil nil nil 1728 nil 8 1894170044 1474 nil nil 11 nil 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1970 33554471 1 nil nil nil nil #callTip nil nil nil #whitespace 1938 3 1970 33554445 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1938 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1938 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1938 5 nil 196934 1 ##(Smalltalk.RGB) 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1938 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 2064 2016 2080 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2048 nil nil nil 2128 nil nil 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1728 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1008 nil 170 176 1008 9215 nil nil nil nil 1970 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1904 nil nil nil nil 1 nil 170 192 34 6 8 'indicator2' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 5 1728 511 1 false nil nil nil nil nil nil nil 8 'indicator0' 2418 1 1728 33554459 13 false nil nil nil nil nil nil nil 8 'indicator1' 2418 3 1728 33423361 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1938 1027 2098 60239 2098 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1938 1031 2098 335 2098 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1938 1029 nil 2098 31185883 1 nil nil nil nil #Notification nil nil nil nil 1042 138 144 34 9 1106 #createAt:extent: 34 2 1154 1 1 1154 579 643 1728 1106 #textLimit: 8 #(1073741823) 1728 1106 #modificationEventMask: 8 #(4607) 1728 1106 #caretPeriod: 8 #(530) 1728 1106 #wordWrap: 8 #(true) 1728 1106 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1728 49 3 nil nil nil nil 2962 3 1728 1 nil nil 67108863 nil nil 2962 5 1728 1 nil nil nil nil nil 1728 1106 #canHScroll: 8 #(false) 1728 1106 #maxCompletionListHeight: 8 #(9) 1728 1106 #sciSetCodePage: 8 #(65001) 1728 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 8 #() 1712 nil 29 170 192 34 4 1728 8 'before' 1392 8 'beforeTitle' nil 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 1 1154 579 683 1296 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 34 2 1728 1392 1712 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 544 34 2 8 1140850688 1 3392 nil 2098 66047 nil 519 nil nil nil 3392 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 579 1 1154 11 683 3392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 8 #() 1712 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 544 34 2 8 1140850688 131073 3632 nil 466 496 nil 7 nil nil nil 3632 514 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3632 34 2 8 1140850945 262145 3728 nil nil nil 7 nil nil nil 3728 nil 8 1905942624 1474 nil nil nil 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 643 1154 581 41 3728 1106 #text: 34 1 8 '
' 3728 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 8 #() 1712 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3632 34 2 8 1140920580 1025 4032 1794 nil false 1840 nil 466 496 nil 7 nil nil nil 4032 nil 8 1894170044 1474 nil nil 11 nil 170 192 34 12 #callTip 1938 77 1984 2000 1 nil nil nil nil #callTip nil nil nil #whitespace 1938 3 2032 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1938 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1938 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1938 5 nil 2098 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1938 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 4240 4208 4256 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 4224 nil nil nil 4288 nil nil 2162 2192 170 192 34 2 #default 2242 1 nil nil nil 4032 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1008 nil 170 176 1008 9215 nil nil nil nil 2304 nil nil 65 nil nil nil 2320 3 170 192 34 2 #container 4160 nil nil nil nil 1 nil 170 192 34 6 8 'indicator0' 2418 1 4032 33554459 13 false nil nil nil nil nil nil nil 8 'indicator2' 2418 5 4032 511 1 false nil nil nil nil nil nil nil 8 'indicator1' 2418 3 4032 33423361 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1938 1027 2098 60239 2098 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1938 1031 2098 335 2098 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1938 1029 nil 2098 31185883 1 nil nil nil nil #Notification nil nil nil nil 1042 138 144 34 9 1106 #createAt:extent: 34 2 1154 1 1 1154 581 643 4032 1106 #textLimit: 8 #(1073741823) 4032 1106 #modificationEventMask: 8 #(4607) 4032 1106 #caretPeriod: 8 #(530) 4032 1106 #wordWrap: 8 #(true) 4032 1106 #margins: 34 1 34 3 2962 1 4032 49 3 nil nil nil nil 2962 3 4032 1 nil nil 67108863 nil nil 2962 5 4032 1 nil nil nil nil nil 4032 1106 #canHScroll: 8 #(false) 4032 1106 #maxCompletionListHeight: 8 #(9) 4032 1106 #sciSetCodePage: 8 #(65001) 4032 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 8 #() 1712 nil 29 170 192 34 4 3728 8 'afterTitle' 4032 8 'after' nil 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 589 1 1154 581 683 3632 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 4032 3728 1712 nil 27 1712 nil 27 170 192 34 2 544 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 626 nil true 34 4 674 1 706 #selectUpper 8 'Select &upper' 1 1 nil nil nil 674 1 706 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 674 1 706 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 31923 nil nil 626 nil true 34 3 674 1 706 #character 8 '&Character' 1 1 nil nil nil 674 1 706 #word 8 '&Word' 1 1 nil nil nil 674 1 706 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 31931 nil nil 626 nil true 34 1 674 1 706 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 31935 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1042 138 144 34 3 1106 #createAt:extent: 34 2 1154 3839 21 1154 1201 801 416 1106 #text: 34 1 8 'Differences' 416 1106 #updateMenuBar 1008 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 544 1712 nil 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

