"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #'Tools.SmalltalkToolShell'
	instanceVariableNames: 'searchPresenter fontSizePresenter'
	classVariableNames: 'HistoryDwellTime SearchFieldFlashes'
	imports: #()
	classInstanceVariableNames: 'optionFlags defaultView defaultExtent defaultSlideyPinsMap additionalKeyBindings commandQueryHandlers'
	classConstants: {
		'CanUseIdeaSpaceMask' -> 16r2.
		'ReuseIfOpenMask' -> 16r1
	}!
Tools.SmalltalkToolShell guid: (Core.GUID fromString: '{87b4c6a0-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SmalltalkToolShell isNonInstantiable: true!
Tools.SmalltalkToolShell comment: 'SmalltalkToolShell is an abstract <topPresenter> providing umbrella functionality for most of the Dolphin development tools. 

All of the tools have the singleton instance of SmalltalkSystem as their model. This makes sense because the SmalltalkSystem is effectively a Facade onto the Smalltalk development image; all user interface modifications to the image should go through this central point. In this way, a tool is effectively acting as a view onto the development image. It is also convenient since all <model>s are also <commandTarget>s. This means that some user interface commands can be directly picked up and acted upon by the SmalltalkSystem without any intervention being required from the tool itself.

Class Variables:
	ReuseIfOpenMask		<integer> mask used to get/set the ''re-use if open'' flag.

Class Instance Variables:
	optionFlags		<integer>
	defaultView		<String> name of the default view.
	defaultExtent		<Point> specifying the default size of new views, nil if none set.
	additionalAccelerators	<Array> of 2-element <Array>s, being command <Symbol> accelerator key <String> pairs
'!
!Tools.SmalltalkToolShell categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!Tools.SmalltalkToolShell methodsFor!

applyOptions
	self systemModel applyOptionsToTool: self!

browseIt
	"Open a new default browser at the same point as the receiver.
	This is the workspace Browse-It command which is subtly different to the Browse Classes
	command, but for many cases the appropriate action is to open a class browser so we
	wire up to the #browseClasses command by default."

	Object browse!

buildPopupForCommand: aSymbol 
	aSymbol == #newIdeaSpace ifTrue: [^self class buildIdeaSpacePopup].
	^nil!

canRefactor
	"Private - Answer whether the development tools support refactoring (requires that the Refactoring Engine be
	installed."

	^self systemModel canRefactor!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^false!

configureFromSavedStateString: aSavedStateString
	"Configures the receiver using the monadic block source in aSavedStateString"

	| result |
	result := Compiler
				compileForEvaluation: aSavedStateString
				in: nil
				evaluationPools: #()
				flags: 0.
	self view noRedrawDo: [(result method value: nil) value: self]!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	searchPresenter := self
				add: SmalltalkSearchPresenter new
				name: 'search'
				helpId: 10510.

	"Font size adjust by slider (if supported by view)"
	fontSizePresenter := self add: NumberPresenter new name: 'fontSize'!

createSchematicWiring
	super createSchematicWiring.
	self
		when: #dropFiles:
		send: #onDropFiles:over:
		to: self systemModel
		withArguments: {nil. self}!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self shortCaption!

fontSize
	^self view actualFont pointSize!

fontSize: anInteger 
	| currentFont |
	currentFont := self view actualFont.
	self view font: (Font name: currentFont name pointSize: anInteger)!

forgetSize
	"Forget the default size for new instances of this tool."

	(self class)
		defaultExtent: nil;
		defaultSlideyPinsMap: nil!

getPinStateFor: aSlideyInneyOuteyThingName 
	"Private - Attempts to find a named SlideyInneyOuteyThing within the view hierarchy of the receiver.
	Answers true if the slidey is pinned, false otherwise. If no such slidy is found answers nil"

	^(self view viewNamed: aSlideyInneyOuteyThingName ifNone: [^nil]) isPinned!

hasFuture
	"Answer whether there is any future history to visit."

	^false!

hasPast
	"Answer whether there is any past history to visit."

	^false!

help
	"Bring up a help page for this tool."

	self systemModel openHelpTopicForTool: self!

historyBack
	"Private - Return to the previously visited method."

	self historyBack: 1!

historyBack: delta
	"Private - Return to a previously visited method <integer>, delta, visits
	in the past.."

	self historySkip: delta negated!

historyForward
	"Private - Return to the previously visited class which has been
	moved back over by a jump back in time."

	self historyForward: 1!

historyForward: delta
	"Private - Return to the previously visited class which has been
	moved back over by a jump back in time."

	self historySkip: delta!

historySkip: delta 
	^self subclassResponsibility!

ideaSpace
	^#{IdeaSpaceShell} valueOrNil
		ifNotNil: [:ideaSpaceShellClass | (self topShell isKindOf: ideaSpaceShellClass) ifTrue: [self topShell]]!

inspectSystemOptions
	"Open a <PropertyInspector> on the system options."

	^(self systemModel inspectSystemOptions)
		selectionOrNil: self class;
		yourself!

isIdeaSpaceCard
	^self ideaSpace notNil!

methodBrowserClass
	^MethodBrowser!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	popup := self buildPopupForCommand: aToolbarButton command asSymbol.
	popup isNil ifTrue: [^nil].
	popup queryAllFromView: self view.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onViewOpened
	super onViewOpened.
	self view acceptDroppedFiles: true.
	fontSizePresenter model: (ValueAspectAdaptor subject: self aspect: #fontSize).
	self class defaultSlideyPinsMap notNil ifTrue: [self slideyPinMap: self class defaultSlideyPinsMap].

	"Enable toolbar pulldowns"
	(self view viewNamed: 'smalltalkTools' ifNone: [])
		ifNotNil: 
			[:toolbar |
			toolbar presenterConnectionPoint
				when: #dropDown:
				send: #onDropDown:
				to: self].
	self applyOptions!

packageManager
	"Private - Answer the current PackageManager."

	^self systemModel packageManager!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	#forgetSize == command 
		ifTrue: 
			[aCommandQuery isEnabled: self class defaultExtent notNil.
			^true].
	command == #historyBack 
		ifTrue: 
			[aCommandQuery isEnabled: self hasPast.
			^true].
	command == #historyForward 
		ifTrue: 
			[aCommandQuery isEnabled: self hasFuture.
			^true].
	(#(#dragToolToIdeaSpace #addToNewIdeaSpace) includes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: (self isIdeaSpaceCard not and: [self class canUseIdeaSpace]).
			^true].
	^super queryCommand: aCommandQuery!

rememberThisSize
	"Record the size of the receiver as the default extent for its tool class."

	(self class)
		defaultExtent: self view extent;
		defaultSlideyPinsMap: self slideyPinMap!

saveStateAspects: aSymbolArray for: aStringName on: aWriteStream
	"Private - Helper method for saving aSymbolArray of aspects of aStringName variable to aWriteStream"

	aSymbolArray do: 
			[:eachSymbol |
			'<1d> <2d>: ' expandMacrosWithArguments: {aStringName. eachSymbol} on: aWriteStream.
			(self perform: eachSymbol) literalStoreEvaluationOn: aWriteStream.
			eachSymbol == aSymbolArray last ifFalse: [aWriteStream nextPut: $.]]!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[:aSmalltalkToolShell | '.
	self 
		saveStateAspects: #(#slideyPinMap)
		for: 'aSmalltalkToolShell'
		on: aWriteStream.
	aWriteStream nextPut: $]!

saveStateString
	"Private - Answer the source of a monadic block that will configure an instance of the receiver's
	class to match the state current receiver. The block expects a fresh instance of the
	receiver's class as it's parameter"

	| stream |
	stream := String smalltalkWriteStream: 512.
	self saveStateOn: stream.
	^stream contents!

searchForClass: aClass 
	^aClass browse!

searchForMethod: aCompiledMethod 
	aCompiledMethod browse!

searchForObject: anObject 
	^anObject inspect!

searchForPackage: aPackage 
	^aPackage browse!

searchForSymbol: aSymbol
	self
		routeCommand: (CommandDescription command: (Message selector: #browseMethodsInEnvironments:
						argument: (self systemModel messagesMatching: (MethodSearch newSelector: aSymbol)
								in: Refactory.Browser.BrowserEnvironment new)))!

searchSmalltalk
	| searchView |
	searchView := searchPresenter view.
	searchView hasFocus ifTrue: [^self].
	searchView
		setFocus;
		flash: self class searchFieldFlashes!

searchSmalltalkFor: anObject 
	anObject searchForInTool: self!

selectionEnvironment
	^self subclassResponsibility!

setPinStateFor: aSlideyInneyOuteyThingName to: aBooleanOrNil 
	"Private - Attempts to find a named SlideyInneyOuteyThing within the view hierarchy of the receiver and sets the
	pin state to aBooleanOrNil. If the latter is nil, then no action is taken"

	| slidey |
	aBooleanOrNil isNil ifTrue: [^self].
	slidey := self view viewNamed: aSlideyInneyOuteyThingName ifNone: [^self].
	slidey isPinned: aBooleanOrNil!

show
	"Shows the view of the receiver.
	Pick up the default extent if any."

	self class defaultExtent ifNotNil: [:ext | self view extent: ext].
	^super show!

slideyPinMap
	"Tool shell often have sliding card trays that are either pinned or unpinned. Answers an IdentityDictionary of pin states
	keyed by the names of the card trays."

	| map |
	map := IdentityDictionary new.
	self slideyPinNames do: [:each | map at: each asSymbol put: (self getPinStateFor: each)].
	^map!

slideyPinMap: anIdentityDictionary 
	"Tool shell often have sliding card trays that are either pinned or unpinned. Sets the pin states
	of the receiver to anIdentityDictionary of pin states keyed by the names of the card trays. Note that
	not all views for a tool will support the same (or indeed any) sliding cards. If a view does not hold
	one of the named cards then the pin state is ignored."

	anIdentityDictionary 
		keysAndValuesDo: [:eachKey :eachValue | self setPinStateFor: eachKey asString to: eachValue]!

slideyPinNames
	^#()!

sourceControl
	^Package manager sourceControl!

systemModel
	^SmalltalkSystem current!

workspaceClass
	^Smalltalk developmentSystem workspaceClass! !
!Tools.SmalltalkToolShell categoriesFor: #applyOptions!private! !
!Tools.SmalltalkToolShell categoriesFor: #browseIt!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #buildPopupForCommand:!private! !
!Tools.SmalltalkToolShell categoriesFor: #canRefactor!private!testing! !
!Tools.SmalltalkToolShell categoriesFor: #canSaveState!private!saved state! !
!Tools.SmalltalkToolShell categoriesFor: #configureFromSavedStateString:!public! !
!Tools.SmalltalkToolShell categoriesFor: #createComponents!initializing!private! !
!Tools.SmalltalkToolShell categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.SmalltalkToolShell categoriesFor: #displayOn:!displaying!public! !
!Tools.SmalltalkToolShell categoriesFor: #fontSize!public! !
!Tools.SmalltalkToolShell categoriesFor: #fontSize:!public! !
!Tools.SmalltalkToolShell categoriesFor: #forgetSize!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #getPinStateFor:!accessing!private! !
!Tools.SmalltalkToolShell categoriesFor: #hasFuture!public!testing! !
!Tools.SmalltalkToolShell categoriesFor: #hasPast!public!testing! !
!Tools.SmalltalkToolShell categoriesFor: #help!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #historyBack!commands!private! !
!Tools.SmalltalkToolShell categoriesFor: #historyBack:!commands!private! !
!Tools.SmalltalkToolShell categoriesFor: #historyForward!commands!private! !
!Tools.SmalltalkToolShell categoriesFor: #historyForward:!commands!private! !
!Tools.SmalltalkToolShell categoriesFor: #historySkip:!commands!private! !
!Tools.SmalltalkToolShell categoriesFor: #ideaSpace!public! !
!Tools.SmalltalkToolShell categoriesFor: #inspectSystemOptions!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #isIdeaSpaceCard!public! !
!Tools.SmalltalkToolShell categoriesFor: #methodBrowserClass!constants!private! !
!Tools.SmalltalkToolShell categoriesFor: #onDropDown:!private! !
!Tools.SmalltalkToolShell categoriesFor: #onViewOpened!private! !
!Tools.SmalltalkToolShell categoriesFor: #packageManager!constants!private! !
!Tools.SmalltalkToolShell categoriesFor: #queryCommand:!commands!private! !
!Tools.SmalltalkToolShell categoriesFor: #rememberThisSize!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #saveStateAspects:for:on:!helpers!private!saved state! !
!Tools.SmalltalkToolShell categoriesFor: #saveStateOn:!private!saved state! !
!Tools.SmalltalkToolShell categoriesFor: #saveStateString!private!saved state! !
!Tools.SmalltalkToolShell categoriesFor: #searchForClass:!private! !
!Tools.SmalltalkToolShell categoriesFor: #searchForMethod:!private! !
!Tools.SmalltalkToolShell categoriesFor: #searchForObject:!public! !
!Tools.SmalltalkToolShell categoriesFor: #searchForPackage:!public! !
!Tools.SmalltalkToolShell categoriesFor: #searchForSymbol:!private! !
!Tools.SmalltalkToolShell categoriesFor: #searchSmalltalk!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #searchSmalltalkFor:!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #selectionEnvironment!public! !
!Tools.SmalltalkToolShell categoriesFor: #setPinStateFor:to:!accessing!private! !
!Tools.SmalltalkToolShell categoriesFor: #show!operations!public! !
!Tools.SmalltalkToolShell categoriesFor: #slideyPinMap!accessing!public! !
!Tools.SmalltalkToolShell categoriesFor: #slideyPinMap:!accessing!public! !
!Tools.SmalltalkToolShell categoriesFor: #slideyPinNames!accessing!private! !
!Tools.SmalltalkToolShell categoriesFor: #sourceControl!commands!public! !
!Tools.SmalltalkToolShell categoriesFor: #systemModel!accessing!private! !
!Tools.SmalltalkToolShell categoriesFor: #workspaceClass!constants!private! !

!Tools.SmalltalkToolShell class methodsFor!

activeIdeaSpace
	^#{IdeaSpaceShell}
		ifDefined: [:ideaSpaceShellClass | (View active topShell isKindOf: ideaSpaceShellClass) ifTrue: [View active topShell]]!

buildIdeaSpacePopup
	| popup |
	popup := Menu new.
	popup
		addCommand: (Message selector: #newIdeaSpace) description: 'New IdeaSpace';
		addCommand: (Message selector: #openIdeaSpace) description: 'Open IdeaSpace from Template...';
		addSeparator;
		addCommand: (Message selector: #saveIdeaSpace) description: 'Save IdeaSpace Template';
		addCommand: (Message selector: #saveIdeaSpaceAs) description: 'Save IdeaSpace Template as...';
		addCommand: (Message selector: #revertIdeaSpace) description: 'Revert IdeaSpace to Template';
		addSeparator;
		addCommand: (Message selector: #addToNewIdeaSpace) description: 'Add to New IdeaSpace';
		addCommand: (Message selector: #dragToolToIdeaSpace) description: 'Drag to Existing IdeaSpace';
		addSeparator;
		addCommand: (Message selector: #breakoutCurrentCard) description: 'Breakout Tool to Desktop'.
	^popup!

canUseIdeaSpace
	"Answers true if instances of the receiver can be opened inside an IdeaSpaceShelll
	if one is available. In fact, it does not always make sense for a system tool
	to make use of an idea space. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	^optionFlags allMask: CanUseIdeaSpaceMask
!

canUseIdeaSpace: aBoolean 
	"Set the receiver to create instances inside an available IdeaSpaceShell if appropriate"

	optionFlags := optionFlags mask: CanUseIdeaSpaceMask set: aBoolean!

defaultAdditionalAccelerators
	"Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	^#(#(#inspectIt 'Shift+Ctrl+I'))!

defaultDefaultView
	"The default view to use if no other default view is configured."

	^View defaultView!

defaultExtent
	"Answer a <Point> which is the user's chosen default extent for new instances
	of the receiver, or nil if left up to Windows."

	^defaultExtent!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument.
	If the argument is nil, then let Windows decide."

	defaultExtent := aPoint!

defaultHistoryDwellTime
	"The default period of time, expressed in milliseconds, for which it is necessary to 'visit'
	a class, method, etc, before that visit is recorded in the visit history list."

	^OS.SystemMetrics current mouseHoverTime!

defaultHistoryListSize
	^10!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^SmalltalkSystem current!

defaultSearchFieldFlashes
	^2!

defaultSlideyPinsMap
	"Answer an <IdentityDictionary> which is the user's chosen mapping for the pinned states
	of any contained sliding trays"

	^defaultSlideyPinsMap!

defaultSlideyPinsMap: anIdentityDictionary 
	"Set the default mapping for the state of the sliding trays to be used for instances of the receiver"

	defaultSlideyPinsMap := anIdentityDictionary!

defaultView
	"Answer the resource name of the default view for the receiver.
	This is configurable for tool shells so that the developer can easily replace the
	standard Dolphin views if he or she wishes. For example one can reconfigure 
	to use simple class browser view if using a portable machine with limited screen 
	real estate."

	defaultView isNil ifTrue: [defaultView := self defaultDefaultView].
	^defaultView!

defaultView: aString
	"Set the default view name."

	defaultView := aString!

getAdditionalKeyBindings
	^additionalKeyBindings ifNil: [self setAdditionalAccelerators: self defaultAdditionalAccelerators]!

getCommandQueryHandlers
	^commandQueryHandlers!

historyDwellTime
	"Answer the period of time, expressed in milliseconds, for which it is necessary to 'visit'
	a class, method, etc, before that visit is recorded in the visit history list."

	^HistoryDwellTime ifNil: [self defaultHistoryDwellTime]!

historyDwellTime: anInteger 
	"Set the period of time, expressed in milliseconds, for which it is necessary to 'visit' a
	class, method, etc, before that visit is recorded in the visit history list. If the argument
	is nil, then the dwell time is restored to the default (which is the system mouse hover time)."

	HistoryDwellTime := anInteger!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon.!

initializeAfterLoad
	"Perform any post-load initialisation for the class.
	Superclass method only initializes direct implementors, so we must initialize others."

	self initializeOptionFlags.
	super initializeAfterLoad.!

initializeOptionFlags
	"Private - Set the default option flags."

	optionFlags := 0!

notificationGetImageBlock
	"Private - Answer a monadic valuable used for getting the image for a compiler
	notification status pane."

	^[:object | object iconImageIndex]!

notificationGetTextBlock
	"Private - Answer a monadic valuable used for getting the text for an compiler
	notification status pane."

	^Message selector: #displayString!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect choice: #defaultView from: self resourceNames);
		add: (Aspect name: #defaultExtent);
		add: (Aspect dictionary: #acceleratorKeyBindings) beImmutable;
		add: (Aspect integer: #historyDwellTime);
		add: (Aspect integer: #searchFieldFlashes);
		add: (Aspect boolean: #reuseIfOpen);
		yourself!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	^optionFlags allMask: ReuseIfOpenMask 
!

reuseIfOpen: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	optionFlags := optionFlags mask: ReuseIfOpenMask set: aBoolean!

searchFieldFlashes
	"Answer the number of times the search field will flash when the search command key sequence
	is pressed. This is to draw attention to the search window since it is not a dialog."

	^SearchFieldFlashes ifNil: [self defaultSearchFieldFlashes]!

searchFieldFlashes: anInteger 
	"Set the number of times the search field will flash when the search command key sequence
	is pressed. This is to draw attention to the search window since it is not a dialog."

	SearchFieldFlashes := anInteger!

setAdditionalKeyBindings: anArray
	additionalKeyBindings := anArray!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray!

show
	"Shows an instance of the receiver. If reuseIfOpen has been set to true then an 
	existing instance of the receiver will be shown and answered rather than
	a new instance."

	(self canUseIdeaSpace and: [self activeIdeaSpace notNil])
		ifTrue: [^self show: self inIdeaSpace: self activeIdeaSpace].
	self reuseIfOpen
		ifTrue: [(SmalltalkToolShell showExistingInstanceOf: self) ifNotNil: [:tool | ^tool]].
	^super show!

show: aClass inIdeaSpace: anIdeaSpaceShell 
	aClass reuseIfOpen 
		ifTrue: 
			[| existingInstanceInsideThisIdeaSpace |
			existingInstanceInsideThisIdeaSpace := aClass allInstances 
						detect: [:each | each topShell == anIdeaSpaceShell]
						ifNone: [].
			existingInstanceInsideThisIdeaSpace notNil 
				ifTrue: [^existingInstanceInsideThisIdeaSpace ensureVisible]].
	^anIdeaSpaceShell newEmbeddedCardOfClass: aClass!

showExistingInstanceOf: aClass
	"Private - Show and answer an the existing, open, instance of this tool, if there is one."

	"Force a collection and finalization cycle to clear avoidable zombies (#1936)"

	| allInstances openInstances |
	MemoryManager current
		collectGarbage;
		administerLastRites.
	allInstances := aClass allInstances.
	openInstances := allInstances select: [:e | e isOpen].
	allInstances size > openInstances size
		ifTrue: [(allInstances difference: openInstances) do: [:e | e release]].
	^openInstances size > 0
		ifTrue: 
			[| tool |
			tool := openInstances first.
			tool topShell view
				show;
				zOrderTop.
			tool]!

toolDescription
	"Answer the description of this tool that should be displayed in, for example,
	the system shell window."

	^self displayString!

toolsFolderHelpId
	^nil!

toolsFolderIcon
	"Answer an instance of SmalltalkSystemIcon suitable for representing the
	receiver in the system folder."

	^SmalltalkSystemIcon
		show: self
		description: self toolDescription
		helpId: self toolsFolderHelpId! !
!Tools.SmalltalkToolShell class categoriesFor: #activeIdeaSpace!public! !
!Tools.SmalltalkToolShell class categoriesFor: #buildIdeaSpacePopup!private! !
!Tools.SmalltalkToolShell class categoriesFor: #canUseIdeaSpace!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #canUseIdeaSpace:!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultDefaultView!constants!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultExtent!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultExtent:!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultHistoryDwellTime!constants!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultHistoryListSize!constants!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultModel!models!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultSearchFieldFlashes!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultSlideyPinsMap!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultSlideyPinsMap:!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultView!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #defaultView:!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #getAdditionalKeyBindings!accessing!private! !
!Tools.SmalltalkToolShell class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!Tools.SmalltalkToolShell class categoriesFor: #historyDwellTime!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #historyDwellTime:!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #icon!constants!public! !
!Tools.SmalltalkToolShell class categoriesFor: #initializeAfterLoad!initializing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #initializeOptionFlags!initializing!private! !
!Tools.SmalltalkToolShell class categoriesFor: #notificationGetImageBlock!constants!private! !
!Tools.SmalltalkToolShell class categoriesFor: #notificationGetTextBlock!constants!private! !
!Tools.SmalltalkToolShell class categoriesFor: #publishedAspects!public! !
!Tools.SmalltalkToolShell class categoriesFor: #reuseIfOpen!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #reuseIfOpen:!accessing!public! !
!Tools.SmalltalkToolShell class categoriesFor: #searchFieldFlashes!public! !
!Tools.SmalltalkToolShell class categoriesFor: #searchFieldFlashes:!public! !
!Tools.SmalltalkToolShell class categoriesFor: #setAdditionalKeyBindings:!accessing!private! !
!Tools.SmalltalkToolShell class categoriesFor: #setCommandQueryHandlers:!accessing!private! !
!Tools.SmalltalkToolShell class categoriesFor: #show!instance creation!public! !
!Tools.SmalltalkToolShell class categoriesFor: #show:inIdeaSpace:!private! !
!Tools.SmalltalkToolShell class categoriesFor: #showExistingInstanceOf:!initializing!instance creation!must strip!private! !
!Tools.SmalltalkToolShell class categoriesFor: #toolDescription!constants!public! !
!Tools.SmalltalkToolShell class categoriesFor: #toolsFolderHelpId!public! !
!Tools.SmalltalkToolShell class categoriesFor: #toolsFolderIcon!constants!public! !

Tools.SmalltalkToolShell class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

