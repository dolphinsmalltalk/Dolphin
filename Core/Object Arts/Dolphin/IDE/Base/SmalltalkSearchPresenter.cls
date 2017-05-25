"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #SmalltalkSearchPresenter
	instanceVariableNames: 'environment'
	classVariableNames: 'AutoCompleteDwell'
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: ''!
SmalltalkSearchPresenter guid: (GUID fromString: '{a8c5bf80-8660-45e4-865c-f489ca9ca4e8}')!
SmalltalkSearchPresenter comment: ''!
!SmalltalkSearchPresenter categoriesForClass!Development!MVP-Resources-IDE Tools! !
!SmalltalkSearchPresenter methodsFor!

applyOptions
	"Private - Apply the class options to the receiver"

	view wordChars: (Character byteCharacterSet 
				select: [:each | (Compiler isAValidIdentifierChar: each) or: [each == $:]]).
	view maxCompletionListHeight: 10.
	view maxCompletionListWidth: 40.
	view autoCompletionSeparator: 16r7F asCharacter!

autoComplete: aSymbol at: posInteger maxItems: maxInteger 
	aSymbol == #normal 
		ifTrue: 
			[self showCompletionListAt: posInteger maxItems: maxInteger.
			^self].
	^nil!

completeWordAt: anInteger with: aString 
	| replaceRange replaceText |
	replaceRange := self rangeToCompleteAt: anInteger.
	replaceText := self searchText copyFrom: replaceRange start to: replaceRange stop.
	replaceText = aString ifTrue: [^self goSearch].
	view
		selectionRange: replaceRange;
		replaceSelection: aString!

completionListSortBlock
	| crt |
	crt := CRTLibrary default.
	^[:a :b | (crt strcmp: a displayString string2: b displayString) <= 0]!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self
		when: #charAdded:
			send: #onCharAdded:
			to: self;
		when: #autoComplete:startingAt:accept:
			send: #onAutoComplete:startingAt:accept:
			to: self;
		when: #timerTick:
			send: #onTimerTick:
			to: self!

findDetails
	^nil!

goSearch
	| searchForObject |
	searchForObject := self searchObject.
	searchForObject notNil 
		ifTrue: [self performSmalltalkSearchFor: searchForObject]
		ifFalse: [^Sound errorBeep]!

initialize
	super initialize.
	environment := BrowserEnvironment new!

insertCompletion: aString at: anInteger 
	"Private - Private-"

	view performUndoableAction: [self completeWordAt: anInteger with: aString]!

isAutoCompletionTruncating
	^view isAutoCompletionTruncating!

isWhitespaceAt: anInteger 
	^(view characterAt: anInteger) isSeparator 
		and: [(view styleIdAt: anInteger) = (view idOfStyleNamed: #whitespace)]!

killAutocompleteTimer
	self view killTimer: SCI_AUTOCSHOW!

maxAutoCompletionListSize
	^200!

maybeShowCompletionList
	| styleName last |
	self view selectionRange isEmpty ifFalse: [^self].
	last := view caretPosition - 1.
	styleName := (view styleAt: last) name.
	(self 
		autoComplete: styleName
		at: last
		maxItems: self maxAutoCompletionListSize) ifNil: []!

onAutoComplete: aString startingAt: anInteger accept: aValueHolder 
	"Private - "

	self insertCompletion: aString at: anInteger.
	aValueHolder value: false!

onCharAdded: aCharacter 
	aCharacter = Character cr 
		ifTrue: 
			[| searchExpression |
			searchExpression := self view plainText copyWithoutAll: String lineDelimiter.
			self view plainText: searchExpression.
			self goSearch]
		ifFalse: [self startAutocompleteTimer]!

onTimerTick: anInteger 
	anInteger == SCI_AUTOCSHOW ifFalse: [^self].
	self killAutocompleteTimer.
	self maybeShowCompletionList!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	super onViewOpened.
	self applyOptions!

performSmalltalkSearchFor: anObject 
	self searchText: ''.
	self commandPolicy 
		route: (CommandDescription command: (Message selector: #searchSmalltalkFor: argument: anObject))!

queryCommand: aCommandQuery 
	"Enters details about a potential command for the receiver into the <CommandQuery>
	arugment."

	| cmd |
	cmd := aCommandQuery commandSymbol.

	"Handle Undo/Redo commands"
	cmd == #goSearch 
		ifTrue: 
			[aCommandQuery isEnabled: self view plainText notEmpty.
			^true].
	^super queryCommand: aCommandQuery!

rangeToCompleteAt: anInteger 
	^(self isWhitespaceAt: anInteger) 
		ifTrue: [anInteger to: anInteger - 1]
		ifFalse: 
			[self isAutoCompletionTruncating 
				ifTrue: [self tokenRangeAt: anInteger]
				ifFalse: [anInteger to: view caretPosition - 1]]!

searchItemsStartingWith: aString maxItems: anInteger
	| result classes filter |
	aString first isLowerCase
		ifTrue: 
			[| matchingSymbols |
			matchingSymbols := self selectorsStartingWith: aString maxItems: anInteger.
			^matchingSymbols].
	filter := (aString includes: $>)
				ifTrue: 
					[| prefix |
					prefix := (aString upTo: $>) asSymbol.
					[:each | each name == prefix]]
				ifFalse: 
					[(aString includes: Character space)
						ifTrue: [[:each | each name beginsWith: aString]]
						ifFalse: [[:each | each isMeta not and: [each name beginsWith: aString]]]].
	classes := environment classes select: filter.
	result := OrderedCollection new.
	classes size > 1
		ifTrue: 
			[classes do: 
					[:each |
					result
						add: (each isMeta ifTrue: [VariableBinding key: each name value: each] ifFalse: [each classBinding])].
			^result].
	classes do: 
			[:each |
			result
				add: (each isMeta ifTrue: [VariableBinding key: each name value: each] ifFalse: [each classBinding]).
			(environment selectorsForClass: each) do: [:sel | result add: each >> sel]].
	Package manager packages do: [:each | result add: each].
	^result select: [:each | each displayString beginsWith: aString]!

searchObject
	^
	[| searchText evaluateText |
	searchText := self searchText.
	searchText first isLowerCase ifTrue: [^Symbol findInterned: searchText].
	evaluateText := searchText copyReplaceAll: '>>' with: '>>#'.
	Compiler evaluate: evaluateText] 
			on: Exception
			do: [:x | Package manager packages detect: [:each | each name = self searchText] ifNone: []]!

searchText
	^self view plainText!

searchText: aString
	self view plainText: aString!

selectorsStartingWith: aString maxItems: anInteger 
	| stream |
	stream := Array writeStream.
	Smalltalk developmentSystem allSelectors do: 
			[:each | 
			(each beginsWith: aString) 
				ifTrue: 
					[stream nextPut: each.
					stream size > anInteger ifTrue: [^#()]]].
	^stream contents!

showCompletionList: aCollection prefixLength: anInteger
	(aCollection size = 1 and: [aCollection anyOne size = anInteger])
		ifTrue: 
			["Don't display a list of one item that is the same as the prefix"
			^self].
	view
		showAutoCompletionList: (aCollection asSortedCollection: self completionListSortBlock)
		prefixLength: anInteger
		withIcons: true!

showCompletionListAt: posInteger maxItems: maxInteger 
	| prefix start choices |
	start := self tokenStartAt: posInteger.
	start = 0 ifTrue: [^self].
	prefix := view plainTextFrom: start to: posInteger.
	prefix size < 2 ifTrue: [^self].
	choices := self searchItemsStartingWith: prefix maxItems: maxInteger.
	self showCompletionList: choices prefixLength: prefix size!

startAutocompleteTimer
	self view setTimer: SCI_AUTOCSHOW interval: self class autoCompleteDwell!

tokenBefore: anInteger 
	^view styler tokenBefore: anInteger!

tokenRangeAt: anInteger 
	^(view styleAt: anInteger) name == #specialCharacter 
		ifTrue: [anInteger to: anInteger]
		ifFalse: [view tokenRangeAt: anInteger]!

tokenStartAt: anInteger 
	^(view styleAt: anInteger) name == #specialCharacter 
		ifTrue: [anInteger]
		ifFalse: [view tokenStartAt: anInteger]! !
!SmalltalkSearchPresenter categoriesFor: #applyOptions!operations!options!private! !
!SmalltalkSearchPresenter categoriesFor: #autoComplete:at:maxItems:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #completeWordAt:with:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #completionListSortBlock!autocompletion!constants!private! !
!SmalltalkSearchPresenter categoriesFor: #createSchematicWiring!initializing!private! !
!SmalltalkSearchPresenter categoriesFor: #findDetails!accessing!private! !
!SmalltalkSearchPresenter categoriesFor: #goSearch!commands!public! !
!SmalltalkSearchPresenter categoriesFor: #initialize!initializing!private! !
!SmalltalkSearchPresenter categoriesFor: #insertCompletion:at:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #isAutoCompletionTruncating!private!testing! !
!SmalltalkSearchPresenter categoriesFor: #isWhitespaceAt:!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #killAutocompleteTimer!autocompletion!private! !
!SmalltalkSearchPresenter categoriesFor: #maxAutoCompletionListSize!autocompletion!constants!public! !
!SmalltalkSearchPresenter categoriesFor: #maybeShowCompletionList!autocompletion!helpers!public! !
!SmalltalkSearchPresenter categoriesFor: #onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
!SmalltalkSearchPresenter categoriesFor: #onCharAdded:!autocompletion!event handling!private! !
!SmalltalkSearchPresenter categoriesFor: #onTimerTick:!event handling!private! !
!SmalltalkSearchPresenter categoriesFor: #onViewOpened!event handling!private! !
!SmalltalkSearchPresenter categoriesFor: #performSmalltalkSearchFor:!operations!private! !
!SmalltalkSearchPresenter categoriesFor: #queryCommand:!commands!private! !
!SmalltalkSearchPresenter categoriesFor: #rangeToCompleteAt:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #searchItemsStartingWith:maxItems:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #searchObject!commands!public! !
!SmalltalkSearchPresenter categoriesFor: #searchText!accessing!public! !
!SmalltalkSearchPresenter categoriesFor: #searchText:!accessing!public! !
!SmalltalkSearchPresenter categoriesFor: #selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #showCompletionList:prefixLength:!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #showCompletionListAt:maxItems:!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #startAutocompleteTimer!autocompletion!helpers!private! !
!SmalltalkSearchPresenter categoriesFor: #tokenBefore:!accessing!autocompletion!private! !
!SmalltalkSearchPresenter categoriesFor: #tokenRangeAt:!accessing!autocompletion!private! !
!SmalltalkSearchPresenter categoriesFor: #tokenStartAt:!accessing!autocompletion!private! !

!SmalltalkSearchPresenter class methodsFor!

autoCompleteDwell
	"Answer the <integer> number of milliseconds that must elapse between characters being typed
	before the workspace will attempt to display an auto-completion list."

	^AutoCompleteDwell!

autoCompleteDwell: anInteger 
	AutoCompleteDwell := anInteger!

defaultAdditionalAccelerators
	^#(#(#searchSmalltalk 'Ctrl+Shift+F')).!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	AutoCompleteDwell := 30.
	!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 0 0 34 2 8 1411453252 262145 416 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 0 0 21 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 416 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 73 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 738 77 786694 ##(Smalltalk.IndexedColor) 33554457 786 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 752 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 false 138 144 8 #() 170 192 896 138 ##(Smalltalk.IdentitySet) 896 0 170 176 896 9215 0 0 0 0 786 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 704 0 0 0 0 3 170 176 34 94 12359 1245702 ##(Smalltalk.ScintillaKeyBinding) 12359 4639 12361 1138 12361 4635 12363 1138 12363 4619 12367 1138 12367 4623 17 1138 17 4653 19 1138 19 4655 27 1138 27 4659 12381 1138 12381 4793 8263 1138 8263 4637 12671 1138 12671 4783 8265 1138 8265 4633 8267 1138 8267 4617 8271 1138 8271 4621 8283 1138 8283 4357 4167 1138 4167 4631 8285 1138 8285 4673 4171 1138 4171 4611 8575 1138 8575 4781 4175 1138 4175 4615 55 1138 55 4651 67 1138 67 4641 4187 1138 4187 4359 4189 1138 4189 4355 69 1138 69 4645 71 1138 71 4629 73 1138 73 4663 75 1138 75 4609 77 1138 77 4605 79 1138 79 4613 81 1138 81 4601 8323 1138 8323 4027 12441 1138 12441 4677 8327 1138 8327 4357 91 1138 91 4649 93 1138 93 4361 12305 1138 12305 4791 12729 1138 12729 4787 12457 1138 12457 4911 12459 1138 12459 4683 8345 1138 8345 4675 8633 1138 8633 4785 8209 1138 8209 4671 8363 1138 8363 4681 8365 1138 8365 4359 8369 1138 8369 4355 8371 1138 8371 4023 8373 1138 8373 4353 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 416 33554465 3 false #Warning 0 0 0 0 0 0 #Error 1938 19 416 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 738 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 738 1027 2034 60239 2034 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 738 1031 2034 335 2034 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 6 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 626 3839 21 626 459 41 416 2226 #modificationEventMask: 8 #(4607) 416 2226 #hoverTime: 8 #(500) 416 2226 #caretPeriod: 8 #(530) 416 2226 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 416 1 3 0 0 0 0 2450 3 416 1 0 0 67108863 0 0 2450 5 416 1 0 0 0 0 0 416 2226 #canHScroll: 8 #(false) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 100 8 0 0 30 0 0 0] 8 #() 626 193 193 0 29 )! !
!SmalltalkSearchPresenter class categoriesFor: #autoCompleteDwell!accessing!autocompletion!public! !
!SmalltalkSearchPresenter class categoriesFor: #autoCompleteDwell:!accessing!autocompletion!public! !
!SmalltalkSearchPresenter class categoriesFor: #defaultAdditionalAccelerators!public! !
!SmalltalkSearchPresenter class categoriesFor: #initialize!initializing!public! !
!SmalltalkSearchPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

