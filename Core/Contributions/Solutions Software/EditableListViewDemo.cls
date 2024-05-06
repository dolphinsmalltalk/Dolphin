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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 2581 1201 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 576 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.SpinButton) 34 15 nil 576 34 2 8 1140916224 1 736 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 866 #hash 8 #() 1 466 8 4278190080 nil 7 nil nil nil 736 nil 8 1938327952 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 457 11 514 71 51 736 1090 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 21 3 736 1090 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 8 #() 514 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 457 1426 #fixedViewLeft 71 1426 #fixedParentTop 11 1426 #fixedViewTop 51 410 ##(Smalltalk.StaticText) 34 16 nil 576 34 2 8 1140850944 65 1504 nil nil nil 7 nil nil nil 1504 nil 8 1938515248 994 nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 307 21 514 141 41 1504 1090 #text: 34 1 8 'Row Height' 1504 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 8 #() 1376 nil 27 1394 1440 307 1456 141 1472 21 1488 41 410 ##(Smalltalk.EmulatedPushButton) 34 30 nil 576 34 2 8 1140924416 1 1824 nil nil nil 7 nil nil nil 1824 nil 8 1938471072 1180998 4 ##(Smalltalk.CommandDescription) #addRecording 8 '&Add Recording' 1 1 nil nil false nil nil nil #disabled 138 ##(Smalltalk.Dictionary) 34 6 721414 ##(Smalltalk.Association) #released 451 1986 #cold 451 1986 #pressed 301 1986 #disabled 301 1986 #hot 451 1986 #enabled 751 true 1 nil nil nil nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 514 25 11 514 241 51 1824 1090 #isEnabled: 8 #(false) 1824 1090 #text: 34 1 8 '&Add Recording' 1824 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 8 #() 1376 nil 29 1394 1440 25 1456 241 1472 11 1488 51 410 ##(Smalltalk.SpinButton) 34 15 nil 576 34 2 8 1140916224 1 2352 802 nil nil 834 866 #= 896 866 #hash 928 1 466 960 nil 7 nil nil nil 2352 nil 8 1938327952 994 nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 514 1331 11 514 71 51 2352 1090 #setRange: 34 1 1202 3 21 3 2352 1090 #udmSetAccel: 34 1 1266 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 2352 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 2 0 0 5 0 0 0 188 2 0 0 30 0 0 0] 8 #() 1376 nil 27 1394 1440 1331 1456 71 1472 11 1488 51 410 ##(Smalltalk.CheckBox) 34 16 nil 576 34 2 8 1409363235 1 2816 802 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 2816 nil 8 1938471072 994 nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 817 9 514 221 61 2816 1090 #text: 34 1 8 'Column Images' 2816 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 8 #() 1376 nil 27 1394 1440 817 1456 221 1472 9 1488 61 410 ##(Smalltalk.CheckBox) 34 16 nil 576 34 2 8 1409363235 1 3184 802 nil nil 2912 false nil nil 7 nil nil nil 3184 nil 8 1938471072 994 nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 613 9 514 171 61 3184 1090 #text: 34 1 8 'Row Image' 3184 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 8 #() 1376 nil 27 1394 1440 613 1456 171 1472 9 1488 61 410 ##(Smalltalk.StaticText) 34 16 nil 576 34 2 8 1140850944 65 3520 nil nil nil 7 nil nil nil 3520 nil 8 1938515248 994 nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1165 17 514 161 41 3520 1090 #text: 34 1 8 'Star Ratings' 3520 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 2 0 0 8 0 0 0 150 2 0 0 28 0 0 0] 8 #() 1376 nil 27 1394 1440 1165 1456 161 1472 17 1488 41 410 ##(Smalltalk.PushButton) 34 20 nil 576 34 2 8 1140924416 1 3840 nil nil nil 7 nil nil nil 3840 nil 8 1938471072 1906 #exit 8 'Close' 1 1 nil nil false nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 2359 11 514 171 51 3840 1090 #text: 34 1 8 'Close' 3840 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 4 0 0 5 0 0 0 240 4 0 0 30 0 0 0] 8 #() 1376 nil 29 1394 1426 #fixedParentRight -189 1456 171 1472 11 1488 51 170 192 34 8 3184 8 'hasRowImage' 2352 8 'starRatings' 2816 8 'hasColumnImages' 736 8 'rowHeight' nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 514 1 1053 514 2549 71 576 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 34 8 1824 736 1504 3184 2816 3520 2352 3840 1376 nil 27 nil nil 410 ##(Smalltalk.EditableListView) 34 40 nil 416 34 2 8 1140920649 1025 4448 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 nil 7 nil nil nil 4448 nil 8 1938566256 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 514 65 65 nil nil 138 144 34 8 1447750 15 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 866 #title 8 #() #title 4448 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 8 '[ :colItem :item | item icon]' 8 #[30 105 226 32 106] #icon 4832 7 513 nil 1 4818 0 nil 4850 2 1 4816 8 'doIt' 8 '[ :colItem :prefix :item | item titleAndEpisode]' 8 #[30 105 226 64 106] #titleAndEpisode 4976 7 769 nil nil true 866 #title: 8 #(nil) 1052998 20 ##(Smalltalk.EmbeddedTextEdit) nil nil 8 #(67174528 0) 5104 802 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 5104 nil nil 994 nil 8 '' 1 nil nil nil nil nil nil nil nil nil 4738 8 'Episode Title' 401 #left 866 #displayString 8 #() 866 #<= 5264 866 #episodeTitle 5264 nil 4448 ##(Smalltalk.IconicListAbstract) 1 nil nil true 866 #episodeTitle: 8 #(nil) 5090 nil nil 8 #(67174528 0) 5344 802 nil false 5168 nil 466 8 4278190080 nil 5 nil nil nil 5344 nil nil nil 1 nil nil nil nil nil nil nil nil nil 4738 8 'Description' 493 #left 866 #displayString 5264 866 #<= 5264 866 #description 5264 nil 4448 ##(Smalltalk.IconicListAbstract) 3 nil nil true 866 #description: 8 #(nil) 1642822 20 ##(Smalltalk.EmbeddedMultilineTextEdit) nil nil 8 #(69275972 0) 5552 802 nil false 5168 nil 466 5408 nil 5 nil nil nil 5552 nil nil 994 nil 8 '' 9 nil nil nil nil nil nil nil nil nil 4738 8 'Date' 201 #left 4818 0 nil 4850 4 1 864 8 'doIt' 8 '[ :item | item ifNil: [''''] ifNotNil: [ :date | date shortString]]' 8 #[32 105 17 100 223 3 97 29 106 70 160 106] 8 '' #ifNil:ifNotNil: #shortString 5680 7 65793 nil 866 #<= 8 #() 866 #date 4800 nil 4448 ##(Smalltalk.IconicListAbstract) 1 nil nil true 866 #date: 8 #(nil) 1644102 21 ##(Smalltalk.EmbeddedFormattedTextEdit) nil nil 8 #(67174528 0) 5872 802 nil false 5168 nil 466 8 4278190080 nil 5 nil nil nil 5872 nil nil 656454 1 ##(Smalltalk.DateToText) nil 8 '' nil nil 1 false false 8 '__/__/____' 8 '/' $_ nil nil nil nil nil nil nil nil nil 4738 8 'Channel' 321 #left 866 #displayString 5792 866 #<= 5792 866 #channel 4800 #channel 4448 ##(Smalltalk.IconicListAbstract) 1 nil nil true 866 #channel: 8 #(nil) 1053510 20 ##(Smalltalk.EmbeddedComboBox) nil nil 8 #(70321794 0) 6160 4514 138 144 4560 nil 4592 466 5936 nil 5 nil nil nil 6160 nil nil 4818 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] #displayString 6240 7 257 nil nil 401 nil true nil nil nil nil nil nil nil nil 4738 8 'Viewed?' 201 #center 866 #displayString 5792 866 #<= 5792 866 #isViewed 4800 #isViewed 4448 ##(Smalltalk.IconicListAbstract) 1 nil nil true 866 #isViewed: 8 #(nil) 410 ##(Smalltalk.EmbeddedCheckBox) 34 20 nil nil 34 2 8 1140924422 1 6416 802 nil false 5168 false 466 5936 nil 5 nil nil nil 6416 nil 8 1938471072 994 nil nil nil nil 8 '' true nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 514 1 1 514 201 51 6416 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1376 nil 45 nil nil nil nil nil nil nil nil 4738 8 'Rating' 121 #left 866 #displayString 5264 866 #<= 5264 4818 0 nil 4850 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] #rating 6784 7 257 nil #starRating1 4448 nil 1 nil nil true 4818 0 nil 4850 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] #rating: 6864 7 513 nil 410 ##(Smalltalk.EmbeddedRadioButton) 34 20 nil nil 34 2 8 1140924425 1 6944 802 nil false 5168 false 466 5408 nil 5 nil nil nil 6944 nil 8 1938471072 994 nil nil nil nil 8 '1*' true nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 201 51 6944 1090 #text: 34 1 7072 6944 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1376 nil 45 nil nil nil 4818 0 nil 4850 3 1 4816 8 'doIt' 8 '[ :recording | recording rating ifNil: [0]]' 8 #[31 105 226 0 100 223 2 97 62 106] #rating #ifNil: 7280 7 257 nil nil nil nil nil 4738 8 '' 201 #left 866 #displayString 8 #() 866 #<= 7408 nil nil 4448 nil 1 4818 0 nil 4850 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 7440 7 257 nil nil true nil 410 ##(Smalltalk.EmbeddedPushButton) 34 35 nil nil 34 2 8 1140925248 1 7536 nil 466 8 4278190080 514 nil 61 5 nil nil nil 7536 nil 8 1938471072 1906 #deleteSelectedRecording 8 'Delete' 1 1 nil 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil false nil nil nil nil 138 ##(Smalltalk.Dictionary) 34 6 1986 #released 451 1986 #cold 451 1986 #pressed 301 1986 #disabled 301 1986 #hot 451 1986 #enabled 751 nil nil nil 514 33 33 nil 3 nil nil nil nil nil nil 7680 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 1 1 7536 1090 #text: 34 1 7680 7536 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 8 #() 1376 nil 41 nil nil nil 4818 0 nil 4850 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | item isViewed ifNil: [0] ifNotNil: [ :bool | bool ifTrue: [2] ifFalse: [1]]]' 8 #[32 105 226 0 100 223 3 97 62 106 70 119 64 106 63 106] #isViewed #ifNil:ifNotNil: #ifTrue:ifFalse: 8160 7 65793 nil 4818 0 nil 4850 2 1 4816 8 'doIt' 8 '[ :item | item isViewed == true]' 8 #[30 105 226 0 58 141 106] #isViewed 8240 7 257 nil nil nil nil #report 4560 nil 131171 nil 34 4 nil nil 514 1 1 nil nil 138 144 4560 nil nil nil 5 nil nil nil nil 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 2549 1053 4448 1090 #text: 34 1 8 'Title' 4448 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 4560 1376 nil 33 170 192 34 2 4448 8 'list' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 514 5119 21 514 2581 1201 416 1090 #text: 34 1 8 'Demo' 416 1090 #updateMenuBar 4560 416 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 9 15 0 0 98 2 0 0] 34 2 4448 576 1376 nil 27 )! !

!EditableListViewDemo class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

