"Filed out from Dolphin Smalltalk X6"!

IdbToolShell subclass: #ProfileBrowser
	instanceVariableNames: 'filterPercentSymbol filterDolphin filterSelector'
	classVariableNames: 'ShowCounts'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfileBrowser guid: (GUID fromString: '{425D0EBB-542E-11D3-998B-D5CA2C3C1D61}')!
ProfileBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfileBrowser categoriesForClass!IDB Goodies! !
!ProfileBrowser methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
Profiler
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

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
		add: NumberPresenter new name: 'progressBar'!

createSchematicWiring
	"Create the trigger wiring for the receiver and link up
	to the sample sets model (a ListModel)"

	super createSchematicWiring.
	(self presenterNamed: 'sampleSets') 
		when: #selectionChanged
		send: #onSampleSetSelectionChanged
		to: self.
	(self presenterNamed: 'selectors') 
		when: #onSelectionChanged
		send: #onSelectorSelectionChanged
		to: self.
	(self presenterNamed: 'sampleSets') model: ProfilerSampleSetManager default sampleSets.
	((self presenterNamed: 'sampleSets') model)
		when: #itemUpdatedAtIndex:
			send: #onSampleSetUpdated:
			to: self;
		when: #itemRemovedAtIndex:
			send: #onSampleSetUpdated:
			to: self!

deleteAllSampleSets
	"Delete all the sample sets"

	ProfilerSampleSetManager default removeAll!

deleteSampleSet
	"Delete the currently selected sample set"

	ProfilerSampleSetManager default 
		removeSampleSetNamed: (self presenterNamed: 'sampleSets') selection name!

filterDolphinXXX
	"Toggle the filter for displaying the Dolphin package classes and tell the tabs"

	"Temporarily removed until I decide what to do with it"

	filterDolphin := filterDolphin not.
	#('classes' 'selectors' 'tally' 'time') 
		do: [:each | (self presenterNamed: each) filterDolphin: filterDolphin]!

filterPercentage: aFloat symbol: aSymbol 
	"Tell the tree presenters the mimimum percentage value for items to be displayed
	and remember the current command (aSymbol)"

	filterPercentSymbol == aSymbol 
		ifFalse: 
			[filterPercentSymbol := aSymbol.
			#('classes' 'selectors' 'tally' 'time') 
				do: [:each | (self presenterNamed: each) filterPercentage: aFloat]]!

filterSelector
	"Tell the tabs to filter out samples or tree branches that do not include the currently 
	selected method (if there is one)"

	filterSelector := filterSelector not.
	self onSelectorSelectionChanged!

isSampleSetSelected
	"Answer true if there is a sample set selected in the list"

	^(self presenterNamed: 'sampleSets') selectionOrNil notNil!

onSampleSetSelectionChanged
	"The sample set selection has been changed so refresh all the other cards"

	| sampleSet |
	(sampleSet := (self presenterNamed: 'sampleSets') selectionOrNil) isNil ifTrue: [^self].
	sampleSet 
		when: #updateIndicator:of:
		send: #onUpdateIndicator:of:
		to: self.
	Cursor wait showWhile: 
			[(self presenterNamed: 'progressBar') view 
				range: (1 to: ((sampleSet samplesSize max: 1) min: self updateIndicatorLimit)).
			self refreshTabsFor: sampleSet.
			(self presenterNamed: 'progressBar') value: 0].
	sampleSet removeEventsTriggeredFor: self.
	self resetSelectorFilter.
	self caption: 'Profiler Browser - ' , sampleSet name!

onSampleSetUpdated: anInteger 
	"This is the target for a triggered event that says that one of the current sample sets
	has been changed in some way. We just update the complete sample set list.
	anInteger is the index of the sample set that changed but we don't need to use it here"

	self sampleSetUpdated!

onSelectorSelectionChanged
	"The method selected in the selector tab list has changed. Depending on the
	whether filetering is active and a method is selected we send nil or a compiledcode"

	| selection |
	selection := (filterSelector and: [(self presenterNamed: 'selectors') hasSelection]) 
				ifTrue: [(self presenterNamed: 'selectors') selectionOrNil object].
	#('samples' 'tally' 'time') do: [:each | (self presenterNamed: each) filterSelector: selection]!

onUpdateIndicator: anInteger of: maximumInteger 
	"The sample set is being scanned and has asked, via a trigger, for the visual display 
	showing its progress to be updated. Fiddle a bit as the maximum vale for the display
	is 65536 so we must start scaling if we will go above that"

	| position |
	position := maximumInteger > self updateIndicatorLimit 
				ifTrue: [(self updateIndicatorLimit * (anInteger / maximumInteger)) truncated]
				ifFalse: [anInteger].
	(self presenterNamed: 'progressBar') value: position!

onViewOpened
	"Initialize the sub presenters and views"

	super onViewOpened.
	filterDolphin := false.
	filterSelector := false.
	filterPercentSymbol := #filter0.
	self caption: 'Profiler Browser - '!

queryCommand: aCommandQuery 
	"Enters details about a potential command for the receiver into aCommandQuery"

	#filterPercentage:symbol: == aCommandQuery commandSymbol 
		ifTrue: 
			[aCommandQuery
				beEnabled;
				isChecked: filterPercentSymbol == aCommandQuery command arguments last.
			^true].
	"#filterDolphin == aCommandQuery commandSymbol 
		ifTrue: 
			[aCommandQuery
				beEnabled;
				isChecked: filterDolphin.
			^true]."
	#filterSelector == aCommandQuery commandSymbol 
		ifTrue: 
			[aCommandQuery
				beEnabled;
				isChecked: filterSelector.
			^true].
	(#(#deleteSampleSet #report) includes: aCommandQuery commandSymbol) 
		ifTrue: 
			[aCommandQuery isEnabled: self isSampleSetSelected.
			^true].
	^super queryCommand: aCommandQuery!

refreshSampleSets
	"Refresh the sample sets list. This can be useful if you want to set all the
	tabs back to their default values - It leaves no sample set selected"

	self sampleSetUpdated!

refreshTabsFor: aSampleSet 
	"A new sample set has been selected so set all the tabs to reflect its contents. aSampleSet may
	be the dummy (named 'None') if we just want to cleaer all the tabs"

	#('samples' 'classes' 'selectors' 'tally' 'time') 
		do: [:each | (self presenterNamed: each) model: aSampleSet]!

report
	"Generate a text report for the selected sample set and open a SmalltalkWorkspaceDocument on it"

	| stream document |
	stream := String writeStream.
	(self presenterNamed: 'sampleSets') selection reportTo: stream.
	(self presenterNamed: 'classes') reportTo: stream.
	(self presenterNamed: 'selectors') reportTo: stream.
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

sampleSetUpdated
	"One of the sample sets has been changed in some way. Set the selection to nil and
	use a dummy model to refresh all the tabs"

	self refreshTabsFor: (ProfilerSampleSet name: 'None').
	(self presenterNamed: 'sampleSets') selectionOrNil: nil.
	self resetSelectorFilter.
	self caption: 'Profiler Browser - '!

startProfiler
	"If the profiler dialog is correctly completed and dismissed with OK then profile
	the the block that was entered with the requested parameters"

	ProfilerSetupDialog showModal isNil ifTrue: [^self].
	Profiler
		samplingInterval: ProfilerSetupDialog interval;
		profile: ProfilerSetupDialog profiledBlock
			inSetNamed: ProfilerSetupDialog sampleSetName
			collect: ProfilerSetupDialog isCollect
			on: ProfilerSetupDialog isOn!

updateIndicatorLimit
	"Answer the limit for the indicator, above which we have to satrt 
	scaling (see #onUpdateIndicator:of:"

	^65000! !
!ProfileBrowser categoriesFor: #about!commands!public! !
!ProfileBrowser categoriesFor: #createComponents!initializing!public! !
!ProfileBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!ProfileBrowser categoriesFor: #deleteAllSampleSets!commands!public! !
!ProfileBrowser categoriesFor: #deleteSampleSet!commands!public! !
!ProfileBrowser categoriesFor: #filterDolphinXXX!commands!public! !
!ProfileBrowser categoriesFor: #filterPercentage:symbol:!private helpers!public! !
!ProfileBrowser categoriesFor: #filterSelector!commands!public! !
!ProfileBrowser categoriesFor: #isSampleSetSelected!public!testing! !
!ProfileBrowser categoriesFor: #onSampleSetSelectionChanged!event handling!public! !
!ProfileBrowser categoriesFor: #onSampleSetUpdated:!event handling!public! !
!ProfileBrowser categoriesFor: #onSelectorSelectionChanged!event handling!public! !
!ProfileBrowser categoriesFor: #onUpdateIndicator:of:!event handling!public! !
!ProfileBrowser categoriesFor: #onViewOpened!event handling!public! !
!ProfileBrowser categoriesFor: #queryCommand:!commands!public! !
!ProfileBrowser categoriesFor: #refreshSampleSets!commands!public! !
!ProfileBrowser categoriesFor: #refreshTabsFor:!private helpers!public! !
!ProfileBrowser categoriesFor: #report!commands!public! !
!ProfileBrowser categoriesFor: #resetSelectorFilter!private helpers!public! !
!ProfileBrowser categoriesFor: #sampleSetUpdated!private helpers!public! !
!ProfileBrowser categoriesFor: #startProfiler!commands!public! !
!ProfileBrowser categoriesFor: #updateIndicatorLimit!constants!public! !

!ProfileBrowser class methodsFor!

defaultShowCounts
	^false!

displayOn: aStream 
	aStream nextPutAll: 'Profile Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) instanceClass defaultIcon!

publishedAspects
	^(super publishedAspects)
		add: (Aspect boolean: #showCounts);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  1201 801 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 576 0 482 31 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 4 0 144 39 0 0 0 0 199 0 253 85 63 1] 514 193 193 0 576 0 8 4294904209 234 256 98 2 410 8 ##(Smalltalk.ProgressBar)  98 15 0 576 98 2 8 1140850688 1 816 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #never 1 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 816 0 8 4294904465 852486 ##(Smalltalk.NullConverter)  0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 9 -1 514 441 41 816 1154 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 201 3 816 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 255 255 255 255 224 0 0 0 19 0 0 0] 98 0 514 193 193 0 27 8 'progressBar' 202 208 98 1 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 576 0 1472 0 1090 202 208 98 1 1154 1184 98 2 514 1 653 514 1185 41 576 1330 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 1 0 0 80 2 0 0 90 1 0 0] 98 1 816 1392 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1648 0 482 31 0 7 0 0 0 1648 546 1 1 0 0 0 0 410 8 ##(Smalltalk.CardContainer)  98 16 0 1648 98 2 8 1140850688 131073 1760 0 994 1024 0 7 0 0 0 1760 655878 ##(Smalltalk.CardLayout)  202 208 98 6 721414 ##(Smalltalk.Association)  8 'Sample set' 410 8 ##(Smalltalk.ListView)  98 30 0 1760 98 2 8 1140920397 1025 1968 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 938 960 8 #identity 994 1024 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 2 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #refreshSampleSets 8 'Refresh' 1 1 0 0 0 2210 1 2242 8 #deleteSampleSet 8 'Delete' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1968 0 8 4294904165 8 ##(Smalltalk.BasicListAbstract)  459270 ##(Smalltalk.Message)  8 #profilerIconIndex 98 0 938 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 5 920646 5 ##(Smalltalk.ListViewColumn)  8 'Name' 201 8 #left 2400 8 ##(Smalltalk.SortedCollection)  2418 8 #name 98 0 0 1968 2560 1 0 0 2562 8 'Samples' 201 8 #center 2400 2624 2418 8 #samplesSize 98 0 0 1968 2560 1 0 0 2562 8 'Elapsed (mS)' 201 2720 2400 2624 2418 8 #samplesElapsedTime 2672 0 1968 2560 1 0 0 2562 8 'Samplings' 201 2720 2400 2624 2418 8 #samplingCount 2672 0 1968 2560 1 0 0 2562 8 'Last sampling' 361 2720 2400 2624 2418 8 #samplingTimeStamp 2672 0 1968 2560 3 0 0 8 #report 2096 0 131169 0 0 1090 202 208 98 3 1154 1184 98 2 514 1 37 514 1169 601 1968 1154 8 #contextMenu: 98 1 2176 1968 1154 8 #text: 98 1 8 'Name' 1968 1330 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 72 2 0 0 62 1 0 0] 98 0 1392 0 27 1922 8 'Samples' 410 8 ##(Smalltalk.ReferenceView)  98 14 0 1760 98 2 8 1140850688 131073 3296 0 0 0 5 0 0 0 3296 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ProfilerSamplesPresenter)  8 #resource_Default_view 0 1090 202 208 98 1 1154 1184 98 2 514 1 37 514 1169 601 3296 1330 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 72 2 0 0 62 1 0 0] 2096 1392 0 27 1922 8 'Classes' 410 3312 98 14 0 1760 98 2 8 1140850688 131073 3616 0 0 0 5 0 0 0 3616 3378 8 ##(Smalltalk.ProfilerClassListPresenter)  3424 0 1090 202 208 98 1 1154 1184 98 2 514 1 37 514 1169 601 3616 1330 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 72 2 0 0 62 1 0 0] 2096 1392 0 27 1922 8 'Selectors' 410 3312 98 14 0 1760 98 2 8 1140850688 131073 3888 0 0 0 5 0 0 0 3888 3378 8 ##(Smalltalk.ProfilerSelectorListPresenter)  3424 0 1090 202 208 98 1 1154 1184 98 2 514 1 37 514 1169 601 3888 1330 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 72 2 0 0 62 1 0 0] 2096 1392 0 27 1922 8 'Tally' 410 3312 98 14 0 1760 98 2 8 1140850688 131073 4160 0 0 0 5 0 0 0 4160 3378 8 ##(Smalltalk.ProfilerTreesPresenter)  3424 0 1090 202 208 98 1 1154 1184 98 2 514 1 37 514 1169 601 4160 1330 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 72 2 0 0 62 1 0 0] 2096 1392 0 27 1922 8 'Time' 410 3312 98 14 0 1760 98 2 8 1140850688 131073 4432 0 0 0 5 0 0 0 4432 3378 4240 3424 0 1090 202 208 98 1 1154 1184 98 2 514 1 37 514 1169 601 4432 1330 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 72 2 0 0 62 1 0 0] 2096 1392 0 27 1968 234 256 98 12 1968 8 'sampleSets' 4432 8 'time' 3616 8 'classes' 4160 8 'tally' 3296 8 'samples' 3888 8 'selectors' 590342 ##(Smalltalk.Rectangle)  514 -7 -7 514 -7 -7 410 8 ##(Smalltalk.TabView)  98 23 0 1760 98 2 8 1140916736 1 4848 2050 202 208 98 6 1952 3280 3600 3872 4144 4416 0 2112 482 31 0 1 0 0 0 4848 0 8 4294904153 2400 8 ##(Smalltalk.IconicListAbstract)  2480 0 0 0 0 0 8 #noIcons 1090 202 208 98 3 1154 1184 98 2 514 1 1 514 1169 637 4848 1154 8 #selectionByIndex:ifAbsent: 98 2 3 1154 8 #yourself 2096 0 4848 1154 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4848 1330 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 62 1 0 0] 98 0 1392 0 27 1090 202 208 98 1 1154 1184 98 2 514 9 9 514 1169 637 1760 1330 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 76 2 0 0 66 1 0 0] 98 7 1968 3296 3616 3888 4160 4432 4848 1392 0 27 234 256 2096 4786 514 9 9 514 9 9 1090 202 208 98 1 1154 1184 98 2 514 1 1 514 1185 653 1648 1330 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 2 0 0 70 1 0 0] 98 1 1760 1392 0 27 234 256 2096 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 5 2162 0 16 98 5 2210 1 2242 8 #startProfiler 8 'Start Profiler' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 2210 1 2242 2976 8 'Report' 1 1 0 0 0 5874 4097 2210 1 2242 8 #exit 8 'Exit' 1 1 0 0 0 8 'File' 0 1 0 0 22041 0 0 2162 0 16 98 3 2210 1 2242 2272 8 'Refresh' 1 1 0 0 0 2210 1 2242 2336 8 'Delete' 1 1 0 0 0 2210 1 2242 8 #deleteAllSampleSets 8 'Delete All' 1 1 0 0 0 8 'Sample set' 0 1 0 0 22049 0 0 2162 0 16 98 8 2210 1 2242 2418 8 #filterPercentage:symbol: 98 2 327734 ##(Smalltalk.Float)  8 0 0 0 0 0 0 0 0 8 #filter0 8 'Filter 0%' 1 1 0 0 0 2210 1 2242 2418 6336 98 2 6370 8 0 0 0 0 0 0 20 64 8 #filter5 8 'Filter 5%' 1 1 0 0 0 2210 1 2242 2418 6336 98 2 6370 8 0 0 0 0 0 0 36 64 8 #filter10 8 'Filter 10%' 1 1 0 0 0 2210 1 2242 2418 6336 98 2 6370 8 0 0 0 0 0 0 57 64 8 #filter25 8 'Filter 25%' 1 1 0 0 0 5874 4097 2210 1 2242 8 #filterDolphin 8 'Filter Dolphin' 1 1 0 0 0 5874 4097 2210 1 2242 8 #filterSelector 8 'Filter selector' 1 1 0 0 0 8 'Filter' 0 1 0 0 22063 0 0 2162 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 22065 0 0 2162 0 16 98 19 2210 1 2242 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 938 8 ##(Smalltalk.ImageRelativeFileLocator)  2512 49 938 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 2210 1 2242 8 #help 8 'On this &Tool' 1249 1 0 0 0 2210 1 2242 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5874 4097 2210 1 2242 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 5874 4097 2210 1 2242 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2210 1 2242 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2210 1 2242 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 2162 0 16 98 4 2210 2097153 2242 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 7106 0 16 7136 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 2210 1 2242 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 7106 0 16 7136 8 'TipOfTheDay.ico' 7776 0 0 5874 4097 2210 1 2242 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 5874 4097 2210 1 2242 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2210 1 2242 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2210 1 2242 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2210 1 2242 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5874 4097 2210 1 2242 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 7106 0 16 7136 8 'LiveUpdate.ico' 7776 0 0 5874 4097 2210 1 2242 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7106 0 16 7136 8 '!!APPLICATION' 7776 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 5 1922 1025 2242 7072 8 '&Contents' 1025 1 7106 0 16 7136 49 7168 1922 1249 2242 7248 8 'On this &Tool' 1249 1 0 1922 5345 2242 7312 8 'What''s This?' 5345 1 0 1922 9441 2242 7696 8 '&Next Tip of the Day' 9441 1 7106 0 16 7136 8 'TipOfTheDay.ico' 7776 1922 13537 2242 7840 8 '&Previous Tip of the Day' 13537 1 7106 0 16 7136 8 'TipOfTheDay.ico' 7776 0 1 0 0 0 0 1 0 0 1090 202 208 98 2 1154 1184 98 2 514 6399 21 514 1201 801 416 1154 8 #menuBar: 98 1 5744 416 1330 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 215 14 0 0 154 1 0 0] 98 2 1648 576 1392 0 27 )!

showCounts
	^ShowCounts ifNil: [self defaultShowCounts] ifNotNil: [ShowCounts]!

showCounts: aBooleanOrNil 
	ShowCounts := aBooleanOrNil! !
!ProfileBrowser class categoriesFor: #defaultShowCounts!constants!public! !
!ProfileBrowser class categoriesFor: #displayOn:!operations!public! !
!ProfileBrowser class categoriesFor: #icon!constants!public! !
!ProfileBrowser class categoriesFor: #publishedAspects!constants!public! !
!ProfileBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!ProfileBrowser class categoriesFor: #showCounts!accessing!public! !
!ProfileBrowser class categoriesFor: #showCounts:!accessing!public! !

