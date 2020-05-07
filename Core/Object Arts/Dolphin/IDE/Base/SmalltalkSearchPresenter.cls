"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #SmalltalkSearchPresenter
	instanceVariableNames: 'environment'
	classVariableNames: 'AutoCompleteDwell'
	poolDictionaries: 'ScintillaConstants'
	classInstanceVariableNames: ''!
SmalltalkSearchPresenter guid: (GUID fromString: '{a8c5bf80-8660-45e4-865c-f489ca9ca4e8}')!
SmalltalkSearchPresenter comment: ''!
!SmalltalkSearchPresenter categoriesForClass!MVP-Resources-IDE Tools! !
!SmalltalkSearchPresenter methodsFor!

applyOptions
	"Private - Apply the class options to the receiver"

	view wordChars: (Character byteCharacterSet
				select: [:each | (Compiler isAValidIdentifierChar: each) or: [each == $:]]).
	view maxCompletionListHeight: 10.
	view maxCompletionListWidth: 40.
	view autoCompletionSeparator: $\x7F.!

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
	self
		autoComplete: styleName
		at: last
		maxItems: self maxAutoCompletionListSize!

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
	view isAutoCompletionActive ifFalse: [self maybeShowCompletionList]!

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
	| result classes classFilter addBlock |
	"Treat searches beginning with punctuation as a selector search,
	to allow searching for underscore-prefixed or binary selectors."
	aString first isUppercase ifFalse: [^self selectorsStartingWith: aString maxItems: anInteger].
	result := OrderedCollection new.
	addBlock := 
			[:obj |
			(obj displayString beginsWith: aString) ifTrue: 
					[result add: obj.
					result size > anInteger ifTrue: [^#()]]].
	Package manager packages do: addBlock.
	Smalltalk associationsDo: 
			[:assoc |
			((assoc value isBehavior not or: [assoc key ~= assoc value name])
				and: [assoc value class conformsToProtocol: #sourceObject]) ifTrue: [addBlock value: assoc]].
	classFilter := (aString includes: $>)
				ifTrue: 
					[| classNamePrefix |
					classNamePrefix := aString upTo: $>.
					[:each | each name = classNamePrefix]]
				ifFalse: 
					[(aString includes: $\x20)
						ifTrue: [[:each | each name beginsWith: aString]]
						ifFalse: [[:each | each isMetaclass not and: [each name beginsWith: aString]]]].
	classes := environment classes select: classFilter.
	classes do: 
			[:each |
			addBlock
				value: (each isMeta ifTrue: [VariableBinding key: each name value: each] ifFalse: [each classBinding])].
	classes size = 1 ifTrue: 
			[environment selectorsForClass: classes anyOne do: [:sel | addBlock value: classes anyOne >> sel]].
	^result.!

searchObject
	| searchText |
	searchText := self searchText.
	searchText isEmpty ifTrue: [^nil].
	(searchText first isUppercase not and: [Symbol isLiteralSymbol: searchText])
		ifTrue: [^Symbol findInterned: searchText].
	(Package manager packageNamed: searchText ifNone: []) ifNotNil: [:a | ^a].
	Smalltalk at: searchText ifPresent: [:a | ^a].
	^[Compiler evaluate: (searchText copyReplaceAll: '>>' with: '>>#')] on: Exception do: [:x | ].!

searchText
	^self view plainText!

searchText: aString
	self view plainText: aString!

selectorsStartingWith: aString maxItems: anInteger 
	| stream |
	stream := Array writeStream: (anInteger bitShift: -1).
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
	choices := self searchItemsStartingWith: prefix maxItems: maxInteger.
	self showCompletionList: choices prefixLength: prefix size.!

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

icon
	^Icon fromId: 'GoSearch.ico'!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1411449156 262145 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 1738225245 852486 ##(Smalltalk.NullConverter) nil nil 73 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 626 77 327686 ##(Smalltalk.Color) #gray 674 #white 1 nil nil nil nil #callTip nil nil nil 34 256 640 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 656 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 784 138 ##(Smalltalk.IdentitySet) 784 nil 170 176 784 nil nil nil nil nil 674 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 130003 170 176 34 100 12879 1245702 ##(Smalltalk.ScintillaKeyBinding) 12879 4623 4113 1026 4113 4653 8775 1026 8775 4637 13753 1026 13753 4787 8777 1026 8777 4633 8779 1026 8779 4617 8783 1026 8783 4621 12893 1026 12893 4793 17 1026 17 4653 4679 1026 4679 4631 19 1026 19 4655 4683 1026 4683 4611 263747 1026 263747 4641 8633 1026 8633 4785 263749 1026 263749 4645 8795 1026 8795 4357 4687 1026 4687 4615 8323 1026 8323 4027 8797 1026 8797 4673 583 1026 583 4629 12671 1026 12671 4783 8327 1026 8327 4357 585 1026 585 4663 587 1026 587 4609 27 1026 27 4659 263761 1026 263761 4601 589 1026 589 4605 591 1026 591 4613 4699 1026 4699 4359 4701 1026 4701 4355 8575 1026 8575 4781 16401 1026 16401 4353 8345 1026 8345 4675 603 1026 603 4649 605 1026 605 4361 12457 1026 12457 4911 55 1026 55 4651 12459 1026 12459 4683 12305 1026 12305 4791 16967 1026 16967 4695 16969 1026 16969 4691 8363 1026 8363 4681 8365 1026 8365 4359 8209 1026 8209 4671 12871 1026 12871 4639 8369 1026 8369 4355 12873 1026 12873 4635 8371 1026 8371 4023 12875 1026 12875 4619 8373 1026 8373 4353 170 192 34 4 #Error 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 416 674 #red 3 false #Error nil nil nil nil nil nil #Warning 1874 17 416 674 #blue 3 false #Warning nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 626 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 626 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 9 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 2226 371 39 416 2178 #textLimit: 8 #(1073741823) 416 2178 #hoverTime: 8 #(500) 416 2178 #caretPeriod: 8 #(530) 416 2178 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 2418 3 416 1 nil nil 67108863 nil nil 2418 5 416 1 nil nil nil nil nil 416 2178 #canHScroll: 8 #(false) 416 2178 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 416 2178 #maxCompletionListHeight: 8 #(9) 416 2178 #edgeColumn: 8 #(1) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 56 8 0 0 29 0 0 0] 8 #() 2226 193 193 nil 29 )! !
!SmalltalkSearchPresenter class categoriesFor: #autoCompleteDwell!accessing!autocompletion!public! !
!SmalltalkSearchPresenter class categoriesFor: #autoCompleteDwell:!accessing!autocompletion!public! !
!SmalltalkSearchPresenter class categoriesFor: #defaultAdditionalAccelerators!public! !
!SmalltalkSearchPresenter class categoriesFor: #icon!constants!public! !
!SmalltalkSearchPresenter class categoriesFor: #initialize!initializing!public! !
!SmalltalkSearchPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

