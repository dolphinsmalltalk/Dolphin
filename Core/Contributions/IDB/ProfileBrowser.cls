"Filed out from Dolphin Smalltalk 7"!

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

	"Generated from:
	self createIconMethod: #icon ofSize: 48@48 fromFile: 'C:\Users\bower\Documents\Dolphin\Core\Contributions\IDB\Resources\IDB Profiler.png'.
	"
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 0 241 73 68 65 84 104 67 237 214 49 10 194 48 20 198 241 30 160 23 16 113 213 251 184 58 185 121 2 39 29 196 193 81 7 189 128 75 79 225 224 232 160 32 57 135 55 40 70 108 51 84 120 241 37 69 243 18 250 5 254 203 107 180 249 209 34 102 189 99 174 83 14 0 233 0 144 14 0 233 0 144 14 0 223 54 183 149 110 46 106 143 79 193 1 123 181 53 71 175 23 181 199 39 0 124 179 1 70 197 160 186 246 110 125 93 126 124 230 91 209 0 218 62 25 0 124 139 14 48 59 79 205 45 181 46 159 37 185 167 89 116 0 223 27 39 3 176 253 170 36 3 248 213 156 11 0 0 152 57 23 0 0 48 115 46 0 146 1 216 254 243 36 3 248 247 65 1 224 2 160 229 156 171 59 128 131 218 153 175 174 87 168 57 151 51 32 214 156 1 147 211 184 122 204 161 162 206 64 229 12 88 92 230 90 61 238 193 162 206 64 213 157 87 40 214 0 144 14 0 233 0 144 46 27 22 125 242 66 26 229 250 5 214 19 14 167 60 4 103 168 0 0 0 0 73 69 78 68 174 66 96 130]!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 721158 ##(Smalltalk.SystemColor) 31 328198 ##(Smalltalk.Point) 1201 801 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140850956 1 560 0 466 31 0 7 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 4 0 144 39 0 0 0 0 199 0 253 85 63 1] 498 193 193 0 560 0 8 4294908487 170 192 34 2 410 ##(Smalltalk.ProgressBar) 34 15 0 560 34 2 8 1140850688 1 784 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) 1 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 7 0 0 0 784 0 8 4294906605 852486 ##(Smalltalk.NullConverter) 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 9 -1 498 441 41 784 1074 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 255 255 255 255 224 0 0 0 19 0 0 0] 8 #() 498 193 193 0 27 8 'progressBar' 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 560 0 1360 0 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 643 498 1169 41 560 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 34 1 784 1280 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 1536 0 466 31 0 7 0 0 0 1536 530 1 1 0 0 0 0 410 ##(Smalltalk.CardContainer) 34 16 0 1536 34 2 8 1140850688 131073 1632 0 914 944 0 7 0 0 0 1632 655878 ##(Smalltalk.CardLayout) 138 144 34 6 721414 ##(Smalltalk.Association) 8 'Sample set' 410 ##(Smalltalk.ListView) 34 30 0 1632 34 2 8 1140920397 1025 1824 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 914 944 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #refreshSampleSets 8 'Refresh' 1 1 0 0 0 2050 1 2082 #deleteSampleSet 8 'Delete' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1824 0 8 4294906755 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 138 144 34 5 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 201 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2210 #name 8 #() 0 1824 2320 1 0 0 2322 8 'Samples' 201 #center ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2210 #samplesSize 8 #() 0 1824 2320 1 0 0 2322 8 'Elapsed (uS)' 201 #center ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2210 #samplesElapsedTime 2384 0 1824 2320 1 0 0 2322 8 'Samplings' 201 #center ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2210 #samplingCount 2384 0 1824 2320 1 0 0 2322 8 'Last sampling' 345 #center ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2210 #samplingTimeStamp 2384 0 1824 2320 3 0 0 #report 1936 0 131169 0 34 4 0 0 498 1 1 0 1010 138 144 34 3 1074 #createAt:extent: 34 2 498 1 47 498 1153 581 1824 1074 #contextMenu: 34 1 2016 1824 1074 #text: 34 1 8 'Name' 1824 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 64 2 0 0 57 1 0 0] 8 #() 1280 0 27 1778 8 'Samples' 410 ##(Smalltalk.ReferenceView) 34 14 0 1632 34 2 8 1140850688 131073 2912 0 0 0 5 0 0 0 2912 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ProfilerSamplesPresenter) #resource_Default_view 0 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 47 498 1153 581 2912 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 64 2 0 0 57 1 0 0] 1936 1280 0 27 1778 8 'Classes' 410 ##(Smalltalk.ReferenceView) 34 14 0 1632 34 2 8 1140850688 131073 3184 0 0 0 5 0 0 0 3184 2978 ##(Smalltalk.ProfilerClassListPresenter) #resource_Default_view 0 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 47 498 1153 581 3184 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 64 2 0 0 57 1 0 0] 1936 1280 0 27 1778 8 'Selectors' 410 ##(Smalltalk.ReferenceView) 34 14 0 1632 34 2 8 1140850688 131073 3440 0 0 0 5 0 0 0 3440 2978 ##(Smalltalk.ProfilerSelectorListPresenter) #resource_Default_view 0 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 47 498 1153 581 3440 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 64 2 0 0 57 1 0 0] 1936 1280 0 27 1778 8 'Tally' 410 ##(Smalltalk.ReferenceView) 34 14 0 1632 34 2 8 1140850688 131073 3696 0 0 0 5 0 0 0 3696 2978 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view 0 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 47 498 1153 581 3696 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 64 2 0 0 57 1 0 0] 1936 1280 0 27 1778 8 'Time' 410 ##(Smalltalk.ReferenceView) 34 14 0 1632 34 2 8 1140850688 131073 3952 0 0 0 5 0 0 0 3952 2978 ##(Smalltalk.ProfilerTreesPresenter) #resource_Default_view 0 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 47 498 1153 581 3952 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 64 2 0 0 57 1 0 0] 1936 1280 0 27 1824 170 192 34 12 1824 8 'sampleSets' 3696 8 'tally' 3440 8 'selectors' 3184 8 'classes' 3952 8 'time' 2912 8 'samples' 590342 ##(Smalltalk.Rectangle) 498 -7 -7 498 -7 -7 410 ##(Smalltalk.TabView) 34 23 0 1632 34 2 8 1140916736 1 4368 1890 138 144 34 6 1808 2896 3168 3424 3680 3936 0 1968 466 31 0 1 0 0 0 4368 0 8 4294904445 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2272 0 0 0 0 0 #noIcons 1010 138 144 34 3 1074 #createAt:extent: 34 2 498 1 1 498 1153 627 4368 1074 #basicSelectionsByIndex: 34 1 8 #(1) 4368 1074 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4368 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 64 2 0 0 57 1 0 0] 8 #() 1280 0 27 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 9 9 498 1153 627 1632 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 68 2 0 0 61 1 0 0] 34 7 1824 2912 3184 3440 3696 3952 4368 1280 0 27 170 192 1936 4306 498 9 9 498 9 9 1010 138 144 34 1 1074 #createAt:extent: 34 2 498 1 1 498 1169 643 1536 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 65 1 0 0] 34 1 1632 1280 0 27 170 192 1936 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 5 2002 0 true 34 5 2050 1 2082 #startProfiler 8 'Start Profiler' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2050 1 2082 #report 8 'Report' 1 1 0 0 0 5282 4097 2050 1 2082 #exit 8 'Exit' 1 1 0 0 0 8 'File' 0 1 0 0 21279 0 0 2002 0 true 34 3 2050 1 2082 #refreshSampleSets 8 'Refresh' 1 1 0 0 0 2050 1 2082 #deleteSampleSet 8 'Delete' 1 1 0 0 0 2050 1 2082 #deleteAllSampleSets 8 'Delete All' 1 1 0 0 0 8 'Sample set' 0 1 0 0 21287 0 0 2002 0 true 34 8 2050 1 2082 2210 #filterPercentage:symbol: 34 2 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 0 0 #filter0 8 'Filter 0%' 1 1 0 0 0 2050 1 2082 2210 #filterPercentage:symbol: 34 2 5730 8 0 0 0 0 0 0 20 64 #filter5 8 'Filter 5%' 1 1 0 0 0 2050 1 2082 2210 #filterPercentage:symbol: 34 2 5730 8 0 0 0 0 0 0 36 64 #filter10 8 'Filter 10%' 1 1 0 0 0 2050 1 2082 2210 #filterPercentage:symbol: 34 2 5730 8 0 0 0 0 0 0 57 64 #filter25 8 'Filter 25%' 1 1 0 0 0 5282 4097 2050 1 2082 #filterDolphin 8 'Filter Dolphin' 1 1 0 0 0 5282 4097 2050 1 2082 #filterSelector 8 'Filter selector' 1 1 0 0 0 8 'Filter' 0 1 0 0 21301 0 0 2002 0 true 8 #() 8 '&Tools' #toolsMenu 1 0 0 21303 0 0 2002 0 true 34 18 2050 1 2082 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 2050 1 2082 #help 8 'On this &Tool' 1249 1 0 0 0 2050 1 2082 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5282 4097 2050 1 2082 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5282 4097 2050 1 2082 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2050 1 2082 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2050 1 2082 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5282 4097 2050 1 2082 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2050 1 2082 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2050 1 2082 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 2050 1 2082 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5282 4097 2050 1 2082 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 6338 0 true 6384 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 5282 4097 2050 1 2082 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6338 0 true 6384 8 '!!APPLICATION' 7072 0 0 8 '&Help' 0 134217729 0 0 21331 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1010 138 144 34 2 1074 #createAt:extent: 34 2 498 3839 21 498 1201 801 416 1074 #updateMenuBar 1936 416 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 2 1536 560 1280 0 27 )!

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

