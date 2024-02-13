"Filed out from Dolphin Smalltalk"!

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
		dipExtent: 200 @ 180;
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
	<commandQuery: #queryDiffMode:>
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
	<commandQuery: #queryDiffMode:>
	self mode: #line!

mode: aSymbol 
	diffsPresenter comparisonMode: aSymbol!

queryDiffMode: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: diffsPresenter comparisonMode == aCommandQuery command!

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
	<commandQuery: #queryDiffMode:>
	self mode: #word! !

!DiffBrowser categoriesForMethods!
about!commands-actions!public! !
about:!operations!public! !
character!commands-actions!public! !
compare:id:and:id:!operations!public! !
createComponents!initializing!public! !
line!commands-actions!public! !
mode:!operations!public! !
queryDiffMode:!commands-queries!private! !
readTextFrom:!helpers!public! !
selectLower!commands-actions!public! !
selectUpper!commands-actions!public! !
styler:!accessing!public! !
textFont:!accessing!public! !
textStyles:!accessing!public! !
word!commands-actions!public! !
!

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

displayOn: aPuttable
	aPuttable nextPutAll: 'Difference Browser'!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() true 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1877802176 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 1 1632 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1632 nil 8 1355169256 1426 nil nil 11 1725586737 170 192 34 10 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1858 3 1762 #teal nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1858 77 1762 #gray 1762 #white 1 nil nil nil nil #callTip nil nil nil #normal 1858 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1858 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1632 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1762 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1824 nil nil nil nil 208 nil 170 192 34 2 #diff 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 1632 1762 #yellow 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1858 1027 1762 #darkGoldenrod 1762 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 1858 1031 1762 #firebrick 1762 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1858 1029 nil 1762 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 1632 1074 #caretPeriod: 8 #(530) 1632 1074 #wordWrap: 8 #(true) 1632 1074 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 1632 49 3 nil nil nil nil 2658 3 1632 1 nil nil 67108863 nil nil 2658 5 1632 1 nil nil nil nil nil 1632 1074 #canHScroll: 8 #(false) 1632 1074 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 1632 1074 #maxCompletionListHeight: 8 #(9) 1632 1074 #edgeColumn: 8 #(1) 1632 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 31 170 192 34 4 1632 8 'before' 1344 8 'beforeTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 337 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 168 0 0 0] 34 2 1632 1344 1616 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3152 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3152 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3248 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 337 1122 1169 11 3152 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 72 2 0 0 173 0 0 0] 8 #() 1616 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3440 nil nil nil 7 nil nil nil 3440 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3440 34 2 8 1140850945 262145 3520 nil nil nil 7 nil nil nil 3520 nil 8 1877802176 1426 nil nil nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 297 1122 1169 41 3520 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 148 0 0 0 72 2 0 0 168 0 0 0] 8 #() 1616 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3440 34 2 8 1140920580 1 3776 1698 nil false 1744 nil 1776 nil 7 nil nil nil 3776 nil 8 1355169256 1426 nil nil 11 1725569265 170 192 34 10 #lineNumber 1858 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1858 3 1904 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1858 77 1936 1952 1 nil nil nil nil #callTip nil nil nil #normal 1858 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1858 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 2002 #normal 170 192 34 2 #default 2066 1 nil nil nil 3776 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2128 nil nil 65 nil nil nil 2144 3 170 192 34 2 #container 3888 nil nil nil nil 208 nil 170 192 34 2 #diff 2226 1 3776 2256 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1858 1027 2320 2336 1 nil nil nil nil #Warning nil nil nil #Error 1858 1031 2368 2384 1 nil nil nil nil #Error nil nil nil #Notification 1858 1029 nil 2416 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 1169 297 3776 1074 #caretPeriod: 8 #(530) 3776 1074 #wordWrap: 8 #(true) 3776 1074 #margins: 34 1 34 3 2658 1 3776 49 3 nil nil nil nil 2658 3 3776 1 nil nil 67108863 nil nil 2658 5 3776 1 nil nil nil nil nil 3776 1074 #canHScroll: 8 #(false) 3776 1074 #targetRange: 34 1 2786 1 -1 3 3776 1074 #maxCompletionListHeight: 8 #(9) 3776 1074 #edgeColumn: 8 #(1) 3776 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 148 0 0 0] 8 #() 1616 nil 31 170 192 34 4 3520 8 'afterTitle' 3776 8 'after' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 347 1122 1169 337 3440 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 173 0 0 0 72 2 0 0 85 1 0 0] 34 2 3776 3520 1616 nil 27 1616 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 56035 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 56043 nil nil 594 nil true 34 15 642 1 674 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 642 1 674 #help 8 'On this &Tool' 1249 1 nil nil nil 642 1 674 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5170 4097 642 1 674 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 1762 #orchid 1952 nil nil 1 nil nil nil nil 5170 4097 642 1 674 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 642 1 674 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 642 1 674 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5170 4097 642 1 674 #dolphinHomePage 8 'Object Arts Homepage' 1 1 5538 nil true 5584 8 '!!APPLICATION' 5632 nil nil 642 1 674 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 642 1 674 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5170 4097 642 1 674 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5826 $\x1F42C nil nil 1762 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 6143 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 1 528 1616 nil 27 )!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #toggleIndentGuides 8 'Indentation &Guides' 1 1 nil nil nil 642 1 674 #toggleVisibleLineEndings 8 'Line &Endings' 1 1 nil nil nil 642 1 674 #toggleLineNumberMargins 8 'Line N&umbers' 1 1 nil nil nil 642 1 674 #toggleVisibleWhitespace 8 'W&hitespace' 1 1 nil nil nil 642 1 674 #toggleWrapping 8 '&Word Wrap' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 976 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 1122 1169 683 528 1074 #contextMenu: 34 1 608 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 1264 34 2 8 1140850945 262145 1344 nil nil nil 7 nil nil nil 1344 nil 8 1877802176 852486 ##(Smalltalk.NullConverter) nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 579 41 1344 1074 #text: 34 1 8 '
' 1344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 33 1 0 0 85 1 0 0] 8 #() 1122 193 193 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 1264 34 2 8 1140920580 262145 1680 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1680 nil 8 1355169256 1426 nil nil 11 1725608577 170 192 34 10 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1906 3 1810 #teal nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1906 77 1810 #gray 1810 #white 1 nil nil nil nil #callTip nil nil nil #normal 1906 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1906 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1680 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1810 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1872 nil nil nil nil 208 nil 170 192 34 2 #diff 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 1680 1810 #yellow 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1906 1027 1810 #darkGoldenrod 1810 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 1906 1031 1810 #firebrick 1810 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 1906 1029 nil 1810 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 579 643 1680 1074 #caretPeriod: 8 #(530) 1680 1074 #wordWrap: 8 #(true) 1680 1074 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 1680 49 3 nil nil nil nil 2706 3 1680 1 nil nil 67108863 nil nil 2706 5 1680 1 nil nil nil nil nil 1680 1074 #canHScroll: 8 #(false) 1680 1074 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 1680 1074 #maxCompletionListHeight: 8 #(9) 1680 1074 #edgeColumn: 8 #(1) 1680 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 65 1 0 0] 8 #() 1664 nil 31 170 192 34 4 1680 8 'before' 1344 8 'beforeTitle' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 1 1 1122 579 683 1264 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 33 1 0 0 85 1 0 0] 34 2 1680 1344 1664 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 3200 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3200 nil 1 #left nil nil nil 1122 1 1 1122 9 9 nil 3296 nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 579 1 1122 11 683 3200 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 33 1 0 0 0 0 0 0 38 1 0 0 85 1 0 0] 8 #() 1664 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 3488 nil nil nil 7 nil nil nil 3488 498 1 1 nil 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850945 262145 3568 nil nil nil 7 nil nil nil 3568 nil 8 1877802176 1426 nil nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 1 643 1122 581 41 3568 1074 #text: 34 1 8 '
' 3568 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 34 1 0 0 85 1 0 0] 8 #() 1664 nil 27 nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3488 34 2 8 1140920580 262145 3872 1746 nil false 1792 nil 1824 nil 7 nil nil nil 3872 nil 8 1355169256 1426 nil nil 11 1725599841 170 192 34 10 #lineNumber 1906 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1906 3 1952 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1906 77 1984 2000 1 nil nil nil nil #callTip nil nil nil #normal 1906 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1906 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 2050 #normal 170 192 34 2 #default 2114 1 nil nil nil 3872 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 2176 nil nil 65 nil nil nil 2192 3 170 192 34 2 #container 3984 nil nil nil nil 208 nil 170 192 34 2 #diff 2274 1 3872 2304 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1906 1027 2368 2384 1 nil nil nil nil #Warning nil nil nil #Error 1906 1031 2416 2432 1 nil nil nil nil #Error nil nil nil #Notification 1906 1029 nil 2464 1 nil nil nil nil #Notification nil nil nil nil 1010 138 144 34 8 1074 #createAt:extent: 34 2 1122 1 1 1122 581 643 3872 1074 #caretPeriod: 8 #(530) 3872 1074 #wordWrap: 8 #(true) 3872 1074 #margins: 34 1 34 3 2706 1 3872 49 3 nil nil nil nil 2706 3 3872 1 nil nil 67108863 nil nil 2706 5 3872 1 nil nil nil nil nil 3872 1074 #canHScroll: 8 #(false) 3872 1074 #targetRange: 34 1 2834 1 -1 3 3872 1074 #maxCompletionListHeight: 8 #(9) 3872 1074 #edgeColumn: 8 #(1) 3872 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 34 1 0 0 65 1 0 0] 8 #() 1664 nil 31 170 192 34 4 3568 8 'afterTitle' 3872 8 'after' nil 1010 138 144 34 1 1074 #createAt:extent: 34 2 1122 589 1 1122 581 683 3488 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 38 1 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 3872 3568 1664 nil 27 1664 nil 27 170 192 34 2 528 8 'diffs' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 594 nil true 34 4 642 1 674 #selectUpper 8 'Select &upper' 1 1 nil nil nil 642 1 674 #selectLower 8 'Select &lower' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 642 1 674 #exit 8 '&Close' 1 1 nil nil nil 8 '&File' nil 1 nil nil 55995 nil nil 594 nil true 34 3 642 1 674 #character 8 '&Character' 1 1 nil nil nil 642 1 674 #word 8 '&Word' 1 1 nil nil nil 642 1 674 #line 8 '&Line' 1 1 nil nil nil 8 '&Mode' nil 1 nil nil 56003 nil nil 594 nil true 34 15 642 1 674 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 642 1 674 #help 8 'On this &Tool' 1249 1 nil nil nil 642 1 674 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5266 4097 642 1 674 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 1810 #orchid 2000 nil nil 1 nil nil nil nil 5266 4097 642 1 674 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 642 1 674 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 642 1 674 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5266 4097 642 1 674 #dolphinHomePage 8 'Object Arts Homepage' 1 1 5634 nil true 5680 8 '!!APPLICATION' 5728 nil nil 642 1 674 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 642 1 674 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5266 4097 642 1 674 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5922 $\x1F42C nil nil 1810 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1010 138 144 34 2 1074 #createAt:extent: 34 2 1122 6143 21 1122 1201 801 416 1074 #text: 34 1 8 'Differences' 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 1 528 1664 nil 27 )! !

!DiffBrowser class categoriesForMethods!
compare:with:!public! !
compareSmalltalkExpression:with:!public! !
compareSmalltalkMethod:with:!public! !
displayOn:!operations!public! !
publishedAspects!operations!public! !
resource_Default_view!public!resources-views! !
resource_Vertical_view!public!resources-views! !
!

