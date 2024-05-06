"Filed out from Dolphin Smalltalk"!

ILExtentDialog subclass: #ILBitmapExtentDialog
	instanceVariableNames: 'bitmapExtent'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILBitmapExtentDialog guid: (GUID fromString: '{563212bc-54f9-430c-addd-0101f3b64ec0}')!

ILBitmapExtentDialog comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILBitmapExtentDialog categoriesForClass!IDB Goodies! !

!ILBitmapExtentDialog methodsFor!

bitmapExtent: aPoint
	bitmapExtent := aPoint.
	self options: ((1 to: aPoint x) select: [:each | aPoint x \\ each = 0]
				thenCollect: 
					[:each | 
					(String writeStream)
						print: aPoint x // each;
						nextPutAll: ' bitmap';
						nextPutAll: (aPoint x // each = 1 ifTrue: [' '] ifFalse: ['s ']);
						nextPutAll: 'sized ';
						print: each;
						nextPutAll: ' x ';
						print: aPoint y;
						contents])!

onSelectionChanged
	| parts |
	parts := optionsPresenter selection subStrings.
	widthPresenter value: (Number fromString: (parts at: 4)).
	heightPresenter value: (Number fromString: (parts at: 6))! !

!ILBitmapExtentDialog categoriesForMethods!
bitmapExtent:!accessing!initializing!public! !
onSelectionChanged!event handling!public! !
!

!ILBitmapExtentDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 14 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 672 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 672 nil 8 1912559344 ##(Smalltalk.BasicListAbstract) 784 false 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 17 17 578 413 361 672 962 #horizontalExtent: 8 #(0) 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 214 0 0 0 188 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 17 1186 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 3 5 1186 #fixedParentTop 17 1186 #fixedViewTop 361 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924416 1025 1296 nil 834 864 nil 7 nil nil nil 1296 nil 8 1912718128 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 578 197 445 578 121 41 1296 962 #setMarginWidths: 34 1 8 #(3 3) 1296 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 222 0 0 0 158 0 0 0 242 0 0 0] 8 #() 1136 nil 27 1154 1186 #fixedPreviousRight 17 1186 #fixedViewLeft 121 1186 #fixedPreviousTop -3 1186 #fixedPreviousBottom 1 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924416 1025 1728 nil 834 864 nil 7 nil nil nil 1728 nil 8 1912718128 1394 nil 8 '' nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 578 197 393 578 121 41 1728 962 #setMarginWidths: 34 1 8 #(3 3) 1728 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 196 0 0 0 158 0 0 0 216 0 0 0] 8 #() 1136 nil 27 1154 1664 17 1680 121 1696 -3 1712 1 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2080 nil nil nil 7 nil nil nil 2080 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 507 431 578 335 71 2080 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 0 0 0 215 0 0 0 164 1 0 0 250 0 0 0] 784 1136 nil 27 1154 1186 #fixedViewRight -333 1186 #fixedParentRight -17 1696 -13 1186 #fixedParentBottom -11 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850946 1 2384 nil nil nil 7 nil nil nil 2384 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 81 449 578 101 37 2384 962 #text: 34 1 8 'Height' 2384 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 224 0 0 0 90 0 0 0 242 0 0 0] 8 #() 1136 nil 27 1154 1200 81 1680 101 1712 17 1280 37 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850946 1 2720 nil nil nil 7 nil nil nil 2720 nil 8 1912674480 2466 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 81 397 578 101 37 2720 962 #text: 34 1 8 'Width' 2720 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 198 0 0 0 90 0 0 0 216 0 0 0] 8 #() 1136 nil 27 1154 1200 81 1680 101 1712 21 1280 37 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 3040 nil nil nil 7 nil nil nil 3040 nil 8 1912674480 2466 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 445 17 578 399 361 3040 962 #text: 34 1 8 'Select the required image size from the list on the left, which shows all the different layouts which are applicable to this bitmap.

You can also specify a size which is not an exact multiple of the bitmap''s width or height but this will result in areas of the original bitmap being omitted or left blank.' 3040 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 222 0 0 0 8 0 0 0 165 1 0 0 188 0 0 0] 8 #() 1136 nil 27 1154 1664 17 2352 -15 1696 1 1712 1 170 192 34 6 672 8 'options' 1728 8 'width' 1296 8 'height' nil nil nil nil nil 32383 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 898 138 144 34 3 962 #createAt:extent: 34 2 578 3839 21 578 891 591 416 962 #text: 34 1 8 'Individual Bitmap Size Dialog' 416 962 #updateMenuBar 784 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 60 9 0 0 49 1 0 0] 34 7 672 3040 2720 1728 2384 1296 2080 1136 nil 27)! !

!ILBitmapExtentDialog class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

