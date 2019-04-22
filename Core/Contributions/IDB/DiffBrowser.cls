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

styler: aScintillaStyler
	diffsPresenter styler: aScintillaStyler!

textFont: aFont 
	diffsPresenter textFont: aFont!

textStyles: anCollectionOfScintillaTextStyle
	diffsPresenter textStyles: anCollectionOfScintillaTextStyle!

word
	self mode: #word! !
!DiffBrowser categoriesFor: #about!commands!public! !
!DiffBrowser categoriesFor: #about:!commands!public! !
!DiffBrowser categoriesFor: #character!commands!public! !
!DiffBrowser categoriesFor: #compare:id:and:id:!operations!public! !
!DiffBrowser categoriesFor: #createComponents!initializing!public! !
!DiffBrowser categoriesFor: #line!commands!public! !
!DiffBrowser categoriesFor: #mode:!commands!public! !
!DiffBrowser categoriesFor: #queryCommand:!commands!public! !
!DiffBrowser categoriesFor: #readTextFrom:!helpers!public! !
!DiffBrowser categoriesFor: #selectLower!commands!public! !
!DiffBrowser categoriesFor: #selectUpper!commands!public! !
!DiffBrowser categoriesFor: #styler:!accessing!public! !
!DiffBrowser categoriesFor: #textFont:!accessing!public! !
!DiffBrowser categoriesFor: #textStyles:!accessing!public! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1905095040 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 1 1632 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 1632 nil 8 1613418089 1426 nil nil 11 nil 170 192 34 10 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1874 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1874 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1874 3 786694 ##(Smalltalk.IndexedColor) 33554445 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1874 77 1954 33554457 1954 33554471 1 nil nil nil nil #callTip nil nil nil 34 256 1888 1936 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1920 nil nil nil 1904 1984 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1632 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1954 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1840 nil nil nil nil 130003 nil 170 192 34 2 #diff 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 1632 131071 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1874 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Error 1874 1031 2354 335 2354 31317503 1 nil nil nil nil #Error nil nil nil #Warning 1874 1027 2354 60239 2354 31326207 1 nil nil nil nil #Warning nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 1632 1074 #textLimit: 8 #(1073741823) 1632 1074 #modificationEventMask: 8 #(4607) 1632 1074 #caretPeriod: 8 #(530) 1632 1074 #wordWrap: 8 #(true) 1632 1074 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1632 49 3 nil nil nil nil 2770 3 1632 1 nil nil 67108863 nil nil 2770 5 1632 1 nil nil nil nil nil 1632 1074 #canHScroll: 8 #(false) 1632 1074 #maxCompletionListHeight: 8 #(9) 1632 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 29 170 192 34 4 1632 8 'before' 1344 8 'beforeTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 337 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 34 2 1632 1344 1616 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3168 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3168 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3264 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 337 1122 1169 11 3168 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 8 #() 1616 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3456 nil nil nil 7 nil nil nil 3456 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3456 34 2 8 1140850945 262145 3536 nil nil nil 7 nil nil nil 3536 nil 8 1905095040 1426 nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 3536 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1616 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3456 34 2 8 1140920580 1 3792 1698 nil false 1744 nil 1776 nil 7 nil nil nil 3792 nil 8 1613418089 1426 nil nil 11 nil 170 192 34 10 #normal 1874 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1874 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1874 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1874 3 1968 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1874 77 2000 2016 1 nil nil nil nil #callTip nil nil nil 34 256 3936 3984 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 3968 nil nil nil 3952 4000 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2050 #normal 170 192 34 2 #default 2114 1 nil nil nil 3792 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2176 nil nil 65 nil nil nil 2192 3 170 192 34 2 #container 3904 nil nil nil nil 130003 nil 170 192 34 2 #diff 2274 1 3792 131071 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1874 1029 nil 2354 31185883 1 nil nil nil nil #Notification nil nil nil #Error 1874 1031 2354 335 2354 31317503 1 nil nil nil nil #Error nil nil nil #Warning 1874 1027 2354 60239 2354 31326207 1 nil nil nil nil #Warning nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 3792 1074 #textLimit: 8 #(1073741823) 3792 1074 #modificationEventMask: 8 #(4607) 3792 1074 #caretPeriod: 8 #(530) 3792 1074 #wordWrap: 8 #(true) 3792 1074 #margins: 34 1 34 3 2770 1 3792 49 3 nil nil nil nil 2770 3 3792 1 nil nil 67108863 nil nil 2770 5 3792 1 nil nil nil nil nil 3792 1074 #canHScroll: 8 #(false) 3792 1074 #maxCompletionListHeight: 8 #(9) 3792 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 29 170 192 34 4 3792 8 'after' 3536 8 'afterTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 347 1122 1169 337 3456 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 34 2 3792 3536 1616 nil 27 1616 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 40075 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 40083 nil nil 594 nil true 34 1 642 1 674 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 40087 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 3 1074 #createAt:extent: 34 2 1122 3839 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1074 #updateMenuBar 976 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 1616 nil 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1905095040 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 579 41 1344 1074 #text: 34 1 8 '
' 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 262145 1680 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 1680 nil 8 1613418089 1426 nil nil 11 nil 170 192 34 10 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1922 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1922 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1922 3 786694 ##(Smalltalk.IndexedColor) 33554445 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1922 77 2002 33554457 2002 33554471 1 nil nil nil nil #callTip nil nil nil 34 256 1936 1984 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1968 nil nil nil 1952 2032 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1680 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2002 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1888 nil nil nil nil 130003 nil 170 192 34 2 #diff 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 1680 131071 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1922 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Error 1922 1031 2402 335 2402 31317503 1 nil nil nil nil #Error nil nil nil #Warning 1922 1027 2402 60239 2402 31326207 1 nil nil nil nil #Warning nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 579 643 1680 1074 #textLimit: 8 #(1073741823) 1680 1074 #modificationEventMask: 8 #(4607) 1680 1074 #caretPeriod: 8 #(530) 1680 1074 #wordWrap: 8 #(true) 1680 1074 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1680 49 3 nil nil nil nil 2818 3 1680 1 nil nil 67108863 nil nil 2818 5 1680 1 nil nil nil nil nil 1680 1074 #canHScroll: 8 #(false) 1680 1074 #maxCompletionListHeight: 8 #(9) 1680 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 8 #() 1664 nil 29 170 192 34 4 1344 8 'beforeTitle' 1680 8 'before' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 579 683 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 34 2 1680 1344 1664 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3216 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3216 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3312 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 579 1 1122 11 683 3216 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 8 #() 1664 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3504 nil nil nil 7 nil nil nil 3504 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3504 34 2 8 1140850945 262145 3584 nil nil nil 7 nil nil nil 3584 nil 8 1905095040 1426 nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 581 41 3584 1074 #text: 34 1 8 '
' 3584 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 8 #() 1664 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3504 34 2 8 1140920580 262145 3888 1746 nil false 1792 nil 1824 nil 7 nil nil nil 3888 nil 8 1613418089 1426 nil nil 11 nil 170 192 34 10 #normal 1922 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1922 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1922 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1922 3 2016 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1922 77 2048 2064 1 nil nil nil nil #callTip nil nil nil 34 256 4032 4080 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 4064 nil nil nil 4048 4096 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2098 #normal 170 192 34 2 #default 2162 1 nil nil nil 3888 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2224 nil nil 65 nil nil nil 2240 3 170 192 34 2 #container 4000 nil nil nil nil 130003 nil 170 192 34 2 #diff 2322 1 3888 131071 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1922 1029 nil 2402 31185883 1 nil nil nil nil #Notification nil nil nil #Error 1922 1031 2402 335 2402 31317503 1 nil nil nil nil #Error nil nil nil #Warning 1922 1027 2402 60239 2402 31326207 1 nil nil nil nil #Warning nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 581 643 3888 1074 #textLimit: 8 #(1073741823) 3888 1074 #modificationEventMask: 8 #(4607) 3888 1074 #caretPeriod: 8 #(530) 3888 1074 #wordWrap: 8 #(true) 3888 1074 #margins: 34 1 34 3 2818 1 3888 49 3 nil nil nil nil 2818 3 3888 1 nil nil 67108863 nil nil 2818 5 3888 1 nil nil nil nil nil 3888 1074 #canHScroll: 8 #(false) 3888 1074 #maxCompletionListHeight: 8 #(9) 3888 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 8 #() 1664 nil 29 170 192 34 4 3888 8 'after' 3584 8 'afterTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 589 1 1122 581 683 3504 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 3888 3584 1664 nil 27 1664 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 41143 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 41151 nil nil 594 nil true 34 1 642 1 674 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 41155 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 3 1074 #createAt:extent: 34 2 1122 3839 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1074 #updateMenuBar 976 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 1664 nil 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

