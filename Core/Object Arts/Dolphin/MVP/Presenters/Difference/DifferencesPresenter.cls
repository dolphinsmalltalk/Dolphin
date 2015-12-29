"Filed out from Dolphin Smalltalk X6"!

Presenter subclass: #DifferencesPresenter
	instanceVariableNames: 'beforePresenter afterPresenter beforeTitlePresenter afterTitlePresenter comparisonMode wordSeparators'
	classVariableNames: 'WordSeparators'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DifferencesPresenter guid: (GUID fromString: '{772EC3BD-72DC-4BAE-9E30-92D686EA4E3B}')!
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
	(Array with: beforePresenter with: afterPresenter) do: 
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
	diffs := (self reduce: anArray) 
				collect: [:each | (items at: each first) value first to: (items at: each last) value last].
	aTextPresenter view styler diffs: diffs.
	aTextPresenter view restyleAll!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 0 32 234 256 98 2 410 432 98 15 0 416 98 2 8 1140850688 131073 640 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 640 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.StaticText)  98 16 0 640 98 2 8 1140850945 1 768 0 0 0 5 0 0 0 768 0 8 4294903875 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 5 1026 341 31 768 962 8 #text: 98 1 8 'Before' 768 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 170 0 0 0 17 0 0 0] 98 0 1026 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ScintillaView)  98 46 0 640 98 2 8 1174409476 262145 1216 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 498 528 0 5 0 0 0 1216 0 8 4294903673 866 0 0 11 0 234 256 98 10 8 #indentGuide 1182726 ##(Smalltalk.ScintillaTextStyle)  75 0 0 1 0 0 0 0 1440 0 0 0 8 #whitespace 1458 3 196934 1 ##(Smalltalk.RGB)  16842881 0 1 0 0 0 0 1488 0 0 0 8 #normal 1458 1 0 0 1 0 0 0 0 1552 0 0 0 8 #lineNumber 1458 67 0 0 1 0 0 0 0 1584 0 0 0 8 #diff 1458 5 0 1522 131071 3 0 0 0 0 1616 0 0 0 98 40 1568 1504 1632 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1600 0 0 0 1472 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler)  98 0 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 1810 33554471 1216 8 #circle 202 208 592 0 63 9215 0 0 0 0 1810 33554447 0 0 0 0 0 0 8 '' 3 234 256 98 2 8 #container 1408 0 0 0 0 1 0 234 256 98 4 8 #Warning 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  19 1216 33423361 3 32 2000 0 8 #Error 2018 17 1216 33554459 3 32 2048 0 898 202 208 98 7 962 992 98 2 1026 1 35 1026 341 467 1216 962 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1216 962 8 #isTextModified: 98 1 32 1216 962 8 #modificationEventMask: 98 1 9215 1216 962 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 1216 49 3 32 1 2434 3 1216 1 1 32 67108863 2434 5 1216 1 1 32 1 1216 962 8 #indentationGuides: 98 1 0 1216 962 8 #tabIndents: 98 1 16 1216 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 170 0 0 0 250 0 0 0] 98 0 1200 0 27 234 256 98 4 1216 8 'before' 768 8 'beforeTitle' 590342 ##(Smalltalk.Rectangle)  1026 1 5 1026 1 1 898 202 208 98 1 962 992 98 2 1026 1 1 1026 341 501 640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 170 0 0 0 250 0 0 0] 98 2 768 1216 1200 0 27 8 'Before' 0 898 202 208 98 1 962 992 98 2 1026 3359 21 1026 701 501 416 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 237 7 0 0 4 1 0 0] 98 3 640 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 3104 0 498 528 0 517 0 0 0 3104 898 202 208 98 1 962 992 98 2 1026 341 1 1026 19 501 3104 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 170 0 0 0 0 0 0 0 179 0 0 0 250 0 0 0] 98 0 1200 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 3360 0 706 31 0 5 0 0 0 3360 738 1 1 410 784 98 16 0 3360 98 2 8 1140850945 1 3456 0 0 0 5 0 0 0 3456 0 8 4294903875 866 0 0 0 898 202 208 98 2 962 992 98 2 1026 1 5 1026 343 31 3456 962 1088 98 1 8 'After' 3456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 171 0 0 0 17 0 0 0] 98 0 1200 0 27 0 0 0 410 1232 98 46 0 3360 98 2 8 1174405380 262145 3760 1298 0 32 1344 0 498 528 0 5 0 0 0 3760 0 8 4294903673 866 0 0 3 0 234 256 98 10 1440 1458 75 0 0 1 0 0 0 0 1440 0 0 0 1488 1458 3 1522 16842881 0 1 0 0 0 0 1488 0 0 0 1552 1458 1 0 0 1 0 0 0 0 1552 0 0 0 1584 1458 67 0 0 1 0 0 0 0 1584 0 0 0 1616 1458 5 0 1522 131071 3 0 0 0 0 1616 0 0 0 98 40 3968 3936 4000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3984 0 0 0 3920 0 0 1682 1712 234 256 98 2 1760 1778 1 1 1824 1840 3760 1856 202 208 592 0 63 9215 0 0 0 0 1888 0 0 0 0 0 0 1904 3 234 256 98 2 1952 3888 0 0 0 0 1 0 234 256 98 4 2000 2018 19 3760 33423361 3 32 2000 0 2048 2018 17 3760 33554459 3 32 2048 0 898 202 208 98 7 962 992 98 2 1026 1 35 1026 343 467 3760 962 2208 98 1 2242 3 1 3 3760 962 2288 98 1 32 3760 962 2336 98 1 9215 3760 962 2384 98 1 98 3 2434 1 3760 49 3 32 1 2434 3 3760 1 1 32 67108863 2434 5 3760 1 1 32 1 3760 962 2512 98 1 0 3760 962 2560 98 1 16 3760 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 171 0 0 0 250 0 0 0] 98 0 1200 0 27 234 256 98 4 3760 8 'after' 3456 8 'afterTitle' 2706 1026 1 5 1026 1 1 898 202 208 98 2 962 992 98 2 1026 359 1 1026 343 501 3360 962 1088 98 1 8 'After' 3360 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 179 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 2 3456 3760 1200 0 27 1200 0 27 )!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!DifferencesPresenter class categoriesFor: #initialize!initializing!public! !
!DifferencesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!DifferencesPresenter class categoriesFor: #wordSeparators!accessing!public! !
!DifferencesPresenter class categoriesFor: #wordSeparators:!accessing!public! !

