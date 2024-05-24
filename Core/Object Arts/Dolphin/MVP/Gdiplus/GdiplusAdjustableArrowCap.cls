"Filed out from Dolphin Smalltalk"!

GdiplusCustomLineCap subclass: #GdiplusAdjustableArrowCap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusAdjustableArrowCap guid: (GUID fromString: '{c1fcc800-8763-11d7-b609-00e0987e8081}')!

GdiplusAdjustableArrowCap comment: 'GdiplusAdjustableArrowCap creates a line cap that looks like an arrow.'!

!GdiplusAdjustableArrowCap categoriesForClass!Unclassified! !

!GdiplusAdjustableArrowCap methodsFor!

height
	"Answer the height of the receiver's cap."

	| height |
	height := FLOAT new.
	GdiplusLibrary default gdipGetAdjustableArrowCapHeight: self asParameter height: height.
	^height value!

height: aNumber
	"Set the height of the receiver's arrow cap."

	GdiplusLibrary default gdipSetAdjustableArrowCapHeight: self asParameter height: aNumber!

isFilled
	"Answer whether the receiver's cap is filled."

	| isFilled |
	isFilled := SDWORD new.
	GdiplusLibrary default gdipGetAdjustableArrowCapFillState: self asParameter fillState: isFilled.
	^isFilled value asBoolean!

isFilled: aBoolean
	"Set whether the receiver's arrow cap should be filled."

	GdiplusLibrary default gdipSetAdjustableArrowCapFillState: self asParameter
		fillState: aBoolean asParameter!

middleInset
	"Answer the middleInset of the receiver's cap."

	| middleInset |
	middleInset := FLOAT new.
	GdiplusLibrary default gdipGetAdjustableArrowCapMiddleInset: self asParameter
		middleInset: middleInset.
	^middleInset value!

middleInset: aNumber
	"Set the middleInset of the receiver's arrow cap."

	GdiplusLibrary default gdipSetAdjustableArrowCapMiddleInset: self asParameter middleInset: aNumber!

width
	"Answer the width of the receiver's cap."

	| width |
	width := FLOAT new.
	GdiplusLibrary default gdipGetAdjustableArrowCapWidth: self asParameter width: width.
	^width value!

width: aNumber
	"Set the width of the receiver's arrow cap."

	GdiplusLibrary default gdipSetAdjustableArrowCapWidth: self asParameter width: aNumber! !

!GdiplusAdjustableArrowCap categoriesForMethods!
height!accessing!public! !
height:!accessing!public! !
isFilled!accessing!public! !
isFilled:!accessing!public! !
middleInset!accessing!public! !
middleInset:!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
!

!GdiplusAdjustableArrowCap class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self fromInitializer: (GdiplusAdjustableArrowCapInitializer 
				height: heightReal
				width: widthReal
				isFilled: isFilledBoolean)!

strokePath: aStrokePath
	^self shouldNotImplement! !

!GdiplusAdjustableArrowCap class categoriesForMethods!
height:width:isFilled:!instance creation!public! !
strokePath:!instance creation!public! !
!

