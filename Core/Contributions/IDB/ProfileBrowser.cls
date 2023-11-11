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
		when: #item:updatedAtIndex:
			send: #onSampleSetUpdated:atIndex:
			to: self;
		when: #item:removedAtIndex:
			send: #onSampleSetUpdated:atIndex:
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

onSampleSetUpdated: aSampleSet atIndex: anInteger 
	"This is the target for a triggered event that says that one of the current sample sets
	has been changed in some way. We just update the complete sample set list."

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
about!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
deleteAllSampleSets!commands!public! !
deleteSampleSet!commands!public! !
filterDolphinXXX!commands!public! !
filterPercentage:symbol:!helpers!private! !
filterSelector!commands!public! !
isSampleSetSelected!public!testing! !
onSampleSetSelectionChanged!event handling!public! !
onSampleSetUpdated:atIndex:!event handling!public! !
onSelectorSelectionChanged!event handling!public! !
onUpdateIndicator:of:!event handling!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!public! !
refreshSampleSets!commands!public! !
refreshTabsFor:!helpers!private! !
report!commands!public! !
resetSelectorFilter!helpers!private! !
sampleSetUpdated!helpers!private! !
startProfiler!commands!public! !
updateIndicatorLimit!constants!public! !
!

!ProfileBrowser class methodsFor!

defaultShowCounts
	^false!

displayOn: aStream 
	aStream nextPutAll: 'Profile Browser'!

icon
	^Profiler icon!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d 328198 ##(Smalltalk.Point) 1201 801 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 560 nil 466 #default nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 4 0 144 39 0 0 0 0 199 0 253 85 63 1] 498 193 193 nil 560 nil 8 1877614448 170 192 34 2 410 ##(Smalltalk.ProgressBar) 34 15 nil 560 34 2 8 1140850688 1 784 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 624 nil 7 nil nil nil 784 nil 8 1877620400 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 9 1 498 441 41 784 1026 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 224 0 0 0 20 0 0 0] 8 #() 498 193 193 nil 27 8 'progressBar' 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 560 nil 1312 nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 643 498 1169 41 560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 34 1 784 1232 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1488 nil 480 nil 7 nil nil nil 1488 530 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 1488 34 2 8 1140850688 131073 1568 nil 624 nil 7 nil nil nil 1568 656710 1 ##(Smalltalk.CardLayout) 138 144 34 6 721414 ##(Smalltalk.Association) 8 'Sample set' 410 ##(Smalltalk.ListView) 34 45 nil 1568 34 2 8 1140920397 1025 1744 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 624 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #refreshSampleSets 8 'Refresh' 1 1 nil nil nil 1954 1 1986 #deleteSampleSet 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1744 nil 8 1877889248 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 273 #left ##(Smalltalk.BasicListAbstract) 2114 #<= 8 #() 2114 #name 8 #() nil 1744 nil 3 nil nil 2226 8 'Samples' 141 #right ##(Smalltalk.BasicListAbstract) 2114 #<= 8 #() 2114 #samplesSize 8 #() nil 1744 nil 1 nil nil 2226 8 'Elapsed' 131 #right ##(Smalltalk.BasicListAbstract) 2114 #<= 8 #() 2114 #samplesElapsedTimeString 8 #() nil 1744 nil 1 nil nil 2226 8 'Interval' 131 #right ##(Smalltalk.BasicListAbstract) 2114 #<= 2512 2114 #samplingIntervalString 2512 nil 1744 nil 1 nil nil 2226 8 'Samplings' 145 #right ##(Smalltalk.BasicListAbstract) 2114 #<= 8 #() 2114 #samplingCount 2320 nil 1744 nil 1 nil nil 2226 8 'Last sampling' 281 #right ##(Smalltalk.BasicListAbstract) 2114 #<= 8 #() 2114 #samplingTimeStamp 2320 nil 1744 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 962 138 144 34 3 1026 #createAt:extent: 34 2 498 1 49 498 1151 575 1744 1026 #contextMenu: 34 1 1920 1744 1026 #text: 34 1 8 'Name' 1744 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 8 #() 1232 nil 35 1698 8 'Samples' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1568 34 2 8 1140850688 131073 3040 nil nil nil 5 nil nil nil 3040 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ProfilerSamplesPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 49 498 1151 575 3040 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1856 1232 nil 27 1698 8 'Classes' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1568 34 2 8 1140850688 131073 3312 nil nil nil 5 nil nil nil 3312 3106 ##(Smalltalk.ProfilerClassListPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 49 498 1151 575 3312 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1856 1232 nil 27 1698 8 'Selectors' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1568 34 2 8 1140850688 131073 3568 nil nil nil 5 nil nil nil 3568 3106 ##(Smalltalk.ProfilerSelectorListPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 49 498 1151 575 3568 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1856 1232 nil 27 1698 8 'Tally' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1568 34 2 8 1140850688 131073 3824 nil nil nil 5 nil nil nil 3824 3106 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 49 498 1151 575 3824 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1856 1232 nil 27 1698 8 'Time' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1568 34 2 8 1140850688 131073 4080 nil nil nil 5 nil nil nil 4080 3106 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 49 498 1151 575 4080 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1856 1232 nil 27 1744 nil nil nil 170 192 34 12 3824 8 'tally' 3312 8 'classes' 4080 8 'time' 1744 8 'sampleSets' 3568 8 'selectors' 3040 8 'samples' 590342 ##(Smalltalk.Rectangle) 498 -7 -3 498 -5 -3 410 ##(Smalltalk.TabViewXP) 34 28 nil 1568 34 2 8 1140916736 1 4496 1810 138 144 34 6 1728 3024 3296 3552 3808 4064 nil 1888 480 nil 1 nil nil nil 4496 nil 8 1877659392 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2176 nil nil nil nil nil #noIcons nil nil nil nil nil 962 138 144 34 3 1026 #createAt:extent: 34 2 498 1 1 498 1153 627 4496 1026 #setSingleSelection: 8 #(1) 4496 1026 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4496 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 64 2 0 0 57 1 0 0] 8 #() 1232 nil 27 962 138 144 34 1 1026 #createAt:extent: 34 2 498 9 9 498 1153 627 1568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 68 2 0 0 61 1 0 0] 34 7 1744 3040 3312 3568 3824 4080 4496 1232 nil 27 170 192 1856 4434 498 9 9 498 9 9 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 1 498 1169 643 1488 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 65 1 0 0] 34 1 1568 1232 nil 27 170 192 1856 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 1906 nil true 34 5 1954 1 1986 #startProfiler 8 'Start Profiler' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1954 1 1986 #report 8 'Report' 1 1 nil nil nil 5378 4097 1954 1 1986 #exit 8 'Exit' 1 1 nil nil nil 8 'File' nil 1 nil nil 56589 nil nil 1906 nil true 34 3 1954 1 1986 #refreshSampleSets 8 'Refresh' 1 1 nil nil nil 1954 1 1986 #deleteSampleSet 8 'Delete' 1 1 nil nil nil 1954 1 1986 #deleteAllSampleSets 8 'Delete All' 1 1 nil nil nil 8 'Sample set' nil 1 nil nil 56597 nil nil 1906 nil true 34 8 1954 1 1986 2114 #filterPercentage:symbol: 34 2 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 0 0 #filter0 8 'Filter 0%' 1 1 nil nil nil 1954 1 1986 2114 #filterPercentage:symbol: 34 2 5826 8 0 0 0 0 0 0 20 64 #filter5 8 'Filter 5%' 1 1 nil nil nil 1954 1 1986 2114 #filterPercentage:symbol: 34 2 5826 8 0 0 0 0 0 0 36 64 #filter10 8 'Filter 10%' 1 1 nil nil nil 1954 1 1986 2114 #filterPercentage:symbol: 34 2 5826 8 0 0 0 0 0 0 57 64 #filter25 8 'Filter 25%' 1 1 nil nil nil 5378 4097 1954 1 1986 #filterDolphin 8 'Filter Dolphin' 1 1 nil nil nil 5378 4097 1954 1 1986 #filterSelector 8 'Filter selector' 1 1 nil nil nil 8 'Filter' nil 1 nil nil 56611 nil nil 1906 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 56613 nil nil 1906 nil true 34 15 1954 1 1986 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1954 1 1986 #help 8 'On this &Tool' 1249 1 nil nil nil 1954 1 1986 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5378 4097 1954 1 1986 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 466 #orchid 466 #white nil nil 1 nil nil nil nil 5378 4097 1954 1 1986 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 1954 1 1986 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 1954 1 1986 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5378 4097 1954 1 1986 #dolphinHomePage 8 'Dolphin Homepage' 1 1 6434 nil true 6480 8 '!!APPLICATION' 6528 nil nil 1954 1 1986 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 1954 1 1986 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5378 4097 1954 1 1986 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6722 $\x1F42C nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 6143 21 498 1201 801 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 87 14 0 0 154 1 0 0] 34 2 1488 560 1232 nil 27)!

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

