"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'UI.DifferencesPresenter'
	instanceVariableNames: 'beforePresenter afterPresenter beforeTitlePresenter afterTitlePresenter comparisonMode wordSeparators'
	classVariableNames: 'WordSeparators'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DifferencesPresenter guid: (Core.GUID fromString: '{772ec3bd-72dc-4bae-9e30-92d686ea4e3b}')!
UI.DifferencesPresenter comment: 'DifferencesPresenter is a component that can be used to compare two pieces of text, highlighting the differences. 

Two pieces of text are compared using the #compare:with: message. The text can be plain or rich text. If rich text is compared, then the styling will be preserved in the resulting display, except of course that the highlighting of any differences takes precedence. 

The differencing algorithm allows comparison and highlighting of differences on a character, word, or line basis. The decomposition of the text into words (when in word comparison mode) is based on whitespace and configurable sets of word separator characters (see #parseWordsFrom:).

DifferencesPresenter is based on Ian Bartholomew''s DiffBrowser.

'!
!UI.DifferencesPresenter categoriesForClass!MVP-Presenters! !
!UI.DifferencesPresenter methodsFor!

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
					Scintilla.Indicator typeName: #diff
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
	self error: 'Unknown comparison mode'!

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

styler
	^beforePresenter view styler!

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
!UI.DifferencesPresenter categoriesForMethods!
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
styler!accessing!public! !
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

!UI.DifferencesPresenter class methodsFor!

initialize
	WordSeparators := '()[]{}<>"''|.,;'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 8 #() false 170 192 34 2 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 984838 #{UI.BorderLayout} 1 1 410 #{UI.StaticText} 34 16 nil 576 34 2 8 1140850945 1 672 nil nil nil 5 nil nil nil 672 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 5 882 345 39 672 834 #text: 34 1 8 'Before' 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 172 0 0 0 21 0 0 0] 8 #() 882 193 193 nil 27 nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 576 34 2 8 1174409476 262145 1056 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 917510 #{Graphics.Color} #default nil 5 nil nil nil 1056 nil 8 1395533126 754 nil nil 11 nil 170 192 34 10 #indentGuide 1444934 1 #{UI.Scintilla.TextStyle} 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 1282 3 1186 #teal nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1282 77 1186 #gray 1186 #white 1 nil nil nil nil #callTip nil nil nil #normal 1282 1 nil nil 1 nil nil nil nil #normal nil nil nil #lineNumber 1282 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 1056 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 528 nil 170 176 528 9215 nil nil 170 176 34 2 81 1186 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil 8 '' 3 170 192 34 2 #container 1248 nil nil nil nil 208 nil 170 192 34 2 #diff 1772614 4 #{UI.Scintilla.IndicatorDefinition} 1 1056 1186 #yellow 33 1 #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1282 1029 nil 1186 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 1282 1027 1186 #darkGoldenrod 1186 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 1282 1031 1186 #firebrick 1186 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 786 34 4 834 #createAt:extent: 34 2 882 1 43 882 345 459 1056 834 #wordWrap: 8 #(true) 1056 834 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 1056 49 3 nil nil nil nil 2098 3 1056 1 nil nil 67108863 nil nil 2098 5 1056 1 nil nil nil nil nil 1056 834 #maxCompletionListHeight: 8 #(9) 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 21 0 0 0 172 0 0 0 250 0 0 0] 8 #() 1040 nil 35 170 192 34 4 1056 8 'before' 672 8 'beforeTitle' 1180166 #{Graphics.Rectangle} 882 1 5 882 1 1 786 34 1 834 #createAt:extent: 34 2 882 1 1 882 345 501 576 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 34 2 672 1056 1040 nil 27 8 'Before' nil 786 34 1 834 #createAt:extent: 34 2 882 12287 21 882 701 501 416 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 4 1 0 0] 34 3 576 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 2672 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2672 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 2768 nil 786 34 1 834 #createAt:extent: 34 2 882 345 1 882 11 501 2672 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 8 #() 1040 nil 27 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 2944 nil nil nil 5 nil nil nil 2944 642 1 1 410 #{UI.StaticText} 34 16 nil 2944 34 2 8 1140850945 1 3024 nil nil nil 5 nil nil nil 3024 nil 8 1815137184 754 nil nil nil 786 34 2 834 #createAt:extent: 34 2 882 1 5 882 347 39 3024 834 #text: 34 1 8 'After' 3024 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 173 0 0 0 21 0 0 0] 8 #() 1040 nil 27 nil nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 2944 34 2 8 1174405380 262145 3312 1122 nil false 1168 nil 1200 nil 5 nil nil nil 3312 nil 8 1395533126 754 nil nil 3 nil 170 192 34 10 #indentGuide 1282 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #whitespace 1282 3 1328 nil 1 nil nil nil nil #whitespace nil nil nil #callTip 1282 77 1360 1376 1 nil nil nil nil #callTip nil nil nil #normal 1282 1 nil nil 1 nil nil nil nil #normal nil nil nil #lineNumber 1282 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil nil 1426 #normal 170 192 34 2 #default 1490 1 nil nil nil 3312 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 528 nil 170 176 528 9215 nil nil 170 176 34 2 81 1584 nil nil 1616 nil 65 nil nil nil 1632 3 170 192 34 2 #container 3424 nil nil nil nil 208 nil 170 192 34 2 #diff 1714 1 3312 1744 33 1 #diff 91 nil nil nil 171 nil nil nil 170 192 34 6 #Notification 1282 1029 nil 1808 1 nil nil nil nil #Notification nil nil nil #Warning 1282 1027 1840 1856 1 nil nil nil nil #Warning nil nil nil #Error 1282 1031 1888 1904 1 nil nil nil nil #Error nil nil nil nil nil nil 786 34 4 834 #createAt:extent: 34 2 882 1 43 882 347 459 3312 834 #wordWrap: 8 #(true) 3312 834 #margins: 34 1 34 3 2098 1 3312 49 3 nil nil nil nil 2098 3 3312 1 nil nil 67108863 nil nil 2098 5 3312 1 nil nil nil nil nil 3312 834 #maxCompletionListHeight: 8 #(9) 3312 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 21 0 0 0 173 0 0 0 250 0 0 0] 8 #() 1040 nil 35 170 192 34 4 3024 8 'afterTitle' 3312 8 'after' 2306 882 1 5 882 1 1 786 34 2 834 #createAt:extent: 34 2 882 355 1 882 347 501 2944 834 #text: 34 1 8 'After' 2944 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 34 2 3024 3312 1040 nil 27 1040 nil 27)!

wordSeparators
	^WordSeparators!

wordSeparators: aString 
	WordSeparators := aString! !
!UI.DifferencesPresenter class categoriesForMethods!
initialize!initializing!public! !
resource_Default_view!public!resources-views! !
wordSeparators!accessing!public! !
wordSeparators:!accessing!public! !
!

