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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 1 1632 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1632 nil 8 1892470377 1426 nil nil 11 nil 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1906 33554471 1 nil nil nil nil #callTip nil nil nil #whitespace 1874 3 1906 33554445 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1874 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1874 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1874 5 nil 196934 1 ##(Smalltalk.RGB) 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1874 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 2000 1952 2016 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1984 nil nil nil 2064 nil nil 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1632 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1906 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1840 nil nil nil nil 1 nil 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 1632 33554459 13 false nil nil nil nil nil nil nil 8 'indicator1' 2354 3 1632 33423361 5 false nil nil nil nil nil nil nil 8 'indicator2' 2354 5 1632 511 1 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1874 1027 2034 60239 2034 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1874 1031 2034 335 2034 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1874 1029 nil 2034 31185883 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 1632 1074 #textLimit: 8 #(1073741823) 1632 1074 #modificationEventMask: 8 #(4607) 1632 1074 #caretPeriod: 8 #(530) 1632 1074 #wordWrap: 8 #(true) 1632 1074 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1632 49 3 nil nil nil nil 2898 3 1632 1 nil nil 67108863 nil nil 2898 5 1632 1 nil nil nil nil nil 1632 1074 #canHScroll: 8 #(false) 1632 1074 #maxCompletionListHeight: 8 #(9) 1632 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 29 170 192 34 4 1344 8 'beforeTitle' 1632 8 'before' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 337 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 34 2 1632 1344 1616 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3296 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3296 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3392 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 337 1122 1169 11 3296 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 8 #() 1616 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3584 nil nil nil 7 nil nil nil 3584 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3584 34 2 8 1140850945 262145 3664 nil nil nil 7 nil nil nil 3664 nil 8 1912674480 1426 nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 3664 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1616 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3584 34 2 8 1140920580 1 3920 1698 nil false 1744 nil 1762 1792 nil 7 nil nil nil 3920 nil 8 1892470377 1426 nil nil 11 nil 170 192 34 12 #callTip 1874 77 1920 1936 1 nil nil nil nil #callTip nil nil nil #whitespace 1874 3 1968 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1874 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1874 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1874 5 nil 2034 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1874 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 4128 4096 4144 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 4112 nil nil nil 4176 nil nil 2098 2128 170 192 34 2 #default 2178 1 nil nil nil 3920 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2240 nil nil 65 nil nil nil 2256 3 170 192 34 2 #container 4048 nil nil nil nil 1 nil 170 192 34 6 8 'indicator2' 2354 5 3920 511 1 false nil nil nil nil nil nil nil 8 'indicator0' 2354 1 3920 33554459 13 false nil nil nil nil nil nil nil 8 'indicator1' 2354 3 3920 33423361 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1874 1027 2034 60239 2034 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1874 1031 2034 335 2034 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1874 1029 nil 2034 31185883 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 3920 1074 #textLimit: 8 #(1073741823) 3920 1074 #modificationEventMask: 8 #(4607) 3920 1074 #caretPeriod: 8 #(530) 3920 1074 #wordWrap: 8 #(true) 3920 1074 #margins: 34 1 34 3 2898 1 3920 49 3 nil nil nil nil 2898 3 3920 1 nil nil 67108863 nil nil 2898 5 3920 1 nil nil nil nil nil 3920 1074 #canHScroll: 8 #(false) 3920 1074 #maxCompletionListHeight: 8 #(9) 3920 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 29 170 192 34 4 3664 8 'afterTitle' 3920 8 'after' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 347 1122 1169 337 3584 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 34 2 3920 3664 1616 nil 27 1616 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 26925 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 26933 nil nil 594 nil true 34 1 642 1 674 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 26937 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 3 1074 #createAt:extent: 34 2 1122 3839 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1074 #updateMenuBar 976 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 1616 nil 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 579 41 1344 1074 #text: 34 1 8 '
' 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 262145 1680 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1680 nil 8 1892470377 1426 nil nil 11 nil 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1954 33554471 1 nil nil nil nil #callTip nil nil nil #whitespace 1922 3 1954 33554445 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1922 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1922 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1922 5 nil 196934 1 ##(Smalltalk.RGB) 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1922 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 2048 2000 2064 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2032 nil nil nil 2112 nil nil 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1680 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1954 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1888 nil nil nil nil 130003 nil 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 1680 33554459 13 false nil nil nil nil nil nil nil 8 'indicator2' 2402 5 1680 511 1 false nil nil nil nil nil nil nil 8 'indicator1' 2402 3 1680 33423361 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1922 1027 2082 60239 2082 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1922 1031 2082 335 2082 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1922 1029 nil 2082 31185883 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 579 643 1680 1074 #textLimit: 8 #(1073741823) 1680 1074 #modificationEventMask: 8 #(4607) 1680 1074 #caretPeriod: 8 #(530) 1680 1074 #wordWrap: 8 #(true) 1680 1074 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1680 49 3 nil nil nil nil 2946 3 1680 1 nil nil 67108863 nil nil 2946 5 1680 1 nil nil nil nil nil 1680 1074 #canHScroll: 8 #(false) 1680 1074 #maxCompletionListHeight: 8 #(9) 1680 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 8 #() 1664 nil 29 170 192 34 4 1680 8 'before' 1344 8 'beforeTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 579 683 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 34 2 1680 1344 1664 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3344 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3344 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3440 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 579 1 1122 11 683 3344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 8 #() 1664 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3632 nil nil nil 7 nil nil nil 3632 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3632 34 2 8 1140850945 262145 3712 nil nil nil 7 nil nil nil 3712 nil 8 1912674480 1426 nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 581 41 3712 1074 #text: 34 1 8 '
' 3712 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 8 #() 1664 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3632 34 2 8 1140920580 262145 4016 1746 nil false 1792 nil 1810 1840 nil 7 nil nil nil 4016 nil 8 1892470377 1426 nil nil 11 nil 170 192 34 12 #callTip 1922 77 1968 1984 1 nil nil nil nil #callTip nil nil nil #whitespace 1922 3 2016 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1922 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1922 1 nil nil 1 nil nil nil nil #normal nil nil nil #diff 1922 5 nil 2082 16908287 3 nil nil nil nil #diff nil 1401 nil #indentGuide 1922 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 4224 4192 4240 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 4208 nil nil nil 4272 nil nil 2146 2176 170 192 34 2 #default 2226 1 nil nil nil 4016 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2288 nil nil 65 nil nil nil 2304 3 170 192 34 2 #container 4144 nil nil nil nil 130003 nil 170 192 34 6 8 'indicator0' 2402 1 4016 33554459 13 false nil nil nil nil nil nil nil 8 'indicator1' 2402 3 4016 33423361 5 false nil nil nil nil nil nil nil 8 'indicator2' 2402 5 4016 511 1 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 1922 1027 2082 60239 2082 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1922 1031 2082 335 2082 31317503 1 nil nil nil nil #Error nil nil nil #Notification 1922 1029 nil 2082 31185883 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 581 643 4016 1074 #textLimit: 8 #(1073741823) 4016 1074 #modificationEventMask: 8 #(4607) 4016 1074 #caretPeriod: 8 #(530) 4016 1074 #wordWrap: 8 #(true) 4016 1074 #margins: 34 1 34 3 2946 1 4016 49 3 nil nil nil nil 2946 3 4016 1 nil nil 67108863 nil nil 2946 5 4016 1 nil nil nil nil nil 4016 1074 #canHScroll: 8 #(false) 4016 1074 #maxCompletionListHeight: 8 #(9) 4016 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 8 #() 1664 nil 29 170 192 34 4 4016 8 'after' 3712 8 'afterTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 589 1 1122 581 683 3632 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 4016 3712 1664 nil 27 1664 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 27297 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 27305 nil nil 594 nil true 34 1 642 1 674 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 27309 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 3 1074 #createAt:extent: 34 2 1122 3839 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1074 #updateMenuBar 976 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 1664 nil 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

