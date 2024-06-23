"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'Tools.SmalltalkSearchPresenter'
	instanceVariableNames: 'searchEnvironment'
	classVariableNames: 'AutoCompleteDwell MaxCompletionListHeight MaxCompletionListWidth OptionFlags'
	imports: #(#{UI.Scintilla private})
	classInstanceVariableNames: ''
	classConstants: { 'LoadingOptionsMask' -> 16r1 }!

Tools.SmalltalkSearchPresenter guid: (Core.GUID fromString: '{a8c5bf80-8660-45e4-865c-f489ca9ca4e8}')!

Tools.SmalltalkSearchPresenter comment: ''!

!Tools.SmalltalkSearchPresenter categoriesForClass!MVP-Resources-IDE Tools! !

!Tools.SmalltalkSearchPresenter methodsFor!

addMethodsOfClass: aClass startingWith: aString toSearchCandidates: aSet max: anInteger
	| format |
	format := ((BindingReference isQualifiedName: aString)
				or: [aClass shortName = aClass unqualifiedName])
					ifTrue: [aString , '>><d>']
					ifFalse: ['<1d>>>%<d> (<2d>)' << { aString. aClass environment fullName }].
	searchEnvironment selectorsForClass: aClass
		do: 
			[:each |
			aSet add: (ListItem object: (aClass compiledMethodAt: each) text: format << each).
			aSet size > anInteger ifTrue: [OperationAborted signal]].
	^aSet!

applyOptions
	"Private - Apply the class options to the receiver"

	view wordChars: ##(Character byteCharacterSet
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
		ifFalse: [searchEnvironment classes detect: [:each | each name = aString] ifNone: nil]!

completeWordAt: anInteger with: aString 
	| replaceRange replaceText |
	replaceRange := self rangeToCompleteAt: anInteger.
	replaceText := self searchText copyFrom: replaceRange start to: replaceRange stop.
	replaceText = aString ifTrue: [^self goSearch].
	view
		selectionRange: replaceRange;
		replaceSelection: aString!

completionForChoice: aString
	| parts |
	aString first isUpperCase ifFalse: [^aString].
	(Package manager packageNamed: aString ifNone: nil) ifNotNil: [^aString].
	parts := $( split: aString.
	parts size = 1 ifTrue: [^aString].
	^(parts second readStream upTo: $)) , '.' , parts first trimBlanks!

completionListSortBlock
	^ScintillaView listSortBlock: false!

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
					((name := each name) beginsWith: aString) ifTrue: [name asString]]]]
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
					(each isMetaclass not and: [(name := each name) beginsWith: aString]) ifTrue: [name asString]]]]!

findDetails
	^nil!

goSearch
	<commandQuery: #hasSearchText>
	| searchForObject |
	searchForObject := self searchObject.
	searchForObject notNil
		ifTrue: [self performSmalltalkSearchFor: searchForObject]
		ifFalse: [^Sound errorBeep]!

hasSearchText
	^self view plainText notEmpty!

initialize
	super initialize.
	searchEnvironment := Refactory.Browser.BrowserEnvironment new!

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
	^SmalltalkWorkspace maxAutoCompletionListSize!

maybeShowCompletionList
	| styleName last |
	self view selectionRange isEmpty ifFalse: [^self].
	last := view caretPosition - 1.
	styleName := (view styleAt: last) name.
	
	[self
		autoComplete: styleName
		at: last
		maxItems: self maxAutoCompletionListSize]
			on: OperationAborted
			do: [:ex | ]!

onAutoComplete: aString startingAt: anInteger accept: aValueHolder
	"Private - The user has made a choice from the auto-completion list. Perform our own insertion, and suppress the view's default completion."

	self insertCompletion: (self completionForChoice: aString) at: anInteger.
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

onViewAvailable
	super onViewAvailable.
	self applyOptions.!

onViewStateRestored
	super onViewStateRestored.
	self applyOptions!

performSmalltalkSearchFor: anObject
	self searchText: ''.
	self commandPolicy
		route: (CommandDescription command: (Message selector: #searchSmalltalkFor: argument: anObject))!

rangeToCompleteAt: anInteger 
	^(self isWhitespaceAt: anInteger) 
		ifTrue: [anInteger to: anInteger - 1]
		ifFalse: 
			[self isAutoCompletionTruncating 
				ifTrue: [self styleRunRangeAt: anInteger]
				ifFalse: [anInteger to: view caretPosition - 1]]!

searchEnvironment
	^searchEnvironment!

searchEnvironment: aBrowserEnvironment
	searchEnvironment := aBrowserEnvironment!

searchItemsStartingWith: aString maxItems: anInteger
	| candidates count |
	"Treat searches beginning with punctuation as a selector search,
	to allow searching for underscore-prefixed or binary selectors."
	aString first isUppercase ifFalse: [^self selectorsStartingWith: aString maxItems: anInteger].
	candidates := Set new.
	Package manager packages
		do: [:each | (each name beginsWith: aString) ifTrue: [candidates add: (ListItem object: each text: each name)]].
	"Very unlikely there will be too many matching packages, but if so don't display a list"
	count := candidates size.
	count > anInteger ifTrue: [OperationAborted signal].
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
			searchEnvironment classesDo: 
					[:each |
					(matchBlock value: each)
						ifNotNil: 
							[:name |
							| candidate |
							candidate := ListItem object: each text: name.
							"Occassionally we may get classes that cannot be referred to unambiguously using their unqualified name, in which case we need to append the namespace to disambiguate. When selected for autocompletion, the qualified class name will be inserted"
							(candidates addNewElement: candidate)
								ifFalse: 
									[| existing |
									existing := candidates remove: candidate.
									"Occassionaly we may encounter a package with the same name as a class, e.g. RBParser. In that case we leave the package name unchanged."
									existing object isBehavior
										ifTrue: [existing text: (self unambiguousCompletionFor: name class: existing object)].
									candidates add: existing.
									candidate text: (self unambiguousCompletionFor: name class: each)].
							candidates add: candidate.
							"If there are too many matching classes, don't display anything yet."
							candidates size > anInteger ifTrue: [OperationAborted signal]]].
			"If we found only one class, then also add all its methods"
			candidates size - count = 1
				ifTrue: 
					[| candidate |
					"Even though there is only one class, there may be a matching package too, so we need to find the class"
					candidate := candidates detect: [:each | each object isBehavior].
					candidates := self
								addMethodsOfClass: candidate object
								startingWith: candidate object name
								toSearchCandidates: candidates
								max: anInteger]].
	^candidates!

searchObject
	^self searchObjectFromText: self searchText!

searchObjectFromText: searchText
	searchText isEmpty ifTrue: [^nil].
	(searchText first isUppercase not and: [Symbol isLiteralSymbol: searchText])
		ifTrue: [^Symbol findInterned: searchText].
	(Package manager packageNamed: searchText ifNone: nil) ifNotNil: [:a | ^a].
	(self classMatchingName: searchText) ifNotNil: [:class | ^class].
	^[Compiler evaluate: (searchText copyReplaceAll: '>>' with: '>>#')] on: Exception do: [:x | nil]!

searchText
	^self view plainText!

searchText: aString
	self view plainText: aString!

selectorsStartingWith: aString maxItems: anInteger
	| stream |
	stream := LimitedWriteStream
				over: (Array writeStream: (anInteger bitShift: -1))
				limit: anInteger
				limitBlock: [:s | OperationAborted signal].
	SmalltalkSystem current allSelectors
		do: [:each | (each beginsWith: aString) ifTrue: [stream nextPut: (ListItem object: each text: each)]].
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
	start := self styleRunStartAt: posInteger.
	start = 0 ifTrue: [^self].
	prefix := view plainTextFrom: start to: posInteger.
	choices := self searchItemsStartingWith: prefix maxItems: maxInteger.
	self showCompletionList: choices prefixLength: prefix size.!

startAutocompleteTimer
	self view setTimer: SCI_AUTOCSHOW interval: self class autoCompleteDwell!

styleRunRangeAt: anInteger
	^(view styleAt: anInteger) name == #specialCharacter
		ifTrue: [anInteger to: anInteger]
		ifFalse: [view styleRunRangeAt: anInteger]!

styleRunStartAt: anInteger
	^(view styleAt: anInteger) name == #specialCharacter
		ifTrue: [anInteger]
		ifFalse: [view styleRunStartAt: anInteger]!

unambiguousCompletionFor: aString class: aClass
	^'<1d> (<2d>)' << { aString. aClass environment fullName }! !

!Tools.SmalltalkSearchPresenter categoriesForMethods!
addMethodsOfClass:startingWith:toSearchCandidates:max:!autocompletion!helpers!private! !
applyOptions!operations!options!private! !
autoComplete:at:maxItems:!autocompletion!helpers!private! !
classMatchingName:!helpers!private! !
completeWordAt:with:!autocompletion!helpers!private! !
completionForChoice:!autocompletion!private! !
completionListSortBlock!autocompletion!constants!private! !
createSchematicWiring!initializing!private! !
filterForClassNamesMatching:!autocompletion!helpers!private! !
findDetails!accessing!private! !
goSearch!commands-actions!public! !
hasSearchText!commands-queries!private!testing! !
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
onViewAvailable!event handling!public! !
onViewStateRestored!event handling!public! !
performSmalltalkSearchFor:!operations!private! !
rangeToCompleteAt:!autocompletion!helpers!private! !
searchEnvironment!accessing!private! !
searchEnvironment:!accessing!private! !
searchItemsStartingWith:maxItems:!autocompletion!helpers!private! !
searchObject!helpers!public! !
searchObjectFromText:!helpers!public! !
searchText!accessing!public! !
searchText:!accessing!public! !
selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
showCompletionList:prefixLength:!autocompletion!helpers!private! !
showCompletionListAt:maxItems:!helpers!private! !
startAutocompleteTimer!autocompletion!helpers!private! !
styleRunRangeAt:!accessing!autocompletion!private! !
styleRunStartAt:!accessing!autocompletion!private! !
unambiguousCompletionFor:class:!autocompletion!helpers!private! !
!

!Tools.SmalltalkSearchPresenter class methodsFor!

autoCompleteDwell
	"Answer the `Duration` that must elapse between characters being typed  before the workspace will attempt to display an auto-completion list."

	self ensureOptionsLoaded.
	^AutoCompleteDwell!

autoCompleteDwell: aDuration
	self autoCompleteDwell = aDuration ifTrue: [^self].
	AutoCompleteDwell := aDuration.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view autoCompleteDwell: aDuration].
	self persistOptions!

ensureOptionsLoaded
	OptionFlags ifNil: [self loadOptions]!

finishedLoadingOptions
	OptionFlags := OptionFlags bitAnd: ##(LoadingOptionsMask bitInvert)!

icon
	^Icon fromId: 'GoSearch.ico'!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	AutoCompleteDwell := 30 milliseconds
	!

invalidateOptions
	OptionFlags := nil!

isLoadingOptions
	^OptionFlags allMask: LoadingOptionsMask!

loadOptions
	SmalltalkToolShell loadOptionsFor: ##(self)!

maxCompletionListHeight
	self ensureOptionsLoaded.
	^MaxCompletionListHeight!

maxCompletionListHeight: anInteger
	self maxCompletionListHeight = anInteger ifTrue: [^self].
	MaxCompletionListHeight := anInteger.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view maxCompletionListHeight: anInteger].
	self persistOptions!

maxCompletionListWidth
	self ensureOptionsLoaded.
	^MaxCompletionListWidth!

maxCompletionListWidth: anInteger
	self maxCompletionListWidth = anInteger ifTrue: [^self].
	MaxCompletionListWidth := anInteger.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view maxCompletionListWidth: anInteger].
	self persistOptions!

optionsAspects
	^self publishedAspects
		removeKey: #yourself;
		yourself!

persistOptions
	^SmalltalkToolShell persistOptionsFor: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: ((Aspect integer: #maxCompletionListHeight)
					defaultValue: 10;
					yourself);
		add: ((Aspect integer: #maxCompletionListWidth)
					defaultValue: 40;
					yourself);
		add: ((Aspect duration: #autoCompleteDwell)
					defaultValue: 30 milliseconds;
					yourself);
		yourself.
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 38 #{Core.Array} 56 nil nil 50 2 8 1411449156 262145 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil nil nil 21 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 73 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.CallTipStyle} 77 6 #{Graphics.Color} #tooltipText 274 #tooltip 1 nil nil nil nil #callTip nil nil nil #normal 3142 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 210 0 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 466 2 23 518 #{Graphics.ThemeColor} #workspaceSelection 81 274 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 210 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 1 210 1 #container 224 nil nil nil nil #{Core.Utf8String} 294 #{Core.Set} 5 518 #{UI.Scintilla.KeyBinding} 9353 4345 706 9951 4345 706 9431 4345 706 9435 4345 706 9385 4345 210 2 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 19 32 274 #red 3 3 #Error nil nil nil nil nil nil #Warning 818 17 32 274 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 210 3 #Error 322 1031 274 #firebrick 274 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 322 1029 nil 274 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 322 1027 274 #darkGoldenrod 274 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 5 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 1138 371 39 32 1090 #margins: 50 1 8 #() 32 1090 #sciSetHScrollBar: 8 #(false) 32 1090 #maxCompletionListHeight: 8 #(9) 32 1090 #sciSetSelectionLayer: 8 #(1) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 184 12 0 0 29 0 0 0] 8 #() 1138 193 193 nil 45)!

startLoadingOptions
	OptionFlags := OptionFlags ?? 0 bitOr: LoadingOptionsMask! !

!Tools.SmalltalkSearchPresenter class categoriesForMethods!
autoCompleteDwell!autocompletion!options!public! !
autoCompleteDwell:!autocompletion!options!public! !
ensureOptionsLoaded!public! !
finishedLoadingOptions!options!private! !
icon!constants!public! !
initialize!initializing!public! !
invalidateOptions!options!private! !
isLoadingOptions!options!private! !
loadOptions!options!private! !
maxCompletionListHeight!options!public! !
maxCompletionListHeight:!options!public! !
maxCompletionListWidth!options!public! !
maxCompletionListWidth:!options!public! !
optionsAspects!public! !
persistOptions!options!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
startLoadingOptions!options!private! !
!

