"Filed out from Dolphin Smalltalk"!

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

!SmalltalkSearchPresenter categoriesForMethods!
applyOptions!operations!options!private! !
autoComplete:at:maxItems:!autocompletion!helpers!private! !
completeWordAt:with:!autocompletion!helpers!private! !
completionListSortBlock!autocompletion!constants!private! !
createSchematicWiring!initializing!private! !
findDetails!accessing!private! !
goSearch!commands!public! !
initialize!initializing!private! !
insertCompletion:at:!autocompletion!helpers!private! !
isAutoCompletionTruncating!private!testing! !
isWhitespaceAt:!helpers!private! !
killAutocompleteTimer!autocompletion!private! !
maxAutoCompletionListSize!autocompletion!constants!public! !
maybeShowCompletionList!autocompletion!helpers!public! !
onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
onCharAdded:!autocompletion!event handling!private! !
onTimerTick:!event handling!private! !
onViewOpened!event handling!private! !
performSmalltalkSearchFor:!operations!private! !
queryCommand:!commands!private! !
rangeToCompleteAt:!autocompletion!helpers!private! !
searchItemsStartingWith:maxItems:!autocompletion!helpers!private! !
searchObject!commands!public! !
searchText!accessing!public! !
searchText:!accessing!public! !
selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
showCompletionList:prefixLength:!autocompletion!helpers!private! !
showCompletionListAt:maxItems:!helpers!private! !
startAutocompleteTimer!autocompletion!helpers!private! !
tokenBefore:!accessing!autocompletion!private! !
tokenRangeAt:!accessing!autocompletion!private! !
tokenStartAt:!accessing!autocompletion!private! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 65 nil nil 34 2 8 1411449156 262145 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 1504001512 852486 ##(Smalltalk.NullConverter) nil nil 73 68819953 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 327686 ##(Smalltalk.Color) #gray 658 #white 1 nil nil nil nil #callTip nil nil nil #normal 626 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 768 138 ##(Smalltalk.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 658 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 208 138 ##(Smalltalk.Set) 34 5 1245702 ##(Smalltalk.ScintillaKeyBinding) 9385 4345 1010 9951 4345 1010 9353 4345 1010 9435 4345 1010 9431 4345 170 192 34 4 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 416 658 #blue 3 false #Warning nil nil nil nil nil nil #Error 1138 19 416 658 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 626 1027 658 #darkGoldenrod 658 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 658 #firebrick 658 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 626 1029 nil 658 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 8 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[191 13 0 0 10 0 0 0 120 14 0 0 29 0 0 0] 193 448 nil 416 1442 #hoverTime: 8 #(500) 416 1442 #caretPeriod: 8 #(530) 416 1442 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil nil nil 1682 3 416 1 nil nil 67108863 nil nil 1682 5 416 1 nil nil nil nil nil 416 1442 #canHScroll: 8 #(false) 416 1442 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 416 1442 #maxCompletionListHeight: 8 #(9) 416 1442 #edgeColumn: 8 #(1) 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 33 )! !

!SmalltalkSearchPresenter class categoriesForMethods!
autoCompleteDwell!accessing!autocompletion!public! !
autoCompleteDwell:!accessing!autocompletion!public! !
defaultAdditionalAccelerators!public! !
icon!constants!public! !
initialize!initializing!public! !
resource_Default_view!public!resources-views! !
!

