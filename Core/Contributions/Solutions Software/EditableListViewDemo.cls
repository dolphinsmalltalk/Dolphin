"Filed out from Dolphin Smalltalk"!

Shell subclass: #EditableListViewDemo
	instanceVariableNames: 'listPresenter rowHeightPresenter hasRowImagePresenter hasColumnImagesPresenter starRatingsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EditableListViewDemo guid: (GUID fromString: '{e27b5b72-70de-474c-a0cc-b14ee3fdc1eb}')!
EditableListViewDemo comment: ''!
!EditableListViewDemo categoriesForClass!MVP-Presenters! !
!EditableListViewDemo methodsFor!

addRecording

	| new |

	new := listPresenter model add: PVRRecording new.
	new date: Date today.
	listPresenter selection: new.
	listPresenter view activateFirstEditor!

channelColumn

	^listPresenter view columnNamed: #channel!

createComponents

	super createComponents.

	listPresenter := self add: ListPresenter new name: 'list'.
	rowHeightPresenter := self add: NumberPresenter new name: 'rowHeight'.
	hasRowImagePresenter := self add: BooleanPresenter new name: 'hasRowImage'.
	hasColumnImagesPresenter := self add: BooleanPresenter new name: 'hasColumnImages'.
	starRatingsPresenter := self add: NumberPresenter new name: 'starRatings'!

createSchematicWiring

	super createSchematicWiring.

	listPresenter when: #selectionChanged send: #onSelectionChanged to: self.
	rowHeightPresenter when: #valueChanged send: #onRowHeightChanged to: self.
	hasRowImagePresenter when: #valueChanged send: #onHasRowImageChanged to: self.
	hasColumnImagesPresenter when: #valueChanged send: #onHasColumnImagesChanged to: self.
	starRatingsPresenter when: #valueChanged send: #onStarRatingsChanged to: self!

deleteSelectedRecording

	listPresenter model remove: listPresenter selection!

deleteViewedRecordings

	listPresenter model removeAll: (self model select: [ :each | each isViewed])!

isViewedColumn

	^listPresenter view columnNamed: #isViewed!

maxStarRatings

	^10!

model: aCollection

	super model: aCollection.
	listPresenter model: (ListModel on: aCollection)!

onHasColumnImagesChanged

	listPresenter view 
		hideActiveEditor; 
		hasColumnImages: hasColumnImagesPresenter model value!

onHasRowImageChanged

	listPresenter view 
		hideActiveEditor;
		getImageBlock: (hasRowImagePresenter model value ifTrue: [IconicListAbstract] ifFalse: [nil])!

onRowHeightChanged

	listPresenter view rowHeight: rowHeightPresenter model value!

onSelectionChanged
!

onStarRatingsChanged

	self showStarRatings: starRatingsPresenter model value!

onViewOpened

	super onViewOpened.

	rowHeightPresenter model value: listPresenter view rowHeight.
	hasRowImagePresenter model value: listPresenter view getImageBlock notNil.
	hasColumnImagesPresenter model value: listPresenter view hasColumnImages.

	self titleColumn editor cueBanner: 'enter a title'.

	self channelColumn editor model searchPolicy: SearchPolicy caseInsensitive.
	self channelColumn editor choices: #('BBC1' 'BBC2' 'ITV' 'Channel 4').

	self isViewedColumn 
		haveCheckAllHeader;
		dropDownMenu: (Menu fromStrings: #('' 'Delete all viewed//deleteViewedRecordings')).

	starRatingsPresenter view range: (1 to: self maxStarRatings).
	starRatingsPresenter model value: 3!

queryCommand: aCommandQuery

	| cmd |

	cmd := aCommandQuery commandSymbol.

	cmd = #deleteViewedRecordings ifTrue:
		[aCommandQuery isEnabled: (self model anySatisfy: [ :each | each isViewed == true]).
		^true].

	^super queryCommand: aCommandQuery
!

showStarRatings: anInteger

	"Example of hiding/showing/creating columns"

	| previousColumn |

	previousColumn := listPresenter view columnNamed: #starRating1.
	2 to: anInteger do:
		[ :index || name column |
		name := ('starRating', index displayString) asSymbol.
		column := listPresenter view columnNamed: name ifNone: 
			[EditableListViewColumn new
				editor: (EmbeddedRadioButton new text: (index displayString, '*'); yourself);
				isEditable: true;
				width: previousColumn width;
				getContentsBlock: [ :item | item rating = index];
				setContentsBlock: [ :item :value | value ifTrue: [item rating: index]];
				getSortContentsBlock: previousColumn getSortContentsBlock;
				text: '';
				name: name;
				showIn: listPresenter view after: previousColumn;
				yourself].
		column isVisible ifFalse: [column show].
		previousColumn := column].

	anInteger + 1 to: self maxStarRatings do: [ :index | (listPresenter view columnNamed: ('starRating', index displayString) asSymbol ifNone: [nil]) ifNotNil: [ :column | column hide]]!

titleColumn

	^listPresenter view columnNamed: #title! !
!EditableListViewDemo categoriesForMethods!
addRecording!commands!public! !
channelColumn!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
deleteSelectedRecording!commands!public! !
deleteViewedRecordings!commands!public! !
isViewedColumn!accessing!public! !
maxStarRatings!accessing!public! !
model:!accessing!public! !
onHasColumnImagesChanged!event handling!public! !
onHasRowImageChanged!event handling!public! !
onRowHeightChanged!event handling!public! !
onSelectionChanged!event handling!public! !
onStarRatingsChanged!event handling!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!public! !
showStarRatings:!helpers!public! !
titleColumn!accessing!public! !
!

!EditableListViewDemo class methodsFor!

defaultModel

	^OrderedCollection new
		add: (PVRRecording new
			title: 'Doctor Who';
			episodeTitle: 'An Unearthly Child';
			description: 'An adventure in time and space';
			date: (Date newDay: 23 monthIndex: 11 year: 1963);
			time: (Time fromString: '17:15');
			channel: 'BBC1';
			isViewed: true;
			rating: 3;
			yourself);
		add: (PVRRecording new
			title: 'The Prisoner';
			episodeTitle: 'Fall Out';
			description: 'Who is Number 1?';
			date: (Date newDay: 1 monthIndex: 2 year: 1968);
			time: (Time fromString: '19:00');
			channel: 'ITV';
			isViewed: false;
			yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 2581 1201 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil 466 #face3d nil 7 nil nil nil 560 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.SpinButton) 34 15 nil 560 34 2 8 1140916224 1 704 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 834 #hash 8 #() 1 480 nil 7 nil nil nil 704 nil 8 1814748160 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 457 11 498 71 51 704 1026 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 21 3 704 1026 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 704 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 457 1362 #fixedViewLeft 71 1362 #fixedParentTop 11 1362 #fixedViewTop 51 410 ##(Smalltalk.CheckBox) 34 16 nil 560 34 2 8 1409363235 1 1440 770 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 1440 nil 8 1815097472 930 nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 817 9 498 221 61 1440 1026 #text: 34 1 8 'Column Images' 1440 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 8 #() 1312 nil 27 1330 1376 817 1392 221 1408 9 1424 61 410 ##(Smalltalk.SpinButton) 34 15 nil 560 34 2 8 1140916224 1 1808 770 nil nil 802 834 #= 864 834 #hash 896 1 480 nil 7 nil nil nil 1808 nil 8 1814748160 930 nil nil 962 138 144 34 3 1026 #createAt:extent: 34 2 498 1331 11 498 71 51 1808 1026 #setRange: 34 1 1138 3 21 3 1808 1026 #udmSetAccel: 34 1 1202 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 1808 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 2 0 0 5 0 0 0 188 2 0 0 30 0 0 0] 8 #() 1312 nil 27 1330 1376 1331 1392 71 1408 11 1424 51 410 ##(Smalltalk.CheckBox) 34 16 nil 560 34 2 8 1409363235 1 2256 770 nil nil 1536 false nil nil 7 nil nil nil 2256 nil 8 1815097472 930 nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 613 9 498 171 61 2256 1026 #text: 34 1 8 'Row Image' 2256 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 8 #() 1312 nil 27 1330 1376 613 1392 171 1408 9 1424 61 410 ##(Smalltalk.EmulatedPushButton) 34 30 nil 560 34 2 8 1140924416 1 2592 nil nil nil 7 nil nil nil 2592 nil 8 1815097472 1180998 4 ##(Smalltalk.CommandDescription) #addRecording 8 '&Add Recording' 1 1 nil nil false nil nil nil #disabled 138 ##(Smalltalk.Dictionary) 34 6 721414 ##(Smalltalk.Association) #released 451 2754 #disabled 301 2754 #cold 451 2754 #enabled 751 2754 #hot 451 2754 #pressed 301 true 1 nil nil nil nil nil nil 962 138 144 34 3 1026 #createAt:extent: 34 2 498 25 11 498 241 51 2592 1026 #isEnabled: 8 #(false) 2592 1026 #text: 34 1 8 '&Add Recording' 2592 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 8 #() 1312 nil 29 1330 1376 25 1392 241 1408 11 1424 51 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 65 3120 nil nil nil 7 nil nil nil 3120 nil 8 1815137184 930 nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 1165 17 498 161 41 3120 1026 #text: 34 1 8 'Star Ratings' 3120 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 2 0 0 8 0 0 0 150 2 0 0 28 0 0 0] 8 #() 1312 nil 27 1330 1376 1165 1392 161 1408 17 1424 41 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 65 3440 nil nil nil 7 nil nil nil 3440 nil 8 1815137184 930 nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 307 21 498 141 41 3440 1026 #text: 34 1 8 'Row Height' 3440 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 8 #() 1312 nil 27 1330 1376 307 1392 141 1408 21 1424 41 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 3760 nil nil nil 7 nil nil nil 3760 nil 8 1815097472 2674 #exit 8 'Close' 1 1 nil nil false nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 2359 11 498 171 51 3760 1026 #text: 34 1 8 'Close' 3760 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 4 0 0 5 0 0 0 240 4 0 0 30 0 0 0] 8 #() 1312 nil 29 1330 1362 #fixedParentRight -189 1392 171 1408 11 1424 51 170 192 34 8 2256 8 'hasRowImage' 1808 8 'starRatings' 1440 8 'hasColumnImages' 704 8 'rowHeight' nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 1053 498 2549 71 560 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 34 8 2592 704 3440 2256 1440 3120 1808 3760 1312 nil 27 nil nil 410 ##(Smalltalk.EditableListView) 34 55 nil 416 34 2 8 1140920649 1025 4368 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 7 nil nil nil 4368 nil 8 1815049392 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 498 65 65 nil nil 138 144 34 8 1447750 15 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 834 #title 8 #() #title 4368 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 8 '[ :colItem :item | item icon]' 8 #[30 105 226 32 106] #icon 4720 7 513 nil 1 4706 0 nil 4738 2 1 4704 8 'doIt' 8 '[ :colItem :prefix :item | item titleAndEpisode]' 8 #[30 105 226 64 106] #titleAndEpisode 4864 7 769 nil nil true 834 #title: 8 #(nil) 1052998 20 ##(Smalltalk.EmbeddedTextEdit) nil nil 8 #(67174528 0) 4992 770 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 4992 nil nil 930 nil 8 '' 1 nil nil nil nil nil nil nil nil nil 4626 8 'Episode Title' 401 #left 834 #displayString 8 #() 834 #<= 5152 834 #episodeTitle 5152 nil 4368 ##(Smalltalk.IconicListAbstract) 1 nil nil true 834 #episodeTitle: 8 #(nil) 4978 nil nil 8 #(67174528 0) 5232 770 nil false 5056 nil 480 nil 5 nil nil nil 5232 nil nil nil 1 nil nil nil nil nil nil nil nil nil 4626 8 'Description' 493 #left 834 #displayString 5152 834 #<= 5152 834 #description 5152 nil 4368 ##(Smalltalk.IconicListAbstract) 3 nil nil true 834 #description: 8 #(nil) 1642822 20 ##(Smalltalk.EmbeddedMultilineTextEdit) nil nil 8 #(69275972 0) 5408 770 nil false 5056 nil 480 nil 5 nil nil nil 5408 nil nil 930 nil 8 '' 9 nil nil nil nil nil nil nil nil nil 4626 8 'Date' 201 #left 4706 0 nil 4738 4 1 832 8 'doIt' 8 '[ :item | item ifNil: [''''] ifNotNil: [ :date | date shortString]]' 8 #[32 105 17 100 223 3 97 29 106 70 160 106] 8 '' #ifNil:ifNotNil: #shortString 5520 7 65793 nil 834 #<= 8 #() 834 #date 4688 nil 4368 ##(Smalltalk.IconicListAbstract) 1 nil nil true 834 #date: 8 #(nil) 1644102 21 ##(Smalltalk.EmbeddedFormattedTextEdit) nil nil 8 #(67174528 0) 5712 770 nil false 5056 nil 480 nil 5 nil nil nil 5712 nil nil 656454 1 ##(Smalltalk.DateToText) nil 8 '' nil nil 1 false false 8 '__/__/____' 8 '/' $_ nil nil nil nil nil nil nil nil nil 4626 8 'Channel' 321 #left 834 #displayString 5632 834 #<= 5632 834 #channel 4688 #channel 4368 ##(Smalltalk.IconicListAbstract) 1 nil nil true 834 #channel: 8 #(nil) 1053510 21 ##(Smalltalk.EmbeddedComboBox) nil nil 8 #(70321794 0) 5968 4434 138 144 4480 nil 4512 480 nil 5 nil nil nil 5968 nil nil 4706 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] #displayString 6032 7 257 nil 4480 401 nil true nil nil nil nil nil nil nil nil 4626 8 'Viewed?' 201 #center 834 #displayString 5632 834 #<= 5632 834 #isViewed 4688 #isViewed 4368 ##(Smalltalk.IconicListAbstract) 1 nil nil true 834 #isViewed: 8 #(nil) 410 ##(Smalltalk.EmbeddedCheckBox) 34 20 nil nil 34 2 8 1140924422 1 6208 770 nil false 5056 false 480 nil 5 nil nil nil 6208 nil 8 1815097472 930 nil nil nil nil 8 '' true nil 962 138 144 34 1 1026 #createAt:extent: 34 2 498 1 1 498 201 51 6208 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1312 nil 45 nil nil nil nil nil nil nil nil 4626 8 'Rating' 121 #left 834 #displayString 5152 834 #<= 5152 4706 0 nil 4738 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] #rating 6560 7 257 nil #starRating1 4368 nil 1 nil nil true 4706 0 nil 4738 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] #rating: 6640 7 513 nil 410 ##(Smalltalk.EmbeddedRadioButton) 34 20 nil nil 34 2 8 1140924425 1 6720 770 nil false 5056 false 480 nil 5 nil nil nil 6720 nil 8 1815097472 930 nil nil nil nil 8 '1*' true nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 1 1 498 201 51 6720 1026 #text: 34 1 6832 6720 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1312 nil 45 nil nil nil 4706 0 nil 4738 3 1 4704 8 'doIt' 8 '[ :recording | recording rating ifNil: [0]]' 8 #[31 105 226 0 100 223 2 97 62 106] #rating #ifNil: 7040 7 257 nil nil nil nil nil 4626 8 '' 201 #left 834 #displayString 8 #() 834 #<= 7168 nil nil 4368 nil 1 4706 0 nil 4738 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 7200 7 257 nil nil true nil 410 ##(Smalltalk.EmbeddedPushButton) 34 35 nil nil 34 2 8 1140925248 1 7296 nil 480 498 nil 61 5 nil nil nil 7296 nil 8 1815097472 2674 #deleteSelectedRecording 8 'Delete' 1 1 nil 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil false nil nil nil nil 138 ##(Smalltalk.Dictionary) 34 6 2754 #released 451 2754 #disabled 301 2754 #cold 451 2754 #enabled 751 2754 #hot 451 2754 #pressed 301 nil nil nil 498 33 33 nil 3 nil nil nil nil nil nil 7408 962 138 144 34 2 1026 #createAt:extent: 34 2 498 1 1 498 1 1 7296 1026 #text: 34 1 7408 7296 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 8 #() 1312 nil 41 nil nil nil 4706 0 nil 4738 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | item isViewed ifNil: [0] ifNotNil: [ :bool | bool ifTrue: [2] ifFalse: [1]]]' 8 #[32 105 226 0 100 223 3 97 62 106 70 119 64 106 63 106] #isViewed #ifNil:ifNotNil: #ifTrue:ifFalse: 7888 7 65793 nil 4706 0 nil 4738 2 1 4704 8 'doIt' 8 '[ :item | item isViewed == true]' 8 #[30 105 226 0 58 141 106] #isViewed 7968 7 257 nil nil nil nil #report 8 #() nil 131171 nil 1 nil nil nil nil nil 5 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 1 1 498 2549 1053 4368 1026 #text: 34 1 8 'Title' 4368 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 8 #() 1312 nil 33 170 192 34 2 4368 8 'list' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 498 12287 21 498 2581 1201 416 1026 #text: 34 1 8 'Demo' 416 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 9 29 0 0 98 2 0 0] 34 2 4368 560 1312 nil 27 )! !
!EditableListViewDemo class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

