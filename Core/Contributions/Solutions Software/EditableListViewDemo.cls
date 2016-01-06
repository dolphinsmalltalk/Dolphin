"Filed out from Dolphin Smalltalk X6.1"!

Shell subclass: #EditableListViewDemo
	instanceVariableNames: 'listPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EditableListViewDemo guid: (GUID fromString: '{E27B5B72-70DE-474C-A0CC-B14EE3FDC1EB}')!
EditableListViewDemo comment: ''!
!EditableListViewDemo categoriesForClass!MVP-Presenters! !
!EditableListViewDemo methodsFor!

addPerson

	| new |

	new := listPresenter model add: ELVDemoPerson new.
	new name: '<enter name>'; dateOfBirth: Date today.
	listPresenter selection: new.
	listPresenter view activateFirstEditor!

createComponents

	super createComponents.

	listPresenter := self add: ListPresenter new name: 'list'!

genderColumn

	^listPresenter view columnNamed: #gender!

model: aCollection

	super model: aCollection.
	listPresenter model: (ListModel on: aCollection)!

nameColumn

	^listPresenter view columnNamed: #name!

onViewOpened

	super onViewOpened.

	"Set a pre-draw handler for the entire list (per row basis)"
	listPresenter view customDrawBlock: 
		[ :context | 
		context item isMarried 
			ifTrue: [context view rowBackcolor: Color cyan]
			ifFalse: [context view rowBackcolor: nil]].

	self genderColumn editor model searchPolicy: SearchPolicy caseInsensitive.
	self genderColumn editor choices: #('<not known>' 'Male' 'Female').

	"Set a pre-draw handler for the Gender column"
	self genderColumn preDrawBlock: 
		[ :context | 
		context item gender  = '<not known>' ifTrue: 
			[context backcolor: Color red. 
			context font isBold: true]].

	"And (for no good reason) only enable it when the person is not married"
	self genderColumn isEditableBlock: [ :person | person isMarried not]!

queryCommand: aCommandQuery

	| cmd |

	cmd := aCommandQuery commandSymbol.

	cmd = #removePersons ifTrue:
		[aCommandQuery isEnabled: listPresenter hasSelection.
		^true].

	^super queryCommand: aCommandQuery
!

removePersons

	listPresenter model removeAll: listPresenter selections! !
!EditableListViewDemo categoriesFor: #addPerson!commands!public! !
!EditableListViewDemo categoriesFor: #createComponents!initializing!public! !
!EditableListViewDemo categoriesFor: #genderColumn!accessing!public! !
!EditableListViewDemo categoriesFor: #model:!accessing!public! !
!EditableListViewDemo categoriesFor: #nameColumn!accessing!public! !
!EditableListViewDemo categoriesFor: #onViewOpened!event handling!public! !
!EditableListViewDemo categoriesFor: #queryCommand:!commands!public! !
!EditableListViewDemo categoriesFor: #removePersons!commands!public! !

!EditableListViewDemo class methodsFor!

defaultModel

	^OrderedCollection new
		add: (ELVDemoPerson new
			name: 'John Smith';
			dateOfBirth: (Date newDay: 1 monthIndex: 1 year: 1970);
			gender: 'Male';
			isMarried: true;
			address: '23 Railway Cuttings
East Cheam';
			yourself);
		add: (ELVDemoPerson new
			name: 'Lucy Davis';
			dateOfBirth: (Date newDay: 1 monthIndex: 1 year: 1972);
			gender: 'Female';
			isMarried: false;
			address: '<please enter>';
			yourself);
		yourself!

resource_Column_icon_view
	"Answer the literal data from which the 'Column icon view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Column_icon_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 560 0 234 256 98 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 533 834 1285 71 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 1 0 0 130 2 0 0 45 1 0 0] 98 2 410 8 ##(Smalltalk.PushButton)  98 17 0 560 98 2 8 1140924416 1 944 0 0 0 7 0 0 0 944 0 8 4294902947 1180998 4 ##(Smalltalk.CommandDescription)  8 #addPerson 8 'Add' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 21 11 834 141 51 944 770 8 #isEnabled: 98 1 32 944 770 8 #text: 98 1 8 'Add' 944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 98 0 834 193 193 0 27 410 960 98 17 0 560 98 2 8 1140924416 1 1392 0 0 0 7 0 0 0 1392 0 8 4294902947 1042 8 #removePersons 8 'Remove' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 171 11 834 141 51 1392 770 1232 98 1 32 1392 770 1280 98 1 8 'Remove' 1392 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 5 0 0 0 155 0 0 0 30 0 0 0] 98 0 1376 0 27 1376 0 27 0 0 410 8 ##(Smalltalk.EditableListView)  98 38 0 416 98 2 8 1140920393 1025 1760 590662 2 ##(Smalltalk.ListModel)  202 208 688 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 8 4278190080 0 7 0 0 0 1760 0 8 4294902771 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1898 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 834 65 65 0 0 202 208 98 4 1447494 14 ##(Smalltalk.EditableListViewColumn)  8 'Name' 321 8 #left 2000 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #name 98 0 2240 1760 2016 1 0 0 16 2210 8 #name: 98 1 0 1052998 13 ##(Smalltalk.EmbeddedTextEdit)  0 0 98 2 134349057 1 2336 721990 2 ##(Smalltalk.ValueHolder)  0 32 1898 1920 8 #equality 0 0 0 5 0 0 0 2336 0 0 852486 ##(Smalltalk.NullConverter)  0 8 '' 1 0 0 0 0 0 0 0 0 2130 8 'Date of Birth' 201 2176 2210 8 #shortString 2256 2210 8 #<= 2256 2210 8 #dateOfBirth 2256 0 1760 2016 1 0 0 16 2210 8 #dateOfBirth: 98 1 0 1644102 13 ##(Smalltalk.EmbeddedFormattedTextEdit)  0 0 98 2 134349057 1 2672 2370 0 32 2400 0 482 8 4278190080 0 5 0 0 0 2672 0 0 656454 1 ##(Smalltalk.DateToText)  0 8 '' 0 0 1 32 32 8 '__/__/____' 8 '/' 1524 0 0 0 0 0 0 0 0 2130 8 'Gender' 241 2176 2210 8 #displayString 2256 2210 2560 2256 2210 8 #gender 2256 2928 1760 2016 1 0 0 16 2210 8 #gender: 98 1 0 1053510 10 ##(Smalltalk.EmbeddedComboBox)  0 0 98 2 140643589 1 3008 1842 202 208 688 0 1904 482 2736 0 5 0 0 0 3008 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] 2880 3104 7 257 0 0 401 0 0 0 0 0 0 0 0 0 2130 8 'Married?' 201 2176 2210 2880 2256 2210 2560 2256 2210 8 #isMarried 2256 0 1760 2016 1 0 0 16 2210 8 #isMarried: 98 1 0 1052742 13 ##(Smalltalk.EmbeddedCheckBox)  0 0 98 2 134348801 1 3360 2370 0 32 2400 32 482 2736 0 5 0 0 0 3360 0 0 0 0 0 0 0 0 0 0 0 8 #report 688 0 131175 0 0 0 202 208 688 0 0 0 3 0 0 706 202 208 98 2 770 800 98 2 834 1 1 834 1285 533 1760 770 1280 98 1 8 'Name' 1760 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 130 2 0 0 10 1 0 0] 98 0 1376 0 29 234 256 98 2 1760 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 2 770 800 98 2 834 2047 21 834 1301 661 416 770 8 #updateMenuBar 688 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 137 6 0 0 84 1 0 0] 98 2 1760 560 1376 0 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 560 0 234 256 98 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 533 834 1285 71 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 1 0 0 130 2 0 0 45 1 0 0] 98 2 410 8 ##(Smalltalk.PushButton)  98 17 0 560 98 2 8 1140924416 1 944 0 0 0 7 0 0 0 944 0 8 4294902947 1180998 4 ##(Smalltalk.CommandDescription)  8 #addPerson 8 'Add' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 21 11 834 141 51 944 770 8 #isEnabled: 98 1 32 944 770 8 #text: 98 1 8 'Add' 944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 98 0 834 193 193 0 27 410 960 98 17 0 560 98 2 8 1140924416 1 1392 0 0 0 7 0 0 0 1392 0 8 4294902947 1042 8 #removePersons 8 'Remove' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 171 11 834 141 51 1392 770 1232 98 1 32 1392 770 1280 98 1 8 'Remove' 1392 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 5 0 0 0 155 0 0 0 30 0 0 0] 98 0 1376 0 27 1376 0 27 0 0 410 8 ##(Smalltalk.EditableListView)  98 38 0 416 98 2 8 1140920393 1025 1760 590662 2 ##(Smalltalk.ListModel)  202 208 688 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 8 4278190080 0 7 0 0 0 1760 0 8 4294902771 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1898 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 834 65 65 0 0 202 208 98 4 1447494 14 ##(Smalltalk.EditableListViewColumn)  8 'Name' 321 8 #left 2000 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #name 98 0 2240 1760 0 1 0 0 16 2210 8 #name: 98 1 0 1052998 13 ##(Smalltalk.EmbeddedTextEdit)  0 0 98 2 134349057 1 2336 721990 2 ##(Smalltalk.ValueHolder)  0 32 1898 1920 8 #equality 0 0 0 5 0 0 0 2336 0 0 852486 ##(Smalltalk.NullConverter)  0 8 '' 1 0 0 0 0 0 0 0 0 2130 8 'Date of Birth' 201 2176 2210 8 #shortString 2256 2210 8 #<= 2256 2210 8 #dateOfBirth 2256 0 1760 2016 1 0 0 16 2210 8 #dateOfBirth: 98 1 0 1644102 13 ##(Smalltalk.EmbeddedFormattedTextEdit)  0 0 98 2 134349057 1 2672 2370 0 32 2400 0 482 8 4278190080 0 5 0 0 0 2672 0 0 656454 1 ##(Smalltalk.DateToText)  0 8 '' 0 0 1 32 32 8 '__/__/____' 8 '/' 1524 0 0 0 0 0 0 0 0 2130 8 'Gender' 241 2176 2210 8 #displayString 2256 2210 2560 2256 2210 8 #gender 2256 2928 1760 2016 1 0 0 16 2210 8 #gender: 98 1 0 1053510 10 ##(Smalltalk.EmbeddedComboBox)  0 0 98 2 140643589 1 3008 1842 202 208 688 0 1904 482 2736 0 5 0 0 0 3008 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] 2880 3104 7 257 0 0 401 0 0 0 0 0 0 0 0 0 2130 8 'Married?' 201 2176 2210 2880 2256 2210 2560 2256 2210 8 #isMarried 2256 0 1760 0 1 0 0 16 2210 8 #isMarried: 98 1 0 1052742 13 ##(Smalltalk.EmbeddedCheckBox)  0 0 98 2 134348801 1 3360 2370 0 32 2400 32 482 2736 0 5 0 0 0 3360 0 0 0 0 0 0 0 0 0 0 0 8 #report 688 0 131171 0 0 0 202 208 688 0 0 0 3 834 33 33 0 706 202 208 98 2 770 800 98 2 834 1 1 834 1285 533 1760 770 1280 98 1 8 'Name' 1760 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 130 2 0 0 10 1 0 0] 98 0 1376 0 29 234 256 98 2 1760 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 2 770 800 98 2 834 2047 21 834 1301 661 416 770 8 #updateMenuBar 688 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 137 6 0 0 84 1 0 0] 98 2 1760 560 1376 0 27 )!

resource_Multiline_column_icons_view
	"Answer the literal data from which the 'Multiline column icons view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiline_column_icons_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 560 0 234 256 98 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 533 834 1285 71 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 1 0 0 130 2 0 0 45 1 0 0] 98 2 410 8 ##(Smalltalk.PushButton)  98 17 0 560 98 2 8 1140924416 1 944 0 0 0 7 0 0 0 944 0 8 4294902947 1180998 4 ##(Smalltalk.CommandDescription)  8 #addPerson 8 'Add' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 21 11 834 141 51 944 770 8 #isEnabled: 98 1 32 944 770 8 #text: 98 1 8 'Add' 944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 98 0 834 193 193 0 27 410 960 98 17 0 560 98 2 8 1140924416 1 1392 0 0 0 7 0 0 0 1392 0 8 4294902947 1042 8 #removePersons 8 'Remove' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 171 11 834 141 51 1392 770 1232 98 1 32 1392 770 1280 98 1 8 'Remove' 1392 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 5 0 0 0 155 0 0 0 30 0 0 0] 98 0 1376 0 27 1376 0 27 0 0 410 8 ##(Smalltalk.EditableListView)  98 38 0 416 98 2 8 1140920397 1025 1760 590662 2 ##(Smalltalk.ListModel)  202 208 688 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 8 4278190080 0 7 0 0 0 1760 0 8 4294902771 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1898 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 834 65 65 0 0 202 208 98 5 1447494 14 ##(Smalltalk.EditableListViewColumn)  8 'Name' 321 8 #left 2000 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #name 98 0 2240 1760 2016 1 0 0 16 2210 8 #name: 98 1 0 1052998 13 ##(Smalltalk.EmbeddedTextEdit)  0 0 98 2 134349057 1 2336 721990 2 ##(Smalltalk.ValueHolder)  0 32 1898 1920 8 #equality 0 0 0 5 0 0 0 2336 0 0 852486 ##(Smalltalk.NullConverter)  0 8 '' 1 0 0 0 0 0 0 0 0 2130 8 '' 201 2176 2210 8 #displayString 98 0 2210 8 #<= 2544 2210 8 #address 2544 0 1760 2016 1 0 0 16 2210 8 #address: 98 1 0 1642822 13 ##(Smalltalk.EmbeddedMultilineTextEdit)  0 0 98 2 138551945 1 2688 2370 0 32 2400 0 482 8 4278190080 0 5 0 0 0 2688 0 0 0 9 0 0 0 0 0 0 0 0 2130 8 'Date of Birth' 201 2176 2210 8 #shortString 2256 2210 2576 2256 2210 8 #dateOfBirth 2256 0 1760 2016 1 0 0 16 2210 8 #dateOfBirth: 98 1 0 1644102 13 ##(Smalltalk.EmbeddedFormattedTextEdit)  0 0 98 2 134349057 1 2944 2370 0 32 2400 0 482 8 4278190080 0 5 0 0 0 2944 0 0 656454 1 ##(Smalltalk.DateToText)  0 8 '' 0 0 1 32 32 8 '__/__/____' 8 '/' 1524 0 0 0 0 0 0 0 0 2130 8 'Gender' 241 2176 2210 2528 2256 2210 2576 2256 2210 8 #gender 2256 3184 1760 2016 1 0 0 16 2210 8 #gender: 98 1 0 1053510 10 ##(Smalltalk.EmbeddedComboBox)  0 0 98 2 140643589 1 3264 1842 202 208 688 0 1904 482 3008 0 5 0 0 0 3264 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] 2528 3360 7 257 0 0 401 0 0 0 0 0 0 0 0 0 2130 8 'Married?' 201 2176 2210 2528 2256 2210 2576 2256 2210 8 #isMarried 2256 0 1760 2016 1 0 0 16 2210 8 #isMarried: 98 1 0 1052742 13 ##(Smalltalk.EmbeddedCheckBox)  0 0 98 2 134348801 1 3616 2370 0 32 2400 32 482 3008 0 5 0 0 0 3616 0 0 0 0 0 0 0 0 0 0 0 8 #report 688 0 131175 0 0 0 202 208 688 0 0 0 11 834 65 65 0 706 202 208 98 2 770 800 98 2 834 1 1 834 1285 533 1760 770 1280 98 1 8 'Name' 1760 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 130 2 0 0 10 1 0 0] 98 0 1376 0 29 234 256 98 2 1760 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 2 770 800 98 2 834 2047 21 834 1301 661 416 770 8 #updateMenuBar 688 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 137 6 0 0 84 1 0 0] 98 2 1760 560 1376 0 27 )!

resource_Multiline_view
	"Answer the literal data from which the 'Multiline view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiline_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 560 0 234 256 98 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 533 834 1285 71 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 10 1 0 0 130 2 0 0 45 1 0 0] 98 2 410 8 ##(Smalltalk.PushButton)  98 17 0 560 98 2 8 1140924416 1 944 0 0 0 7 0 0 0 944 0 8 4294902947 1180998 4 ##(Smalltalk.CommandDescription)  8 #addPerson 8 'Add' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 21 11 834 141 51 944 770 8 #isEnabled: 98 1 32 944 770 8 #text: 98 1 8 'Add' 944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 5 0 0 0 80 0 0 0 30 0 0 0] 98 0 834 193 193 0 27 410 960 98 17 0 560 98 2 8 1140924416 1 1392 0 0 0 7 0 0 0 1392 0 8 4294902947 1042 8 #removePersons 8 'Remove' 1 1 0 0 32 706 202 208 98 3 770 800 98 2 834 171 11 834 141 51 1392 770 1232 98 1 32 1392 770 1280 98 1 8 'Remove' 1392 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 5 0 0 0 155 0 0 0 30 0 0 0] 98 0 1376 0 27 1376 0 27 0 0 410 8 ##(Smalltalk.EditableListView)  98 38 0 416 98 2 8 1140920397 1025 1760 590662 2 ##(Smalltalk.ListModel)  202 208 688 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 8 4278190080 0 7 0 0 0 1760 0 8 4294902771 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1898 8 ##(Smalltalk.IconImageManager)  8 #current 0 0 0 834 65 65 0 0 202 208 98 5 1447494 14 ##(Smalltalk.EditableListViewColumn)  8 'Name' 321 8 #left 2000 8 ##(Smalltalk.SortedCollection)  459270 ##(Smalltalk.Message)  8 #name 98 0 2240 1760 0 1 0 0 16 2210 8 #name: 98 1 0 1052998 13 ##(Smalltalk.EmbeddedTextEdit)  0 0 98 2 134349057 1 2336 721990 2 ##(Smalltalk.ValueHolder)  0 32 1898 1920 8 #equality 0 0 0 5 0 0 0 2336 0 0 852486 ##(Smalltalk.NullConverter)  0 8 '' 1 0 0 0 0 0 0 0 0 2130 8 '' 201 2176 2210 8 #displayString 98 0 2210 8 #<= 2544 2210 8 #address 2544 0 1760 0 1 0 0 16 2210 8 #address: 98 1 0 1642822 13 ##(Smalltalk.EmbeddedMultilineTextEdit)  0 0 98 2 138551945 1 2688 2370 0 32 2400 0 482 8 4278190080 0 5 0 0 0 2688 0 0 0 9 0 0 0 0 0 0 0 0 2130 8 'Date of Birth' 201 2176 2210 8 #shortString 2256 2210 2576 2256 2210 8 #dateOfBirth 2256 0 1760 0 1 0 0 16 2210 8 #dateOfBirth: 98 1 0 1644102 13 ##(Smalltalk.EmbeddedFormattedTextEdit)  0 0 98 2 134349057 1 2944 2370 0 32 2400 0 482 8 4278190080 0 5 0 0 0 2944 0 0 656454 1 ##(Smalltalk.DateToText)  0 8 '' 0 0 1 32 32 8 '__/__/____' 8 '/' 1524 0 0 0 0 0 0 0 0 2130 8 'Gender' 241 2176 2210 2528 2256 2210 2576 2256 2210 8 #gender 2256 3184 1760 0 1 0 0 16 2210 8 #gender: 98 1 0 1053510 10 ##(Smalltalk.EmbeddedComboBox)  0 0 98 2 140643589 1 3264 1842 202 208 688 0 1904 482 8 4278190080 0 5 0 0 0 3264 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 8 ##(Smalltalk.ListControlView)  8 #defaultGetTextBlock 415614371 8 #[30 105 226 0 106] 2528 3376 7 257 0 0 401 0 0 0 0 0 0 0 0 0 2130 8 'Married?' 201 2176 2210 2528 2256 2210 2576 2256 2210 8 #isMarried 2256 0 1760 0 1 0 0 16 2210 8 #isMarried: 98 1 0 1052742 13 ##(Smalltalk.EmbeddedCheckBox)  0 0 98 2 134348801 1 3632 2370 0 32 2400 32 482 3008 0 5 0 0 0 3632 0 0 0 0 0 0 0 0 0 0 0 8 #report 688 0 131171 0 0 0 202 208 688 0 0 0 11 834 49 193 0 706 202 208 98 2 770 800 98 2 834 1 1 834 1285 533 1760 770 1280 98 1 8 'Name' 1760 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 130 2 0 0 10 1 0 0] 98 0 1376 0 29 234 256 98 2 1760 8 'list' 0 0 0 0 0 1 0 0 0 0 1 0 0 706 202 208 98 2 770 800 98 2 834 2047 21 834 1301 661 416 770 8 #updateMenuBar 688 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 3 0 0 10 0 0 0 137 6 0 0 84 1 0 0] 98 2 1760 560 1376 0 27 )! !
!EditableListViewDemo class categoriesFor: #defaultModel!public! !
!EditableListViewDemo class categoriesFor: #resource_Column_icon_view!public!resources-views! !
!EditableListViewDemo class categoriesFor: #resource_Default_view!public!resources-views! !
!EditableListViewDemo class categoriesFor: #resource_Multiline_column_icons_view!public!resources-views! !
!EditableListViewDemo class categoriesFor: #resource_Multiline_view!public!resources-views! !

