﻿"Filed out from Dolphin Smalltalk"!

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

queryToggleIndentGuides: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: beforePresenter view hasIndentationGuides!

queryToggleLineNumberMargins: aCommandQuery
	beforePresenter view lineNumberMargin
		ifNil: [aCommandQuery beDisabled]
		ifNotNil: 
			[:margin |
			aCommandQuery
				beEnabled;
				isChecked: margin width ~= 0]!

queryToggleSyntaxColoring: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: beforePresenter view isStylingEnabled!

queryToggleVisibleLineEndings: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: beforePresenter view hasVisibleLineEndings!

queryToggleVisibleWhitespace: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: beforePresenter view whitespaceVisibility ~~ #invisible!

queryToggleWrapping: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: beforePresenter view wordWrap!

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

	<commandQuery: #queryToggleIndentGuides:>
	beforePresenter view toggleIndentationGuides.
	afterPresenter view toggleIndentationGuides!

toggleLineNumberMargins
	"Show or hide the first line number margin, inverting the current state."

	<commandQuery: #queryToggleLineNumberMargins:>
	beforePresenter view toggleLineNumbers.
	afterPresenter view toggleLineNumbers!

toggleSyntaxColoring
	<commandQuery: #queryToggleSyntaxColoring:>
	beforePresenter view toggleStyling.
	afterPresenter view toggleStyling!

toggleVisibleLineEndings
	"Show or hide the end-of-line characters."

	<commandQuery: #queryToggleVisibleLineEndings:>
	beforePresenter view toggleLineEndings.
	afterPresenter view toggleLineEndings!

toggleVisibleWhitespace
	"Show or hide the whitespace markers in the view."

	<commandQuery: #queryToggleVisibleWhitespace:>
	beforePresenter view toggleWhitespace.
	afterPresenter view toggleWhitespace!

toggleWrapping
	<commandQuery: #queryToggleWrapping:>
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
queryToggleIndentGuides:!commands-queries!private! !
queryToggleLineNumberMargins:!commands-queries!private! !
queryToggleSyntaxColoring:!commands-queries!private! !
queryToggleVisibleLineEndings:!commands-queries!private! !
queryToggleVisibleWhitespace:!commands-queries!private! !
queryToggleWrapping:!commands-queries!private! !
reduce:!helpers!private! !
refresh!public!updating! !
styler!accessing!public! !
styler:!accessing!public! !
textFont:!accessing!public! !
textStyles:!accessing!public! !
toggleIndentGuides!commands-actions!public! !
toggleLineNumberMargins!commands-actions!public! !
toggleSyntaxColoring!commands-actions!public! !
toggleVisibleLineEndings!commands-actions!public! !
toggleVisibleWhitespace!commands-actions!public! !
toggleWrapping!commands-actions!public! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 224 nil nil nil 5 nil nil nil 224 1798 #{UI.BorderLayout} 1 1 18 #{UI.StaticText} 50 16 nil 224 50 2 8 1140850945 1 320 nil nil nil 5 nil nil nil 320 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 2 0 0 0 172 0 0 0 21 0 0 0] 193 352 nil 320 466 #text: 50 1 8 'Before' 320 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 224 50 2 8 1174409476 262145 688 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 6 #{Graphics.Color} #default nil 5 nil nil nil 688 nil nil 386 nil nil 11 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 5 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 818 #gray 818 #white 1 nil nil nil nil #callTip nil nil nil #indentGuide 898 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 898 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 898 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 898 3 818 #teal nil 1 nil nil nil nil #whitespace nil nil nil nil 326 1 #{UI.Scintilla.NullStyler} #normal 866 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 688 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 146 0 9215 nil nil 146 1 81 818 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil nil nil 3 866 1 #container 880 nil nil nil nil #{Core.Utf8String} nil 866 1 #diff 3142 5 #{UI.Scintilla.IndicatorDefinition} 1 688 818 #yellow 33 1 #diff 91 nil nil nil 171 nil nil nil 866 3 #Error 898 1031 818 #firebrick 818 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 898 1029 nil 818 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 898 1027 818 #darkGoldenrod 818 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 418 50 4 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 21 0 0 0 172 0 0 0 250 0 0 0] 193 720 nil 688 466 #wordWrap: 8 #(true) 688 466 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 688 49 3 nil nil nil nil 1650 3 688 nil nil nil 67108863 nil nil 1650 5 688 nil nil nil nil nil nil 688 466 #maxCompletionListHeight: 8 #(9) 688 3 8 #() 658 193 193 nil 45 178 864 50 4 688 8 'before' 320 8 'beforeTitle' 518 #{Graphics.Rectangle} 658 1 5 658 1 1 418 50 1 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 0 0 0 0 172 0 0 0 250 0 0 0] 193 256 8 '' 224 3 50 2 320 688 658 193 193 nil 27 8 'Before' nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[255 14 0 0 10 0 0 0 93 16 0 0 4 1 0 0] 193 80 8 '' 32 1 50 3 224 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 2224 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 2224 nil 1 #left nil nil nil 658 1 1 658 9 9 nil 2320 nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[172 0 0 0 0 0 0 0 177 0 0 0 250 0 0 0] 193 2256 8 '' 2224 3 8 #() 658 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2512 nil nil nil 5 nil nil nil 2512 290 1 1 18 #{UI.StaticText} 50 16 nil 2512 50 2 8 1140850945 1 2592 nil nil nil 5 nil nil nil 2592 nil nil 386 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 2 0 0 0 173 0 0 0 21 0 0 0] 193 2624 nil 2592 466 #text: 50 1 8 'After' 2592 3 8 #() 658 193 193 nil 27 nil nil nil 18 #{UI.Scintilla.ScintillaView} 50 56 nil 2512 50 2 8 1174405380 262145 2864 754 nil false 800 nil 832 nil 5 nil nil nil 2864 nil nil 386 nil nil 3 #focusLost nil nil nil nil 866 5 #callTip 898 77 928 944 1 nil nil nil nil #callTip nil nil nil #indentGuide 898 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 898 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 898 1 nil nil 1 nil nil nil nil #normal nil nil nil #whitespace 898 3 1024 nil 1 nil nil nil nil #whitespace nil nil nil nil 1042 #normal 866 1 #default 1090 1 nil nil nil 2864 #circle nil nil nil nil nil nil 1122 0 nil 146 0 9215 nil nil 146 1 81 1184 nil nil 1216 nil 65 nil nil nil nil 3 866 1 #container 2960 nil nil nil nil #{Core.Utf8String} nil 866 1 #diff 1266 1 2864 1296 33 1 #diff 91 nil nil nil 171 nil nil nil 866 3 #Error 898 1031 1344 1360 1 nil nil nil nil #Error nil nil nil #Notification 898 1029 nil 1392 1 nil nil nil nil #Notification nil nil nil #Warning 898 1027 1424 1440 1 nil nil nil nil #Warning nil nil nil nil nil nil 418 50 4 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 21 0 0 0 173 0 0 0 250 0 0 0] 193 2896 nil 2864 466 #wordWrap: 8 #(true) 2864 466 #margins: 50 1 50 3 1650 1 2864 49 3 nil nil nil nil 1650 3 2864 nil nil nil 67108863 nil nil 1650 5 2864 nil nil nil nil nil nil 2864 466 #maxCompletionListHeight: 8 #(9) 2864 3 8 #() 658 193 193 nil 45 178 864 50 4 2864 8 'after' 2592 8 'afterTitle' 1842 658 1 5 658 1 1 418 50 1 466 #createWindow: 50 1 514 546 8 #[177 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 193 2544 8 'After' 2512 3 50 2 2592 2864 658 193 193 nil 27 658 193 193 nil 27)!

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

