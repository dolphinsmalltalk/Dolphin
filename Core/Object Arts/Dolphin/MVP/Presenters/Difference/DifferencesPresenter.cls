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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 0 0 34 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 624 0 721158 ##(Smalltalk.SystemColor) 31 0 5 0 0 0 624 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 0 624 34 2 8 1140850945 1 752 0 0 0 5 0 0 0 752 0 8 4294903859 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 5 978 345 31 752 930 #text: 34 1 8 'Before' 752 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 172 0 0 0 17 0 0 0] 8 #() 978 193 193 0 27 0 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 624 34 2 8 1174409476 262145 1152 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 482 512 0 5 0 0 0 1152 0 8 4294906539 834 0 0 11 0 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1394 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 1362 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 1362 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #diff 1362 5 0 196934 1 ##(Smalltalk.RGB) 131071 3 0 0 0 0 #diff 0 1401 0 #whitespace 1362 3 1490 16842881 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 1362 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 1440 1520 1472 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1456 0 0 0 1552 0 0 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 1152 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 576 0 170 176 576 9215 0 0 0 0 1394 33554447 0 0 65 0 0 0 8 '' 3 170 192 34 2 #container 1328 0 0 0 0 1 0 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 1152 33423361 3 false #Warning 0 0 0 0 0 0 #Error 1826 17 1152 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 1362 1029 0 1490 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 1362 1027 1490 60239 1490 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 1362 1031 1490 335 1490 31317503 1 0 0 0 0 #Error 0 0 0 0 866 138 144 34 4 930 #createAt:extent: 34 2 978 1 35 978 345 467 1152 930 #modificationEventMask: 8 #(4607) 1152 930 #caretPeriod: 8 #(530) 1152 930 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1152 49 3 0 0 0 0 2258 3 1152 1 0 0 67108863 0 0 2258 5 1152 1 0 0 0 0 0 1152 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1136 0 29 170 192 34 4 752 8 'beforeTitle' 1152 8 'before' 590342 ##(Smalltalk.Rectangle) 978 1 5 978 1 1 866 138 144 34 1 930 #createAt:extent: 34 2 978 1 1 978 345 501 624 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 34 2 752 1152 1136 0 27 8 'Before' 0 866 138 144 34 1 930 #createAt:extent: 34 2 978 3839 21 978 701 501 416 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 3 624 410 ##(Smalltalk.Splitter) 34 12 0 416 34 2 8 1140850688 1 2832 0 482 512 0 517 0 0 0 2832 866 138 144 34 1 930 #createAt:extent: 34 2 978 345 1 978 11 501 2832 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 1136 0 27 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 3072 0 690 31 0 5 0 0 0 3072 722 1 1 410 ##(Smalltalk.StaticText) 34 16 0 3072 34 2 8 1140850945 1 3168 0 0 0 5 0 0 0 3168 0 8 4294903859 834 0 0 0 866 138 144 34 2 930 #createAt:extent: 34 2 978 1 5 978 347 31 3168 930 #text: 34 1 8 'After' 3168 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 173 0 0 0 17 0 0 0] 8 #() 1136 0 27 0 0 0 410 ##(Smalltalk.ScintillaView) 34 50 0 3072 34 2 8 1174405380 262145 3472 1218 0 false 1264 0 482 512 0 5 0 0 0 3472 0 8 4294906539 834 0 0 3 0 170 192 34 12 #callTip 1362 77 1408 1424 1 0 0 0 0 #callTip 0 0 0 #normal 1362 1 0 0 1 0 0 0 0 #normal 0 0 0 #lineNumber 1362 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #diff 1362 5 0 1490 131071 3 0 0 0 0 #diff 0 1401 0 #whitespace 1362 3 1490 16842881 0 1 0 0 0 0 #whitespace 0 0 0 #indentGuide 1362 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 34 40 3648 3712 3680 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3664 0 0 0 3744 0 0 1586 1616 170 192 34 2 #default 1666 1 0 0 0 3472 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 576 0 170 176 576 9215 0 0 0 0 1728 0 0 65 0 0 0 1744 3 170 192 34 2 #container 3600 0 0 0 0 1 0 170 192 34 4 #Warning 1826 19 3472 33423361 3 false #Warning 0 0 0 0 0 0 #Error 1826 17 3472 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 1362 1029 0 1490 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 1362 1027 1490 60239 1490 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 1362 1031 1490 335 1490 31317503 1 0 0 0 0 #Error 0 0 0 0 866 138 144 34 4 930 #createAt:extent: 34 2 978 1 35 978 347 467 3472 930 #modificationEventMask: 8 #(4607) 3472 930 #caretPeriod: 8 #(530) 3472 930 #margins: 34 1 34 3 2258 1 3472 49 3 0 0 0 0 2258 3 3472 1 0 0 67108863 0 0 2258 5 3472 1 0 0 0 0 0 3472 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 173 0 0 0 250 0 0 0] 8 #() 1136 0 29 170 192 34 4 3168 8 'afterTitle' 3472 8 'after' 2434 978 1 5 978 1 1 866 138 144 34 2 930 #createAt:extent: 34 2 978 355 1 978 347 501 3072 930 #text: 34 1 8 'After' 3072 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 34 2 3168 3472 1136 0 27 1136 0 27 )!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!DifferencesPresenter class categoriesFor: #initialize!initializing!public! !
!DifferencesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!DifferencesPresenter class categoriesFor: #wordSeparators!accessing!public! !
!DifferencesPresenter class categoriesFor: #wordSeparators:!accessing!public! !

