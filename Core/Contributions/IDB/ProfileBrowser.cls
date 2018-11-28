"Filed out from Dolphin Smalltalk 7"!

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
		samplingInterval: ProfilerSetupDialog interval * 1000;
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1201 801 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 560 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 4 0 144 39 0 0 0 0 199 0 253 85 63 1] 498 193 193 nil 560 nil 8 1914952576 170 192 34 2 410 ##(Smalltalk.ProgressBar) 34 15 nil 560 34 2 8 1140850688 1 816 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 640 nil 7 nil nil nil 816 nil 8 1915019648 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 9 1 498 441 41 816 1058 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 224 0 0 0 20 0 0 0] 8 #() 498 193 193 nil 27 8 'progressBar' 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 560 nil 1344 nil 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 643 498 1169 41 560 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 34 1 816 1264 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1520 nil 480 nil 7 nil nil nil 1520 530 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 1520 34 2 8 1140850688 131073 1600 nil 640 nil 7 nil nil nil 1600 655878 ##(Smalltalk.CardLayout) 138 144 34 6 721414 ##(Smalltalk.Association) 8 'Sample set' 410 ##(Smalltalk.ListView) 34 30 nil 1600 34 2 8 1140920397 1025 1776 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 640 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #refreshSampleSets 8 'Refresh' 1 1 nil nil nil 1986 1 2018 #deleteSampleSet 8 'Delete' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1776 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 6 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 273 #left ##(Smalltalk.BasicListAbstract) 2146 #<= 8 #() 2146 #name 8 #() nil 1776 2256 3 nil nil 2258 8 'Samples' 141 #right ##(Smalltalk.BasicListAbstract) 2146 #<= 8 #() 2146 #samplesSize 8 #() nil 1776 2256 1 nil nil 2258 8 'Elapsed' 131 #right ##(Smalltalk.BasicListAbstract) 2146 #<= 8 #() 2146 #samplesElapsedTimeString 8 #() nil 1776 2256 1 nil nil 2258 8 'Interval' 131 #right ##(Smalltalk.BasicListAbstract) 2146 #<= 2544 2146 #samplingIntervalString 2544 nil 1776 nil 1 nil nil 2258 8 'Samplings' 145 #right ##(Smalltalk.BasicListAbstract) 2146 #<= 8 #() 2146 #samplingCount 2352 nil 1776 2256 1 nil nil 2258 8 'Last sampling' 281 #right ##(Smalltalk.BasicListAbstract) 2146 #<= 8 #() 2146 #samplingTimeStamp 2352 nil 1776 2256 1 nil nil #report 1888 nil 131169 nil 34 4 nil nil 498 1 1 nil 994 138 144 34 3 1058 #createAt:extent: 34 2 498 1 49 498 1151 575 1776 1058 #contextMenu: 34 1 1952 1776 1058 #text: 34 1 8 'Name' 1776 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 8 #() 1264 nil 27 1730 8 'Samples' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1600 34 2 8 1140850688 131073 3088 nil nil nil 5 nil nil nil 3088 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ProfilerSamplesPresenter) #resource_Default_view nil 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 49 498 1151 575 3088 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1888 1264 nil 27 1730 8 'Classes' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1600 34 2 8 1140850688 131073 3360 nil nil nil 5 nil nil nil 3360 3154 ##(Smalltalk.ProfilerClassListPresenter) #resource_Default_view nil 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 49 498 1151 575 3360 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1888 1264 nil 27 1730 8 'Selectors' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1600 34 2 8 1140850688 131073 3616 nil nil nil 5 nil nil nil 3616 3154 ##(Smalltalk.ProfilerSelectorListPresenter) #resource_Default_view nil 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 49 498 1151 575 3616 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1888 1264 nil 27 1730 8 'Tally' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1600 34 2 8 1140850688 131073 3872 nil nil nil 5 nil nil nil 3872 3154 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view nil 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 49 498 1151 575 3872 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1888 1264 nil 27 1730 8 'Time' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1600 34 2 8 1140850688 131073 4128 nil nil nil 5 nil nil nil 4128 3154 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view nil 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 49 498 1151 575 4128 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 63 2 0 0 55 1 0 0] 1888 1264 nil 27 1776 170 192 34 12 3360 8 'classes' 3616 8 'selectors' 3872 8 'tally' 4128 8 'time' 1776 8 'sampleSets' 3088 8 'samples' 590342 ##(Smalltalk.Rectangle) 498 -7 -3 498 -5 -3 410 ##(Smalltalk.TabViewXP) 34 28 nil 1600 34 2 8 1140916736 1 4544 1842 138 144 34 6 1760 3072 3344 3600 3856 4112 nil 1920 480 nil 1 nil nil nil 4544 nil 8 1915274640 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2208 nil nil nil nil nil #noIcons nil nil nil nil nil 994 138 144 34 3 1058 #createAt:extent: 34 2 498 1 1 498 1153 627 4544 1058 #basicSelectionsByIndex: 34 1 8 #(1) 4544 1058 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4544 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 64 2 0 0 57 1 0 0] 8 #() 1264 nil 27 994 138 144 34 1 1058 #createAt:extent: 34 2 498 9 9 498 1153 627 1600 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 68 2 0 0 61 1 0 0] 34 7 1776 3088 3360 3616 3872 4128 4544 1264 nil 27 170 192 1888 4482 498 9 9 498 9 9 994 138 144 34 1 1058 #createAt:extent: 34 2 498 1 1 498 1169 643 1520 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 65 1 0 0] 34 1 1600 1264 nil 27 170 192 1888 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 1938 nil true 34 5 1986 1 2018 #startProfiler 8 'Start Profiler' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1986 1 2018 #report 8 'Report' 1 1 nil nil nil 5442 4097 1986 1 2018 #exit 8 'Exit' 1 1 nil nil nil 8 'File' nil 1 nil nil 50385 nil nil 1938 nil true 34 3 1986 1 2018 #refreshSampleSets 8 'Refresh' 1 1 nil nil nil 1986 1 2018 #deleteSampleSet 8 'Delete' 1 1 nil nil nil 1986 1 2018 #deleteAllSampleSets 8 'Delete All' 1 1 nil nil nil 8 'Sample set' nil 1 nil nil 50393 nil nil 1938 nil true 34 8 1986 1 2018 2146 #filterPercentage:symbol: 34 2 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 0 0 #filter0 8 'Filter 0%' 1 1 nil nil nil 1986 1 2018 2146 #filterPercentage:symbol: 34 2 5890 8 0 0 0 0 0 0 20 64 #filter5 8 'Filter 5%' 1 1 nil nil nil 1986 1 2018 2146 #filterPercentage:symbol: 34 2 5890 8 0 0 0 0 0 0 36 64 #filter10 8 'Filter 10%' 1 1 nil nil nil 1986 1 2018 2146 #filterPercentage:symbol: 34 2 5890 8 0 0 0 0 0 0 57 64 #filter25 8 'Filter 25%' 1 1 nil nil nil 5442 4097 1986 1 2018 #filterDolphin 8 'Filter Dolphin' 1 1 nil nil nil 5442 4097 1986 1 2018 #filterSelector 8 'Filter selector' 1 1 nil nil nil 8 'Filter' nil 1 nil nil 50407 nil nil 1938 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 50409 nil nil 1938 nil true 34 15 1986 1 2018 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1986 1 2018 #help 8 'On this &Tool' 1249 1 nil nil nil 1986 1 2018 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5442 4097 1986 1 2018 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 262406 ##(Smalltalk.ARGB) 8 4292695180 786694 ##(Smalltalk.IndexedColor) 33554471 nil nil 1 nil nil nil nil 5442 4097 1986 1 2018 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 1986 1 2018 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 1986 1 2018 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5442 4097 1986 1 2018 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 6498 nil true 6544 8 '!!APPLICATION' 6592 nil nil 1986 1 2018 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 1986 1 2018 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5442 4097 1986 1 2018 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6786 $\x1F42C nil nil 196934 1 ##(Smalltalk.RGB) 17741887 nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 50433 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 994 138 144 34 2 1058 #createAt:extent: 34 2 498 3839 21 498 1201 801 416 1058 #updateMenuBar 1888 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 2 1520 560 1264 nil 27 )!

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

