"Filed out from Dolphin Smalltalk 7"!

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

	starRatingsPresenter view range: (1 to: self maxStarRatings).
	starRatingsPresenter model value: 3!

queryCommand: aCommandQuery

	| cmd |

	cmd := aCommandQuery commandSymbol.

	cmd = #removeRecordings ifTrue:
		[aCommandQuery isEnabled: listPresenter hasSelection.
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
!EditableListViewDemo categoriesFor: #addRecording!commands!public! !
!EditableListViewDemo categoriesFor: #channelColumn!accessing!public! !
!EditableListViewDemo categoriesFor: #createComponents!initializing!public! !
!EditableListViewDemo categoriesFor: #createSchematicWiring!initializing!public! !
!EditableListViewDemo categoriesFor: #deleteSelectedRecording!commands!public! !
!EditableListViewDemo categoriesFor: #maxStarRatings!accessing!public! !
!EditableListViewDemo categoriesFor: #model:!accessing!public! !
!EditableListViewDemo categoriesFor: #onHasColumnImagesChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onHasRowImageChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onRowHeightChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onSelectionChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onStarRatingsChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onViewOpened!event handling!public! !
!EditableListViewDemo categoriesFor: #queryCommand:!commands!public! !
!EditableListViewDemo categoriesFor: #showStarRatings:!helpers!public! !
!EditableListViewDemo categoriesFor: #titleColumn!accessing!public! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 2581 1201 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 576 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 576 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.CheckBox) 34 16 0 576 34 2 8 1409363235 1 736 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) false 0 0 7 0 0 0 736 0 8 4294906547 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 613 9 514 171 61 736 978 #text: 34 1 8 'Row Image' 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 8 #() 514 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 613 1218 #fixedViewLeft 171 1218 #fixedParentTop 9 1218 #fixedViewTop 61 410 ##(Smalltalk.SpinButton) 34 15 0 576 34 2 8 1140916224 1 1296 802 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1410 #hash 8 #() 1 466 8 4278190080 0 7 0 0 0 1296 0 8 4294902729 882 0 0 914 138 144 34 3 978 #createAt:extent: 34 2 514 457 11 514 71 51 1296 978 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 21 3 1296 978 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) 0 17 1296 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 8 #() 1168 0 27 1186 1232 457 1248 71 1264 11 1280 51 410 ##(Smalltalk.SpinButton) 34 15 0 576 34 2 8 1140916224 1 1872 802 0 0 1378 1410 #= 1440 1410 #hash 1472 1 466 1504 0 7 0 0 0 1872 0 8 4294902729 882 0 0 914 138 144 34 3 978 #createAt:extent: 34 2 514 1331 11 514 71 51 1872 978 #setRange: 34 1 1698 3 21 3 1872 978 #udmSetAccel: 34 1 1762 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) 0 17 1872 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 2 0 0 5 0 0 0 188 2 0 0 30 0 0 0] 8 #() 1168 0 27 1186 1232 1331 1248 71 1264 11 1280 51 410 ##(Smalltalk.PushButton) 34 20 0 576 34 2 8 1140924416 1 2336 0 0 0 7 0 0 0 2336 0 8 4294906547 1180998 4 ##(Smalltalk.CommandDescription) #exit 8 'Close' 1 1 0 0 false 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 514 2359 11 514 171 51 2336 978 #text: 34 1 8 'Close' 2336 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 4 0 0 5 0 0 0 240 4 0 0 30 0 0 0] 8 #() 1168 0 29 1186 1218 #fixedParentRight -189 1248 171 1264 11 1280 51 410 ##(Smalltalk.StaticText) 34 16 0 576 34 2 8 1140850944 65 2704 0 0 0 7 0 0 0 2704 0 8 4294906669 882 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 514 307 21 514 141 41 2704 978 #text: 34 1 8 'Row Height' 2704 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 8 #() 1168 0 27 1186 1232 307 1248 141 1264 21 1280 41 410 ##(Smalltalk.CheckBox) 34 16 0 576 34 2 8 1409363235 1 3024 802 0 0 848 false 0 0 7 0 0 0 3024 0 8 4294906547 882 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 514 817 9 514 221 61 3024 978 #text: 34 1 8 'Column Images' 3024 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 8 #() 1168 0 27 1186 1232 817 1248 221 1264 9 1280 61 410 ##(Smalltalk.StaticText) 34 16 0 576 34 2 8 1140850944 65 3360 0 0 0 7 0 0 0 3360 0 8 4294906669 882 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 514 1165 17 514 161 41 3360 978 #text: 34 1 8 'Star Ratings' 3360 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 70 2 0 0 8 0 0 0 150 2 0 0 28 0 0 0] 8 #() 1168 0 27 1186 1232 1165 1248 161 1264 17 1280 41 410 ##(Smalltalk.EmulatedPushButton) 34 30 0 576 34 2 8 1140924416 1 3680 0 0 0 7 0 0 0 3680 0 8 4294906547 2418 #addRecording 8 '&Add Recording' 1 1 0 0 false 0 0 0 #disabled 138 ##(Smalltalk.Dictionary) 34 6 721414 ##(Smalltalk.Association) #disabled 301 3826 #enabled 751 3826 #cold 451 3826 #released 451 3826 #hot 451 3826 #pressed 301 false 1 0 0 0 0 0 0 914 138 144 34 3 978 #createAt:extent: 34 2 514 25 11 514 241 51 3680 978 #isEnabled: 8 #(false) 3680 978 #text: 34 1 8 '&Add Recording' 3680 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 8 #() 1168 0 29 1186 1232 25 1248 241 1264 11 1280 51 170 192 34 8 3024 8 'hasColumnImages' 1296 8 'rowHeight' 736 8 'hasRowImage' 1872 8 'starRatings' 0 914 138 144 34 1 978 #createAt:extent: 34 2 514 1 1053 514 2549 71 576 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 34 8 3680 1296 2704 736 3024 3360 1872 2336 1168 0 27 0 0 410 ##(Smalltalk.EditableListView) 34 40 0 416 34 2 8 1140920649 1025 4448 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 0 7 0 0 0 4448 0 8 4294902461 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 514 65 65 0 0 138 144 34 8 1447750 15 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 1410 #title 8 #() #title 4448 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 8 '[ :colItem :item | item icon]' 8 #[30 105 226 32 106] #icon 4832 7 513 0 1 4818 0 0 4850 2 1 4816 8 'doIt' 8 '[ :colItem :prefix :item | item titleAndEpisode]' 8 #[30 105 226 64 106] #titleAndEpisode 4976 7 769 0 0 true 1410 #title: 8 #(nil) 1052998 20 ##(Smalltalk.EmbeddedTextEdit) 0 0 8 #(67174528 0) 5104 802 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 0 0 5 0 0 0 5104 0 0 882 0 8 '' 1 0 0 0 0 0 0 0 0 0 4738 8 'Episode Title' 401 #left 1410 #displayString 8 #() 1410 #<= 5264 1410 #episodeTitle 5264 0 4448 ##(Smalltalk.IconicListAbstract) 1 0 0 true 1410 #episodeTitle: 8 #(nil) 5090 0 0 8 #(67174528 0) 5344 802 0 false 5168 0 466 8 4278190080 0 5 0 0 0 5344 0 0 0 1 0 0 0 0 0 0 0 0 0 4738 8 'Description' 493 #left 1410 #displayString 5264 1410 #<= 5264 1410 #description 5264 0 4448 ##(Smalltalk.IconicListAbstract) 3 0 0 true 1410 #description: 8 #(nil) 1642822 20 ##(Smalltalk.EmbeddedMultilineTextEdit) 0 0 8 #(69275972 0) 5552 802 0 false 5168 0 466 5408 0 5 0 0 0 5552 0 0 882 0 8 '' 9 0 0 0 0 0 0 0 0 0 4738 8 'Date' 201 #left 4818 0 0 4850 4 1 1408 8 'doIt' 8 '[ :item | item ifNil: [''''] ifNotNil: [ :date | date shortString]]' 8 #[32 105 17 100 223 3 97 29 106 70 160 106] 8 '' #ifNil:ifNotNil: #shortString 5680 7 65793 0 1410 #<= 8 #() 1410 #date 4800 0 4448 ##(Smalltalk.IconicListAbstract) 1 0 0 true 1410 #date: 8 #(nil) 1644102 21 ##(Smalltalk.EmbeddedFormattedTextEdit) 0 0 8 #(67174528 0) 5872 802 0 false 5168 0 466 8 4278190080 0 5 0 0 0 5872 0 0 656454 1 ##(Smalltalk.DateToText) 0 8 '' 0 0 1 false false 8 '__/__/____' 8 '/' $_ 0 0 0 0 0 0 0 0 0 4738 8 'Channel' 321 #left 1410 #displayString 5792 1410 #<= 5792 1410 #channel 4800 #channel 4448 ##(Smalltalk.IconicListAbstract) 1 0 0 true 1410 #channel: 8 #(nil) 1053510 20 ##(Smalltalk.EmbeddedComboBox) 0 0 8 #(70321794 0) 6160 4514 138 144 4560 0 4592 466 5936 0 5 0 0 0 6160 0 0 4818 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] #displayString 6240 7 257 0 0 401 0 true 0 0 0 0 0 0 0 0 4738 8 'Viewed?' 161 #center 1410 #displayString 5792 1410 #<= 5792 1410 #isViewed 4800 0 4448 ##(Smalltalk.IconicListAbstract) 1 0 0 true 1410 #isViewed: 8 #(nil) 410 ##(Smalltalk.EmbeddedCheckBox) 34 19 0 0 34 2 8 1140924422 1 6416 802 0 false 5168 false 466 5936 0 5 0 0 0 6416 0 8 4294906547 882 0 0 0 0 8 '' true 914 138 144 34 1 978 #createAt:extent: 34 2 514 1 1 514 201 51 6416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1168 0 43 0 0 0 0 0 0 0 0 4738 8 'Rating' 121 #left 1410 #displayString 5264 1410 #<= 5264 4818 0 0 4850 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] #rating 6784 7 257 0 #starRating1 4448 0 1 0 0 true 4818 0 0 4850 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] #rating: 6864 7 513 0 410 ##(Smalltalk.EmbeddedRadioButton) 34 19 0 0 34 2 8 1140924425 1 6944 802 0 false 5168 false 466 5408 0 5 0 0 0 6944 0 8 4294906547 882 0 0 0 0 8 '1*' true 914 138 144 34 2 978 #createAt:extent: 34 2 514 1 1 514 201 51 6944 978 #text: 34 1 7072 6944 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1168 0 43 0 0 0 4818 0 0 4850 3 1 4816 8 'doIt' 8 '[ :recording | recording rating ifNil: [0]]' 8 #[31 105 226 0 100 223 2 97 62 106] #rating #ifNil: 7280 7 257 0 0 0 0 0 4738 8 '' 201 #left 1410 #displayString 8 #() 1410 #<= 7408 0 0 4448 0 1 4818 0 0 4850 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 7440 7 257 0 0 true 0 410 ##(Smalltalk.EmbeddedPushButton) 34 35 0 0 34 2 8 1140925248 1 7536 0 466 8 4278190080 514 0 61 5 0 0 0 7536 0 8 4294906547 2418 #deleteSelectedRecording 8 'Delete' 1 1 0 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 false 0 0 0 0 138 ##(Smalltalk.Dictionary) 34 6 3826 #disabled 301 3826 #enabled 751 3826 #cold 451 3826 #released 451 3826 #hot 451 3826 #pressed 301 0 0 0 514 33 33 0 3 0 0 0 0 0 0 7680 914 138 144 34 2 978 #createAt:extent: 34 2 514 1 1 514 1 1 7536 978 #text: 34 1 7680 7536 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 8 #() 1168 0 41 0 0 0 4818 0 0 4850 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | item isViewed ifNil: [0] ifNotNil: [ :bool | bool ifTrue: [2] ifFalse: [1]]]' 8 #[32 105 226 0 100 223 3 97 62 106 70 119 64 106 63 106] #isViewed #ifNil:ifNotNil: #ifTrue:ifFalse: 8160 7 65793 0 4818 0 0 4850 2 1 4816 8 'doIt' 8 '[ :item | item isViewed == true]' 8 #[30 105 226 0 58 141 106] #isViewed 8240 7 257 0 0 0 0 #report 4560 0 131171 0 34 4 0 0 514 1 1 0 0 138 144 4560 0 0 0 5 0 0 0 0 914 138 144 34 2 978 #createAt:extent: 34 2 514 1 1 514 2549 1053 4448 978 #text: 34 1 8 'Title' 4448 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 8 #() 1168 0 31 170 192 34 2 4448 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 914 138 144 34 3 978 #createAt:extent: 34 2 514 5119 21 514 2581 1201 416 978 #text: 34 1 8 'Demo' 416 978 #updateMenuBar 4560 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 9 15 0 0 98 2 0 0] 34 2 4448 576 1168 0 27 )! !
!EditableListViewDemo class categoriesFor: #defaultModel!models!public! !
!EditableListViewDemo class categoriesFor: #resource_Default_view!public!resources-views! !

