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
	new title: '<enter title>'; date: Date today.
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

	rowHeightPresenter when: #valueChanged send: #onRowHeightChanged to: self.
	hasRowImagePresenter when: #valueChanged send: #onHasRowImageChanged to: self.
	hasColumnImagesPresenter when: #valueChanged send: #onHasColumnImagesChanged to: self!

deleteSelectedRecording

	listPresenter model remove: listPresenter selection!

model: aCollection

	super model: aCollection.
	listPresenter model: (ListModel on: aCollection)!

nameColumn

	^listPresenter view columnNamed: #name!

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

onViewOpened

	super onViewOpened.

	rowHeightPresenter model value: listPresenter view rowHeight.
	hasRowImagePresenter model value: listPresenter view getImageBlock notNil.
	hasColumnImagesPresenter model value: listPresenter view hasColumnImages.

	self channelColumn editor model searchPolicy: SearchPolicy caseInsensitive.
	self channelColumn editor choices: #('BBC1' 'BBC2' 'ITV' 'Channel 4')!

queryCommand: aCommandQuery

	| cmd |

	cmd := aCommandQuery commandSymbol.

	cmd = #removeRecordings ifTrue:
		[aCommandQuery isEnabled: listPresenter hasSelection.
		^true].

	^super queryCommand: aCommandQuery
! !
!EditableListViewDemo categoriesFor: #addRecording!commands!public! !
!EditableListViewDemo categoriesFor: #channelColumn!accessing!public! !
!EditableListViewDemo categoriesFor: #createComponents!initializing!public! !
!EditableListViewDemo categoriesFor: #createSchematicWiring!initializing!public! !
!EditableListViewDemo categoriesFor: #deleteSelectedRecording!commands!public! !
!EditableListViewDemo categoriesFor: #model:!accessing!public! !
!EditableListViewDemo categoriesFor: #nameColumn!accessing!public! !
!EditableListViewDemo categoriesFor: #onHasColumnImagesChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onHasRowImageChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onRowHeightChanged!event handling!public! !
!EditableListViewDemo categoriesFor: #onViewOpened!event handling!public! !
!EditableListViewDemo categoriesFor: #queryCommand:!commands!public! !

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 2581 1201 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 592 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 592 0 234 256 98 6 410 8 ##(Smalltalk.CheckBox) 98 16 0 592 98 2 8 1409363235 1 736 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) 32 0 0 7 0 0 0 736 0 8 4294912073 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 530 817 9 530 221 61 736 994 8 #text: 98 1 8 'Column Images' 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 4 0 0 0 6 2 0 0 34 0 0 0] 98 0 530 193 193 0 27 8 'hasColumnImages' 410 8 ##(Smalltalk.SpinButton) 98 15 0 592 98 2 8 1140916224 1 1248 818 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) 8 #= 98 0 1378 8 #hash 98 0 1 482 8 4278190080 0 7 0 0 0 1248 0 8 4294903201 898 0 0 930 202 208 98 3 994 1024 98 2 530 457 11 530 71 51 1248 994 8 #setRange: 98 1 525062 ##(Smalltalk.Interval) 3 21 3 1248 994 8 #udmSetAccel: 98 1 918854 1 ##(Smalltalk.StructureArray) 8 #[0 0 0 0 1 0 0 0 2 0 0 0 5 0 0 0 5 0 0 0 20 0 0 0] 7 8 ##(Smalltalk.UDACCEL) 0 17 1248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 5 0 0 0 7 1 0 0 30 0 0 0] 98 0 1216 0 27 8 'rowHeight' 410 752 98 16 0 592 98 2 8 1409363235 1 1920 818 0 0 864 32 0 0 7 0 0 0 1920 0 8 4294912073 898 0 0 0 930 202 208 98 2 994 1024 98 2 530 613 9 530 171 61 1920 994 1104 98 1 8 'Row Image' 1920 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 50 1 0 0 4 0 0 0 135 1 0 0 34 0 0 0] 98 0 1216 0 27 8 'hasRowImage' 0 930 202 208 98 1 994 1024 98 2 530 1 1053 530 2549 71 592 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 14 2 0 0 250 4 0 0 49 2 0 0] 98 5 410 8 ##(Smalltalk.PushButton) 98 20 0 592 98 2 8 1140924416 1 2416 0 0 0 7 0 0 0 2416 0 8 4294912073 1180998 4 ##(Smalltalk.CommandDescription) 8 #addRecording 8 '&Add Recording' 1 1 0 0 32 0 0 0 930 202 208 98 3 994 1024 98 2 530 25 11 530 241 51 2416 994 8 #isEnabled: 98 1 32 2416 994 1104 98 1 8 '&Add Recording' 2416 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 5 0 0 0 132 0 0 0 30 0 0 0] 98 0 1216 0 29 1248 410 8 ##(Smalltalk.StaticText) 98 16 0 592 98 2 8 1140850944 65 2832 0 0 0 7 0 0 0 2832 0 8 4294908085 898 0 0 0 930 202 208 98 2 994 1024 98 2 530 307 21 530 141 41 2832 994 1104 98 1 8 'Row Height' 2832 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 0 0 0 10 0 0 0 223 0 0 0 30 0 0 0] 98 0 1216 0 27 1920 736 1216 0 27 0 0 410 8 ##(Smalltalk.EditableListView) 98 40 0 416 98 2 8 1140920393 1025 3152 590662 2 ##(Smalltalk.ListModel) 202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 8 4278190080 0 7 0 0 0 3152 0 8 4294910993 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 530 65 65 0 0 202 208 98 10 1447494 14 ##(Smalltalk.EditableListViewColumn) 8 'Title' 401 8 #left 3376 8 ##(Smalltalk.SortedCollection) 1378 8 #title 98 0 3584 3152 3392 1 0 0 16 1378 8 #title: 98 1 0 1052998 13 ##(Smalltalk.EmbeddedTextEdit) 0 0 98 2 134349057 1 3680 818 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 0 0 5 0 0 0 3680 0 0 898 0 8 '' 1 0 0 0 0 0 0 0 0 3490 8 'Episode Title' 401 3536 1378 8 #displayString 98 0 1378 8 #<= 3856 1378 8 #episodeTitle 3856 0 3152 3392 1 0 0 16 1378 8 #episodeTitle: 98 1 0 3666 0 0 98 2 134349057 1 3984 818 0 32 3744 0 482 8 4278190080 0 5 0 0 0 3984 0 0 0 1 0 0 0 0 0 0 0 0 3490 8 'Description' 321 3536 1378 3840 3856 1378 3888 3856 1378 8 #description 3856 0 3152 3392 1 0 0 16 1378 8 #description: 98 1 0 1642822 13 ##(Smalltalk.EmbeddedMultilineTextEdit) 0 0 98 2 138551945 1 4224 818 0 32 3744 0 482 4048 0 5 0 0 0 4224 0 0 898 0 8 '' 9 0 0 0 0 0 0 0 0 3490 8 'Date' 201 3536 1378 8 #shortString 98 0 1378 3888 4384 1378 8 #date 3600 0 3152 3392 1 0 0 16 1378 8 #date: 98 1 0 1644102 13 ##(Smalltalk.EmbeddedFormattedTextEdit) 0 0 98 2 134349057 1 4512 818 0 32 3744 0 482 8 4278190080 0 5 0 0 0 4512 0 0 656454 1 ##(Smalltalk.DateToText) 0 8 '' 0 0 1 32 32 8 '__/__/____' 8 '/' 1524 0 0 0 0 0 0 0 0 3490 8 'Channel' 321 3536 1378 3840 4384 1378 3888 4384 1378 8 #channel 3600 4752 3152 3392 1 0 0 16 1378 8 #channel: 98 1 0 1053510 10 ##(Smalltalk.EmbeddedComboBox) 0 0 98 2 140643589 1 4832 3234 202 208 3280 0 3312 482 4576 0 5 0 0 0 4832 0 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 8 ##(Smalltalk.ListControlView) 8 #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] 3840 4928 7 257 0 0 401 0 0 0 0 0 0 0 0 0 3490 8 'Viewed?' 201 3536 1378 3840 4384 1378 3888 4384 1378 8 #isViewed 3600 0 3152 3392 1 0 0 16 1378 8 #isViewed: 98 1 0 1053254 20 ##(Smalltalk.EmbeddedCheckBox) 0 0 98 2 134365191 1 5184 818 0 32 3744 32 482 4576 0 5 0 0 0 5184 0 0 0 0 0 0 0 0 0 0 0 0 0 3490 8 'Rating' 121 3536 1378 3840 3856 1378 3888 3856 4914 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[ :recording | recording rating = 1]' 8 #[30 105 226 0 63 132 106] 8 #rating 5312 7 257 0 0 3152 0 1 0 0 16 4914 0 0 5330 2 1 5360 8 'doIt' 8 '[ :recording :val | recording rating: 1]' 8 #[30 105 17 63 176 106] 8 #rating: 5440 7 513 0 410 8 ##(Smalltalk.EmbeddedRadioButton) 98 18 0 0 98 2 8 1140924425 1 5536 818 0 32 3744 32 482 4048 0 5 0 0 0 5536 0 8 4294912073 898 0 0 0 0 8 '1*' 930 202 208 98 2 994 1024 98 2 530 1 1 530 201 51 5536 994 1104 98 1 5680 5536 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 98 0 1216 0 27 0 0 0 0 0 0 0 3490 4304 121 3536 1378 3840 3856 1378 3888 3856 4914 0 0 5330 2 1 5360 8 'doIt' 8 '[ :recording | recording rating = 2]' 8 #[30 105 226 0 64 132 106] 5424 5936 7 257 0 0 3152 0 1 0 0 16 4914 0 0 5330 2 1 5360 8 'doIt' 8 '[ :recording :val | recording rating: 2]' 8 #[30 105 17 64 176 106] 5520 6016 7 513 0 410 5552 98 18 0 0 98 2 8 1140924425 1 6096 818 0 32 3744 32 482 4048 0 5 0 0 0 6096 0 8 4294912073 898 0 0 0 0 8 '2*' 930 202 208 98 2 994 1024 98 2 530 1 1 530 201 51 6096 994 1104 98 1 6224 6096 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 98 0 1216 0 27 0 0 0 0 0 0 0 3490 8 '' 121 3536 1378 3840 3856 1378 3888 3856 4914 0 0 5330 2 1 5360 8 'doIt' 8 '[ :recording | recording rating = 3]' 8 #[30 105 226 0 214 3 132 106] 5424 6496 7 257 0 0 3152 0 1 0 0 16 4914 0 0 5330 2 1 5360 8 'doIt' 8 '[ :recording :val | recording rating: 3]' 8 #[30 105 17 214 3 176 106] 5520 6576 7 513 0 410 5552 98 18 0 0 98 2 8 1140924425 1 6656 818 0 32 3744 32 482 4048 0 5 0 0 0 6656 0 8 4294912073 898 0 0 0 0 8 '3*' 930 202 208 98 2 994 1024 98 2 530 1 1 530 201 51 6656 994 1104 98 1 6784 6656 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 100 0 0 0 25 0 0 0] 98 0 1216 0 27 0 0 0 0 0 0 0 3490 8 '' 201 3536 1378 3840 98 0 1378 3888 7040 0 0 3152 0 1 4914 0 0 5330 2 1 5360 8 'doIt' 8 '[ :item | ''Delete this recording'']' 8 #[30 105 29 106] 8 'Delete this recording' 7072 7 257 0 0 16 0 410 8 ##(Smalltalk.EmbeddedPushButton) 98 35 0 0 98 2 8 1140924480 1 7168 0 482 8 4278190080 530 201 71 5 0 0 0 7168 0 8 4294912073 2514 8 #deleteSelectedRecording 8 'Delete' 1 1 0 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'False.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 32 0 0 0 0 202 8 ##(Smalltalk.Dictionary) 98 6 721414 ##(Smalltalk.Association) 8 #disabled 301 7538 8 #enabled 751 7538 8 #pressed 301 7538 8 #cold 451 7538 8 #hot 451 7538 8 #released 451 0 0 0 530 33 33 0 3 0 0 0 0 0 0 7344 930 202 208 98 2 994 1024 98 2 530 1 1 530 1 1 7168 994 1104 98 1 7344 7168 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 98 0 1216 0 29 0 0 0 0 1378 5104 98 0 0 0 8 #report 3280 0 131171 0 98 4 0 0 530 1 1 0 0 202 208 3280 0 0 0 5 0 0 0 0 930 202 208 98 2 994 1024 98 2 530 1 1 530 2549 1053 3152 994 1104 98 1 8 'Title' 3152 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 250 4 0 0 14 2 0 0] 98 0 1216 0 31 234 256 98 2 3152 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 930 202 208 98 3 994 1024 98 2 530 5119 21 530 2581 1201 416 994 1104 98 1 8 'Demo' 416 994 8 #updateMenuBar 3280 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 9 15 0 0 98 2 0 0] 98 2 3152 592 1216 0 27 )! !
!EditableListViewDemo class categoriesFor: #defaultModel!public! !
!EditableListViewDemo class categoriesFor: #resource_Default_view!public!resources-views! !

