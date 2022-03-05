"Filed out from Dolphin Smalltalk"!

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
!ILExtentDialog categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onSelectionChanged!event handling!public! !
options:!initializing!public! !
!

!ILExtentDialog class methodsFor!

defaultModel
	^16 @ 16!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 672 nil nil nil 7 nil nil nil 672 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 445 17 578 399 369 672 850 #text: 34 1 8 'Select the required image size from the list on the left, which shows the size of any images currently in the library and  a selection of common values.

You can also specify a new size by entering the appropriate values for the image''s width and height.' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 8 0 0 0 165 1 0 0 192 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 17 1090 #fixedParentRight -15 1090 #fixedPreviousTop 1 1090 #fixedPreviousBottom 1 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850946 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1912674480 754 nil nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 578 81 405 578 101 37 1168 850 #text: 34 1 8 'Width' 1168 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 202 0 0 0 90 0 0 0 220 0 0 0] 8 #() 1040 nil 27 1058 1090 #fixedParentLeft 81 1090 #fixedViewLeft 101 1152 21 1090 #fixedViewTop 37 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850946 1 1536 nil nil nil 7 nil nil nil 1536 nil 8 1912674480 754 nil nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 578 81 457 578 101 37 1536 850 #text: 34 1 8 'Height' 1536 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 228 0 0 0 90 0 0 0 246 0 0 0] 8 #() 1040 nil 27 1058 1488 81 1504 101 1152 17 1520 37 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924416 1025 1856 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1856 nil 8 1912718128 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 786 138 144 34 2 850 #createAt:extent: 34 2 578 197 401 578 121 41 1856 850 #setMarginWidths: 34 1 8 #(3 3) 1856 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 200 0 0 0 158 0 0 0 220 0 0 0] 8 #() 1040 nil 27 1058 1104 17 1504 121 1136 -3 1152 1 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924416 1025 2256 nil 1922 1952 nil 7 nil nil nil 2256 nil 8 1912718128 1986 nil 8 '' nil 1 786 138 144 34 2 850 #createAt:extent: 34 2 578 197 453 578 121 41 2256 850 #setMarginWidths: 34 1 8 #(3 3) 2256 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 226 0 0 0 158 0 0 0 246 0 0 0] 8 #() 1040 nil 27 1058 1104 17 1504 121 1136 -3 1152 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2608 nil nil nil 7 nil nil nil 2608 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 786 138 144 34 1 850 #createAt:extent: 34 2 578 507 439 578 335 63 2608 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 0 0 0 219 0 0 0 164 1 0 0 250 0 0 0] 8 #() 1040 nil 27 1058 1090 #fixedViewRight -333 1120 -17 1136 -13 1090 #fixedParentBottom -11 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 2912 590662 2 ##(Smalltalk.ListModel) 138 144 2848 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1922 1952 nil 7 nil nil nil 2912 nil 8 1912559344 ##(Smalltalk.BasicListAbstract) 2848 false 786 138 144 34 2 850 #createAt:extent: 34 2 578 17 17 578 413 369 2912 850 #horizontalExtent: 8 #(0) 2912 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 214 0 0 0 192 0 0 0] 8 #() 1040 nil 27 1058 1488 17 1090 #relativeParentWidth 327734 ##(Smalltalk.Float) 8 0 0 0 0 0 0 224 63 1090 #fixedParentTop 17 2896 -127 170 192 34 6 1856 8 'width' 2256 8 'height' 2912 8 'options' nil nil nil nil nil 32543 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 786 138 144 34 3 850 #createAt:extent: 34 2 578 3839 21 578 891 591 416 850 #text: 34 1 8 'Library Image Size Dialog' 416 850 #updateMenuBar 2848 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 60 9 0 0 49 1 0 0] 34 7 2912 672 1168 1856 1536 2256 2608 1040 nil 27)! !
!ILExtentDialog class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
!

