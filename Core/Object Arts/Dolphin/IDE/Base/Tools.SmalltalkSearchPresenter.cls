"Filed out from Dolphin Smalltalk 7"!

UI.Presenter subclass: #'Tools.SmalltalkSearchPresenter'
	instanceVariableNames: 'environment'
	classVariableNames: 'AutoCompleteDwell'
	imports: #(#{UI.Scintilla.ScintillaConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkSearchPresenter guid: (Core.GUID fromString: '{a8c5bf80-8660-45e4-865c-f489ca9ca4e8}')!
Tools.SmalltalkSearchPresenter comment: ''!
!Tools.SmalltalkSearchPresenter categoriesForClass!MVP-Resources-IDE Tools! !
!Tools.SmalltalkSearchPresenter methodsFor!

addMethodsOfClass: aClass startingWith: aString toSearchCandidates: anOrderedCollection max: anInteger
	| prefix |
	prefix := aString , '>>'.
	environment selectorsForClass: aClass
		do: 
			[:each |
			anOrderedCollection
				add: (SmalltalkSearchCandidate matchingName: prefix , each object: (aClass compiledMethodAt: each)).
			anOrderedCollection size > anInteger ifTrue: [^#()]].
	^anOrderedCollection!

applyOptions
	"Private - Apply the class options to the receiver"

	view wordChars: (Character byteCharacterSet
				select: [:each | (Compiler isAValidIdentifierChar: each) or: [each == $:]]).
	view maxCompletionListHeight: 10.
	view maxCompletionListWidth: 40.
	view autoCompletionSeparator: $\x7F!

autoComplete: aSymbol at: posInteger maxItems: maxInteger 
	aSymbol == #normal 
		ifTrue: 
			[self showCompletionListAt: posInteger maxItems: maxInteger.
			^self].
	^nil!

classMatchingName: aString
	^(BindingReference isQualifiedName: aString)
		ifTrue: [aString asQualifiedReference valueOrNil]
		ifFalse: [environment classes detect: [:each | each name = aString] ifNone: []]!

completeWordAt: anInteger with: aString 
	| replaceRange replaceText |
	replaceRange := self rangeToCompleteAt: anInteger.
	replaceText := self searchText copyFrom: replaceRange start to: replaceRange stop.
	replaceText = aString ifTrue: [^self goSearch].
	view
		selectionRange: replaceRange;
		replaceSelection: aString!

completionListSortBlock
	^[:a :b | (a displayString <===> b displayString) <= 0]!

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

filterForClassNamesMatching: aString
	| isQualifiedName |
	isQualifiedName := BindingReference isQualifiedName: aString.
	^(aString includes: $\x20)
		ifTrue: 
			[isQualifiedName
				ifTrue: 
					[
					[:each |
					| name |
					((name := each fullName) beginsWith: aString) ifTrue: [name]]]
				ifFalse: 
					[
					[:each |
					| name |
					((name := each name) beginsWith: aString) ifTrue: [name]]]]
		ifFalse: 
			[isQualifiedName
				ifTrue: 
					[
					[:each |
					| name |
					(each isMetaclass not and: [(name := each fullName) beginsWith: aString]) ifTrue: [name]]]
				ifFalse: 
					[
					[:each |
					| name |
					(each isMetaclass not and: [(name := each name) beginsWith: aString]) ifTrue: [name]]]]!

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
	environment := Refactory.Browser.BrowserEnvironment new!

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
	aCharacter == $\r
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
	| candidates count |
	"Treat searches beginning with punctuation as a selector search,
	to allow searching for underscore-prefixed or binary selectors."
	aString first isUppercase ifFalse: [^self selectorsStartingWith: aString maxItems: anInteger].
	candidates := OrderedCollection new.
	Package manager packages
		do: [:each | (each name beginsWith: aString) ifTrue: [candidates add: each]].
	"Very unlikely there will be too many matching packages, but if so don't display a list"
	count := candidates size.
	count > anInteger ifTrue: [^#()].
	"Find matching classes in the environment"
	(aString includes: $>)
		ifTrue: 
			[| classNamePrefix |
			classNamePrefix := aString upTo: $>.
			(self classMatchingName: classNamePrefix)
				ifNotNil: 
					[:class |
					candidates := self
								addMethodsOfClass: class
								startingWith: classNamePrefix
								toSearchCandidates: candidates
								max: anInteger]]
		ifFalse: 
			[| matchBlock |
			matchBlock := self filterForClassNamesMatching: aString.
			environment classesDo: 
					[:each |
					(matchBlock value: each)
						ifNotNil: 
							[:name |
							candidates add: (SmalltalkSearchCandidate matchingName: name object: each).
							"If there are too many matching classes, don't display anything yet."
							candidates size > anInteger ifTrue: [^#()]]].
			"If we found only one class, then also add all its methods"
			candidates size - count = 1
				ifTrue: 
					[| candidate |
					candidate := candidates last.
					candidates := self
								addMethodsOfClass: candidate object
								startingWith: candidate matchingName
								toSearchCandidates: candidates
								max: anInteger]].
	^candidates!

searchObject
	| searchText |
	searchText := self searchText.
	searchText isEmpty ifTrue: [^nil].
	(searchText first isUppercase not and: [Symbol isLiteralSymbol: searchText])
		ifTrue: [^Symbol findInterned: searchText].
	(Package manager packageNamed: searchText ifNone: []) ifNotNil: [:a | ^a].
	(self classMatchingName: searchText) ifNotNil: [:class | ^class].
	^[Compiler evaluate: (searchText copyReplaceAll: '>>' with: '>>#')] on: Exception do: [:x | nil]!

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
!Tools.SmalltalkSearchPresenter categoriesFor: #addMethodsOfClass:startingWith:toSearchCandidates:max:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #applyOptions!operations!options!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #autoComplete:at:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #classMatchingName:!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #completeWordAt:with:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #completionListSortBlock!autocompletion!constants!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #filterForClassNamesMatching:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #findDetails!accessing!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #goSearch!commands!public! !
!Tools.SmalltalkSearchPresenter categoriesFor: #initialize!initializing!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #insertCompletion:at:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #isAutoCompletionTruncating!private!testing! !
!Tools.SmalltalkSearchPresenter categoriesFor: #isWhitespaceAt:!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #killAutocompleteTimer!autocompletion!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #maxAutoCompletionListSize!autocompletion!constants!public! !
!Tools.SmalltalkSearchPresenter categoriesFor: #maybeShowCompletionList!autocompletion!helpers!public! !
!Tools.SmalltalkSearchPresenter categoriesFor: #onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #onCharAdded:!autocompletion!event handling!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #onTimerTick:!event handling!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #onViewOpened!event handling!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #performSmalltalkSearchFor:!operations!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #queryCommand:!commands!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #rangeToCompleteAt:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #searchItemsStartingWith:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #searchObject!commands!public! !
!Tools.SmalltalkSearchPresenter categoriesFor: #searchText!accessing!public! !
!Tools.SmalltalkSearchPresenter categoriesFor: #searchText:!accessing!public! !
!Tools.SmalltalkSearchPresenter categoriesFor: #selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #showCompletionList:prefixLength:!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #showCompletionListAt:maxItems:!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #startAutocompleteTimer!autocompletion!helpers!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #tokenBefore:!accessing!autocompletion!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #tokenRangeAt:!accessing!autocompletion!private! !
!Tools.SmalltalkSearchPresenter categoriesFor: #tokenStartAt:!accessing!autocompletion!private! !

!Tools.SmalltalkSearchPresenter class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Scintilla.ScintillaView) 34 50 nil nil 34 2 8 1411449156 262145 416 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil nil nil 21 nil nil nil 416 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 73 1848902001 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 626 77 917510 ##(Graphics.Color) #gray 674 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 768 138 ##(Core.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 674 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 1 170 192 34 2 #container 592 nil nil nil nil 208 138 ##(Core.Set) 34 5 1507846 ##(UI.Scintilla.KeyBinding) 9385 4345 1010 9951 4345 1010 9353 4345 1010 9435 4345 1010 9431 4345 170 192 34 4 #Warning 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 416 674 #blue 3 false #Warning nil nil nil nil nil nil #Error 1138 19 416 674 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 626 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 626 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 626 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 8 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 1490 371 39 416 1442 #hoverTime: 8 #(500) 416 1442 #caretPeriod: 8 #(530) 416 1442 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 416 1 3 nil nil nil nil 1650 3 416 1 nil nil 67108863 nil nil 1650 5 416 1 nil nil nil nil nil 416 1442 #canHScroll: 8 #(false) 416 1442 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 416 1442 #maxCompletionListHeight: 8 #(9) 416 1442 #edgeColumn: 8 #(1) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 184 12 0 0 29 0 0 0] 8 #() 1490 193 193 nil 31 )! !
!Tools.SmalltalkSearchPresenter class categoriesFor: #autoCompleteDwell!accessing!autocompletion!public! !
!Tools.SmalltalkSearchPresenter class categoriesFor: #autoCompleteDwell:!accessing!autocompletion!public! !
!Tools.SmalltalkSearchPresenter class categoriesFor: #defaultAdditionalAccelerators!public! !
!Tools.SmalltalkSearchPresenter class categoriesFor: #icon!constants!public! !
!Tools.SmalltalkSearchPresenter class categoriesFor: #initialize!initializing!public! !
!Tools.SmalltalkSearchPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

