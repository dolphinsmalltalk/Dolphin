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

	^#(#'!!STL' 4 2126 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 6 ##(Smalltalk.Color) #default 518 ##(Smalltalk.Point) 2581 1201 551 nil nil nil 416 1798 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 560 nil 466 #face3d nil 7 nil nil nil 560 262 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.EmulatedPushButton) 34 30 nil 560 34 2 8 1140924416 1 704 nil nil nil 7 nil nil nil 704 nil 8 1837122896 1350 4 ##(Smalltalk.CommandDescription) #addRecording 8 '&Add Recording' 1 1 nil nil false nil nil nil #disabled 138 ##(Smalltalk.Dictionary) 34 6 518 ##(Smalltalk.Association) #released 451 866 #disabled 301 866 #cold 451 866 #enabled 751 866 #hot 451 866 #pressed 301 false 1 nil nil nil nil nil nil 262 ##(Smalltalk.MessageSequence) 34 3 774 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 25 11 498 241 51 704 1026 #isEnabled: 8 #(false) 704 1026 #text: 34 1 8 '&Add Recording' 704 262 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 8 #() 498 193 193 nil 29 2118 2 ##(Smalltalk.FramingConstraints) 1030 ##(Smalltalk.FramingCalculation) #fixedParentLeft 25 1298 #fixedViewLeft 241 1298 #fixedParentTop 11 1298 #fixedViewTop 51 410 ##(Smalltalk.CheckBox) 34 16 nil 560 34 2 8 1409363235 1 1376 1094 2 ##(Smalltalk.ValueHolder) nil nil 6 ##(Smalltalk.NeverSearchPolicy) false nil nil 7 nil nil nil 1376 nil 8 1837122896 518 ##(Smalltalk.NullConverter) nil nil nil 978 34 2 1026 #createAt:extent: 34 2 498 817 9 498 221 61 1376 1026 #text: 34 1 8 'Column Images' 1376 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 8 #() 1248 nil 27 1266 1312 817 1328 221 1344 9 1360 61 410 ##(Smalltalk.PushButton) 34 20 nil 560 34 2 8 1140924416 1 1760 nil nil nil 7 nil nil nil 1760 nil 8 1837122896 786 #exit 8 'Close' 1 1 nil nil false nil nil nil 978 34 2 1026 #createAt:extent: 34 2 498 2359 11 498 171 51 1760 1026 #text: 34 1 8 'Close' 1760 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 4 0 0 5 0 0 0 240 4 0 0 30 0 0 0] 8 #() 1248 nil 29 1266 1298 #fixedParentRight -189 1328 171 1344 11 1360 51 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 65 2096 nil nil nil 7 nil nil nil 2096 nil 8 1837327488 1522 nil nil nil 978 34 2 1026 #createAt:extent: 34 2 498 1165 17 498 161 41 2096 1026 #text: 34 1 8 'Star Ratings' 2096 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 2 0 0 8 0 0 0 150 2 0 0 28 0 0 0] 8 #() 1248 nil 27 1266 1312 1165 1328 161 1344 17 1360 41 410 ##(Smalltalk.SpinButton) 34 15 nil 560 34 2 8 1140916224 1 2400 1442 nil nil 518 ##(Smalltalk.PluggableSearchPolicy) 518 ##(Smalltalk.Message) #= 8 #() 2514 #hash 8 #() 1 480 nil 7 nil nil nil 2400 nil 8 1837036144 1522 nil nil 978 34 3 1026 #createAt:extent: 34 2 498 457 11 498 71 51 2400 1026 #setRange: 34 1 774 ##(Smalltalk.Interval) 3 21 3 2400 1026 #udmSetAccel: 34 1 1350 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 2400 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 8 #() 1248 nil 27 1266 1312 457 1328 71 1344 11 1360 51 410 ##(Smalltalk.CheckBox) 34 16 nil 560 34 2 8 1409363235 1 2928 1442 nil nil 1488 false nil nil 7 nil nil nil 2928 nil 8 1837122896 1522 nil nil nil 978 34 2 1026 #createAt:extent: 34 2 498 613 9 498 171 61 2928 1026 #text: 34 1 8 'Row Image' 2928 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 8 #() 1248 nil 27 1266 1312 613 1328 171 1344 9 1360 61 410 ##(Smalltalk.StaticText) 34 16 nil 560 34 2 8 1140850944 65 3248 nil nil nil 7 nil nil nil 3248 nil 8 1837327488 1522 nil nil nil 978 34 2 1026 #createAt:extent: 34 2 498 307 21 498 141 41 3248 1026 #text: 34 1 8 'Row Height' 3248 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 8 #() 1248 nil 27 1266 1312 307 1328 141 1344 21 1360 41 410 ##(Smalltalk.SpinButton) 34 15 nil 560 34 2 8 1140916224 1 3552 1442 nil nil 2482 2514 #= 2544 2514 #hash 2576 1 480 nil 7 nil nil nil 3552 nil 8 1837036144 1522 nil nil 978 34 3 1026 #createAt:extent: 34 2 498 1331 11 498 71 51 3552 1026 #setRange: 34 1 2754 3 21 3 3552 1026 #udmSetAccel: 34 1 2818 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) nil 17 3552 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 2 0 0 5 0 0 0 188 2 0 0 30 0 0 0] 8 #() 1248 nil 27 1266 1312 1331 1328 71 1344 11 1360 51 170 192 34 8 3552 8 'starRatings' 2928 8 'hasRowImage' 2400 8 'rowHeight' 1376 8 'hasColumnImages' nil 978 34 1 1026 #createAt:extent: 34 2 498 1 1053 498 2549 71 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 34 8 704 2400 3248 2928 1376 2096 3552 1760 1248 nil 27 nil nil 410 ##(Smalltalk.EditableListView) 34 55 nil 416 34 2 8 1140920649 1025 4224 838 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 6 ##(Smalltalk.IdentitySearchPolicy) 480 nil 7 nil nil nil 4224 nil 8 1837183200 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1350 1 ##(Smalltalk.IconImageManager) nil nil nil 498 65 65 nil nil 138 144 34 8 5958 15 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2514 #title 8 #() #title 4224 1382 3 ##(Smalltalk.BlockClosure) 0 nil 1318 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.IconicListAbstract class) 8 'doIt' 8 '[ :colItem :item | item icon]' 8 #[30 105 226 32 106] #icon 4576 7 513 nil 1 4562 0 nil 4594 2 1 4560 8 'doIt' 8 '[ :colItem :prefix :item | item titleAndEpisode]' 8 #[30 105 226 64 106] #titleAndEpisode 4672 7 769 nil nil true 2514 #title: 8 #(nil) 5446 22 ##(Smalltalk.EmbeddedTextEdit) nil nil 8 #(67174528 0) 4800 1442 nil false 6 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 4800 nil nil 1522 nil 8 '' 1 #focusLost nil nil nil nil nil nil nil nil nil nil nil nil 4482 8 'Episode Title' 401 #left 2514 #displayString 8 #() 2514 #<= 4960 2514 #episodeTitle 4960 nil 4224 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2514 #episodeTitle: 8 #(nil) 4786 nil nil 8 #(67174528 0) 5040 1442 nil false 4864 nil 480 nil 5 nil nil nil 5040 nil nil nil 1 #focusLost nil nil nil nil nil nil nil nil nil nil nil nil 4482 8 'Description' 493 #left 2514 #displayString 4960 2514 #<= 4960 2514 #description 4960 nil 4224 ##(Smalltalk.IconicListAbstract) 3 nil nil true 2514 #description: 8 #(nil) 5446 22 ##(Smalltalk.EmbeddedMultilineTextEdit) nil nil 8 #(69275972 0) 5216 1442 nil false 4864 nil 480 nil 5 nil nil nil 5216 nil nil 1522 nil 8 '' 9 #focusLost nil nil nil nil nil nil nil nil nil nil nil nil 4482 8 'Date' 201 #left 4562 0 nil 4594 4 1 2512 8 'doIt' 8 '[ :item | item ifNil: [''''] ifNotNil: [ :date | date shortString]]' 8 #[32 105 17 100 223 3 97 29 106 70 160 106] 8 '' #ifNil:ifNotNil: #shortString 5328 7 65793 nil 2514 #<= 8 #() 2514 #date 4544 nil 4224 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2514 #date: 8 #(nil) 6726 22 ##(Smalltalk.EmbeddedFormattedTextEdit) nil nil 8 #(67174528 0) 5520 1442 nil false 4864 nil 480 nil 5 nil nil nil 5520 nil nil 1094 1 ##(Smalltalk.DateToText) nil 8 '' nil nil 1 #focusLost nil nil nil false false 8 '__/__/____' 8 '/' $_ nil nil nil nil nil nil nil nil nil 4482 8 'Channel' 321 #left 2514 #displayString 5440 2514 #<= 5440 2514 #channel 4544 #channel 4224 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2514 #channel: 8 #(nil) 4934 21 ##(Smalltalk.EmbeddedComboBox) nil nil 8 #(70321794 0) 5776 4290 138 144 4336 nil 4368 480 nil 5 nil nil nil 5776 nil nil 4562 0 nil 1318 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] #displayString 5840 7 257 nil 8 #() 401 nil true nil nil nil nil nil nil nil nil 4482 8 'Viewed?' 201 #center 2514 #displayString 5440 2514 #<= 5440 2514 #isViewed 4544 #isViewed 4224 ##(Smalltalk.IconicListAbstract) 1 nil nil true 2514 #isViewed: 8 #(nil) 410 ##(Smalltalk.EmbeddedCheckBox) 34 20 nil nil 34 2 8 1140924422 1 6032 1442 nil false 4864 false 480 nil 5 nil nil nil 6032 nil 8 1837122896 1522 nil nil nil nil 8 '' true nil 978 34 1 1026 #createAt:extent: 34 2 498 1 1 498 201 51 6032 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1248 nil 45 nil nil nil nil nil nil nil nil 4482 8 'Rating' 121 #left 2514 #displayString 4960 2514 #<= 4960 4562 0 nil 4594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] #rating 6368 7 257 nil #starRating1 4224 nil 1 nil nil true 4562 0 nil 4594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] #rating: 6448 7 513 nil 410 ##(Smalltalk.EmbeddedRadioButton) 34 20 nil nil 34 2 8 1140924425 1 6528 1442 nil false 4864 false 480 nil 5 nil nil nil 6528 nil 8 1837122896 1522 nil nil nil nil 8 '1*' true nil 978 34 2 1026 #createAt:extent: 34 2 498 1 1 498 201 51 6528 1026 #text: 34 1 6640 6528 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1248 nil 45 nil nil nil 4562 0 nil 4594 3 1 4560 8 'doIt' 8 '[ :recording | recording rating ifNil: [0]]' 8 #[31 105 226 0 100 223 2 97 62 106] #rating #ifNil: 6832 7 257 nil nil nil nil nil 4482 8 '' 201 #left 2514 #displayString 8 #() 2514 #<= 6960 nil nil 4224 nil 1 4562 0 nil 4594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 6992 7 257 nil nil true nil 410 ##(Smalltalk.EmbeddedPushButton) 34 35 nil nil 34 2 8 1140925248 1 7088 nil 480 498 nil 61 5 nil nil nil 7088 nil 8 1837122896 786 #deleteSelectedRecording 8 'Delete' 1 1 nil 838 4 ##(Smalltalk.Icon) nil true 1030 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'False.ico' 526 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil false nil nil nil nil 138 ##(Smalltalk.Dictionary) 34 6 866 #released 451 866 #disabled 301 866 #cold 451 866 #enabled 751 866 #hot 451 866 #pressed 301 nil nil nil 498 33 33 nil 3 nil nil nil nil nil nil 7200 978 34 2 1026 #createAt:extent: 34 2 498 1 1 498 1 1 7088 1026 #text: 34 1 7200 7088 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 8 #() 1248 nil 41 nil nil nil 4562 0 nil 4594 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | item isViewed ifNil: [0] ifNotNil: [ :bool | bool ifTrue: [2] ifFalse: [1]]]' 8 #[32 105 226 0 100 223 3 97 62 106 70 119 64 106 63 106] #isViewed #ifNil:ifNotNil: #ifTrue:ifFalse: 7664 7 65793 nil 4562 0 nil 4594 2 1 4560 8 'doIt' 8 '[ :item | item isViewed == true]' 8 #[30 105 226 0 58 141 106] #isViewed 7744 7 257 nil nil nil nil #report 8 #() nil 131171 nil 1 nil nil nil nil 1 5 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 978 34 2 1026 #createAt:extent: 34 2 498 1 1 498 2549 1053 4224 1026 #text: 34 1 8 'Title' 4224 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 8 #() 1248 nil 33 170 192 34 2 4224 8 'list' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 978 34 2 1026 #createAt:extent: 34 2 498 6143 21 498 2581 1201 416 1026 #text: 34 1 8 'Demo' 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 9 17 0 0 98 2 0 0] 34 2 4224 560 1248 nil 27)! !
!EditableListViewDemo class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

