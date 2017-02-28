"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #EditableListViewDemo
	instanceVariableNames: 'listPresenter rowHeightPresenter hasRowImagePresenter hasColumnImagesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EditableListViewDemo guid: (GUID fromString: '{E27B5B72-70DE-474C-A0CC-B14EE3FDC1EB}')!
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
	hasColumnImagesPresenter := self add: BooleanPresenter new name: 'hasColumnImages'!

createSchematicWiring

	super createSchematicWiring.

	listPresenter when: #selectionChanged send: #onSelectionChanged to: self.
	rowHeightPresenter when: #valueChanged send: #onRowHeightChanged to: self.
	hasRowImagePresenter when: #valueChanged send: #onHasRowImageChanged to: self.
	hasColumnImagesPresenter when: #valueChanged send: #onHasColumnImagesChanged to: self!

deleteSelectedRecording

	listPresenter model remove: listPresenter selection!

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

onViewOpened

	super onViewOpened.

	rowHeightPresenter model value: listPresenter view rowHeight.
	hasRowImagePresenter model value: listPresenter view getImageBlock notNil.
	hasColumnImagesPresenter model value: listPresenter view hasColumnImages.

	self titleColumn editor cueBanner: 'enter a title'.

	self channelColumn editor model searchPolicy: SearchPolicy caseInsensitive.
	self channelColumn editor choices: #('BBC1' 'BBC2' 'ITV' 'Channel 4')!

queryCommand: aCommandQuery

	| cmd |

	cmd := aCommandQuery commandSymbol.

	cmd = #removeRecordings ifTrue:
		[aCommandQuery isEnabled: listPresenter hasSelection.
		^true].

	^super queryCommand: aCommandQuery
!

titleColumn

	^listPresenter view columnNamed: #title! !
!EditableListViewDemo categoriesFor: #addRecording!commands!public! !
!EditableListViewDemo categoriesFor: #channelColumn!accessing!public! !
!EditableListViewDemo categoriesFor: #createComponents!initializing!public! !
!EditableListViewDemo categoriesFor: #createSchematicWiring!initializing!public! !
!EditableListViewDemo categoriesFor: #deleteSelectedRecording!commands!public! !
!EditableListViewDemo categoriesFor: #model:!accessing!public! !
!EditableListViewDemo categoriesFor: #onHasColumnImagesChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onHasRowImageChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onRowHeightChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onSelectionChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onViewOpened!event handling!public! !
!EditableListViewDemo categoriesFor: #queryCommand:!commands!public! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 2581 1201 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 576 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 576 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.SpinButton) 34 15 0 576 34 2 8 1140916224 1 736 721990 2 ##(Smalltalk.ValueHolder) 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 866 #hash 8 #() 1 466 8 4278190080 0 7 0 0 0 736 0 8 4294902581 852486 ##(Smalltalk.NullConverter) 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 457 11 514 71 51 736 1090 #setRange: 34 1 525062 ##(Smalltalk.Interval) 3 21 3 736 1090 #udmSetAccel: 34 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 ##(Smalltalk.UDACCEL) 0 17 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 8 #() 514 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 457 1426 #fixedViewLeft 71 1426 #fixedParentTop 11 1426 #fixedViewTop 51 410 ##(Smalltalk.EmulatedPushButton) 34 30 0 576 34 2 8 1140924416 1 1504 0 0 0 7 0 0 0 1504 0 8 4294907985 1180998 4 ##(Smalltalk.CommandDescription) #addRecording 8 '&Add Recording' 1 1 0 0 false 0 0 0 #disabled 138 ##(Smalltalk.Dictionary) 34 6 721414 ##(Smalltalk.Association) #hot 451 1666 #pressed 301 1666 #enabled 751 1666 #released 451 1666 #cold 451 1666 #disabled 301 false 1 0 0 0 0 0 0 1026 138 144 34 3 1090 #createAt:extent: 34 2 514 25 11 514 241 51 1504 1090 #isEnabled: 8 #(false) 1504 1090 #text: 34 1 8 '&Add Recording' 1504 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 8 #() 1376 0 29 1394 1440 25 1456 241 1472 11 1488 51 410 ##(Smalltalk.CheckBox) 34 16 0 576 34 2 8 1409363235 1 2032 802 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) false 0 0 7 0 0 0 2032 0 8 4294907985 994 0 0 0 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 613 9 514 171 61 2032 1090 #text: 34 1 8 'Row Image' 2032 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 8 #() 1376 0 27 1394 1440 613 1456 171 1472 9 1488 61 410 ##(Smalltalk.CheckBox) 34 16 0 576 34 2 8 1409363235 1 2400 802 0 0 2128 false 0 0 7 0 0 0 2400 0 8 4294907985 994 0 0 0 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 817 9 514 221 61 2400 1090 #text: 34 1 8 'Column Images' 2400 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 8 #() 1376 0 27 1394 1440 817 1456 221 1472 9 1488 61 410 ##(Smalltalk.PushButton) 34 20 0 576 34 2 8 1140924416 1 2736 0 0 0 7 0 0 0 2736 0 8 4294907985 1586 #exit 8 'Close' 1 1 0 0 false 0 0 0 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 2359 11 514 171 51 2736 1090 #text: 34 1 8 'Close' 2736 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 155 4 0 0 5 0 0 0 240 4 0 0 30 0 0 0] 8 #() 1376 0 29 1394 1426 #fixedParentRight -189 1456 171 1472 11 1488 51 410 ##(Smalltalk.StaticText) 34 16 0 576 34 2 8 1140850944 65 3088 0 0 0 7 0 0 0 3088 0 8 4294905019 994 0 0 0 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 307 21 514 141 41 3088 1090 #text: 34 1 8 'Row Height' 3088 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 8 #() 1376 0 27 1394 1440 307 1456 141 1472 21 1488 41 170 192 34 6 2032 8 'hasRowImage' 736 8 'rowHeight' 2400 8 'hasColumnImages' 0 1026 138 144 34 1 1090 #createAt:extent: 34 2 514 1 1053 514 2549 71 576 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 34 6 1504 736 3088 2032 2400 2736 1376 0 27 0 0 410 ##(Smalltalk.EditableListView) 34 40 0 416 34 2 8 1140920649 1025 3648 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 0 7 0 0 0 3648 0 8 4294907523 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 514 65 65 0 0 138 144 34 10 1447750 15 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 866 #title 8 #() #title 3648 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin Common Controls' 8 'IconicListAbstract' 8 'doIt' 8 '[ :colItem :item | item icon]' 8 #[30 105 226 32 106] #icon 4032 7 513 0 1 4018 0 0 4050 2 1 4016 8 'doIt' 8 '[ :colItem :prefix :item | item titleAndEpisode]' 8 #[30 105 226 64 106] #titleAndEpisode 4176 7 769 0 0 true 866 #title: 8 #(nil) 1052998 20 ##(Smalltalk.EmbeddedTextEdit) 0 0 8 #(67174528 0) 4304 802 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 0 0 5 0 0 0 4304 0 0 994 0 8 '' 1 0 0 0 0 0 0 0 0 0 3938 8 'Episode Title' 401 #left 866 #displayString 8 #() 866 #<= 4464 866 #episodeTitle 4464 0 3648 ##(Smalltalk.IconicListAbstract) 1 0 0 true 866 #episodeTitle: 8 #(nil) 4290 0 0 8 #(67174528 0) 4544 802 0 false 4368 0 466 8 4278190080 0 5 0 0 0 4544 0 0 0 1 0 0 0 0 0 0 0 0 0 3938 8 'Description' 493 #left 866 #displayString 4464 866 #<= 4464 866 #description 4464 0 3648 ##(Smalltalk.IconicListAbstract) 3 0 0 true 866 #description: 8 #(nil) 1642822 20 ##(Smalltalk.EmbeddedMultilineTextEdit) 0 0 8 #(69275972 0) 4752 802 0 false 4368 0 466 4608 0 5 0 0 0 4752 0 0 994 0 8 '' 9 0 0 0 0 0 0 0 0 0 3938 8 'Date' 201 #left 4018 0 0 4050 4 1 864 8 'doIt' 8 '[ :item | item ifNil: [''''] ifNotNil: [ :date | date shortString]]' 8 #[32 105 17 100 223 3 97 29 106 70 160 106] 8 '' #ifNil:ifNotNil: #shortString 4880 7 65793 0 866 #<= 8 #() 866 #date 4000 0 3648 ##(Smalltalk.IconicListAbstract) 1 0 0 true 866 #date: 8 #(nil) 1644102 21 ##(Smalltalk.EmbeddedFormattedTextEdit) 0 0 8 #(67174528 0) 5072 802 0 false 4368 0 466 8 4278190080 0 5 0 0 0 5072 0 0 656454 1 ##(Smalltalk.DateToText) 0 8 '' 0 0 1 false false 8 '__/__/____' 8 '/' $_ 0 0 0 0 0 0 0 0 0 3938 8 'Channel' 321 #left 866 #displayString 4992 866 #<= 4992 866 #channel 4000 #channel 3648 ##(Smalltalk.IconicListAbstract) 1 0 0 true 866 #channel: 8 #(nil) 1053510 20 ##(Smalltalk.EmbeddedComboBox) 0 0 8 #(70321794 0) 5360 3714 138 144 3760 0 3792 466 5136 0 5 0 0 0 5360 0 0 4018 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] #displayString 5440 7 257 0 0 401 0 true 0 0 0 0 0 0 0 0 3938 8 'Viewed?' 161 #center 866 #displayString 4992 866 #<= 4992 866 #isViewed 4000 0 3648 ##(Smalltalk.IconicListAbstract) 1 0 0 true 866 #isViewed: 8 #(nil) 410 ##(Smalltalk.EmbeddedCheckBox) 34 19 0 0 34 2 8 1140924422 1 5616 802 0 false 4368 false 466 5136 0 5 0 0 0 5616 0 8 4294907985 994 0 0 0 0 8 '' true 1026 138 144 34 1 1090 #createAt:extent: 34 2 514 1 1 514 201 51 5616 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1376 0 43 0 0 0 0 0 0 0 0 3938 8 'Rating' 121 #left 866 #displayString 4464 866 #<= 4464 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] #rating 5984 7 257 0 0 3648 0 1 0 0 true 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] #rating: 6064 7 513 0 410 ##(Smalltalk.EmbeddedRadioButton) 34 19 0 0 34 2 8 1140924425 1 6144 802 0 false 4368 false 466 4608 0 5 0 0 0 6144 0 8 4294907985 994 0 0 0 0 8 '1*' true 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 201 51 6144 1090 #text: 34 1 6272 6144 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1376 0 43 0 0 0 0 0 0 0 0 3938 4832 121 #left 866 #displayString 4464 866 #<= 4464 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 2]' 8 #[30 105 226 0 64 132 106] #rating 6528 7 257 0 0 3648 0 1 0 0 true 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 2]' 8 #[30 105 17 64 176 106] #rating: 6608 7 513 0 410 ##(Smalltalk.EmbeddedRadioButton) 34 19 0 0 34 2 8 1140924425 1 6688 802 0 false 4368 false 466 4608 0 5 0 0 0 6688 0 8 4294907985 994 0 0 0 0 8 '2*' 0 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 201 51 6688 1090 #text: 34 1 6816 6688 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1376 0 43 0 0 0 0 0 0 0 0 3938 8 '' 121 #left 866 #displayString 4464 866 #<= 4464 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 3]' 8 #[30 105 226 0 214 3 132 106] #rating 7088 7 257 0 0 3648 0 1 0 0 true 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording :val | recording rating: 3]' 8 #[30 105 17 214 3 176 106] #rating: 7168 7 513 0 410 ##(Smalltalk.EmbeddedRadioButton) 34 19 0 0 34 2 8 1140924425 1 7248 802 0 false 4368 false 466 4608 0 5 0 0 0 7248 0 8 4294907985 994 0 0 0 0 8 '3*' false 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 201 51 7248 1090 #text: 34 1 7376 7248 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 8 #() 1376 0 43 0 0 0 0 0 0 0 0 3938 8 '' 201 #left 866 #displayString 8 #() 866 #<= 7632 0 0 3648 0 1 4018 0 0 4050 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 7664 7 257 0 0 true 0 410 ##(Smalltalk.EmbeddedPushButton) 34 35 0 0 34 2 8 1140925248 1 7760 0 466 8 4278190080 514 0 61 5 0 0 0 7760 0 8 4294907985 1586 #deleteSelectedRecording 8 'Delete' 1 1 0 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 false 0 0 0 0 138 ##(Smalltalk.Dictionary) 34 6 1666 #hot 451 1666 #pressed 301 1666 #enabled 751 1666 #released 451 1666 #cold 451 1666 #disabled 301 0 0 0 514 33 33 0 3 0 0 0 0 0 0 7904 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 1 1 7760 1090 #text: 34 1 7904 7760 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 8 #() 1376 0 41 0 0 0 0 4018 0 0 4050 2 1 864 8 'doIt' 8 '[ :item | item isViewed == true]' 8 #[30 105 226 0 58 141 106] #isViewed 8384 7 257 0 0 0 0 #report 3760 0 131171 0 34 4 0 0 514 1 1 0 0 138 144 3760 0 0 0 5 0 0 0 0 1026 138 144 34 2 1090 #createAt:extent: 34 2 514 1 1 514 2549 1053 3648 1090 #text: 34 1 8 'Title' 3648 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 8 #() 1376 0 31 170 192 34 2 3648 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 138 144 34 3 1090 #createAt:extent: 34 2 514 5119 21 514 2581 1201 416 1090 #text: 34 1 8 'Demo' 416 1090 #updateMenuBar 3760 416 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 9 15 0 0 98 2 0 0] 34 2 3648 576 1376 0 27 )! !
!EditableListViewDemo class categoriesFor: #defaultModel!models!public! !
!EditableListViewDemo class categoriesFor: #resource_Default_view!public!resources-views! !

