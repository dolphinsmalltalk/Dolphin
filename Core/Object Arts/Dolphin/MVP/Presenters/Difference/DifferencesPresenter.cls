"Filed out from Dolphin Smalltalk"!

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

itemsFrom: aString 
	comparisonMode == #character 
		ifTrue: [^aString asOrderedCollection collect: [:each | each asString]].
	comparisonMode == #line ifTrue: [^aString lines].
	comparisonMode == #word ifTrue: [^self parseWordsFrom: aString].
	self error: 'Unknown comparison mode'.!

parse: aString 
	| items positions |
	items := self itemsFrom: aString.
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
!DifferencesPresenter categoriesForMethods!
afterText:!accessing!public! !
afterTitle:!accessing!public! !
beforeText:!accessing!public! !
beforeTitle:!accessing!public! !
clear!operations!public! !
clearDiffs!operations!public! !
compare:with:!operations!public! !
comparisonMode!accessing!public! !
comparisonMode:!accessing!public! !
createComponents!initializing!private! !
diff:and:!private!updating! !
display:items:presenter:!private!updating! !
initialize!initializing!private! !
itemsFrom:!helpers!private! !
parse:!helpers!private! !
parseWordsFrom:!helpers!private! !
queryCommand:!commands!private! !
reduce:!helpers!private! !
refresh!public!updating! !
styler:!accessing!public! !
textFont:!accessing!public! !
textStyles:!accessing!public! !
toggleIndentGuides!commands!public! !
toggleLineNumberMargins!commands!public! !
toggleSyntaxColoring!commands!public! !
toggleVisibleLineEndings!commands!public! !
toggleVisibleWhitespace!commands!public! !
toggleWrapping!commands!public! !
wordSeparators!accessing!public! !
wordSeparators:!accessing!public! !
!

!DifferencesPresenter class methodsFor!

initialize
	WordSeparators := '()[]{}<>"''|.,;'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 576 34 2 8 1140850945 1 672 nil nil nil 5 nil nil nil 672 nil 8 1867478992 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 5 898 345 31 672 850 #text: 34 1 8 'Before' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 172 0 0 0 17 0 0 0] 8 #() 898 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 576 34 2 8 1174409476 262145 1072 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1072 nil 8 1533163101 754 nil nil 11 nil 170 192 34 10 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 1298 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 1298 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 1298 77 1202 #gray 1202 #white 1 nil nil nil nil #callTip nil nil nil #whitespace 1298 3 1202 #teal nil 1 nil nil nil nil #whitespace nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1072 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 528 nil 170 176 528 9215 nil nil nil nil 1202 #silver nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1264 nil nil nil nil 130003 nil 170 192 34 2 #diff 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 1072 1202 #yellow 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1298 1027 1202 #darkGoldenrod 1202 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 1298 1029 nil 1202 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 1298 1031 1202 #firebrick 1202 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 786 138 144 34 8 850 #createAt:extent: 34 2 898 1 35 898 345 467 1072 850 #textLimit: 8 #(1073741823) 1072 850 #caretPeriod: 8 #(530) 1072 850 #wordWrap: 8 #(true) 1072 850 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 1072 49 3 nil nil nil nil 2130 3 1072 1 nil nil 67108863 nil nil 2130 5 1072 1 nil nil nil nil nil 1072 850 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 1072 850 #maxCompletionListHeight: 8 #(9) 1072 850 #edgeColumn: 8 #(1) 1072 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1056 nil 29 170 192 34 4 1072 8 'before' 672 8 'beforeTitle' 590342 ##(Smalltalk.Rectangle) 898 1 5 898 1 1 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 345 501 576 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 34 2 672 1072 1056 nil 27 8 'Before' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 7039 21 898 701 501 416 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 29 15 0 0 4 1 0 0] 34 3 576 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2832 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2832 nil 1 #left nil nil nil 898 1 1 898 9 9 nil 2928 nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 345 1 898 11 501 2832 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 1056 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3120 nil nil nil 5 nil nil nil 3120 642 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 3120 34 2 8 1140850945 1 3200 nil nil nil 5 nil nil nil 3200 nil 8 1867478992 754 nil nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 5 898 347 31 3200 850 #text: 34 1 8 'After' 3200 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 173 0 0 0 17 0 0 0] 8 #() 1056 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3120 34 2 8 1174405380 262145 3504 1138 nil false 1184 nil 1216 nil 5 nil nil nil 3504 nil 8 1533163101 754 nil nil 3 nil 170 192 34 10 #lineNumber 1298 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 1298 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #normal 1298 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 1298 77 1376 1392 1 nil nil nil nil #callTip nil nil nil #whitespace 1298 3 1424 nil 1 nil nil nil nil #whitespace nil nil nil nil 1442 #normal 170 192 34 2 #default 1506 1 nil nil nil 3504 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 528 nil 170 176 528 9215 nil nil nil nil 1568 nil nil 65 nil nil nil 1584 3 170 192 34 2 #container 3616 nil nil nil nil 130003 nil 170 192 34 2 #diff 1666 1 3504 1696 33 false #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Warning 1298 1027 1760 1776 1 nil nil nil nil #Warning nil nil nil #Notification 1298 1029 nil 1808 1 nil nil nil nil #Notification nil nil nil #Error 1298 1031 1840 1856 1 nil nil nil nil #Error nil nil nil nil 786 138 144 34 8 850 #createAt:extent: 34 2 898 1 35 898 347 467 3504 850 #textLimit: 8 #(1073741823) 3504 850 #caretPeriod: 8 #(530) 3504 850 #wordWrap: 8 #(true) 3504 850 #margins: 34 1 34 3 2130 1 3504 49 3 nil nil nil nil 2130 3 3504 1 nil nil 67108863 nil nil 2130 5 3504 1 nil nil nil nil nil 3504 850 #targetRange: 34 1 2226 1 -1 3 3504 850 #maxCompletionListHeight: 8 #(9) 3504 850 #edgeColumn: 8 #(1) 3504 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 173 0 0 0 250 0 0 0] 8 #() 1056 nil 29 170 192 34 4 3200 8 'afterTitle' 3504 8 'after' 2434 898 1 5 898 1 1 786 138 144 34 2 850 #createAt:extent: 34 2 898 355 1 898 347 501 3120 850 #text: 34 1 8 'After' 3120 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 34 2 3200 3504 1056 nil 27 1056 nil 27 )!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!DifferencesPresenter class categoriesForMethods!
initialize!initializing!public! !
resource_Default_view!public!resources-views! !
wordSeparators!accessing!public! !
wordSeparators:!accessing!public! !
!

