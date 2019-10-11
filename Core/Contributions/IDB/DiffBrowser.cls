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

compareSmalltalkExpression: aSmalltalkExpression1 with: aSmalltalkExpression2

	^self show
		styler: SmalltalkExpressionStyler new;
		textStyles: SmalltalkWorkspace textStyles;
		compare: aSmalltalkExpression1 id: 'A' and: aSmalltalkExpression2 id: 'B';
		yourself!

compareSmalltalkMethod: aSmalltalkMethod1 with: aSmalltalkMethod2

	^self show
		styler: SmalltalkMethodStyler new;
		textStyles: MethodWorkspace textStyles;
		compare: aSmalltalkMethod1 id: 'A' and: aSmalltalkMethod2 id: 'B';
		yourself!

displayOn: aStream
	aStream nextPutAll: 'Difference Browser'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 1 1632 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1632 nil 8 1349308863 1426 nil nil 11 nil 170 192 34 10 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 1858 3 1762 #teal nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1858 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 1858 77 1762 #gray 1762 #white 1 nil nil nil nil #callTip nil nil nil #normal 1858 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 256 1984 1888 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1920 nil nil nil 1872 1936 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1632 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1762 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1824 nil nil nil nil 130003 nil 170 192 34 2 #diff 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 1632 1762 #yellow 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1858 1027 1762 #darkGoldenrod 1762 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 1858 1031 1762 #firebrick 1762 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1858 1029 nil 1762 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 1632 1074 #textLimit: 8 #(1073741823) 1632 1074 #caretPeriod: 8 #(530) 1632 1074 #wordWrap: 8 #(true) 1632 1074 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 1632 49 3 nil nil nil nil 2706 3 1632 1 nil nil 67108863 nil nil 2706 5 1632 1 nil nil nil nil nil 1632 1074 #canHScroll: 8 #(false) 1632 1074 #maxCompletionListHeight: 8 #(9) 1632 1074 #edgeColumn: 8 #(1) 1632 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 29 170 192 34 4 1632 8 'before' 1344 8 'beforeTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 337 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 34 2 1632 1344 1616 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3136 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3136 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3232 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 337 1122 1169 11 3136 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 8 #() 1616 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3424 nil nil nil 7 nil nil nil 3424 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3424 34 2 8 1140850945 262145 3504 nil nil nil 7 nil nil nil 3504 nil 8 1903849936 1426 nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 3504 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1616 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3424 34 2 8 1140920580 1 3760 1698 nil false 1744 nil 1776 nil 7 nil nil nil 3760 nil 8 1349308863 1426 nil nil 11 nil 170 192 34 10 #indentGuide 1858 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 1858 3 1904 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1858 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 1858 77 1952 1968 1 nil nil nil nil #callTip nil nil nil #normal 1858 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 256 3968 3920 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 3936 nil nil nil 3904 3952 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2018 #normal 170 192 34 2 #default 2082 1 nil nil nil 3760 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2144 nil nil 65 nil nil nil 2160 3 170 192 34 2 #container 3872 nil nil nil nil 130003 nil 170 192 34 2 #diff 2242 1 3760 2272 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1858 1027 2336 2352 1 nil nil nil nil #Warning nil nil nil #Error 1858 1031 2384 2400 1 nil nil nil nil #Error nil nil nil #Notification 1858 1029 nil 2432 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 3760 1074 #textLimit: 8 #(1073741823) 3760 1074 #caretPeriod: 8 #(530) 3760 1074 #wordWrap: 8 #(true) 3760 1074 #margins: 34 1 34 3 2706 1 3760 49 3 nil nil nil nil 2706 3 3760 1 nil nil 67108863 nil nil 2706 5 3760 1 nil nil nil nil nil 3760 1074 #canHScroll: 8 #(false) 3760 1074 #maxCompletionListHeight: 8 #(9) 3760 1074 #edgeColumn: 8 #(1) 3760 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 29 170 192 34 4 3504 8 'afterTitle' 3760 8 'after' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 347 1122 1169 337 3424 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 34 2 3760 3504 1616 nil 27 1616 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 37399 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 37407 nil nil 594 nil true 34 1 642 1 674 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 37411 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 3 1074 #createAt:extent: 34 2 1122 3839 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1074 #updateMenuBar 976 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 1616 nil 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 579 41 1344 1074 #text: 34 1 8 '
' 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 262145 1680 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1680 nil 8 1349308863 1426 nil nil 11 nil 170 192 34 10 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 1906 3 1810 #teal nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1906 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 1906 77 1810 #gray 1810 #white 1 nil nil nil nil #callTip nil nil nil #normal 1906 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 256 2032 1936 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1968 nil nil nil 1920 1984 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1680 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1810 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1872 nil nil nil nil 130003 nil 170 192 34 2 #diff 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 1680 1810 #yellow 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1906 1027 1810 #darkGoldenrod 1810 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 1906 1031 1810 #firebrick 1810 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1906 1029 nil 1810 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 579 643 1680 1074 #textLimit: 8 #(1073741823) 1680 1074 #caretPeriod: 8 #(530) 1680 1074 #wordWrap: 8 #(true) 1680 1074 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 1680 49 3 nil nil nil nil 2754 3 1680 1 nil nil 67108863 nil nil 2754 5 1680 1 nil nil nil nil nil 1680 1074 #canHScroll: 8 #(false) 1680 1074 #maxCompletionListHeight: 8 #(9) 1680 1074 #edgeColumn: 8 #(1) 1680 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 8 #() 1664 nil 29 170 192 34 4 1680 8 'before' 1344 8 'beforeTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 579 683 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 34 2 1680 1344 1664 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3184 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3184 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3280 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 579 1 1122 11 683 3184 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 8 #() 1664 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3472 nil nil nil 7 nil nil nil 3472 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3472 34 2 8 1140850945 262145 3552 nil nil nil 7 nil nil nil 3552 nil 8 1903849936 1426 nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 581 41 3552 1074 #text: 34 1 8 '
' 3552 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 8 #() 1664 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3472 34 2 8 1140920580 262145 3856 1746 nil false 1792 nil 1824 nil 7 nil nil nil 3856 nil 8 1349308863 1426 nil nil 11 nil 170 192 34 10 #indentGuide 1906 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 1906 3 1952 nil 1 nil nil nil nil #whitespace nil nil nil #lineNumber 1906 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 1906 77 2000 2016 1 nil nil nil nil #callTip nil nil nil #normal 1906 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 256 4064 4016 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 4032 nil nil nil 4000 4048 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 2066 #normal 170 192 34 2 #default 2130 1 nil nil nil 3856 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2192 nil nil 65 nil nil nil 2208 3 170 192 34 2 #container 3968 nil nil nil nil 130003 nil 170 192 34 2 #diff 2290 1 3856 2320 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1906 1027 2384 2400 1 nil nil nil nil #Warning nil nil nil #Error 1906 1031 2432 2448 1 nil nil nil nil #Error nil nil nil #Notification 1906 1029 nil 2480 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 581 643 3856 1074 #textLimit: 8 #(1073741823) 3856 1074 #caretPeriod: 8 #(530) 3856 1074 #wordWrap: 8 #(true) 3856 1074 #margins: 34 1 34 3 2754 1 3856 49 3 nil nil nil nil 2754 3 3856 1 nil nil 67108863 nil nil 2754 5 3856 1 nil nil nil nil nil 3856 1074 #canHScroll: 8 #(false) 3856 1074 #maxCompletionListHeight: 8 #(9) 3856 1074 #edgeColumn: 8 #(1) 3856 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 8 #() 1664 nil 29 170 192 34 4 3856 8 'after' 3552 8 'afterTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 589 1 1122 581 683 3472 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 3856 3552 1664 nil 27 1664 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 38085 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 38093 nil nil 594 nil true 34 1 642 1 674 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 38097 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 3 1074 #createAt:extent: 34 2 1122 3839 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1074 #updateMenuBar 976 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 1664 nil 27 )! !
!DiffBrowser class categoriesFor: #compare:with:!public! !
!DiffBrowser class categoriesFor: #compareSmalltalkExpression:with:!public! !
!DiffBrowser class categoriesFor: #compareSmalltalkMethod:with:!public! !
!DiffBrowser class categoriesFor: #displayOn:!operations!public! !
!DiffBrowser class categoriesFor: #publishedAspects!operations!public! !
!DiffBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!DiffBrowser class categoriesFor: #resource_Vertical_view!public!resources-views! !

