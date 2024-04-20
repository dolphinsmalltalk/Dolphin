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

accept
	"Save the source on the currently displayed source card."

	<commandQuery: #queryAcceptIt:>
	self perform: self acceptItCommand!

acceptItCommand
	"Private - Answer the <Symbol> of the contextual command to save changes to something, depending on the subview with focus and/or selection."

	^nil!

addToCommandRoute: aCommandPolicy
	"Update the command routing path of the <CommandPolicy> argument with the receiver's contribution to the command path. "

	super addToCommandRoute: aCommandPolicy.
	"The development system is normally needed at the end of the path to provide the standard development commands needed in most tools. In many cases it will be the receiver's model, and so will have been added already unless the receiver has a different model (e.g. an RBModel)"
	aCommandPolicy appendTarget: self developmentSystem.
	"Answer self to have the command policy decide where to go next - default routing is up to the parent presenter, but there typically isn't one for a shell so the traversal is usually over."
	^self!

applyOptions
	SmalltalkSystem current applyOptionsToTool: self!

browseClassHierarchy
	"Open a new hierarchy browser at the root of the standard class hierarchy."

	^self developmentSystem browseHierarchy: Object!

browseDefinitions
	"Context-sensitive browse definitions command (F12)."

	<commandQuery: #queryBrowseDefinitions:>
	<acceleratorKey: 'F12'>
	self perform: self browseDefinitionsCommand!

browseDefinitionsCommand
	"Answer the <Symbol> of the contextual command to browse definitions of something, depending on the subview with focus and/or selection."

	^nil!

browseHierarchyCommand
	"Answer the <Symbol> of the contextual command to browse the class hierarchy of something, depending on the subview with focus and/or selection."

	^#browseClassHierarchy!

browseIt
	"Open a browser on the selected item in the window with focus."

	<commandQuery: #queryBrowseIt:>
	self perform: self browseItCommand!

browseItCommand
	"Answer the <Symbol> of the contextual command to browse something, depending on the subview with focus and/or selection."

	^#browseClass!

browseMethodsIn: aBrowserEnvironment
	^(self developmentSystem browseMethodsIn: aBrowserEnvironment)
		model: self model;
		yourself!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment
	^(self developmentSystem browseMethodsInEnvironments: aCollectionOfBrowserEnvironment)
		model: self model;
		yourself!

browseReferences
	"Context-sensitive browse references command (Shift+F12)."

	<commandQuery: #queryBrowseReferences:>
	<acceleratorKey: 'Shift+F12'>
	self perform: self browseReferencesCommand!

browseReferencesCommand
	"Answer the <Symbol> of the contextual command to browse references to something, depending on the subview with focus and/or selection."

	^nil!

browserEnvironment
	^self systemModel browserEnvironment!

browseTests
	"Open a new SUnit browser on all test."

	^self developmentSystem testBrowserClass show!

buildHistoryFutureMenu: aMenu
	aMenu
		clear;
		text: '&Forward'!

buildHistoryPastMenu: aMenu
	aMenu
		clear;
		text: '&Back'!

canRefactor
	"Private - Answer whether the development tools support refactoring (requires that the Refactoring Engine be
	installed."

	^SmalltalkSystem current canRefactor!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^false!

changeManager
	^self developmentSystem changeManager!

clearChangeHistory
	"Discard system change history (i.e. undo/redo list)."

	<commandQuery: #queryClearChangeHistory:>
	(MessageBox new
		headline: 'Clear change history?';
		confirm: 'Are you sure you want to clear the change history (undo/redo for past changes will be lost)?')
			ifTrue: [self developmentSystem nukeChangeHistory]!

clearSelection
	"Private - Remove the selected object from the system"

	<commandQuery: #queryDeleteIt:>
	self perform: self deleteItCommand!

configureFromSavedStateString: aSavedStateString
	"Configures the receiver using the monadic block source in aSavedStateString"

	| expr |
	expr := Compiler compileExpression: aSavedStateString in: nil.
	self view noRedrawDo: [(expr value: nil) value: self]!

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

deleteItCommand
	"Answer the <Symbol> of the contextual command to delete something, depending on the subview with focus and/or selection."

	^nil!

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

	<commandQuery: #hasRememberedSize>
	self class
		defaultSlideyPinsMap: nil;
		defaultExtent: nil!

futureSize
	"Answer the number of visits in the history which were made after the
	current one."

	^0!

getPinStateFor: aSlideyInneyOuteyThingName 
	"Private - Attempts to find a named SlideyInneyOuteyThing within the view hierarchy of the receiver.
	Answers true if the slidey is pinned, false otherwise. If no such slidy is found answers nil"

	^(self view viewNamed: aSlideyInneyOuteyThingName ifNone: [^nil]) isPinned!

hasFuture
	"Answer whether there is any future history to visit."

	^self futureSize > 0!

hasPast
	"Answer whether there is any past history to visit."

	^self pastSize > 0!

hasRedoableOperations
	^self changeManager hasRedoableOperations!

hasRememberedSize
	^self class defaultExtent notNil!

hasUndoableOperations
	^self changeManager hasUndoableOperations!

help
	"Bring up a help page for this tool."

	<acceleratorKey: 'F1'>
	self developmentSystem openHelpTopicForTool: self!

historyBack
	"Private - Return to the previously visited method."

	<menuPopulator: #buildHistoryPastMenu:>
	<commandQuery: #queryHistoryBack:>
	self historyBack: 1!

historyBack: delta
	"Private - Return to a previously visited method <integer>, delta, visits
	in the past.."

	<commandQuery: #queryHistoryRewind:>
	self historySkip: delta negated!

historyForward
	"Private - Return to the previously visited class which has been
	moved back over by a jump back in time."

	<menuPopulator: #buildHistoryFutureMenu:>
	<commandQuery: #queryHistoryForward:>
	self historyForward: 1!

historyForward: delta
	"Private - Return to the previously visited class which has been
	moved back over by a jump back in time."

	<commandQuery: #queryHistoryFastForward:>
	self historySkip: delta!

historySkip: anInteger
	"Private - Move around in the history list by the specified <integer> delta (negative for backwards)."

	"Nothing to do by default."!

ideaSpace
	^#{IdeaSpaceShell} valueOrNil
		ifNotNil: [:ideaSpaceShellClass | (self topShell isKindOf: ideaSpaceShellClass) ifTrue: [self topShell]]!

inspectIt
	"Open a browser on the selected category/protocol/variables.
	Note that we only receive this command it one of the filter panes is selected
	as class hierarchy, method browser, and workspace presenters all handle
	it themselves."

	"VW compatibility"

	<acceleratorKey: 'Ctrl+I'>
	<acceleratorKey: 'Ctrl+Q'>
	<commandQuery: #queryInspectIt:>
	self perform: self inspectItCommand!

inspectItCommand
	"Answer the <Symbol> of the contextual command to inspect something, depending on the subview with focus and/or selection."

	^nil!

inspectSystemOptions
	"Open a <PropertyInspector> on the system options."

	^(self developmentSystem inspectSystemOptions)
		selectionOrNil: self class;
		yourself!

isIdeaSpaceCard
	^self ideaSpace notNil!

methodBrowserClass
	^MethodBrowser!

onViewAvailable
	super onViewAvailable.
	self applyOptions!

onViewClosed
	"Private - Sent by the receiver's view when it has been closed.
	Disconnect from any events triggered by the devlopment system"

	super onViewClosed.
	self release
!

onViewOpened
	super onViewOpened.
	fontSizePresenter model: (ValueAspectAdaptor subject: self aspect: #fontSize).
	self class defaultSlideyPinsMap ifNotNil: [:map | self slideyPinMap: map]!

onViewStateRestored
	super onViewStateRestored.
	self view acceptDroppedFiles: true.
	self applyOptions!

packageManager
	"Private - Answer the current PackageManager."

	^self developmentSystem packageManager!

pastSize
	"Answer the number of visits in the history which were made before the current one."

	^0!

performCommand: aCommand
	aCommand commandDescription isAbortable ifFalse: [^super performCommand: aCommand].
	^[super performCommand: aCommand] on: OperationAborted
		do: 
			[:ex |
			self statusModel value: ex.
			nil]!

queryAcceptIt: aCommandQuery
	self acceptItCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseDefinitions: aCommandQuery
	"Browse Definitions (F12) is a context-sensitive command. We open a browser appropriate to the selected node, or let some other presenter handle if if the selected node is not browsable.
	As the command's menu text typically has an insertion to specify what will be browsed, we ensure it is reset, otherwise it might end up displaying whatever was last browsable."

	self browseDefinitionsCommand
		ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseHierarchy: aCommandQuery
	self browseHierarchyCommand
		ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseIt: aCommandQuery
	self browseItCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseReferences: aCommandQuery
	"Browse References (Shift+F12) is a context-sensitive command. We open a browser appropriate to the selected node, or let some other presenter handle if if the selected node is not browsable for references.
	As the command's menu text typically has an insertion to specify what will be browsed, we ensure it is reset, otherwise it might end up displaying whatever was last browsable."

	self browseReferencesCommand
		ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseTests: aCommandQuery
	aCommandQuery isEnabled: self developmentSystem testBrowserClass notNil!

queryClearChangeHistory: aCommandQuery
	aCommandQuery isEnabled: (self hasUndoableOperations or: [self hasRedoableOperations])!

queryDeleteIt: aCommandQuery
	self deleteItCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryHistoryBack: aCommandQuery
	aCommandQuery isEnabled: self hasPast!

queryHistoryFastForward: aCommandQuery
	aCommandQuery isEnabled: self futureSize >= aCommandQuery command arguments first!

queryHistoryForward: aCommandQuery
	aCommandQuery isEnabled: self hasFuture!

queryHistoryRewind: aCommandQuery
	aCommandQuery isEnabled: self pastSize >= aCommandQuery command arguments first!

queryInspectIt: aCommandQuery
	self inspectItCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryRedoChange: aCommandQuery
	| description |
	self hasRedoableOperations
		ifTrue: 
			[description := self changeManager redoChange.
			aCommandQuery beEnabled]
		ifFalse: 
			[description := 'Change'.
			aCommandQuery beDisabled].
	aCommandQuery expandMenuTextWith: description!

queryUndoChange: aCommandQuery
	| description |
	self hasUndoableOperations
		ifTrue: 
			[description := self changeManager undoChange.
			aCommandQuery beEnabled]
		ifFalse: 
			[description := 'Change'.
			aCommandQuery beDisabled].
	aCommandQuery expandMenuTextWith: description!

redoChange
	"Redo the last change in the undo history list."

	<commandQuery: #queryRedoChange:>
	self changeManager redoOperation!

refactoringsMenu
	"Enable the Refactorings menu when the Refactoring Browser support is loaded"!

release
	"Remove references to objects that may refer back to the receiver. "

	super release.
	self model removeEventsTriggeredFor: self!

rememberThisSize
	"Record the size of the receiver as the default extent for its tool class."

	self class
		defaultSlideyPinsMap: self slideyPinMap;
		defaultExtent: self view designExtent
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
						argument: ((MethodSearch newSelector: aSymbol) matchesIn: self browserEnvironment)))!

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

	self class defaultExtent ifNotNil: [:ext | self view designExtent: ext].
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

undoChange
	"Undo the last change in the undo history list."

	<commandQuery: #queryUndoChange:>
	self changeManager undoOperation!

workspaceClass
	^SmalltalkSystem current workspaceClass! !

!Tools.SmalltalkToolShell categoriesForMethods!
accept!commands-actions!public! !
acceptItCommand!commands-mappings!private! !
addToCommandRoute:!commands-routing!public! !
applyOptions!private! !
browseClassHierarchy!public! !
browseDefinitions!commands-actions!public! !
browseDefinitionsCommand!commands-mappings!private! !
browseHierarchyCommand!commands-mappings!private! !
browseIt!commands-actions!public! !
browseItCommand!commands-mappings!private! !
browseMethodsIn:!operations!public! !
browseMethodsInEnvironments:!browsing!public! !
browseReferences!commands-actions!public! !
browseReferencesCommand!commands-mappings!private! !
browserEnvironment!accessing!public! !
browseTests!public! !
buildHistoryFutureMenu:!commands-menus!private! !
buildHistoryPastMenu:!commands-menus!private! !
canRefactor!private!testing! !
canSaveState!private!saved state! !
changeManager!accessing!public! !
clearChangeHistory!public!refactoring! !
clearSelection!commands-actions!private! !
configureFromSavedStateString:!public! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
deleteItCommand!commands-mappings!private! !
developmentSystem!public! !
displayOn:!displaying!public! !
fontSize!public! !
fontSize:!public! !
forgetSize!commands-actions!public! !
futureSize!accessing!public! !
getPinStateFor:!accessing!private! !
hasFuture!public!testing! !
hasPast!public!testing! !
hasRedoableOperations!public!testing! !
hasRememberedSize!private!testing! !
hasUndoableOperations!public!testing! !
help!commands-actions!public! !
historyBack!commands-actions!private! !
historyBack:!commands-actions!private! !
historyForward!commands-actions!private! !
historyForward:!commands-actions!private! !
historySkip:!commands-actions!private! !
ideaSpace!public! !
inspectIt!commands-actions!public! !
inspectItCommand!commands-mappings!private! !
inspectSystemOptions!commands-actions!public! !
isIdeaSpaceCard!public! !
methodBrowserClass!constants!private! !
onViewAvailable!event handling!public! !
onViewClosed!event handling!private! !
onViewOpened!private! !
onViewStateRestored!event handling!public! !
packageManager!constants!private! !
pastSize!accessing!public! !
performCommand:!commands-routing!public! !
queryAcceptIt:!commands-queries!private! !
queryBrowseDefinitions:!commands-queries!private! !
queryBrowseHierarchy:!commands-queries!private! !
queryBrowseIt:!commands-queries!private! !
queryBrowseReferences:!commands-queries!private! !
queryBrowseTests:!private! !
queryClearChangeHistory:!commands-queries!private! !
queryDeleteIt:!commands-queries!private! !
queryHistoryBack:!commands-queries!private! !
queryHistoryFastForward:!commands-queries!private! !
queryHistoryForward:!commands-queries!private! !
queryHistoryRewind:!commands-queries!private! !
queryInspectIt:!commands-queries!private! !
queryRedoChange:!commands-queries!private! !
queryUndoChange:!commands-queries!private! !
redoChange!commands-actions!public! !
refactoringsMenu!public! !
release!dependency!public! !
rememberThisSize!commands-actions!public! !
saveStateAspects:for:on:!helpers!private!saved state! !
saveStateOn:!private!saved state! !
saveStateString!private!saved state! !
searchForClass:!private! !
searchForMethod:!private! !
searchForObject:!public! !
searchForPackage:!public! !
searchForSymbol:!private! !
searchSmalltalk!commands-actions!public! !
searchSmalltalkFor:!commands-actions!public! !
selectionEnvironment!public! !
setPinStateFor:to:!accessing!private! !
show!operations!public! !
slideyPinMap!accessing!public! !
slideyPinMap:!accessing!public! !
slideyPinNames!accessing!private! !
statusModel!accessing!private! !
systemModel!accessing!private! !
undoChange!commands-actions!public! !
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
	"Answer a <Point> which is the user's chosen default extent for new instances of the receiver, or nil if left up to Windows.
	Note that the answer assumes a resolution of 96 DPI, so needs to be scaled to the target monitor."

	self ensureOptionsLoaded.
	^defaultExtent!

defaultExtent: aPoint
	"Set the default extent to be used for instances of the receiver to the <Point> argument, which is expected to specify the normalized (i.e. at 96 DPI) pixel extent to use.
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
	SmalltalkWorkspaceDocument invalidateOptions.
	SmalltalkSearchPresenter invalidateOptions!

isLoadingOptions
	^self optionFlags allMask: LoadingMask!

loadOptions
	self loadOptionsFor: self!

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
		add: (Aspect point: #defaultExtent);
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
	^self persistOptions!

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

