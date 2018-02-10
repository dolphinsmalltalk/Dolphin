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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 544 0 466 496 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 0 0 0 674 1 706 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 0 0 0 674 1 706 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 0 0 0 674 1 706 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 0 0 0 674 1 706 #toggleWrapping 8 '&Word Wrap' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 544 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 1008 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1154 1169 683 544 1106 #contextMenu: 34 1 640 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 0 544 34 2 8 1140850688 131073 1296 0 466 496 0 7 0 0 0 1296 514 1 1 0 410 ##(Smalltalk.StaticText) 34 16 0 1296 34 2 8 1140850945 262145 1392 0 0 0 7 0 0 0 1392 0 8 4294903859 852486 ##(Smalltalk.NullConverter) 0 0 0 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 297 1154 1169 41 1392 1106 #text: 34 1 8 '
' 1392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1154 193 193 0 27 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 1296 34 2 8 1140920580 1025 1728 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 466 496 0 7 0 0 0 1728 0 8 4294906539 1474 0 0 11 0 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1970 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 1938 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 1938 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #diff 1938 5 0 196934 1 ##(Smalltalk.RGB) 16908287 3 0 0 0 0 #diff 0 1401 0 #whitespace 1938 3 1970 33554445 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 1938 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 2016 2096 2048 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2032 0 0 0 2128 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 1728 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1008 0 170 176 1008 9215 0 0 0 0 1970 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 1904 0 0 0 0 1 0 170 192 34 6 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 1728 33423361 5 false 0 0 0 0 0 0 0 8 'indicator2' 2418 5 1728 511 1 false 0 0 0 0 0 0 0 8 'indicator0' 2418 1 1728 33554459 13 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 1938 1029 0 2066 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 1938 1027 2066 60239 2066 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 1938 1031 2066 335 2066 31317503 1 0 0 0 0 #Error 0 0 0 0 1042 138 144 34 6 1106 #createAt:extent: 34 2 1154 1 1 1154 1169 297 1728 1106 #modificationEventMask: 8 #(4607) 1728 1106 #caretPeriod: 8 #(530) 1728 1106 #wordWrap: 8 #(true) 1728 1106 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1728 49 3 0 0 0 0 2930 3 1728 1 0 0 67108863 0 0 2930 5 1728 1 0 0 0 0 0 1728 1106 #canHScroll: 8 #(false) 1728 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1712 0 29 170 192 34 4 1392 8 'beforeTitle' 1728 8 'before' 0 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 1 1154 1169 337 1296 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 34 2 1728 1392 1712 0 27 410 ##(Smalltalk.Splitter) 34 12 0 544 34 2 8 1140850688 1 3296 0 2066 66047 0 519 0 0 0 3296 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 337 1154 1169 11 3296 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 8 #() 1712 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 544 34 2 8 1140850688 131073 3536 0 466 496 0 7 0 0 0 3536 514 1 1 0 410 ##(Smalltalk.StaticText) 34 16 0 3536 34 2 8 1140850945 262145 3632 0 0 0 7 0 0 0 3632 0 8 4294903859 1474 0 0 0 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 297 1154 1169 41 3632 1106 #text: 34 1 8 '
' 3632 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1712 0 27 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 3536 34 2 8 1140920580 1025 3936 1794 0 false 1840 0 466 496 0 7 0 0 0 3936 0 8 4294906539 1474 0 0 11 0 170 192 34 12 #callTip 1938 77 1984 2000 1 0 0 0 0 #callTip 0 0 0 #normal 1938 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 1938 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #diff 1938 5 0 2066 16908287 3 0 0 0 0 #diff 0 1401 0 #whitespace 1938 3 2112 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 1938 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 4112 4176 4144 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4128 0 0 0 4192 0 0 2162 2192 170 192 34 2 #default 2242 1 0 0 0 3936 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1008 0 170 176 1008 9215 0 0 0 0 2304 0 0 65 0 0 0 2320 3 170 192 34 2 #container 4064 0 0 0 0 1 0 170 192 34 6 8 'indicator0' 2418 1 3936 33554459 13 false 0 0 0 0 0 0 0 8 'indicator2' 2418 5 3936 511 1 false 0 0 0 0 0 0 0 8 'indicator1' 2418 3 3936 33423361 5 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 1938 1029 0 2066 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 1938 1027 2066 60239 2066 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 1938 1031 2066 335 2066 31317503 1 0 0 0 0 #Error 0 0 0 0 1042 138 144 34 6 1106 #createAt:extent: 34 2 1154 1 1 1154 1169 297 3936 1106 #modificationEventMask: 8 #(4607) 3936 1106 #caretPeriod: 8 #(530) 3936 1106 #wordWrap: 8 #(true) 3936 1106 #margins: 34 1 34 3 2930 1 3936 49 3 0 0 0 0 2930 3 3936 1 0 0 67108863 0 0 2930 5 3936 1 0 0 0 0 0 3936 1106 #canHScroll: 8 #(false) 3936 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1712 0 29 170 192 34 4 3936 8 'after' 3632 8 'afterTitle' 0 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 347 1154 1169 337 3536 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 34 2 3936 3632 1712 0 27 1712 0 27 170 192 34 2 544 8 'diffs' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 3 626 0 true 34 4 674 1 706 #selectUpper 8 'Select &upper' 1 1 0 0 0 674 1 706 #selectLower 8 'Select &lower' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 674 1 706 #exit 8 '&Close' 1 1 0 0 0 8 '&File' 0 1 0 0 39565 0 0 626 0 true 34 3 674 1 706 #character 8 '&Character' 1 1 0 0 0 674 1 706 #word 8 '&Word' 1 1 0 0 0 674 1 706 #line 8 '&Line' 1 1 0 0 0 8 '&Mode' 0 1 0 0 39573 0 0 626 0 true 34 1 674 1 706 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 39577 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1042 138 144 34 3 1106 #createAt:extent: 34 2 1154 3839 21 1154 1201 801 416 1106 #text: 34 1 8 'Differences' 416 1106 #updateMenuBar 1008 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 544 1712 0 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 0 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 544 0 466 496 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 0 0 0 674 1 706 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 0 0 0 674 1 706 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 0 0 0 674 1 706 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 0 0 0 674 1 706 #toggleWrapping 8 '&Word Wrap' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 544 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 1008 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1154 1169 683 544 1106 #contextMenu: 34 1 640 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 0 544 34 2 8 1140850688 131073 1296 0 466 496 0 7 0 0 0 1296 514 1 1 0 410 ##(Smalltalk.StaticText) 34 16 0 1296 34 2 8 1140850945 262145 1392 0 0 0 7 0 0 0 1392 0 8 4294903859 852486 ##(Smalltalk.NullConverter) 0 0 0 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 643 1154 579 41 1392 1106 #text: 34 1 8 '
' 1392 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 8 #() 1154 193 193 0 27 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 1296 34 2 8 1140920580 1025 1728 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 466 496 0 7 0 0 0 1728 0 8 4294906539 1474 0 0 11 0 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1970 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 1938 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 1938 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #diff 1938 5 0 196934 1 ##(Smalltalk.RGB) 16908287 3 0 0 0 0 #diff 0 1401 0 #whitespace 1938 3 1970 33554445 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 1938 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 2016 2096 2048 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2032 0 0 0 2128 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 1728 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1008 0 170 176 1008 9215 0 0 0 0 1970 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 1904 0 0 0 0 1 0 170 192 34 6 8 'indicator1' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 3 1728 33423361 5 false 0 0 0 0 0 0 0 8 'indicator0' 2418 1 1728 33554459 13 false 0 0 0 0 0 0 0 8 'indicator2' 2418 5 1728 511 1 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 1938 1029 0 2066 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 1938 1027 2066 60239 2066 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 1938 1031 2066 335 2066 31317503 1 0 0 0 0 #Error 0 0 0 0 1042 138 144 34 6 1106 #createAt:extent: 34 2 1154 1 1 1154 579 643 1728 1106 #modificationEventMask: 8 #(4607) 1728 1106 #caretPeriod: 8 #(530) 1728 1106 #wordWrap: 8 #(true) 1728 1106 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1728 49 3 0 0 0 0 2930 3 1728 1 0 0 67108863 0 0 2930 5 1728 1 0 0 0 0 0 1728 1106 #canHScroll: 8 #(false) 1728 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 8 #() 1712 0 29 170 192 34 4 1728 8 'before' 1392 8 'beforeTitle' 0 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 1 1 1154 579 683 1296 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 34 2 1728 1392 1712 0 27 410 ##(Smalltalk.Splitter) 34 12 0 544 34 2 8 1140850688 1 3296 0 2066 66047 0 519 0 0 0 3296 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 579 1 1154 11 683 3296 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 8 #() 1712 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 544 34 2 8 1140850688 131073 3536 0 466 496 0 7 0 0 0 3536 514 1 1 0 410 ##(Smalltalk.StaticText) 34 16 0 3536 34 2 8 1140850945 262145 3632 0 0 0 7 0 0 0 3632 0 8 4294903859 1474 0 0 0 1042 138 144 34 2 1106 #createAt:extent: 34 2 1154 1 643 1154 581 41 3632 1106 #text: 34 1 8 '
' 3632 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 8 #() 1712 0 27 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 3536 34 2 8 1140920580 1025 3936 1794 0 false 1840 0 466 496 0 7 0 0 0 3936 0 8 4294906539 1474 0 0 11 0 170 192 34 12 #callTip 1938 77 1984 2000 1 0 0 0 0 #callTip 0 0 0 #normal 1938 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 1938 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #diff 1938 5 0 2066 16908287 3 0 0 0 0 #diff 0 1401 0 #whitespace 1938 3 2112 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 1938 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 4112 4176 4144 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4128 0 0 0 4192 0 0 2162 2192 170 192 34 2 #default 2242 1 0 0 0 3936 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1008 0 170 176 1008 9215 0 0 0 0 2304 0 0 65 0 0 0 2320 3 170 192 34 2 #container 4064 0 0 0 0 1 0 170 192 34 6 8 'indicator0' 2418 1 3936 33554459 13 false 0 0 0 0 0 0 0 8 'indicator1' 2418 3 3936 33423361 5 false 0 0 0 0 0 0 0 8 'indicator2' 2418 5 3936 511 1 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 1938 1029 0 2066 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 1938 1027 2066 60239 2066 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 1938 1031 2066 335 2066 31317503 1 0 0 0 0 #Error 0 0 0 0 1042 138 144 34 6 1106 #createAt:extent: 34 2 1154 1 1 1154 581 643 3936 1106 #modificationEventMask: 8 #(4607) 3936 1106 #caretPeriod: 8 #(530) 3936 1106 #wordWrap: 8 #(true) 3936 1106 #margins: 34 1 34 3 2930 1 3936 49 3 0 0 0 0 2930 3 3936 1 0 0 67108863 0 0 2930 5 3936 1 0 0 0 0 0 3936 1106 #canHScroll: 8 #(false) 3936 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 8 #() 1712 0 29 170 192 34 4 3936 8 'after' 3632 8 'afterTitle' 0 1042 138 144 34 1 1106 #createAt:extent: 34 2 1154 589 1 1154 581 683 3536 1234 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 3936 3632 1712 0 27 1712 0 27 170 192 34 2 544 8 'diffs' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 3 626 0 true 34 4 674 1 706 #selectUpper 8 'Select &upper' 1 1 0 0 0 674 1 706 #selectLower 8 'Select &lower' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 674 1 706 #exit 8 '&Close' 1 1 0 0 0 8 '&File' 0 1 0 0 39545 0 0 626 0 true 34 3 674 1 706 #character 8 '&Character' 1 1 0 0 0 674 1 706 #word 8 '&Word' 1 1 0 0 0 674 1 706 #line 8 '&Line' 1 1 0 0 0 8 '&Mode' 0 1 0 0 39553 0 0 626 0 true 34 1 674 1 706 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 39557 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1042 138 144 34 3 1106 #createAt:extent: 34 2 1154 3839 21 1154 1201 801 416 1106 #text: 34 1 8 'Differences' 416 1106 #updateMenuBar 1008 416 1234 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 544 1712 0 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

