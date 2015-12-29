"Filed out from Dolphin Smalltalk X6"!

ILExtentDialog subclass: #ILBitmapExtentDialog
	instanceVariableNames: 'bitmapExtent'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILBitmapExtentDialog guid: (GUID fromString: '{563212BC-54F9-430C-ADDD-0101F3B64EC0}')!
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
!ILBitmapExtentDialog categoriesFor: #bitmapExtent:!accessing!initializing!public! !
!ILBitmapExtentDialog categoriesFor: #onSelectionChanged!event handling!public! !

!ILBitmapExtentDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (LiteralResourceIdentifier class: self name name: 'Default view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(DialogView) 98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 133 0 0 0 416 852230 ##(FramingLayout) 234 240 98 14 410 8 ##(StaticText) 98 16 0 416 98 2 8 1140850946 1 592 0 0 0 7 0 0 0 592 0 8 4294904261 852486 ##(NullConverter) 0 0 0 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 81 475 850 101 51 592 786 8 #text: 98 1 8 'Height' 592 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 237 0 0 0 90 0 0 0 6 1 0 0] 98 0 850 193 193 0 27 1181766 2 ##(FramingConstraints) 1114638 ##(STBSingletonProxy) 8 ##(FramingCalculation) 8 #fixedParentLeft 81 1082 1104 8 #fixedViewLeft 101 1082 1104 8 #fixedPreviousBottom 17 1082 1104 8 #fixedViewTop 51 410 8 ##(TextEdit) 98 16 0 416 98 2 8 1140924416 1025 1232 0 482 512 0 7 0 0 0 1232 0 8 4294904653 852742 ##(IntegerToText) 0 8 '' 0 1 722 202 208 98 3 786 816 98 2 850 197 459 850 121 51 1232 786 8 #selectionRange: 98 1 525062 ##(Interval) 3 1 3 1232 786 8 #isTextModified: 98 1 32 1232 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 229 0 0 0 158 0 0 0 254 0 0 0] 98 0 1024 0 27 1042 1082 1104 8 #fixedPreviousRight 17 1136 121 1082 1104 8 #fixedPreviousTop -15 1200 51 410 608 98 16 0 416 98 2 8 1140850946 1 1760 0 0 0 7 0 0 0 1760 0 8 4294904261 690 0 0 0 722 202 208 98 2 786 816 98 2 850 81 409 850 101 51 1760 786 912 98 1 8 'Width' 1760 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 204 0 0 0 90 0 0 0 229 0 0 0] 98 0 1024 0 27 1042 1088 81 1136 101 1168 33 1200 51 410 8 ##(ReferenceView) 98 14 0 416 98 2 8 1140850688 131073 2080 0 0 0 5 0 0 0 2080 1638918 ##(ResourceIdentifier) 8 ##(Presenter) 8 #resource_OK_Cancel_button_block 0 722 202 208 98 1 786 816 98 2 850 553 443 850 311 71 2080 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 1 0 0 221 0 0 0 175 1 0 0 0 1 0 0] 98 0 1024 0 27 1042 1082 1104 8 #fixedViewRight -309 1082 1104 8 #fixedParentRight -15 1728 -15 1200 71 410 1248 98 16 0 416 98 2 8 1140924416 1025 2464 0 482 512 0 7 0 0 0 2464 0 8 4294904653 1346 0 8 '' 0 1 722 202 208 98 3 786 816 98 2 850 197 409 850 121 51 2464 786 1520 98 1 1554 3 1 3 2464 786 1600 98 1 32 2464 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 0 0 0 204 0 0 0 158 0 0 0 229 0 0 0] 98 0 1024 0 27 1042 1696 17 1136 121 1728 1 1168 1 410 608 98 16 0 416 98 2 8 1140850945 1 2848 0 0 0 7 0 0 0 2848 0 8 4294904261 690 0 0 0 722 202 208 98 2 786 816 98 2 850 455 17 850 409 361 2848 786 912 98 1 8 'Select the required image size from the list on the left, which shows all the different layouts which are applicable to this bitmap.

You can also specify a size which is not an exact multiple of the bitmap''s width or height but this will result in areas of the original bitmap being omitted or left blank.' 2848 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 227 0 0 0 8 0 0 0 175 1 0 0 188 0 0 0] 98 0 1024 0 27 1042 1696 17 2432 -15 1728 1 1168 1 410 8 ##(ListBox) 98 17 0 416 98 2 8 1144062209 1025 3168 590662 2 ##(ListModel) 202 208 2368 0 1082 8 ##(SearchPolicy) 8 #identity 482 512 0 7 0 0 0 3168 0 8 4294904553 8 ##(BasicListAbstract) 2368 32 722 202 208 98 2 786 816 98 2 850 17 17 850 423 361 3168 786 8 #horizontalExtent: 98 1 1 3168 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 8 0 0 0 8 0 0 0 219 0 0 0 188 0 0 0] 98 0 1024 0 27 1042 1088 17 1082 1104 8 #relativeParentWidth 524806 ##(Fraction) 3 5 1082 1104 8 #fixedParentTop 17 1200 361 234 256 98 6 3168 8 'options' 1232 8 'height' 2464 8 'width' 0 0 0 0 0 14051 0 0 0 0 1 0 0 590598 ##(Semaphore) 0 0 1 0 8 2010572111 722 202 208 98 3 786 816 98 2 850 1155 905 850 891 591 416 786 912 98 1 8 'Individual Bitmap Size Dialog' 416 786 8 #menuBar: 98 1 0 416 962 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 2 0 0 196 1 0 0 254 3 0 0 235 2 0 0] 98 7 3168 2848 1760 2464 592 1232 2080 1024 0 27)! !
!ILBitmapExtentDialog class categoriesFor: #resource_Default_view!public!resources-views! !

