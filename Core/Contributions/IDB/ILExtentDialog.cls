"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ILExtentDialog
	instanceVariableNames: 'widthPresenter heightPresenter optionsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILExtentDialog guid: (GUID fromString: '{cb954d0c-f8cc-4ab0-a826-c1a6978a7106}')!
ILExtentDialog comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILExtentDialog categoriesForClass!IDB Goodies! !
!ILExtentDialog methodsFor!

createComponents
	super createComponents.
	widthPresenter := self add: NumberPresenter new name: 'width'.
	heightPresenter := self add: NumberPresenter new name: 'height'.
	optionsPresenter := self add: ListPresenter new name: 'options'!

createSchematicWiring
	super createSchematicWiring.
	optionsPresenter 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self.
	optionsPresenter 
		when: #actionPerformed
		send: #ok
		to: self!

model: aPoint
	super model: aPoint.
	widthPresenter model: (self model aspectValue: #x).
	heightPresenter model: (self model aspectValue: #y).
	optionsPresenter list: OrderedCollection new!

onSelectionChanged
	widthPresenter value: optionsPresenter selection x.
	heightPresenter value: optionsPresenter selection y!

options: aCollection
	optionsPresenter
		list: aCollection;
		selection: aCollection first! !
!ILExtentDialog categoriesFor: #createComponents!initializing!public! !
!ILExtentDialog categoriesFor: #createSchematicWiring!initializing!public! !
!ILExtentDialog categoriesFor: #model:!accessing!public! !
!ILExtentDialog categoriesFor: #onSelectionChanged!event handling!public! !
!ILExtentDialog categoriesFor: #options:!initializing!public! !

!ILExtentDialog class methodsFor!

defaultModel
	^16 @ 16!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (LiteralResourceIdentifier class: self name name: 'Default view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(DialogView) 98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 133 0 0 0 416 852230 ##(FramingLayout) 234 240 98 14 410 8 ##(ListBox) 98 17 0 416 98 2 8 1144062209 1025 592 590662 2 ##(ListModel) 202 208 98 0 0 1114638 ##(STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 482 512 0 7 0 0 0 592 0 8 4294904553 8 ##(BasicListAbstract) 720 32 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 17 17 978 423 383 592 914 8 #horizontalExtent: 98 1 1 592 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 219 0 0 0 199 0 0 0] 98 0 978 193 193 0 27 1181766 2 ##(FramingConstraints) 746 8 ##(FramingCalculation) 8 #fixedParentLeft 17 746 1200 8 #relativeParentWidth 327734 ##(Float) 8 0 0 0 0 0 0 224 63 746 1200 8 #fixedParentTop 17 746 1200 8 #fixedParentBottom -127 410 8 ##(TextEdit) 98 16 0 416 98 2 8 1140924416 1025 1360 0 482 512 0 7 0 0 0 1360 0 8 4294904653 852742 ##(IntegerToText) 0 8 '' 0 1 850 202 208 98 3 914 944 98 2 978 197 465 978 121 51 1360 914 8 #selectionRange: 98 1 525062 ##(Interval) 3 1 3 1360 914 8 #isTextModified: 98 1 32 1360 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 232 0 0 0 158 0 0 0 1 1 0 0] 98 0 1136 0 27 1154 746 1200 8 #fixedPreviousRight 17 746 1200 8 #fixedViewLeft 121 746 1200 8 #fixedPreviousTop -15 746 1200 8 #fixedViewTop 51 410 8 ##(StaticText) 98 16 0 416 98 2 8 1140850946 1 1952 0 0 0 7 0 0 0 1952 0 8 4294904261 852486 ##(NullConverter) 0 0 0 850 202 208 98 2 914 944 98 2 978 81 481 978 101 51 1952 914 8 #text: 98 1 8 'Height' 1952 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 240 0 0 0 90 0 0 0 9 1 0 0] 98 0 1136 0 27 1154 1184 81 746 1200 8 #fixedPreviousLeft -15 746 1200 8 #fixedPreviousBottom 17 1920 51 410 1968 98 16 0 416 98 2 8 1140850945 1 2384 0 0 0 7 0 0 0 2384 0 8 4294904261 2050 0 0 0 850 202 208 98 2 914 944 98 2 978 455 17 978 409 383 2384 914 2208 98 1 8 'Select the required image size from the list on the left, which shows the size of any images currently in the library and  a selection of common values.

You can also specify a new size by entering the appropriate values for the image''s width and height.' 2384 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 8 0 0 0 175 1 0 0 199 0 0 0] 98 0 1136 0 27 1154 1824 17 746 1200 8 #fixedParentRight -15 1888 1 2352 1 410 8 ##(ReferenceView) 98 14 0 416 98 2 8 1140850688 131073 2736 0 0 0 5 0 0 0 2736 1638918 ##(ResourceIdentifier) 8 ##(Presenter) 8 #resource_OK_Cancel_button_block 0 850 202 208 98 1 914 944 98 2 978 553 449 978 311 71 2736 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 1 0 0 224 0 0 0 175 1 0 0 3 1 0 0] 720 1136 0 27 1154 746 1200 8 #fixedViewRight -309 2704 -15 1888 -15 1920 71 410 1968 98 16 0 416 98 2 8 1140850946 1 3072 0 0 0 7 0 0 0 3072 0 8 4294904261 2050 0 0 0 850 202 208 98 2 914 944 98 2 978 81 431 978 101 51 3072 914 2208 98 1 8 'Width' 3072 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 215 0 0 0 90 0 0 0 240 0 0 0] 98 0 1136 0 27 1154 1184 81 1856 101 2352 33 1920 51 410 1376 98 16 0 416 98 2 8 1140924416 1025 3392 0 482 512 0 7 0 0 0 3392 0 8 4294904653 1474 0 8 '' 0 1 850 202 208 98 3 914 944 98 2 978 197 415 978 121 51 3392 914 1648 98 1 1682 3 1 3 3392 914 1728 98 1 32 3392 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 207 0 0 0 158 0 0 0 232 0 0 0] 98 0 1136 0 27 1154 1824 17 1856 121 1888 -15 1920 51 234 256 98 6 1360 8 'height' 592 8 'options' 3392 8 'width' 0 0 0 0 0 14119 0 0 0 0 1 0 0 590598 ##(Semaphore) 0 0 1 0 8 2010572111 850 202 208 98 3 914 944 98 2 978 1155 905 978 891 591 416 914 2208 98 1 8 'Library Image Size Dialog' 416 914 8 #menuBar: 98 1 0 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 2 0 0 196 1 0 0 254 3 0 0 235 2 0 0] 98 7 592 2384 3072 3392 1952 1360 2736 1136 0 27)! !
!ILExtentDialog class categoriesFor: #defaultModel!models!public! !
!ILExtentDialog class categoriesFor: #resource_Default_view!public!resources-views! !

