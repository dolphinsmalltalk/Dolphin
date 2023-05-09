"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'Tools.SmalltalkToolShell'
	instanceVariableNames: 'searchPresenter fontSizePresenter'
	classVariableNames: 'HistoryDwellTime SearchFieldFlashes'
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: 'optionFlags defaultView defaultExtent defaultSlideyPinsMap additionalKeyBindings'
	classConstants: {
			'CanUseIdeaSpaceMask' -> 16r2.
			'LoadingMask' -> 16r1.
			'ReuseIfOpenMask' -> 16r4.
			'ShowOptionLoadingTimes' -> false
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

addToCommandRoute: aCommandPolicy
	"Update the command routing path of the <CommandPolicy> argument with the receiver's contribution to the command path. "

	super addToCommandRoute: aCommandPolicy.
	"The development system is normally needed at the end of the path to provide the standard development commands needed in most tools. In many cases it will be the receiver's model, and so will have been added already unless the receiver has a different model (e.g. an RBModel)"
	aCommandPolicy appendTarget: self developmentSystem.
	"Answer self to have the command policy decide where to go next - default routing is up to the parent presenter, but there typically isn't one for a shell so the traversal is usually over."
	^self!

applyOptions
	SmalltalkSystem current applyOptionsToTool: self!

browseIt
	"Open a new default browser at the same point as the receiver.
	This is the workspace Browse-It command which is subtly different to the Browse Classes
	command, but for many cases the appropriate action is to open a class browser so we
	wire up to the #browseClasses command by default."

	Object browse!

browseMethodsIn: aBrowserEnvironment
	^(self developmentSystem browseMethodsIn: aBrowserEnvironment)
		model: self model;
		yourself!

browserEnvironment
	^self systemModel browserEnvironment!

buildPopupForCommand: aSymbol 
	aSymbol == #newIdeaSpace ifTrue: [^self class buildIdeaSpacePopup].
	^nil!

canRefactor
	"Private - Answer whether the development tools support refactoring (requires that the Refactoring Engine be
	installed."

	^SmalltalkSystem current canRefactor!

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
				environment: nil
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
		to: self developmentSystem
		withArguments: {nil. self}!

developmentSystem
	^SmalltalkSystem current!

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
		defaultSlideyPinsMap: nil;
		defaultExtent: nil!

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

	<acceleratorKey: 'F1'>
	self developmentSystem openHelpTopicForTool: self!

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

historySkip: anInteger
	"Private - Move around in the history list by the specified <integer> delta (negative for backwards)."

	"Nothing to do by default."!

ideaSpace
	^#{IdeaSpaceShell} valueOrNil
		ifNotNil: [:ideaSpaceShellClass | (self topShell isKindOf: ideaSpaceShellClass) ifTrue: [self topShell]]!

inspectSystemOptions
	"Open a <PropertyInspector> on the system options."

	^(self developmentSystem inspectSystemOptions)
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
	popup queryAllAlong: self commandPolicy recursive: true.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onViewCreated
	self view acceptDroppedFiles: true.
	^super onViewCreated!

onViewOpened
	super onViewOpened.
	fontSizePresenter model: (ValueAspectAdaptor subject: self aspect: #fontSize).
	self class defaultSlideyPinsMap ifNotNil: [:map | self slideyPinMap: map].

	"Enable toolbar pulldowns"
	(self view viewNamed: 'smalltalkTools' ifNone: nil)
		ifNotNil: 
			[:toolbar |
			toolbar presenterConnectionPoint
				when: #dropDown:
				send: #onDropDown:
				to: self].
	self applyOptions!

packageManager
	"Private - Answer the current PackageManager."

	^self developmentSystem packageManager!

performCommand: aCommand
	aCommand commandDescription isAbortable ifFalse: [^super performCommand: aCommand].
	^[super performCommand: aCommand] on: OperationAborted
		do: 
			[:ex |
			self statusModel value: ex.
			nil]!

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
		defaultSlideyPinsMap: self slideyPinMap;
		defaultExtent: self view extent
!

saveStateAspects: aSymbolArray for: aStringName on: aWriteStream
	"Private - Helper method for saving aSymbolArray of aspects of aStringName variable to aWriteStream"

	aSymbolArray do: 
			[:eachSymbol |
			| value |
			'<1d> <2d>: ' expandMacrosWithArguments: {aStringName. eachSymbol} on: aWriteStream.
			value := self perform: eachSymbol.
			value isSelfEvaluating
				ifTrue: [value printOn: aWriteStream]
				ifFalse: [value literalStoreEvaluationOn: aWriteStream]]
		separatedBy: [aWriteStream nextPut: $.]!

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
						argument: (self browserEnvironment messagesMatching: (MethodSearch newSelector: aSymbol))))!

searchSmalltalk
	<acceleratorKey: 'Ctrl+Shift+F'>
	| searchView |
	searchView := searchPresenter view.
	searchView hasFocus ifTrue: [^self].
	searchView
		setFocus;
		flash: self class searchFieldFlashes!

searchSmalltalkFor: anObject 
	anObject searchForInTool: self!

selectionEnvironment
	^BrowserEnvironment new!

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

statusModel
	^[:ex | ex toTrace]!

systemModel
	^self developmentSystem!

workspaceClass
	^SmalltalkSystem current workspaceClass! !
!Tools.SmalltalkToolShell categoriesForMethods!
addToCommandRoute:!commands!public! !
applyOptions!private! !
browseIt!commands!public! !
browseMethodsIn:!operations!public! !
browserEnvironment!accessing!public! !
buildPopupForCommand:!private! !
canRefactor!private!testing! !
canSaveState!private!saved state! !
configureFromSavedStateString:!public! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
developmentSystem!public! !
displayOn:!displaying!public! !
fontSize!public! !
fontSize:!public! !
forgetSize!commands!public! !
getPinStateFor:!accessing!private! !
hasFuture!public!testing! !
hasPast!public!testing! !
help!commands!public! !
historyBack!commands!private! !
historyBack:!commands!private! !
historyForward!commands!private! !
historyForward:!commands!private! !
historySkip:!commands!private! !
ideaSpace!public! !
inspectSystemOptions!commands!public! !
isIdeaSpaceCard!public! !
methodBrowserClass!constants!private! !
onDropDown:!private! !
onViewCreated!event handling!public! !
onViewOpened!private! !
packageManager!constants!private! !
performCommand:!commands!public! !
queryCommand:!commands!private! !
rememberThisSize!commands!public! !
saveStateAspects:for:on:!helpers!private!saved state! !
saveStateOn:!private!saved state! !
saveStateString!private!saved state! !
searchForClass:!private! !
searchForMethod:!private! !
searchForObject:!public! !
searchForPackage:!public! !
searchForSymbol:!private! !
searchSmalltalk!commands!public! !
searchSmalltalkFor:!commands!public! !
selectionEnvironment!public! !
setPinStateFor:to:!accessing!private! !
show!operations!public! !
slideyPinMap!accessing!public! !
slideyPinMap:!accessing!public! !
slideyPinNames!accessing!private! !
statusModel!accessing!private! !
systemModel!accessing!private! !
workspaceClass!constants!private! !
!

!Tools.SmalltalkToolShell class methodsFor!

activeIdeaSpace
	^#{IdeaSpaceShell} ifDefined: 
			[:ideaSpaceShellClass |
			| active |
			active := View active.
			(active notNil and: [active topShell isKindOf: ideaSpaceShellClass]) ifTrue: [active topShell]]!

applyOptions
	"Override point for subclases that wish to update instances"!

buildIdeaSpacePopup
	| popup |
	popup := Menu new.
	popup
		addCommand: (Message selector: #newIdeaSpace) description: 'New IdeaSpace';
		addCommand: (Message selector: #openIdeaSpace) description: 'Open IdeaSpace from Template…';
		addSeparator;
		addCommand: (Message selector: #saveIdeaSpace) description: 'Save IdeaSpace Template';
		addCommand: (Message selector: #saveIdeaSpaceAs) description: 'Save IdeaSpace Template as…';
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

	^self optionFlags allMask: CanUseIdeaSpaceMask!

canUseIdeaSpace: aBoolean 
	"Set the receiver to create instances inside an available IdeaSpaceShell if appropriate"

	self setOptionFlag: CanUseIdeaSpaceMask value: aBoolean!

canUseIdeaSpaceAspect
	^(Aspect boolean: #canUseIdeaSpace)
		defaultValue: true;
		yourself!

defaultAdditionalAccelerators
	"Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	"Ctrl+Shift+I to bring up an alternate inspector is not on the menus. In many tools this is picked up from the annotation associated with the inspectIt command in SmalltalkWorkspace, but not all tools contain a workspace but the inspect command is generally applicable to any selection in a tree or list, etc."

	^#(#(#inspectIt 'Shift+Ctrl+I'))!

defaultDefaultSlideyPinsMap
	^nil!

defaultDefaultView
	"The default view to use if no other default view is configured."

	^View defaultView!

defaultExtent
	"Answer a <Point> which is the user's chosen default extent for new instances
	of the receiver, or nil if left up to Windows."

	self ensureOptionsLoaded.
	^defaultExtent!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument.
	If the argument is nil, then let Windows decide."

	self defaultExtent = aPoint ifTrue: [^self].
	defaultExtent := aPoint.
	self persistOptions!

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

defaultOptionFlags
	^0!

defaultSearchFieldFlashes
	^2!

defaultSlideyPinsMap
	"Private - Answer an <IdentityDictionary> which is the user's chosen mapping for the pinned states of any contained sliding trays, or nil if no preferences."

	self ensureOptionsLoaded.
	^defaultSlideyPinsMap!

defaultSlideyPinsMap: anIdentityDictionary
	"Private - Set the default mapping for the state of the sliding trays to be used for instances of the receiver"

	defaultSlideyPinsMap := anIdentityDictionary
				ifNotNil: [anIdentityDictionary isEmpty ifFalse: [anIdentityDictionary]]!

defaultView
	"Answer the resource name of the default view for the receiver.
	This is configurable for tool shells so that the developer can easily replace the
	standard Dolphin views if he or she wishes. For example one can reconfigure 
	to use simple class browser view if using a portable machine with limited screen 
	real estate."

	self ensureOptionsLoaded.
	^defaultView!

defaultView: aString
	"Set the default view name."

	defaultView = aString ifTrue: [^self].
	defaultView := aString.
	self persistOptions!

ensureOptionsLoaded
	optionFlags ifNil: [self loadOptions]!

finishedLoadingOptions
	optionFlags := optionFlags bitAnd: ##(LoadingMask bitInvert)!

getAdditionalKeyBindings
	self ensureOptionsLoaded.
	^additionalKeyBindings!

historyDwellTime
	"Answer the period of time, expressed in milliseconds, for which it is necessary to 'visit'
	a class, method, etc, before that visit is recorded in the visit history list."

	self ensureOptionsLoaded.
	^HistoryDwellTime!

historyDwellTime: anInteger
	"Set the period of time, expressed in milliseconds, for which it is necessary to 'visit' a
	class, method, etc, before that visit is recorded in the visit history list. If the argument
	is nil, then the dwell time is restored to the default (which is the system mouse hover time)."

	anInteger = self historyDwellTime ifTrue: [^self].
	HistoryDwellTime := anInteger.
	self persistOptions!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon.!

invalidateLocalOptions
	optionFlags := nil!

invalidateOptions
	SmalltalkWorkspace invalidateOptions.
	self allSubclassesDo: [:each | each invalidateLocalOptions].
	SmalltalkWorkspaceDocument invalidateOptions!

isLoadingOptions
	^self optionFlags allMask: LoadingMask!

loadOptions
	self loadOptionsFor: self.
	self applyOptions!

loadOptionsFor: aClass
	| start stop aspects |
	ShowOptionLoadingTimes
		ifTrue: 
			[Transcript
				nextPutAll: 'Loading options for ';
				print: aClass.
			start := Time microsecondClockValue].
	aClass startLoadingOptions.
	aspects := aClass optionsAspects.
	
	[| regkey options |
	regkey := self userSettingsRootKey.
	options := regkey objectAt: aClass name ifAbsent: nil.
	regkey free.
	options
		ifNotNil: 
			[options keysAndValuesDo: 
					[:eachKey :eachValue |
					(aspects removeKey: eachKey ifAbsent: nil)
						ifNotNil: [:aspect | aspect writeInto: aClass value: eachValue]]]]
			on: Error
			do: 
				[:ex |
				Transcript
					cr;
					nextPutAll: 'Error loading options for ';
					print: aClass;
					nextPutAll: ': ';
					print: ex;
					cr].
	"Set any default values that were not read from the settings in the registry."
	aspects do: [:each | each writeInto: aClass value: each defaultValue value].
	aClass finishedLoadingOptions.
	ShowOptionLoadingTimes
		ifTrue: 
			[stop := Time microsecondClockValue.
			Transcript
				nextPutAll: ' completed in ';
				display: (stop - start) microseconds;
				cr]!

notificationGetImageBlock
	"Private - Answer a monadic valuable used for getting the image for a compiler
	notification status pane."

	^[:object | object iconImageIndex]!

notificationGetTextBlock
	"Private - Answer a monadic valuable used for getting the text for an compiler
	notification status pane."

	^Message selector: #displayString!

optionFlags
	self ensureOptionsLoaded.
	^optionFlags!

optionsAspects
	^self publishedAspects
		removeKey: #yourself;
		add: ((Aspect dictionary: #defaultSlideyPinsMap)
					defaultValue: self defaultDefaultSlideyPinsMap;
					yourself);
		yourself!

persistOptions
	^self persistOptionsFor: self
!

persistOptionsFor: aClass
	| regkey options |
	(aClass isNonInstantiable or: [aClass isLoadingOptions]) ifTrue: [^false].
	options := IdentityDictionary new.
	aClass optionsAspects do: 
			[:each |
			| aspectValue |
			aspectValue := each readFrom: aClass.
			aspectValue = each defaultValue value ifFalse: [options at: each key put: aspectValue]].
	regkey := SmalltalkToolShell userSettingsRootKey.
	OS.RegistrySerializer
		write: options
		to: regkey
		name: aClass name.
	regkey free.
	^true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: ((Aspect
					choice: #defaultView
					from: [self resourceNames]
					type: String)
					icon: UI.ResourceIdentifier icon;
					defaultValue: self defaultDefaultView;
					yourself);
		add: (Aspect extent: #defaultExtent);
		add: ((Aspect dictionary: #acceleratorKeyBindings)
					beImmutable;
					defaultValue: [self defaultAcceleratorKeyBindings];
					yourself);
		add: ((Aspect integer: #historyDwellTime)
					defaultValue: self defaultHistoryDwellTime;
					yourself);
		add: ((Aspect integer: #searchFieldFlashes)
					defaultValue: self defaultSearchFieldFlashes;
					yourself);
		add: (Aspect boolean: #reuseIfOpen);
		yourself!

reuseIfOpen
	"Answers true if an already open instance of the receiver should be reused instead of
	creating additional instances. In fact, it does not always make sense for a system tool
	to allow re-use. Therefore, although all tools support this functionality, only some
	expose it as a published aspect so that it may be set as a system option."

	^self optionFlags allMask: ReuseIfOpenMask!

reuseIfOpen: aBoolean
	"Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	self setOptionFlag: ReuseIfOpenMask value: aBoolean!

searchFieldFlashes
	"Answer the number of times the search field will flash when the search command key sequence
	is pressed. This is to draw attention to the search window since it is not a dialog."

	self ensureOptionsLoaded.
	^SearchFieldFlashes!

searchFieldFlashes: anInteger 
	"Set the number of times the search field will flash when the search command key sequence
	is pressed. This is to draw attention to the search window since it is not a dialog."

	SearchFieldFlashes = anInteger ifTrue: [^self].
	SearchFieldFlashes := anInteger.
	self persistOptions!

setAdditionalKeyBindings: anArray
	additionalKeyBindings = anArray ifTrue: [^self].
	additionalKeyBindings := anArray.
	self persistOptions!

setOptionFlag: anInteger value: aBoolean
	"Private - Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	(self optionFlags allMask: anInteger) == aBoolean ifTrue: [^false].
	optionFlags := optionFlags mask: anInteger set: aBoolean.
	self persistOptions.
	^true!

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
						ifNone: nil.
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
	allInstances := aClass primAllInstances.
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

startLoadingOptions
	optionFlags := LoadingMask!

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
		helpId: self toolsFolderHelpId!

userSettingsKey
	^OS.RegKey userRoot createKey: self userSettingsKeyName!

userSettingsKeyName
	^SessionManager.Current productRegistryKey , '\' , self name!

userSettingsRootKey
	^OS.RegKey userRoot createKey: SessionManager.Current productRegistryKey! !
!Tools.SmalltalkToolShell class categoriesForMethods!
activeIdeaSpace!public! !
applyOptions!accessing!options!private! !
buildIdeaSpacePopup!private! !
canUseIdeaSpace!options!public! !
canUseIdeaSpace:!options!public! !
canUseIdeaSpaceAspect!private! !
defaultAdditionalAccelerators!constants!private! !
defaultDefaultSlideyPinsMap!constants!options!private! !
defaultDefaultView!constants!public! !
defaultExtent!options!public! !
defaultExtent:!options!public! !
defaultHistoryDwellTime!constants!public! !
defaultHistoryListSize!constants!public! !
defaultModel!models!public! !
defaultOptionFlags!constants!options!private! !
defaultSearchFieldFlashes!constants!options!public! !
defaultSlideyPinsMap!options!private! !
defaultSlideyPinsMap:!options!private! !
defaultView!options!public! !
defaultView:!options!public! !
ensureOptionsLoaded!options!private! !
finishedLoadingOptions!options!private! !
getAdditionalKeyBindings!options!private! !
historyDwellTime!options!public! !
historyDwellTime:!options!public! !
icon!constants!public! !
invalidateLocalOptions!options!private! !
invalidateOptions!options!private! !
isLoadingOptions!private! !
loadOptions!options!private! !
loadOptionsFor:!options!private! !
notificationGetImageBlock!constants!private! !
notificationGetTextBlock!constants!private! !
optionFlags!options!private! !
optionsAspects!public! !
persistOptions!options!private! !
persistOptionsFor:!private! !
publishedAspects!options!public! !
reuseIfOpen!options!public! !
reuseIfOpen:!options!public! !
searchFieldFlashes!options!public! !
searchFieldFlashes:!options!public! !
setAdditionalKeyBindings:!options!private! !
setOptionFlag:value:!options!private! !
show!instance creation!public! !
show:inIdeaSpace:!private! !
showExistingInstanceOf:!initializing!instance creation!must strip!private! !
startLoadingOptions!options!private! !
toolDescription!constants!public! !
toolsFolderHelpId!constants!public! !
toolsFolderIcon!constants!public! !
userSettingsKey!options!public! !
userSettingsKeyName!constants!options!public! !
userSettingsRootKey!options!public! !
!

Tools.SmalltalkToolShell class methodProtocol: #installableSystemTool attributes: #(#readOnly) selectors: #(#registerAsToolWith: #unregisterAsToolWith:)!

