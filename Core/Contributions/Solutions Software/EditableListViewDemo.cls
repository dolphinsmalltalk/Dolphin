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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 2581 1201 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil 466 #face3d nil 5 nil nil nil 560 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.CheckBox) 34 16 nil 560 34 2 8 1409363235 1 704 721990 2 ##(Smalltalk.ValueHolder) 0 nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 704 nil nil 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 193 736 8 'Row Image' 704 3 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 613 1122 #fixedViewLeft 171 1122 #fixedParentTop 9 1122 #fixedViewTop 61 410 ##(Smalltalk.CheckBox) 34 16 nil 560 34 2 8 1409363235 1 1200 770 0 nil 816 false nil nil 5 nil nil nil 1200 nil nil 834 nil nil nil 866 34 1 914 #createWindow: 34 1 962 994 8 #[152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 193 1232 8 'Column Images' 1200 3 8 #() 498 193 193 nil 27 1090 1136 817 1152 221 1168 9 1184 61 410 ##(Smalltalk.EmulatedPushButton) 34 30 nil 560 34 2 8 1140924416 1 1472 nil nil nil 5 nil nil nil 1472 nil nil 1180998 4 ##(Smalltalk.CommandDescription) #addRecording 8 '&Add Recording' 1 1 nil nil false nil nil nil #disabled 138 ##(Smalltalk.Dictionary) 34 6 721414 ##(Smalltalk.Association) #released 451 1618 #disabled 301 1618 #cold 451 1618 #enabled 751 1618 #hot 451 1618 #pressed 301 false 1 nil nil nil nil nil nil 866 34 2 914 #createWindow: 34 1 962 994 8 #[12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 193 1504 8 '&Add Recording' 1472 914 #isEnabled: 8 #(false) 1472 3 8 #() 498 193 193 nil 29 1090 1136 25 1152 241 1168 11 1184 51 410 ##(Smalltalk.SpinButton) 34 15 nil 560 34 2 8 1140916224 1 1936 770 0 nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2050 #hash 8 #() 1 480 nil 5 nil nil nil 1936 nil nil 834 nil nil 866 34 3 914 #createWindow: 34 1 962 994 8 #[228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 193 1968 8 '' 1936 914 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 21 3 1936 914 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 1936 3 8 #() 498 193 193 nil 27 1090 1136 457 1152 71 1168 11 1184 51 410 ##(Smalltalk.SpinButton) 34 15 nil 560 34 2 8 1140916224 1 2464 770 0 nil 2018 2050 #= 2080 2050 #hash 2112 1 480 nil 5 nil nil nil 2464 nil nil 834 nil nil 866 34 3 914 #createWindow: 34 1 962 994 8 #[153 2 0 0 5 0 0 0 188 2 0 0 30 0 0 0] 193 2496 8 '' 2464 914 #setRange: 34 1 2306 3 21 3 2464 914 #udmSetAccel: 34 1 2370 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 2464 3 8 #() 498 193 193 nil 27 1090 1136 1331 1152 71 1168 11 1184 51 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 2896 nil nil nil 5 nil nil nil 2896 nil nil 1538 #exit 8 'Close' 1 1 nil nil false nil nil nil 866 34 1 914 #createWindow: 34 1 962 994 8 #[155 4 0 0 5 0 0 0 240 4 0 0 30 0 0 0] 193 2928 8 'Close' 2896 3 8 #() 498 193 193 nil 29 1090 1122 #fixedParentRight -189 1152 171 1168 11 1184 51 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 65 3184 nil nil nil 5 nil nil nil 3184 nil nil 834 nil nil nil 866 34 2 914 #createWindow: 34 1 962 994 8 #[70 2 0 0 8 0 0 0 150 2 0 0 28 0 0 0] 193 3216 nil 3184 914 #text: 34 1 8 'Star Ratings' 3184 3 8 #() 498 193 193 nil 27 1090 1136 1165 1152 161 1168 17 1184 41 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 65 3472 nil nil nil 5 nil nil nil 3472 nil nil 834 nil nil nil 866 34 2 914 #createWindow: 34 1 962 994 8 #[153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 193 3504 nil 3472 914 #text: 34 1 8 'Row Height' 3472 3 8 #() 498 193 193 nil 27 1090 1136 307 1152 141 1168 21 1184 41 170 192 34 8 1200 8 'hasColumnImages' 704 8 'hasRowImage' 1936 8 'rowHeight' 2464 8 'starRatings' nil 866 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 193 592 8 '' 560 3 34 8 1472 1936 3472 704 1200 3184 2464 2896 498 193 193 nil 27 nil nil 410 ##(Smalltalk.EditableListView) 34 55 nil 416 34 2 8 1140920649 1025 4016 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 nil nil nil 4016 nil nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 498 65 65 nil nil 138 144 34 8 1447750 15 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2050 #title 8 #() #title 4016 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 8 '[ :colItem :item | item icon]' 8 #[30 105 226 32 106] #icon 4352 7 513 nil 1 4338 0 nil 4370 2 1 4336 8 'doIt' 8 '[ :colItem :prefix :item | item titleAndEpisode]' 8 #[30 105 226 64 106] #titleAndEpisode 4496 7 769 nil nil true 2050 #title: 8 #(nil) 1054022 22 ##(Smalltalk.EmbeddedTextEdit) nil nil 8 #(67174528 0) 4624 770 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 4624 nil nil 834 nil 8 '' 1 #focusLost nil nil nil nil nil nil nil nil nil nil nil nil 4258 8 'Episode Title' 401 #left 2050 #displayString 8 #() 2050 #<= 4784 2050 #episodeTitle 4784 nil 4016 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2050 #episodeTitle: 8 #(nil) 4610 nil nil 8 #(67174528 0) 4864 770 nil false 4688 nil 480 nil 5 nil nil nil 4864 nil nil nil 1 #focusLost nil nil nil nil nil nil nil nil nil nil nil nil 4258 8 'Description' 493 #left 2050 #displayString 4784 2050 #<= 4784 2050 #description 4784 nil 4016 ##(Smalltalk.IconicListAbstract) 3 nil nil true 2050 #description: 8 #(nil) 1643846 22 ##(Smalltalk.EmbeddedMultilineTextEdit) nil nil 8 #(69275972 0) 5040 770 nil false 4688 nil 480 nil 5 nil nil nil 5040 nil nil 834 nil 8 '' 9 #focusLost nil nil nil nil nil nil nil nil nil nil nil nil 4258 8 'Date' 201 #left 4338 0 nil 4370 4 1 2048 8 'doIt' 8 '[ :item | item ifNil: [''''] ifNotNil: [ :date | date shortString]]' 8 #[32 105 17 100 223 3 97 29 106 70 160 106] 8 '' #ifNil:ifNotNil: #shortString 5152 7 65793 nil 2050 #<= 8 #() 2050 #date 4320 nil 4016 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2050 #date: 8 #(nil) 1645126 22 ##(Smalltalk.EmbeddedFormattedTextEdit) nil nil 8 #(67174528 0) 5344 770 nil false 4688 nil 480 nil 5 nil nil nil 5344 nil nil 656454 1 ##(Smalltalk.DateToText) nil 8 '' nil nil 1 #focusLost nil nil nil false false 8 '__/__/____' 8 '/' $_ nil nil nil nil nil nil nil nil nil 4258 8 'Channel' 321 #left 2050 #displayString 5264 2050 #<= 5264 2050 #channel 4320 #channel 4016 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2050 #channel: 8 #(nil) 1053510 21 ##(Smalltalk.EmbeddedComboBox) nil nil 8 #(70321794 0) 5600 4082 138 144 4128 nil 4160 480 nil 5 nil nil nil 5600 nil nil 4338 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] #displayString 5664 7 257 nil 8 #() 401 nil true nil nil nil nil nil nil nil nil 4258 8 'Viewed?' 201 #center 2050 #displayString 5264 2050 #<= 5264 2050 #isViewed 4320 #isViewed 4016 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2050 #isViewed: 8 #(nil) 1053766 22 ##(Smalltalk.EmbeddedCheckBox) nil 655366 ##(Smalltalk.DeafObject) 34 2 8 1140924422 1 5904 770 nil false 4688 false 480 nil 5 nil nil nil 5904 nil nil 834 nil nil nil nil 8 '' true nil nil nil nil nil nil nil nil nil 4258 8 'Rating' 121 #left 2050 #displayString 4784 2050 #<= 4784 4338 0 nil 4370 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] #rating 6064 7 257 nil #starRating1 4016 nil 1 nil nil true 4338 0 nil 4370 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] #rating: 6144 7 513 nil 1250374 22 ##(Smalltalk.EmbeddedRadioButton) nil 5904 34 2 8 1140924425 1 5904 770 nil false 4688 false 480 nil 5 nil nil nil 5904 nil nil 834 nil nil nil nil 8 '1*' true nil nil nil nil 4338 0 nil 4370 3 1 4336 8 'doIt' 8 '[ :recording | recording rating ifNil: [0]]' 8 #[31 105 226 0 100 223 2 97 62 106] #rating #ifNil: 6336 7 257 nil nil nil nil nil 4258 8 '' 201 #left 2050 #displayString 8 #() 2050 #<= 6464 nil nil 4016 nil 1 4338 0 nil 4370 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 6496 7 257 nil nil true nil 1188678 20 ##(Smalltalk.EmbeddedPushButton) nil 5904 34 2 8 1140925248 1 5904 nil 480 498 nil 61 5 nil nil nil 5904 nil nil 1538 #deleteSelectedRecording 8 'Delete' 1 1 nil 262982 4 ##(Smalltalk.Icon) 0 true 2229254 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil false nil nil nil nil 138 ##(Smalltalk.Dictionary) 34 6 1618 #released 451 1618 #disabled 301 1618 #cold 451 1618 #enabled 751 1618 #hot 451 1618 #pressed 301 nil nil nil 498 33 33 787526 1 ##(Smalltalk.ImageManager) 170 176 34 2 6720 3 170 176 4128 nil nil 3 nil nil nil nil nil nil 6688 nil nil nil 4338 0 nil 4370 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | item isViewed ifNil: [0] ifNotNil: [ :bool | bool ifTrue: [2] ifFalse: [1]]]' 8 #[32 105 226 0 100 223 3 97 62 106 70 119 64 106 63 106] #isViewed #ifNil:ifNotNil: #ifTrue:ifFalse: 7056 7 65793 nil 4338 0 nil 4370 2 1 4336 8 'doIt' 8 '[ :item | item isViewed == true]' 8 #[30 105 226 0 58 141 106] #isViewed 7136 7 257 nil nil nil nil #report 8 #() nil 131171 nil 1 nil nil nil nil 1 1638662 ##(Smalltalk.ListViewVirtualUpdateMode) 4016 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 34 1 914 #createWindow: 34 1 962 994 8 #[0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 193 4048 8 'Title' 4016 3 8 #() 498 193 193 nil 33 170 192 34 2 4016 8 'list' nil nil nil nil nil 1 nil nil nil nil nil nil 193 866 34 1 914 #createWindow: 34 1 962 590342 ##(Smalltalk.Rectangle) 498 6143 21 498 8723 1221 193 448 8 'Demo' 416 1 34 2 4016 560 498 193 193 nil 27 )! !

!EditableListViewDemo class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

