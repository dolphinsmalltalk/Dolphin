"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #EditableListViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EditableListViewTest guid: (GUID fromString: '{d26230d4-ebc5-4253-9863-c59849d538e1}')!

EditableListViewTest comment: ''!

!EditableListViewTest categoriesForClass!Unclassified! !

!EditableListViewTest methodsFor!

classToTest
	^EditableListView!

clickRow: rowIndex column: columnIndex modifiers: modsMask

	| coords |

	coords := (presenter view subItemRectRow: rowIndex column: columnIndex) center.
	presenter view
		wmLButtonDown: WM_LBUTTONDOWN wParam: modsMask lParam:  
			(UIntPtrBytes new
				lowPart: coords x;
				highPart: coords y;
				yourself).
!

drawEditableListViewAfter: aBlock

	| elv bitmap canvas |

	elv := presenter view.

	"Hide the view to avoid any errors during UI invalidation"
	elv hide.

	aBlock value: elv.

	bitmap := Bitmap displayCompatibleWithExtent: elv extent.
	canvas := bitmap canvas.
	elv
		sendMessage: WM_PRINT
		wParam: canvas handle
		lParam: PRF_CLIENT | PRF_ERASEBKGND | PRF_CHILDREN | PRF_NONCLIENT | PRF_OWNED.
	canvas free.
	bitmap free!

editableListViewBytes15

	^#[33 83 84 66 32 51 32 78 8 12 0 10 0 0 0 83 84 66 86 105 101 119 80 114 111 120 121 154 0 0 0 82 0 0 0 20 0 0 0 83 83 87 32 69 100 105 116 97 98 108 101 76 105 115 116 86 105 101 119 82 0 0 0 16 0 0 0 69 100 105 116 97 98 108 101 76 105 115 116 86 105 101 119 98 0 0 0 40 0 0 0 0 0 0 0 0 0 0 0 98 0 0 0 2 0 0 0 130 0 0 0 4 0 0 0 77 16 1 68 1 4 0 0 160 1 0 0 70 3 9 0 2 0 0 0 76 105 115 116 77 111 100 101 108 202 0 0 0 208 0 0 0 98 0 0 0 0 0 0 0 0 0 0 0 6 0 20 0 73 100 101 110 116 105 116 121 83 101 97 114 99 104 80 111 108 105 99 121 6 1 8 0 67 111 108 111 114 82 101 102 130 0 0 0 8 0 0 0 0 0 0 255 0 0 0 0 0 0 0 0 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 160 1 0 0 0 0 0 0 130 0 0 0 8 0 0 0 195 24 255 255 0 0 0 0 154 0 0 0 82 0 0 0 22 0 0 0 68 111 108 112 104 105 110 32 76 105 115 116 32 80 114 101 115 101 110 116 101 114 82 0 0 0 17 0 0 0 66 97 115 105 99 76 105 115 116 65 98 115 116 114 97 99 116 154 0 0 0 82 0 0 0 23 0 0 0 68 111 108 112 104 105 110 32 67 111 109 109 111 110 32 67 111 110 116 114 111 108 115 82 0 0 0 18 0 0 0 73 99 111 110 105 99 76 105 115 116 65 98 115 116 114 97 99 116 70 5 16 0 1 0 0 0 73 99 111 110 73 109 97 103 101 77 97 110 97 103 101 114 0 0 0 0 0 0 0 0 0 0 0 0 6 2 5 0 80 111 105 110 116 65 0 0 0 65 0 0 0 0 0 0 0 0 0 0 0 202 0 0 0 208 0 0 0 98 0 0 0 1 0 0 0 70 23 22 0 15 0 0 0 69 100 105 116 97 98 108 101 76 105 115 116 86 105 101 119 67 111 108 117 109 110 82 0 0 0 8 0 0 0 67 111 108 117 109 110 32 49 201 0 0 0 178 0 0 0 4 0 0 0 108 101 102 116 176 2 0 0 154 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 16 0 0 0 83 111 114 116 101 100 67 111 108 108 101 99 116 105 111 110 0 0 0 0 0 0 0 0 160 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 16 0 0 0 0 0 0 0 70 17 16 0 20 0 0 0 69 109 98 101 100 100 101 100 84 101 120 116 69 100 105 116 0 0 0 0 0 0 0 0 98 0 0 0 2 0 0 0 1 1 2 8 1 0 0 0 240 3 0 0 70 4 11 0 2 0 0 0 86 97 108 117 101 72 111 108 100 101 114 0 0 0 0 32 0 0 0 6 0 20 0 69 113 117 97 108 105 116 121 83 101 97 114 99 104 80 111 108 105 99 121 0 0 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 240 3 0 0 0 0 0 0 0 0 0 0 6 2 13 0 78 117 108 108 67 111 110 118 101 114 116 101 114 0 0 0 0 82 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 178 0 0 0 6 0 0 0 114 101 112 111 114 116 64 2 0 0 0 0 0 0 99 0 2 0 0 0 0 0 98 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 50 3 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 202 0 0 0 208 0 0 0 64 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 82 0 0 0 5 0 0 0 100 117 109 109 121 0 0 0 0 0 0 0 0 6 1 15 0 77 101 115 115 97 103 101 83 101 113 117 101 110 99 101 202 0 0 0 208 0 0 0 98 0 0 0 2 0 0 0 6 3 11 0 77 101 115 115 97 103 101 83 101 110 100 178 0 0 0 16 0 0 0 99 114 101 97 116 101 65 116 58 101 120 116 101 110 116 58 98 0 0 0 2 0 0 0 50 3 0 0 1 0 0 0 1 0 0 0 50 3 0 0 235 1 0 0 55 1 0 0 160 1 0 0 18 5 0 0 178 0 0 0 5 0 0 0 116 101 120 116 58 98 0 0 0 1 0 0 0 82 0 0 0 8 0 0 0 67 111 108 117 109 110 32 49 160 1 0 0 6 1 15 0 87 73 78 68 79 87 80 76 65 67 69 77 69 78 84 114 0 0 0 44 0 0 0 44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 245 0 0 0 155 0 0 0 98 0 0 0 0 0 0 0 50 3 0 0 193 0 0 0 193 0 0 0 0 0 0 0 31 0 0 0 ]!

elvWithEmbeddedComboBoxBytes20

	^#[33 83 84 66 32 52 32 78 8 12 0 10 0 0 0 83 84 66 86 105 101 119 80 114 111 120 121 154 0 0 0 18 1 0 0 20 0 0 0 83 83 87 32 69 100 105 116 97 98 108 101 76 105 115 116 86 105 101 119 18 1 0 0 16 0 0 0 69 100 105 116 97 98 108 101 76 105 115 116 86 105 101 119 98 0 0 0 55 0 0 0 0 0 0 0 0 0 0 0 98 0 0 0 2 0 0 0 130 0 0 0 4 0 0 0 78 16 1 68 1 4 0 0 160 1 0 0 70 3 9 0 2 0 0 0 76 105 115 116 77 111 100 101 108 202 0 0 0 208 0 0 0 98 0 0 0 0 0 0 0 0 0 0 0 6 0 20 0 73 100 101 110 116 105 116 121 83 101 97 114 99 104 80 111 108 105 99 121 6 0 5 0 67 111 108 111 114 178 0 0 0 7 0 0 0 100 101 102 97 117 108 116 0 0 0 0 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 160 1 0 0 0 0 0 0 130 0 0 0 4 0 0 0 112 84 149 116 102 5 12 0 3 0 0 0 66 108 111 99 107 67 108 111 115 117 114 101 0 0 0 0 0 0 0 0 38 5 14 0 67 111 109 112 105 108 101 100 77 101 116 104 111 100 2 0 0 0 3 0 0 0 154 0 0 0 18 1 0 0 22 0 0 0 68 111 108 112 104 105 110 32 76 105 115 116 32 80 114 101 115 101 110 116 101 114 18 1 0 0 15 0 0 0 76 105 115 116 67 111 110 116 114 111 108 86 105 101 119 178 0 0 0 19 0 0 0 100 101 102 97 117 108 116 71 101 116 84 101 120 116 66 108 111 99 107 227 142 107 25 114 0 0 0 5 0 0 0 30 105 226 0 106 178 0 0 0 13 0 0 0 100 105 115 112 108 97 121 83 116 114 105 110 103 192 2 0 0 7 0 0 0 1 1 0 0 0 0 0 0 178 2 0 0 0 0 0 0 0 0 0 0 210 2 0 0 2 0 0 0 3 0 0 0 154 0 0 0 18 1 0 0 23 0 0 0 68 111 108 112 104 105 110 32 67 111 109 109 111 110 32 67 111 110 116 114 111 108 115 18 1 0 0 18 0 0 0 73 99 111 110 105 99 76 105 115 116 65 98 115 116 114 97 99 116 178 0 0 0 20 0 0 0 100 101 102 97 117 108 116 71 101 116 73 109 97 103 101 66 108 111 99 107 99 185 210 25 114 0 0 0 5 0 0 0 30 105 226 0 106 178 0 0 0 14 0 0 0 105 99 111 110 73 109 97 103 101 73 110 100 101 120 80 3 0 0 7 0 0 0 1 1 0 0 0 0 0 0 70 5 16 0 1 0 0 0 73 99 111 110 73 109 97 103 101 77 97 110 97 103 101 114 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 202 0 0 0 208 0 0 0 98 0 0 0 1 0 0 0 70 23 22 0 15 0 0 0 69 100 105 116 97 98 108 101 76 105 115 116 86 105 101 119 67 111 108 117 109 110 82 0 0 0 8 0 0 0 67 111 108 117 109 110 32 49 201 0 0 0 178 0 0 0 4 0 0 0 108 101 102 116 6 2 7 0 77 101 115 115 97 103 101 64 3 0 0 64 2 0 0 82 4 0 0 178 0 0 0 2 0 0 0 60 61 64 2 0 0 0 0 0 0 0 0 0 0 160 1 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 16 0 0 0 0 0 0 0 70 19 16 0 20 0 0 0 69 109 98 101 100 100 101 100 67 111 109 98 111 66 111 120 0 0 0 0 0 0 0 0 98 0 0 0 2 0 0 0 5 13 98 8 1 0 0 0 160 4 0 0 18 2 0 0 202 0 0 0 208 0 0 0 64 2 0 0 0 0 0 0 96 2 0 0 128 2 0 0 0 0 0 0 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 160 4 0 0 0 0 0 0 0 0 0 0 192 2 0 0 0 0 0 0 145 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 178 0 0 0 10 0 0 0 115 109 97 108 108 73 99 111 110 115 64 2 0 0 0 0 0 0 97 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 1 15 0 77 101 115 115 97 103 101 83 101 113 117 101 110 99 101 202 0 0 0 208 0 0 0 98 0 0 0 1 0 0 0 6 3 11 0 77 101 115 115 97 103 101 83 101 110 100 178 0 0 0 16 0 0 0 99 114 101 97 116 101 65 116 58 101 120 116 101 110 116 58 98 0 0 0 2 0 0 0 6 2 5 0 80 111 105 110 116 1 0 0 0 1 0 0 0 114 5 0 0 145 1 0 0 189 2 0 0 160 1 0 0 6 1 15 0 87 73 78 68 79 87 80 76 65 67 69 77 69 78 84 114 0 0 0 44 0 0 0 44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 200 0 0 0 94 1 0 0 98 0 0 0 0 0 0 0 114 5 0 0 193 0 0 0 193 0 0 0 0 0 0 0 33 0 0 0 ]!

initializePresenter

	presenter := ListPresenter show: 'Editable list view'.
	presenter model: (ListModel on: (1 to: 5) asOrderedCollection)!

testColumnInvalidation
	"#1328 The column invalidation rectangle was wrong when the ELV was not at y=0 in its parent"

	<nocreate>
	| shell elv rect |
	shell := ShellView new create.
	shell rectangle: (100 @ 100 extent: 300 @ 400).
	
	[shell show.
	elv := ListPresenter loadViewResource: 'Editable list view' inContext: shell.
	elv
		getImageBlock: nil;
		model: (ListModel withAll: (1 to: 10));
		position: 0 @ 100;
		show;
		onViewOpened.

	"Flush any pending invalidation"
	SessionManager current inputState pumpMessages.

	"Set a custom background color and invalidate only column 1"
	elv rowBackcolor: Color red.
	elv primaryColumn invalidate.
	SessionManager current inputState pumpMessages.

	"Previously the column invalidation rectangle was incorrect preventing upper items in the list from being invalidated"
	rect := elv subItemRectRow: 1 column: 1.
	self assert: (elv canvas pixelAt: rect center) equals: Color red]
			ensure: [shell exit]!

testEmbeddedComboBoxStbConversion20
	"#1030 Ensure legacy EmbeddedComboBoxes are valid when opened (specifically lastSelIndices)"

	<nocreate>
	| elv |
	elv := Object fromBinaryStoreBytes: self elvWithEmbeddedComboBoxBytes20 context: View desktop.
	[self assert: elv allColumns first editor lastSelIndices equals: #()] ensure: [elv close]!

testMultiSelectAnchor

	"#1329 Ensure multi-selection range is set correctly, specifically in relation to the anchor item"

	presenter view isMultiSelect: true.

	self clickRow: 3 column: 1 modifiers: 0.
	self assert: presenter selections size equals: 1.
	self assert: presenter selectionByIndex equals: 3.

	self clickRow: 5 column: 1 modifiers: 0.
	self assert: presenter selections size equals: 1.
	self assert: presenter selectionByIndex equals: 5.

	self clickRow: 1 column: 1 modifiers: MK_SHIFT.

	"Previously the anchor would still have been 3 from the initial 'click' resulting in only 1-3 being selected"
	self assert: presenter selections size equals: 5.
	self assert: presenter selections asSortedCollection asArray equals: #(1 2 3 4 5)!

testOwnerDrawnCheckBox

	"#1333 A non-primary column with some types of owner-drawn editors (e.g. if the column has an image) caused MNU: UndefinedObject does not understand asCOLORREF during display.
	Test all editor classes for completeness"

	EditableListViewColumn new
		editor: EmbeddedCheckBox new;
		getContentsBlock: [ :item | item odd];
		getImageBlock: [ :item | item icon];
		showIn: presenter view.

	self shouldnt: [self drawEditableListViewAfter: [ :elv | elv hasColumnImages: true]] raise: MessageNotUnderstood!

testOwnerDrawnComboBox

	"#1333 A non-primary column with an owner-drawn combo box (e.g. if the column has an image) caused MNU: UndefinedObject does not understand asCOLORREF during display"

	EditableListViewColumn new
		editor: EmbeddedComboBox new;
		getImageBlock: [ :date | date icon];
		showIn: presenter view.

	self shouldnt: [self drawEditableListViewAfter: [ :elv | elv hasColumnImages: true]] raise: MessageNotUnderstood!

testOwnerDrawnFormattedTextEdit

	"#1333 A non-primary column with an owner-drawn formatted text edit (e.g. if the column has an image) caused MNU: UndefinedObject does not understand asCOLORREF during display"

	EditableListViewColumn new
		editor: EmbeddedFormattedTextEdit newForDate;
		getContentsBlock: [ :index | Date today addDays: index];
		getTextBlock: [ :date | date shortString];
		getImageBlock: [ :date | date icon];
		showIn: presenter view.

	self shouldnt: [self drawEditableListViewAfter: [ :elv | elv hasColumnImages: true]] raise: MessageNotUnderstood!

testOwnerDrawnMultilineTextEdit

	"#1333 A non-primary column with some types of owner-drawn editors (e.g. if the column has an image) caused MNU: UndefinedObject does not understand asCOLORREF during display.
	Test all editor classes for completeness"

	EditableListViewColumn new
		editor: EmbeddedMultilineTextEdit new;
		getContentsBlock: [ :item | item displayString];
		getImageBlock: [ :item | item icon];
		showIn: presenter view.

	self shouldnt: [self drawEditableListViewAfter: [ :elv | elv hasColumnImages: true]] raise: MessageNotUnderstood!

testOwnerDrawnRadioButton

	"#1333 A non-primary column with some types of owner-drawn editors (e.g. if the column has an image) caused MNU: UndefinedObject does not understand asCOLORREF during display.
	Test all editor classes for completeness"

	EditableListViewColumn new
		editor: EmbeddedRadioButton new;
		getContentsBlock: [ :item | item odd];
		getImageBlock: [ :item | item icon];
		showIn: presenter view.

	self shouldnt: [self drawEditableListViewAfter: [ :elv | elv hasColumnImages: true]] raise: MessageNotUnderstood!

testOwnerDrawnTextEdit

	"#1333 A non-primary column with some types of owner-drawn editors (e.g. if the column has an image) caused MNU: UndefinedObject does not understand asCOLORREF during display.
	Test all editor classes for completeness"

	EditableListViewColumn new
		editor: EmbeddedTextEdit new;
		getContentsBlock: [ :item | item displayString];
		getImageBlock: [ :item | item icon];
		showIn: presenter view.

	self shouldnt: [self drawEditableListViewAfter: [ :elv | elv hasColumnImages: true]] raise: MessageNotUnderstood!

testPackageClosure
	"Tests predicted unimplemented messages in EditableListViewDemo
		- defineTemplate- sent from ExternalStructure>>ensureDefined, which is replaced with a no-op stub in deployed apps. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps.
		- evaluate: Compiler deliberately removed from the scope of the test to reduce noise. Should not be in the UnimplementedMessages section of the actual deployment log for GUI apps."
	<nocreate>
	| missing aBrowserEnvironment expected |
	aBrowserEnvironment := BrowserEnvironment new
				forPackagesDeployment: { EditableListViewDemo owningPackage }.
	missing := Smalltalk developmentSystem unimplementedSelectorsIn: aBrowserEnvironment.
	expected := #(#defineTemplate).
	"Use symmetric  difference, as we also want to fix up the test if some missing message is fixed."
	self assert: (missing symmetricDifference: expected) asArray sort equals: #()
	"To debug this, open an env browser on the deployment scope as follows:
		EnvironmentBrowserShell onEnvironment: aBrowserEnvironment.
	The call graph to unimplemented messages can then be investigated starting with the Method/Browse other/All unimplemented command"!

testSelectionColorOverridesRowBackcolor

	"#1330
	This test is included for reference/completeness only; it wasn't possible to programatically reproduce the cosmetic issue in the bug report"

	| elv rect2 rect3 rect4 selectionColor |

	elv := presenter view.
	elv isMultiSelect: true.

	elv customDrawBlock: 
		[ :context | 
		context view rowBackcolor: nil.
		context item = 3 ifTrue: [context view rowBackcolor: Color red]].

	"Test unselected behaviour - row 3 should be red; others default"
	elv invalidate.
	SessionManager inputState pumpMessages.
	rect2 := presenter view subItemRectRow: 2 column: 1.
	self assert: (elv canvas pixelAt: rect2 center) equals: Color window.
	rect3 := presenter view subItemRectRow: 3 column: 1.
	self assert: (elv canvas pixelAt: rect3 center) equals: Color red.
	rect4 := presenter view subItemRectRow: 4 column: 1.
	self assert: (elv canvas pixelAt: rect4 center) equals: Color window.

	self clickRow: 4 column: 1 modifiers: 0.
	self assert: presenter selectionByIndex equals: 4.

	self clickRow: 2 column: 1 modifiers: MK_SHIFT.
	self assert: presenter selections asSortedCollection asArray equals: #(2 3 4).
	elv invalidate.
	SessionManager inputState pumpMessages.
	
	"Selected rows including those with special background colors should have the default selection background color"
	selectionColor := elv canvas pixelAt: rect2 center.
	self assert: (elv canvas pixelAt: rect3 center) equals: selectionColor.
	self assert: (elv canvas pixelAt: rect4 center) equals: selectionColor!

testStbConversion15
	"#1024: Ensure repurposed inst var slots from version 15 are cleared out"

	<nocreate>
	| instVarNames elv |
	instVarNames := EditableListView allInstanceVariableNames.
	elv := Object fromBinaryStoreBytes: self editableListViewBytes15 context: View desktop.
	self assert: elv lvFlags equals: 0.
	
	[self assert: (elv instVarAt: (instVarNames indexOf: 'originalColumns')) equals: nil.
	self assert: (elv instVarAt: (instVarNames indexOf: 'headerControl')) equals: nil]
			ensure: [elv close]!

testTooltipTextResetWhenColumnAdded

	"Related to #1332"

	| elv lastIndex |

	elv := presenter view.
	elv allColumns first getInfoTipBlock: [ :item | '*<1d>*' << item].

	"Test the normal behaviour"
	lastIndex := presenter model size.
	elv hotItemAndColumn: lastIndex@1.
	elv lvmGetToolTips ifNotNil: [ :tipHwnd | UserLibrary default showWindow: tipHwnd nCmdShow: SW_SHOW].
	self assert: elv hotItemTipText equals: '*<1d>*' << lastIndex.
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd)]).

	EditableListViewColumn new
		getContentsBlock: [ :item | item];
		getInfoTipBlock: [ :item | '*<1d>*' << item];
		showIn: presenter view.

	"Ensure the active tip text has been reset"
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd) not]).
	self assert: elv hotItemTipText equals: nil!

testTooltipTextResetWhenColumnOrderChanged

	"Related to #1332"

	| elv lastIndex |

	elv := presenter view.
	elv allColumns first getInfoTipBlock: [ :item | '*<1d>*' << item].

	EditableListViewColumn new
		getContentsBlock: [ :item | item];
		getInfoTipBlock: [ :item | '/<1d>/' << item];
		showIn: presenter view.

	"Test the normal behaviour"
	lastIndex := presenter model size.
	elv hotItemAndColumn: lastIndex@1.
	elv lvmGetToolTips ifNotNil: [ :tipHwnd | UserLibrary default showWindow: tipHwnd nCmdShow: SW_SHOW].
	self assert: elv hotItemTipText equals: '*<1d>*' << lastIndex.
	elv hotItemAndColumn: lastIndex@2.
	self assert: elv hotItemTipText equals: '/<1d>/' << lastIndex.
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd)]).

	presenter view columnOrder: #(2 1).

	"Ensure the active tip text has been reset"
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd) not]).
	self assert: elv hotItemTipText equals: nil!

testTooltipTextResetWhenColumnRemoved

	"#1332 An error occurs when removing a columns with an active tooltip window for that column"

	| elv lastIndex |

	elv := presenter view.
	EditableListViewColumn new
		getContentsBlock: [ :item | item];
		getInfoTipBlock: [ :item | '*<1d>*' << item];
		showIn: presenter view.

	"Test the normal behaviour"
	lastIndex := presenter model size.
	elv hotItemAndColumn: lastIndex@2.
	elv lvmGetToolTips ifNotNil: [ :tipHwnd | UserLibrary default showWindow: tipHwnd nCmdShow: SW_SHOW].
	self assert: elv hotItemTipText equals: '*<1d>*' << lastIndex.
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd)]).

	self shouldnt: [elv allColumns last hide] raise: BoundsError.
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd) not]).
	self shouldnt: [elv hotItemTipText] raise: BoundsError.
	self assert: elv hotItemTipText equals: nil!

testTooltipTextResetWhenItemAdded

	"#1331 When adding an item an active tooltip window remains visible even if the relevant item has moved"

	| elv lastIndex |

	elv := presenter view.
	elv allColumns first getInfoTipBlock: [ :item | '*<1d>*' << item].

	"Test the normal behaviour"
	lastIndex := presenter model size.
	elv hotItemAndColumn: lastIndex@1.
	elv lvmGetToolTips ifNotNil: [ :tipHwnd | UserLibrary default showWindow: tipHwnd nCmdShow: SW_SHOW].
	self assert: elv hotItemTipText equals: '*<1d>*' << lastIndex.
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd)]).

	presenter model addFirst: 0.

	"Ensure the active tip text has been reset"
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd) not]).
	self assert: elv hotItemTipText equals: nil!

testTooltipTextResetWhenItemRemoved

	"#1331 When removing an item an active tooltip window for that item remains visible or errors when refreshed"

	| elv lastIndex |

	elv := presenter view.
	elv allColumns first getInfoTipBlock: [ :item | '*<1d>*' << item].

	"Test the normal behaviour"
	lastIndex := presenter model size.
	elv hotItemAndColumn: lastIndex@1.
	elv lvmGetToolTips ifNotNil: [ :tipHwnd | UserLibrary default showWindow: tipHwnd nCmdShow: SW_SHOW].
	self assert: elv hotItemTipText equals: '*<1d>*' << lastIndex.
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd)]).

	presenter model removeLast.

	"At this point one of the following may happen:
	 - nothing - previously the tip window for the removed item remained visible (wrong)
	 - the view receives a tip text request - previously a BoundsError would occur if the removed item was last since the hot item index was now out of range.
	 - the view received a mouse exit or move event which resets the hot item - this meant neither of the first two issues happened 
	The reason for the different pattern could not be determined.

	Both potential issues are now resolved by resetting the hot item and hiding any tip window when the list changes - verify this:"
	self assert: (elv lvmGetToolTips ifNil: [true] ifNotNil: [ :tipHwnd | (UserLibrary default isWindowVisible: tipHwnd) not]).
	self shouldnt: [elv hotItemTipText] raise: BoundsError.
	self assert: elv hotItemTipText equals: nil! !

!EditableListViewTest categoriesForMethods!
classToTest!helpers!private! !
clickRow:column:modifiers:!helpers!private! !
drawEditableListViewAfter:!helpers!private! !
editableListViewBytes15!constants!private! !
elvWithEmbeddedComboBoxBytes20!constants!private! !
initializePresenter!public!running! !
testColumnInvalidation!public!unit tests! !
testEmbeddedComboBoxStbConversion20!public!unit tests! !
testMultiSelectAnchor!public!unit tests! !
testOwnerDrawnCheckBox!public!unit tests! !
testOwnerDrawnComboBox!public!unit tests! !
testOwnerDrawnFormattedTextEdit!public!unit tests! !
testOwnerDrawnMultilineTextEdit!public!unit tests! !
testOwnerDrawnRadioButton!public!unit tests! !
testOwnerDrawnTextEdit!public!unit tests! !
testPackageClosure!public!unit tests! !
testSelectionColorOverridesRowBackcolor!public!unit tests! !
testStbConversion15!public!unit tests! !
testTooltipTextResetWhenColumnAdded!public!unit tests! !
testTooltipTextResetWhenColumnOrderChanged!public!unit tests! !
testTooltipTextResetWhenColumnRemoved!public!unit tests! !
testTooltipTextResetWhenItemAdded!public!unit tests! !
testTooltipTextResetWhenItemRemoved!public!unit tests! !
!

