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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 624 nil 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil nil nil 624 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 624 34 2 8 1140850945 1 752 nil nil nil 5 nil nil nil 752 nil 8 4294902487 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 5 978 345 31 752 930 #text: 34 1 8 'Before' 752 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 172 0 0 0 17 0 0 0] 8 #() 978 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 624 34 2 8 1174409476 262145 1152 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 482 512 nil 5 nil nil nil 1152 nil 8 4294907129 834 nil nil 11 nil 170 192 34 12 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 1394 33554471 1 nil nil nil nil #callTip nil nil nil #lineNumber 1362 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1362 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 1362 3 196934 1 ##(Smalltalk.RGB) 16842881 nil 1 nil nil nil nil #whitespace nil nil nil #indentGuide 1362 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #diff 1362 5 nil 1490 131071 3 nil nil nil nil #diff nil 1401 nil 34 40 1456 1472 1536 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1440 nil nil nil 1520 nil nil 1310982 ##(Smalltalk.DiffsScintillaStyler) 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 1152 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 576 nil 170 176 576 9215 nil nil nil nil 1394 33554447 nil nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1328 nil nil nil nil 1 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 1152 33423361 3 false #Warning nil nil nil nil nil nil #Error 1826 17 1152 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 1362 1029 nil 1490 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 1362 1027 1490 60239 1490 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1362 1031 1490 335 1490 31317503 1 nil nil nil nil #Error nil nil nil nil 866 138 144 34 6 930 #createAt:extent: 34 2 978 1 35 978 345 467 1152 930 #modificationEventMask: 8 #(4607) 1152 930 #caretPeriod: 8 #(530) 1152 930 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 1152 49 3 nil nil nil nil 2258 3 1152 1 nil nil 67108863 nil nil 2258 5 1152 1 nil nil nil nil nil 1152 930 #maxCompletionListHeight: 8 #(9) 1152 930 #sciSetCodePage: 8 #(65001) 1152 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1136 nil 29 170 192 34 4 1152 8 'before' 752 8 'beforeTitle' 590342 ##(Smalltalk.Rectangle) 978 1 5 978 1 1 866 138 144 34 1 930 #createAt:extent: 34 2 978 1 1 978 345 501 624 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 34 2 752 1152 1136 nil 27 8 'Before' nil 866 138 144 34 1 930 #createAt:extent: 34 2 978 3839 21 978 701 501 416 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 4 1 0 0] 34 3 624 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 2896 nil 482 512 nil 517 nil nil nil 2896 866 138 144 34 1 930 #createAt:extent: 34 2 978 345 1 978 11 501 2896 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 1136 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3136 nil 690 31 nil 5 nil nil nil 3136 722 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 3136 34 2 8 1140850945 1 3232 nil nil nil 5 nil nil nil 3232 nil 8 4294902487 834 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 978 1 5 978 347 31 3232 930 #text: 34 1 8 'After' 3232 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 173 0 0 0 17 0 0 0] 8 #() 1136 nil 27 nil nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 3136 34 2 8 1174405380 262145 3536 1218 nil false 1264 nil 482 512 nil 5 nil nil nil 3536 nil 8 4294907129 834 nil nil 3 nil 170 192 34 12 #callTip 1362 77 1408 1424 1 nil nil nil nil #callTip nil nil nil #lineNumber 1362 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 1362 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 1362 3 1490 16842881 nil 1 nil nil nil nil #whitespace nil nil nil #indentGuide 1362 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #diff 1362 5 nil 1490 131071 3 nil nil nil nil #diff nil 1401 nil 34 40 3728 3744 3792 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 3712 nil nil nil 3776 nil nil 1586 1616 170 192 34 2 #default 1666 1 nil nil nil 3536 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 576 nil 170 176 576 9215 nil nil nil nil 1728 nil nil 65 nil nil nil 1744 3 170 192 34 2 #container 3664 nil nil nil nil 1 nil 170 192 34 4 #Warning 1826 19 3536 33423361 3 false #Warning nil nil nil nil nil nil #Error 1826 17 3536 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 1362 1029 nil 1490 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 1362 1027 1490 60239 1490 31326207 1 nil nil nil nil #Warning nil nil nil #Error 1362 1031 1490 335 1490 31317503 1 nil nil nil nil #Error nil nil nil nil 866 138 144 34 6 930 #createAt:extent: 34 2 978 1 35 978 347 467 3536 930 #modificationEventMask: 8 #(4607) 3536 930 #caretPeriod: 8 #(530) 3536 930 #margins: 34 1 34 3 2258 1 3536 49 3 nil nil nil nil 2258 3 3536 1 nil nil 67108863 nil nil 2258 5 3536 1 nil nil nil nil nil 3536 930 #maxCompletionListHeight: 8 #(9) 3536 930 #sciSetCodePage: 8 #(65001) 3536 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 17 0 0 0 173 0 0 0 250 0 0 0] 8 #() 1136 nil 29 170 192 34 4 3536 8 'after' 3232 8 'afterTitle' 2498 978 1 5 978 1 1 866 138 144 34 2 930 #createAt:extent: 34 2 978 355 1 978 347 501 3136 930 #text: 34 1 8 'After' 3136 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 34 2 3232 3536 1136 nil 27 1136 nil 27 )!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!DifferencesPresenter class categoriesFor: #initialize!initializing!public! !
!DifferencesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!DifferencesPresenter class categoriesFor: #wordSeparators!accessing!public! !
!DifferencesPresenter class categoriesFor: #wordSeparators:!accessing!public! !

