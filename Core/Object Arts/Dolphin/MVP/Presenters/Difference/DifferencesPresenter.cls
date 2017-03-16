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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout) 234 240 98 0 32 234 256 98 2 410 432 98 15 0 416 98 2 8 1140850688 131073 640 0 721158 ##(Smalltalk.SystemColor) 31 0 5 0 0 0 640 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.StaticText) 98 16 0 640 98 2 8 1140850945 1 768 0 0 0 5 0 0 0 768 0 8 4294904577 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 1 5 1026 345 31 768 962 8 #text: 98 1 8 'Before' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 172 0 0 0 17 0 0 0] 98 0 1026 193 193 0 27 0 0 0 410 8 ##(Smalltalk.ScintillaView) 98 50 0 640 98 2 8 1174409476 262145 1216 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 498 528 0 5 0 0 0 1216 0 8 4294906441 866 0 0 11 0 234 256 98 12 8 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 0 0 1 0 0 0 0 1440 0 0 0 8 #indentGuide 1458 75 0 0 1 0 0 0 0 1488 0 0 0 8 #normal 1458 1 0 0 1 0 0 0 0 1520 0 0 0 8 #callTip 1458 77 786694 ##(Smalltalk.IndexedColor) 33554457 1586 33554471 1 0 0 0 0 1552 0 0 0 8 #diff 1458 5 0 196934 1 ##(Smalltalk.RGB) 131071 3 0 0 0 0 1632 0 1401 0 8 #whitespace 1458 3 1666 16842881 0 1 0 0 0 0 1696 0 0 0 98 40 1536 1712 1648 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1472 0 0 0 1504 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 98 0 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 1216 8 #circle 0 0 0 0 0 0 202 208 592 0 63 9215 0 0 0 0 1586 33554447 0 0 65 0 0 0 8 '' 3 234 256 98 2 8 #container 1408 0 0 0 0 1 0 234 256 98 4 8 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 1216 33423361 3 32 2032 0 0 0 0 0 0 8 #Error 2050 17 1216 33554459 3 32 2080 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 1458 1029 0 1666 31185883 1 0 0 0 0 2144 0 0 0 2080 1458 1031 1666 335 1666 31317503 1 0 0 0 0 2080 0 0 0 2032 1458 1027 1666 60239 1666 31326207 1 0 0 0 0 2032 0 0 0 0 898 202 208 98 9 962 992 98 2 1026 1 35 1026 345 467 1216 962 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 1216 962 8 #isTextModified: 98 1 32 1216 962 8 #modificationEventMask: 98 1 9215 1216 962 8 #secondaryCaretForecolor: 98 1 1666 16711423 1216 962 8 #caretPeriod: 98 1 1061 1216 962 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 1216 49 3 32 1 15 2754 3 1216 1 1 32 67108863 15 2754 5 1216 1 1 32 1 15 1216 962 8 #tabIndents: 98 1 16 1216 962 8 #areAdditionalCaretsVisible: 98 1 16 1216 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 172 0 0 0 250 0 0 0] 98 0 1200 0 29 234 256 98 4 768 8 'beforeTitle' 1216 8 'before' 590342 ##(Smalltalk.Rectangle) 1026 1 5 1026 1 1 898 202 208 98 1 962 992 98 2 1026 1 1 1026 345 501 640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 98 2 768 1216 1200 0 27 8 'Before' 0 898 202 208 98 1 962 992 98 2 1026 3839 21 1026 701 501 416 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 98 3 640 410 8 ##(Smalltalk.Splitter) 98 12 0 416 98 2 8 1140850688 1 3424 0 498 528 0 517 0 0 0 3424 898 202 208 98 1 962 992 98 2 1026 345 1 1026 11 501 3424 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 98 0 1200 0 27 410 432 98 15 0 416 98 2 8 1140850688 131073 3680 0 706 31 0 5 0 0 0 3680 738 1 1 410 784 98 16 0 3680 98 2 8 1140850945 1 3776 0 0 0 5 0 0 0 3776 0 8 4294904577 866 0 0 0 898 202 208 98 2 962 992 98 2 1026 1 5 1026 347 31 3776 962 1088 98 1 8 'After' 3776 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 173 0 0 0 17 0 0 0] 98 0 1200 0 27 0 0 0 410 1232 98 50 0 3680 98 2 8 1174405380 262145 4080 1298 0 32 1344 0 498 528 0 5 0 0 0 4080 0 8 4294906441 866 0 0 3 0 234 256 98 12 1440 1458 67 0 0 1 0 0 0 0 1440 0 0 0 1488 1458 75 0 0 1 0 0 0 0 1488 0 0 0 1520 1458 1 0 0 1 0 0 0 0 1520 0 0 0 1552 1458 77 1600 1616 1 0 0 0 0 1552 0 0 0 1632 1458 5 0 1666 131071 3 0 0 0 0 1632 0 1401 0 1696 1458 3 1666 16842881 0 1 0 0 0 0 1696 0 0 0 98 40 4272 4336 4304 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4240 0 0 0 4256 0 0 1762 1792 234 256 98 2 1840 1858 1 0 0 0 4080 1888 0 0 0 0 0 0 202 208 592 0 63 9215 0 0 0 0 1920 0 0 65 0 0 0 1936 3 234 256 98 2 1984 4208 0 0 0 0 1 0 234 256 98 4 2032 2050 19 4080 33423361 3 32 2032 0 0 0 0 0 0 2080 2050 17 4080 33554459 3 32 2080 0 0 0 0 0 0 0 0 234 256 98 6 2144 1458 1029 0 1666 31185883 1 0 0 0 0 2144 0 0 0 2080 1458 1031 1666 335 1666 31317503 1 0 0 0 0 2080 0 0 0 2032 1458 1027 1666 60239 1666 31326207 1 0 0 0 0 2032 0 0 0 0 898 202 208 98 9 962 992 98 2 1026 1 35 1026 347 467 4080 962 2416 98 1 2450 3 1 3 4080 962 2496 98 1 32 4080 962 2544 98 1 9215 4080 962 2592 98 1 1666 16711423 4080 962 2656 98 1 1061 4080 962 2704 98 1 98 3 2754 1 4080 49 3 32 1 15 2754 3 4080 1 1 32 67108863 15 2754 5 4080 1 1 32 1 15 4080 962 2832 98 1 16 4080 962 2880 98 1 16 4080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 173 0 0 0 250 0 0 0] 98 0 1200 0 29 234 256 98 4 3776 8 'afterTitle' 4080 8 'after' 3026 1026 1 5 1026 1 1 898 202 208 98 2 962 992 98 2 1026 355 1 1026 347 501 3680 962 1088 98 1 8 'After' 3680 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 98 2 3776 4080 1200 0 27 1200 0 27 )!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!DifferencesPresenter class categoriesFor: #initialize!initializing!public! !
!DifferencesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!DifferencesPresenter class categoriesFor: #wordSeparators!accessing!public! !
!DifferencesPresenter class categoriesFor: #wordSeparators:!accessing!public! !

