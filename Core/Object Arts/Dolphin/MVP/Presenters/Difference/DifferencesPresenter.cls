"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #DifferencesPresenter
	instanceVariableNames: 'beforePresenter afterPresenter beforeTitlePresenter afterTitlePresenter comparisonMode wordSeparators'
	classVariableNames: 'WordSeparators'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DifferencesPresenter guid: (GUID fromString: '{772ec3bd-72dc-4bae-9e30-92d686ea4e3b}')!
DifferencesPresenter comment: 'DifferencesPresenter is a component that can be used to compare two pieces of text, highlighting the differences. 

Two pieces of text are compared using the #compare:with: message. The text can be plain or rich text. If rich text is compared, then the styling will be preserved in the resulting display, except of course that the highlighting of any differences takes precedence. 

The differencing algorithm allows comparison and highlighting of differences on a character, word, or line basis. The decomposition of the text into words (when in word comparison mode) is based on whitespace and configurable sets of word separator characters (see #parseWordsFrom:).

DifferencesPresenter is based on Ian Bartholomew''s DiffBrowser.

'!
!DifferencesPresenter categoriesForClass!MVP-Presenters! !
!DifferencesPresenter methodsFor!

afterText: afterString 
	afterPresenter value: afterString!

afterTitle: aString 
	afterTitlePresenter value: aString!

beforeText: beforeString 
	beforePresenter value: beforeString!

beforeTitle: aString 
	beforeTitlePresenter value: aString!

clear
	beforePresenter clear.
	afterPresenter clear!

clearDiffs
	{beforePresenter. afterPresenter} do: 
			[:each |
			self
				display: #()
				items: #()
				presenter: each]!

compare: beforeString with: afterString 
	self
		beforeText: beforeString;
		afterText: afterString;
		refresh!

comparisonMode
	^comparisonMode!

comparisonMode: aSymbol 
	"Set the comparison mode, one of #line, #word, or #character."

	comparisonMode := aSymbol.
	self refresh!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	beforePresenter := self add: TextPresenter new name: 'before'.
	afterPresenter := self add: TextPresenter new name: 'after'.
	beforeTitlePresenter := self add: TextPresenter new name: 'beforeTitle'.
	afterTitlePresenter := self add: TextPresenter new name: 'afterTitle'!

diff: beforeSequence and: afterSequence 
	| match |
	match := (beforeSequence collect: [:each | each key]) 
				longestCommonSubsequenceInInterval: (1 to: beforeSequence size)
				withCollection: (afterSequence collect: [:each | each key])
				inInterval: (1 to: afterSequence size).
	self 
		display: match
		items: beforeSequence
		presenter: beforePresenter.
	self 
		display: (afterSequence inverseMatchVector: match)
		items: afterSequence
		presenter: afterPresenter!

display: anArray items: items presenter: aTextPresenter
	| diffs |
	diffs := (self reduce: anArray) collect: 
					[:each |
					ScintillaIndicator styleName: #diff
						range: ((items at: each first) value first to: (items at: each last) value last)].
	aTextPresenter view indicators: diffs!

initialize
	super initialize.
	wordSeparators := self class wordSeparators.
	comparisonMode := #word!

parse: aString 
	| items positions |
	comparisonMode == #character 
		ifTrue: [items := aString asOrderedCollection collect: [:each | each asString]].
	comparisonMode == #line 
		ifTrue: [items := aString lines]
		ifFalse: [items := self parseWordsFrom: aString].
	positions := OrderedCollection new.
	items inject: 1
		into: 
			[:begin :each | 
			| pos str |
			str := each isEmpty ifTrue: [String lineDelimiter] ifFalse: [each].
			pos := aString findString: str startingAt: begin.
			positions add: each -> (pos to: pos + each size - 1).
			pos + str size].
	^positions select: [:each | each key notEmpty]!

parseWordsFrom: aString 
	"Private - Split into words and then split off any extra bracketing characters that are wrapping the word. 
	This prevents something like -
	aaa bbb ccc   diffWith->  (aaa bbb ccc) reddening all of (aaa and ccc)"

	| aStream answer wordStream |
	answer := OrderedCollection new.
	aStream := aString readStream.
	wordStream := String writeStream: 10.
	[aStream atEnd] whileFalse: 
			[| next word |
			wordStream reset.
			[aStream atEnd or: [(next := aStream next) isSeparator]] whileFalse: 
					[(wordSeparators identityIncludes: next) 
						ifTrue: 
							[word := wordStream contents.
							word notEmpty ifTrue: [answer add: word].
							wordStream reset.
							answer add: next asString]
						ifFalse: [wordStream nextPut: next]].
			word := wordStream contents.
			word notEmpty ifTrue: [answer add: word]].
	^answer asArray!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	command == #toggleSyntaxColoring
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: beforePresenter view isStylingEnabled.
			^true].
	command == #toggleLineNumberMargins
		ifTrue: 
			[beforePresenter view lineNumberMargin 
				ifNil: [aCommandQuery isEnabled: false]
				ifNotNil: 
					[:margin | 
					aCommandQuery
						isEnabled: true;
						isChecked: margin width ~= 0].
			^true].
	command == #toggleVisibleLineEndings 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: beforePresenter view hasVisibleLineEndings.
			^true].
	command == #toggleIndentGuides 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: beforePresenter view hasIndentationGuides.
			^true].
	command == #toggleVisibleWhitespace 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: beforePresenter view whitespaceVisibility ~~ #invisible.
			^true].
	command == #toggleWrapping
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: beforePresenter view wordWrap.
			^true].
	^super queryCommand: aCommandQuery!

reduce: anArray 
	| ranges stream |
	ranges := OrderedCollection new.
	stream := anArray readStream.
	[stream atEnd] whileFalse: 
			[(stream skipTo: nil) 
				ifTrue: 
					[| start |
					start := stream position.
					stream skipWhile: [:each | each isNil].
					ranges add: (start to: stream position)]].
	^ranges!

refresh
	| before after |
	before := beforePresenter view plainText.
	after := afterPresenter view plainText.
	(before isEmpty or: [after isEmpty]) 
		ifTrue: [self clearDiffs]
		ifFalse: [self diff: (self parse: before) and: (self parse: after)]!

styler: aScintillaStyler
	beforePresenter view styler: aScintillaStyler.
	afterPresenter view styler: aScintillaStyler!

textFont: aFont 
	beforePresenter view font: aFont.
	afterPresenter view font: aFont!

textStyles: aCollectionOfScintillaTextStyles
	beforePresenter view textStyles: aCollectionOfScintillaTextStyles.
	afterPresenter view textStyles: aCollectionOfScintillaTextStyles!

toggleIndentGuides
	"Show or hide the indentation guides."

	beforePresenter view toggleIndentationGuides.
	afterPresenter view toggleIndentationGuides!

toggleLineNumberMargins
	"Show or hide the first line number margin, inverting the current state."

	beforePresenter view toggleLineNumbers.
	afterPresenter view toggleLineNumbers!

toggleSyntaxColoring
	beforePresenter view toggleStyling.
	afterPresenter view toggleStyling!

toggleVisibleLineEndings
	"Show or hide the end-of-line characters."

	beforePresenter view toggleLineEndings.
	afterPresenter view toggleLineEndings!

toggleVisibleWhitespace
	"Show or hide the whitespace markers in the view."

	beforePresenter view toggleWhitespace.
	afterPresenter view toggleWhitespace!

toggleWrapping
	beforePresenter view toggleWordWrap.
	afterPresenter view toggleWordWrap!

wordSeparators
	^wordSeparators!

wordSeparators: aString 
	wordSeparators := aString! !
!DifferencesPresenter categoriesFor: #afterText:!accessing!public! !
!DifferencesPresenter categoriesFor: #afterTitle:!accessing!public! !
!DifferencesPresenter categoriesFor: #beforeText:!accessing!public! !
!DifferencesPresenter categoriesFor: #beforeTitle:!accessing!public! !
!DifferencesPresenter categoriesFor: #clear!operations!public! !
!DifferencesPresenter categoriesFor: #clearDiffs!operations!public! !
!DifferencesPresenter categoriesFor: #compare:with:!operations!public! !
!DifferencesPresenter categoriesFor: #comparisonMode!accessing!public! !
!DifferencesPresenter categoriesFor: #comparisonMode:!accessing!public! !
!DifferencesPresenter categoriesFor: #createComponents!initializing!private! !
!DifferencesPresenter categoriesFor: #diff:and:!private!updating! !
!DifferencesPresenter categoriesFor: #display:items:presenter:!private!updating! !
!DifferencesPresenter categoriesFor: #initialize!initializing!private! !
!DifferencesPresenter categoriesFor: #parse:!helpers!private! !
!DifferencesPresenter categoriesFor: #parseWordsFrom:!helpers!private! !
!DifferencesPresenter categoriesFor: #queryCommand:!commands!private! !
!DifferencesPresenter categoriesFor: #reduce:!helpers!private! !
!DifferencesPresenter categoriesFor: #refresh!public!updating! !
!DifferencesPresenter categoriesFor: #styler:!accessing!public! !
!DifferencesPresenter categoriesFor: #textFont:!accessing!public! !
!DifferencesPresenter categoriesFor: #textStyles:!accessing!public! !
!DifferencesPresenter categoriesFor: #toggleIndentGuides!commands!public! !
!DifferencesPresenter categoriesFor: #toggleLineNumberMargins!commands!public! !
!DifferencesPresenter categoriesFor: #toggleSyntaxColoring!commands!public! !
!DifferencesPresenter categoriesFor: #toggleVisibleLineEndings!commands!public! !
!DifferencesPresenter categoriesFor: #toggleVisibleWhitespace!commands!public! !
!DifferencesPresenter categoriesFor: #toggleWrapping!commands!public! !
!DifferencesPresenter categoriesFor: #wordSeparators!accessing!public! !
!DifferencesPresenter categoriesFor: #wordSeparators:!accessing!public! !

!DifferencesPresenter class methodsFor!

initialize
	WordSeparators := '()[]{}<>"''|.,;'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 576 34 2 8 1140850945 1 672 nil nil nil 5 nil nil nil 672 nil 8 1905095040 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 5 898 345 31 672 850 #text: 34 1 8 'Before' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 172 0 0 0 17 0 0 0] 8 #() 898 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 576 34 2 8 1174409476 262145 1072 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1072 nil 8 1613418089 754 nil nil 11 nil 170 192 34 10 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1314 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1314 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1314 3 196934 1 ##(Smalltalk.RGB) 16842881 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1314 77 786694 ##(Smalltalk.IndexedColor) 33554457 1442 33554471 1 nil nil nil nil #callTip nil nil nil 34 256 1328 1376 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1360 nil nil nil 1344 1424 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1072 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 528 nil 170 176 528 9215 nil nil nil nil 1442 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1280 nil nil nil nil 130003 nil 170 192 34 2 #diff 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 1072 131071 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1314 1029 nil 1394 31185883 1 nil nil nil nil #Notification nil nil nil #Error 1314 1031 1394 335 1394 31317503 1 nil nil nil nil #Error nil nil nil #Warning 1314 1027 1394 60239 1394 31326207 1 nil nil nil nil #Warning nil nil nil nil 786 138 144 34 7 850 #createAt:extent: 34 2 898 1 35 898 345 467 1072 850 #textLimit: 8 #(1073741823) 1072 850 #modificationEventMask: 8 #(4607) 1072 850 #caretPeriod: 8 #(530) 1072 850 #wordWrap: 8 #(true) 1072 850 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1072 49 3 nil nil nil nil 2210 3 1072 1 nil nil 67108863 nil nil 2210 5 1072 1 nil nil nil nil nil 1072 850 #maxCompletionListHeight: 8 #(9) 1072 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1056 nil 29 170 192 34 4 672 8 'beforeTitle' 1072 8 'before' 590342 ##(Smalltalk.Rectangle) 898 1 5 898 1 1 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 345 501 576 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 34 2 672 1072 1056 nil 27 8 'Before' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 3839 21 898 701 501 416 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 3 576 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2816 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2816 nil 1 #left nil nil nil 898 1 1 898 9 9 nil 2912 nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 345 1 898 11 501 2816 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 1056 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3104 nil nil nil 5 nil nil nil 3104 642 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 3104 34 2 8 1140850945 1 3184 nil nil nil 5 nil nil nil 3184 nil 8 1905095040 754 nil nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 5 898 347 31 3184 850 #text: 34 1 8 'After' 3184 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 173 0 0 0 17 0 0 0] 8 #() 1056 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3104 34 2 8 1174405380 262145 3488 1138 nil false 1184 nil 1216 nil 5 nil nil nil 3488 nil 8 1613418089 754 nil nil 3 nil 170 192 34 10 #normal 1314 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 1314 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 1314 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #whitespace 1314 3 1394 16842881 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1314 77 1456 1472 1 nil nil nil nil #callTip nil nil nil 34 256 3632 3680 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 3664 nil nil nil 3648 3712 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1506 #normal 170 192 34 2 #default 1570 1 nil nil nil 3488 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 528 nil 170 176 528 9215 nil nil nil nil 1632 nil nil 65 nil nil nil 1648 3 170 192 34 2 #container 3600 nil nil nil nil 130003 nil 170 192 34 2 #diff 1730 1 3488 131071 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1314 1029 nil 1394 31185883 1 nil nil nil nil #Notification nil nil nil #Error 1314 1031 1394 335 1394 31317503 1 nil nil nil nil #Error nil nil nil #Warning 1314 1027 1394 60239 1394 31326207 1 nil nil nil nil #Warning nil nil nil nil 786 138 144 34 7 850 #createAt:extent: 34 2 898 1 35 898 347 467 3488 850 #textLimit: 8 #(1073741823) 3488 850 #modificationEventMask: 8 #(4607) 3488 850 #caretPeriod: 8 #(530) 3488 850 #wordWrap: 8 #(true) 3488 850 #margins: 34 1 34 3 2210 1 3488 49 3 nil nil nil nil 2210 3 3488 1 nil nil 67108863 nil nil 2210 5 3488 1 nil nil nil nil nil 3488 850 #maxCompletionListHeight: 8 #(9) 3488 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 173 0 0 0 250 0 0 0] 8 #() 1056 nil 29 170 192 34 4 3184 8 'afterTitle' 3488 8 'after' 2418 898 1 5 898 1 1 786 138 144 34 2 850 #createAt:extent: 34 2 898 355 1 898 347 501 3104 850 #text: 34 1 8 'After' 3104 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 34 2 3184 3488 1056 nil 27 1056 nil 27 )!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!DifferencesPresenter class categoriesFor: #initialize!initializing!public! !
!DifferencesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!DifferencesPresenter class categoriesFor: #wordSeparators!accessing!public! !
!DifferencesPresenter class categoriesFor: #wordSeparators:!accessing!public! !

