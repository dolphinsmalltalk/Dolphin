"Filed out from Dolphin Smalltalk"!

IdbToolShell subclass: #ProfileBrowser
	instanceVariableNames: 'filterPercentSymbol filterDolphin filterSelector'
	classVariableNames: 'ShowCounts'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfileBrowser guid: (GUID fromString: '{425d0ebb-542e-11d3-998b-d5ca2c3c1d61}')!

ProfileBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfileBrowser categoriesForClass!IDB Goodies! !

!ProfileBrowser methodsFor!

browseClass
	<commandQuery: #queryBrowseClass:>
	self currentCard presenterConnectionPoint presenter selectionOrNil browse!

browseItCommand
	"Answer the <Symbol> of the contextual command to browse something, depending on the subview with focus and/or selection."

	^self isShowingSampleSets ifFalse: [#browseClass]!

cardsPresenter	
	^self presenterNamed: 'cards'!

classesPresenter
	^self presenterNamed: 'classes'!

clearSampleSetSelection
	"One of the sample sets has been changed in some way. Set the selection to nil and
	use a dummy model to refresh all the tabs"

	self refreshTabsFor: (ProfilerSampleSet name: 'None').
	self sampleSetsPresenter selectionOrNil: nil.
	self resetSelectorFilter.
	self caption: 'Profiler Browser'!

createComponents
	"Create the presenters for the sub views in the shell"

	super createComponents.
	self
		add: ListPresenter new name: 'sampleSets';
		add: ProfilerSamplesPresenter new name: 'samples';
		add: ProfilerClassListPresenter new name: 'classes';
		add: ProfilerSelectorListPresenter new name: 'selectors';
		add: ProfilerTallyTreePresenter new name: 'tally';
		add: ProfilerTimeTreePresenter new name: 'time';
		add: NumberPresenter new name: 'progressBar';
		add: Presenter new name: 'cards'.!

createSchematicWiring
	"Create the trigger wiring for the receiver and link up
	to the sample sets model (a ListModel)"

	super createSchematicWiring.
	self sampleSetsPresenter
		when: #selectionChanged
		send: #onSampleSetSelectionChanged
		to: self.
	self selectorsPresenter
		when: #onSelectionChanged
			send: #onSelectorSelectionChanged
			to: self;
		when: #actionPerformed
			send: #browseIt
			to: self.
	self classesPresenter
		when: #actionPerformed
			send: #browseIt
			to: self.
	self samplesPresenter
		when: #actionPerformed
			send: #browseIt
			to: self.
	self sampleSetsPresenter model: ProfilerSampleSetManager default sampleSets.
	self sampleSetsPresenter model
		when: #item:updatedAtIndex:
			send: #onSampleSetUpdated:atIndex:
			to: self;
		when: #item:removedAtIndex:
			send: #onSampleSetUpdated:atIndex:
			to: self!

currentCard
	^self cardsPresenter view currentCard!

deleteAllSampleSets
	"Delete all the sample sets"

	<commandQuery: #queryDeleteAllSampleSets:>
	ProfilerSampleSetManager default removeAll!

deleteSampleSet
	"Delete the currently selected sample set"

	<commandQuery: #isSampleSetSelected>
	ProfilerSampleSetManager default removeSampleSetNamed: self sampleSetsPresenter selection name!

filterDolphinXXX
	"Toggle the filter for displaying the Dolphin package classes and tell the tabs"

	"Temporarily removed until I decide what to do with it"

	<commandQuery: #queryFilterDolphin:>
	filterDolphin := filterDolphin not.
	#('classes' 'selectors' 'tally' 'time')
		do: [:each | (self presenterNamed: each) filterDolphin: filterDolphin]!

filterPercentage: aFloat symbol: aSymbol
	"Tell the tree presenters the mimimum percentage value for items to be displayed
	and remember the current command (aSymbol)"

	<commandQuery: #queryFilterPercentage:>
	filterPercentSymbol == aSymbol
		ifFalse: 
			[filterPercentSymbol := aSymbol.
			#('classes' 'selectors' 'tally' 'time')
				do: [:each | (self presenterNamed: each) filterPercentage: aFloat]]!

filterSelector
	"Tell the tabs to filter out samples or tree branches that do not include the currently 
	selected method (if there is one)"

	<commandQuery: #queryFilterSelector:>
	filterSelector := filterSelector not.
	self onSelectorSelectionChanged!

idbAbout
	"Display the about view"

	self 
		idbAbout: '
Profiler
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

isSampleSetSelected
	"Answer true if there is a sample set selected in the list"

	^self sampleSetsPresenter selectionOrNil notNil!

isShowingSampleSets
	^self currentCard name = 'sampleSets'!

onSampleSetSelectionChanged
	"The sample set selection has been changed so refresh all the other cards"

	| sampleSet |
	sampleSet := self sampleSetsPresenter selectionOrNil.
	sampleSet
		ifNil: 
			[self clearSampleSetSelection.
			^self].
	sampleSet
		when: #updateIndicator:of:
		send: #onUpdateIndicator:of:
		to: self.
	Cursor wait showWhile: 
			[| progressBar range |
			progressBar := self progressBar.
			progressBar value: 0.
			range := 1 to: ((sampleSet samplesSize max: 1) min: self updateIndicatorLimit).
			range size > 1 ifTrue: [progressBar view range: range].
			self refreshTabsFor: sampleSet.
			
			[200 milliseconds wait.
			[self progressBar hide] postToInputQueue] fork].
	sampleSet removeEventsTriggeredFor: self.
	self resetSelectorFilter.
	self caption: 'Profiler Browser - ' , sampleSet name!

onSampleSetUpdated: aSampleSet atIndex: anInteger 
	"This is the target for a triggered event that says that one of the current sample sets
	has been changed in some way. We just update the complete sample set list."

	self refreshSampleSets!

onSelectorSelectionChanged
	"The method selected in the selector tab list has changed. Depending on the
	whether filetering is active and a method is selected we send nil or a compiledcode"

	| selection |
	selection := (filterSelector and: [self selectorsPresenter hasSelection])
				ifTrue: [self selectorsPresenter selectionOrNil object].
	#('samples' 'tally' 'time') do: [:each | (self presenterNamed: each) filterSelector: selection]!

onUpdateIndicator: anInteger of: maximumInteger
	"The sample set is being scanned and has asked, via a trigger, for the visual display 
	showing its progress to be updated. Fiddle a bit as the maximum vale for the display
	is 65536 so we must start scaling if we will go above that"

	| position |
	position := maximumInteger > self updateIndicatorLimit
				ifTrue: [(self updateIndicatorLimit * (anInteger / maximumInteger)) truncated]
				ifFalse: [anInteger].
	self progressBar
		show;
		value: position!

onViewOpened
	"Initialize the sub presenters and views"

	super onViewOpened.
	filterDolphin := false.
	filterSelector := false.
	filterPercentSymbol := #filter0.
	self caption: 'Profiler Browser'.
	self progressBar hide!

progressBar
	^self presenterNamed: 'progressBar'!

queryBrowseClass: aCommandQuery
	| selection |
	selection := self currentCard presenterConnectionPoint presenter selectionOrNil.
	selection ifNil: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: selection browseableObject!

queryDeleteAllSampleSets: aCommandQuery
	aCommandQuery isEnabled: ProfilerSampleSetManager default sampleSets notEmpty!

queryFilterDolphin: aCommandQuery
	"Temporarily disabled until I decide what to do with it"
	aCommandQuery
		"beEnabled;"
		isChecked: filterDolphin!

queryFilterPercentage: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: filterPercentSymbol == aCommandQuery command arguments last!

queryFilterSelector: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: filterSelector!

refreshSampleSets
	"Refresh the sample sets list. This can be useful if you want to set all the
	tabs back to their default values - It leaves no sample set selected"

	self clearSampleSetSelection!

refreshTabsFor: aSampleSet 
	"A new sample set has been selected so set all the tabs to reflect its contents. aSampleSet may
	be the dummy (named 'None') if we just want to cleaer all the tabs"

	#('samples' 'classes' 'selectors' 'tally' 'time') 
		do: [:each | (self presenterNamed: each) model: aSampleSet]!

report
	"Generate a text report for the selected sample set and open a SmalltalkWorkspaceDocument on it"

	<commandQuery: #isSampleSetSelected>
	| stream document |
	stream := String writeStream.
	self sampleSetsPresenter selection reportTo: stream.
	self classesPresenter reportTo: stream.
	self selectorsPresenter reportTo: stream.
	document := SmalltalkWorkspaceDocument show.
	document workspace view font: (Font name: 'Courier').
	document setDocumentData: stream contents!

resetSelectorFilter
	"For some reason, probably the sample set has been updated/changed we need to make sure
	the selector filter is inacive. It it is currently active, turn it off"

	filterSelector 
		ifTrue: 
			[filterSelector := false.
			#('samples' 'tally' 'time') do: [:each | (self presenterNamed: each) filterSelector: nil]]!

sampleSetsPresenter
	^self presenterNamed: 'sampleSets'!

samplesPresenter
	^self presenterNamed: 'samples'!

selectorsPresenter
	^self presenterNamed: 'selectors'!

startProfiler
	"If the profiler dialog is correctly completed and dismissed with OK then profile
	the block that was entered with the requested parameters"

	ProfilerSetupDialog showModal isNil ifTrue: [^self].
	Profiler
		samplingInterval: ProfilerSetupDialog interval milliseconds;
		profile: ProfilerSetupDialog profiledBlock
			inSetNamed: ProfilerSetupDialog sampleSetName
			collect: ProfilerSetupDialog isCollect
			on: ProfilerSetupDialog isOn!

updateIndicatorLimit
	"Answer the limit for the indicator, above which we have to satrt 
	scaling (see #onUpdateIndicator:of:"

	^65000! !

!ProfileBrowser categoriesForMethods!
browseClass!commands-actions!public! !
browseItCommand!commands-mappings!private! !
cardsPresenter!accessing!private! !
classesPresenter!accessing!private! !
clearSampleSetSelection!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
currentCard!accessing!private! !
deleteAllSampleSets!commands!commands-actions!public! !
deleteSampleSet!commands!commands-actions!public! !
filterDolphinXXX!commands!commands-actions!public! !
filterPercentage:symbol:!helpers!private! !
filterSelector!commands!commands-actions!public! !
idbAbout!commands!commands-actions!public! !
isSampleSetSelected!public!testing! !
isShowingSampleSets!commands-actions!commands-queries!private! !
onSampleSetSelectionChanged!event handling!public! !
onSampleSetUpdated:atIndex:!event handling!public! !
onSelectorSelectionChanged!event handling!public! !
onUpdateIndicator:of:!event handling!public! !
onViewOpened!event handling!public! !
progressBar!accessing!private! !
queryBrowseClass:!commands!commands-actions!commands-queries!private! !
queryDeleteAllSampleSets:!commands-queries!private! !
queryFilterDolphin:!commands!commands-actions!commands-queries!private! !
queryFilterPercentage:!commands!commands-queries!private! !
queryFilterSelector:!commands!commands-queries!private! !
refreshSampleSets!commands!commands-actions!public! !
refreshTabsFor:!helpers!private! !
report!commands!commands-actions!public! !
resetSelectorFilter!helpers!private! !
sampleSetsPresenter!accessing!private! !
samplesPresenter!accessing!private! !
selectorsPresenter!accessing!private! !
startProfiler!commands!commands-actions!public! !
updateIndicatorLimit!constants!public! !
!

!ProfileBrowser class methodsFor!

defaultShowCounts
	^false!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Profile Browser'!

icon
	^Profiler icon!

publishedAspects
	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	^aspects
		add: ((Aspect boolean: #showCounts)
					defaultValue: [self defaultShowCounts];
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Smalltalk.Color) #face3d 918022 ##(Smalltalk.Point) 1201 801 551 nil nil nil 416 984838 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.Status) 34 21 nil 416 34 2 8 1140850956 1 560 nil 466 #default nil 7 nil 852998 ##(Smalltalk.Font) nil true 655622 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 4 0 144 39 0 0 0 0 199 0 253 85 63 1] 498 193 193 nil 560 nil 8 1806706432 170 192 34 2 410 ##(Smalltalk.ProgressBar) 34 15 nil 560 34 2 8 1140850688 1 784 918598 2 ##(Smalltalk.ValueHolder) nil nil 1572870 ##(Smalltalk.NeverSearchPolicy) 1 624 nil 7 nil nil nil 784 nil 8 1806693776 1049094 ##(Smalltalk.NullConverter) nil nil 1310982 ##(Smalltalk.MessageSequence) 34 2 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 9 7 498 221 31 784 1010 #range: 34 1 852742 ##(Smalltalk.Interval) 1 201 3 784 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 3 0 0 0 114 0 0 0 18 0 0 0] 8 #() 498 193 193 nil 27 8 'progressBar' nil nil nil 138 144 34 1 1311814 1 ##(Smalltalk.StatusOwnerDraw) 8705 1 560 nil 1296 nil 962 34 1 1010 #createAt:extent: 34 2 498 1 643 498 1169 41 560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 34 1 784 1216 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1456 nil 480 nil 7 nil nil nil 1456 530 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 1456 34 2 8 1140850688 131073 1536 nil 624 nil 7 nil nil nil 1536 853318 1 ##(Smalltalk.CardLayout) 138 144 34 6 1049094 ##(Smalltalk.Association) 8 'Sample set' 410 ##(Smalltalk.ListView) 34 45 nil 1536 34 2 8 1140920397 1025 1712 787270 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 624 nil 7 461638 4 ##(Smalltalk.Menu) nil true 34 2 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1377606 4 ##(Smalltalk.CommandDescription) #refreshSampleSets 8 'Refresh' 1 1 nil nil nil 1922 1 1954 #deleteSampleSet 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1712 nil 8 1806969104 ##(Smalltalk.BasicListAbstract) 786950 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 6 1117254 5 ##(Smalltalk.ListViewColumn) 8 'Name' 273 #left ##(Smalltalk.BasicListAbstract) 2082 #<= 8 #() 2082 #name 8 #() nil 1712 nil 3 nil nil 2194 8 'Samples' 141 #right ##(Smalltalk.BasicListAbstract) 2082 #<= 8 #() 2082 #samplesSize 8 #() nil 1712 nil 1 nil nil 2194 8 'Elapsed' 131 #right ##(Smalltalk.BasicListAbstract) 2082 #<= 8 #() 2082 #samplesElapsedTimeString 8 #() nil 1712 nil 1 nil nil 2194 8 'Interval' 131 #right ##(Smalltalk.BasicListAbstract) 2082 #<= 2480 2082 #samplingIntervalString 2480 nil 1712 nil 1 nil nil 2194 8 'Samplings' 145 #right ##(Smalltalk.BasicListAbstract) 2082 #<= 8 #() 2082 #samplingCount 2288 nil 1712 nil 1 nil nil 2194 8 'Last sampling' 281 #right ##(Smalltalk.BasicListAbstract) 2082 #<= 8 #() 2082 #samplingTimeStamp 2288 nil 1712 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 962 34 2 1010 #createAt:extent: 34 2 498 1 49 498 1151 575 1712 1010 #text: 34 1 8 'Name' 1712 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 8 #() 1216 nil 35 1666 8 'Samples' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1536 34 2 8 1140850688 131073 2960 nil nil nil 5 nil nil nil 2960 1376838 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ProfilerSamplesPresenter) #resource_Default_view nil 962 34 1 1010 #createAt:extent: 34 2 498 1 49 498 1151 575 2960 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1824 1216 nil 27 1666 8 'Classes' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1536 34 2 8 1140850688 131073 3216 nil nil nil 5 nil nil nil 3216 3026 ##(Smalltalk.ProfilerClassListPresenter) #resource_Default_view nil 962 34 1 1010 #createAt:extent: 34 2 498 1 49 498 1151 575 3216 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1824 1216 nil 27 1666 8 'Selectors' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1536 34 2 8 1140850688 131073 3456 nil nil nil 5 nil nil nil 3456 3026 ##(Smalltalk.ProfilerSelectorListPresenter) #resource_Default_view nil 962 34 1 1010 #createAt:extent: 34 2 498 1 49 498 1151 575 3456 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1824 1216 nil 27 1666 8 'Tally' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1536 34 2 8 1140850688 131073 3696 nil nil nil 5 nil nil nil 3696 3026 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view nil 962 34 1 1010 #createAt:extent: 34 2 498 1 49 498 1151 575 3696 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1824 1216 nil 27 1666 8 'Time' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1536 34 2 8 1140850688 131073 3936 nil nil nil 5 nil nil nil 3936 3026 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view nil 962 34 1 1010 #createAt:extent: 34 2 498 1 49 498 1151 575 3936 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1824 1216 nil 27 1712 nil nil nil 170 192 34 12 3216 8 'classes' 3936 8 'time' 3696 8 'tally' 1712 8 'sampleSets' 3456 8 'selectors' 2960 8 'samples' 1180166 ##(Smalltalk.Rectangle) 498 -7 -3 498 -5 -3 410 ##(Smalltalk.TabViewXP) 34 28 nil 1536 34 2 8 1140916736 1 4336 1778 138 144 34 6 1696 2944 3200 3440 3680 3920 nil 1856 480 nil 1 nil nil nil 4336 nil 8 1806565616 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2144 nil nil nil nil nil #noIcons nil nil nil nil nil 962 34 3 1010 #createAt:extent: 34 2 498 1 1 498 1153 627 4336 1010 #setSingleSelection: 8 #(1) 4336 1010 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4336 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 64 2 0 0 57 1 0 0] 8 #() 1216 nil 27 962 34 1 1010 #createAt:extent: 34 2 498 9 9 498 1153 627 1536 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 68 2 0 0 61 1 0 0] 34 7 1712 2960 3216 3456 3696 3936 4336 1216 nil 27 170 192 34 2 1536 8 'cards' 4274 498 9 9 498 9 9 962 34 1 1010 #createAt:extent: 34 2 498 1 1 498 1169 643 1456 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 65 1 0 0] 34 1 1536 1216 nil 27 170 192 1824 nil 658246 4 ##(Smalltalk.MenuBar) nil true 34 5 1874 nil true 34 5 1922 1 1954 #startProfiler 8 'Start Profiler' 1 1 nil nil nil 1179974 1 ##(Smalltalk.DividerMenuItem) 4097 1922 1 1954 #report 8 'Report' 1 1 nil nil nil 5202 4097 1922 1 1954 #exit 8 'Exit' 1 1 nil nil nil 8 'File' nil 1 nil nil 36505 nil nil 1874 nil true 34 3 1922 1 1954 #refreshSampleSets 8 'Refresh' 1 1 nil nil nil 1922 1 1954 #deleteSampleSet 8 'Delete' 1 1 nil nil nil 1922 1 1954 #deleteAllSampleSets 8 'Delete All' 1 1 nil nil nil 8 'Sample set' nil 1 nil nil 36513 nil nil 1874 nil true 34 8 1922 1 1954 2082 #filterPercentage:symbol: 34 2 8 0.0 #filter0 8 'Filter 0%' 1 1 nil nil nil 1922 1 1954 2082 #filterPercentage:symbol: 34 2 8 5.0 #filter5 8 'Filter 5%' 1 1 nil nil nil 1922 1 1954 2082 #filterPercentage:symbol: 34 2 8 10.0 #filter10 8 'Filter 10%' 1 1 nil nil nil 1922 1 1954 2082 #filterPercentage:symbol: 34 2 8 25.0 #filter25 8 'Filter 25%' 1 1 nil nil nil 5202 4097 1922 1 1954 #filterDolphin 8 'Filter Dolphin' 1 1 nil nil nil 5202 4097 1922 1 1954 #filterSelector 8 'Filter selector' 1 1 nil nil nil 8 'Filter' nil 1 nil nil 36527 nil nil 1874 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 36529 nil nil 1874 nil true 34 15 1922 1 1954 #helpContents 8 '&Contents' 1025 1 852806 4 ##(Smalltalk.Icon) nil true 2819078 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'Help.ico' 2490894 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 1922 1 1954 #help 8 'On this &Tool' 1249 1 nil nil nil 1922 1 1954 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5202 4097 1922 1 1954 #learnSmalltalk 8 'Learn Smalltalk' 1 1 1378630 2 ##(Smalltalk.TextTileIcon) $🎓 nil 466 #orchid 466 #white nil nil 1 nil nil nil nil 5202 4097 1922 1 1954 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 1922 1 1954 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 1922 1 1954 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5202 4097 1922 1 1954 #dolphinHomePage 8 'Dolphin Homepage' 1 1 6242 nil true 6274 8 '!!APPLICATION' 6336 65541 nil nil nil 1922 1 1954 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 1922 1 1954 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5202 4097 1922 1 1954 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6530 $🐬 nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 36553 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 962 34 1 1010 #createAt:extent: 34 2 498 6143 21 498 1201 801 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 2 1456 560 1216 nil 27 )!

showCounts
	^ShowCounts ifNil: [self defaultShowCounts] ifNotNil: [ShowCounts]!

showCounts: aBooleanOrNil 
	ShowCounts := aBooleanOrNil! !

!ProfileBrowser class categoriesForMethods!
defaultShowCounts!constants!public! !
displayOn:!operations!public! !
icon!constants!public! !
publishedAspects!constants!public! !
resource_Default_view!public!resources-views! !
showCounts!accessing!public! !
showCounts:!accessing!public! !
!

