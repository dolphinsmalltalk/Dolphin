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

	| status height |
	height := FLOAT new.
	(status := GdiplusLibrary default gdipGetAdjustableArrowCapHeight: self asParameter height: height)
		= Ok ifFalse: [GdiplusError signal: 'GdipGetAdjustableArrowCapHeight failed' with: status].
	^height value!

height: aNumber 
	"Set the height of the receiver's arrow cap."

	| status |
	(status := GdiplusLibrary default gdipSetAdjustableArrowCapHeight: self asParameter height: aNumber) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetAdjustableArrowCapHeight failed' with: status]!

isFilled
	"Answer whether the receiver's cap is filled."

	| status isFilled |
	isFilled := SDWORD new.
	(status := GdiplusLibrary default gdipGetAdjustableArrowCapFillState: self asParameter
				fillState: isFilled) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetAdjustableArrowCapFillState failed' with: status].
	^isFilled value asBoolean!

isFilled: aBoolean 
	"Set whether the receiver's arrow cap should be filled."

	| status |
	(status := GdiplusLibrary default gdipSetAdjustableArrowCapFillState: self asParameter
				fillState: aBoolean asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetAdjustableArrowCapFillState failed' with: status]!

middleInset
	"Answer the middleInset of the receiver's cap."

	| status middleInset |
	middleInset := FLOAT new.
	(status := GdiplusLibrary default gdipGetAdjustableArrowCapMiddleInset: self asParameter
				middleInset: middleInset) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetAdjustableArrowCapMiddleInset failed' with: status].
	^middleInset value!

middleInset: aNumber 
	"Set the middleInset of the receiver's arrow cap."

	| status |
	(status := GdiplusLibrary default gdipSetAdjustableArrowCapMiddleInset: self asParameter
				middleInset: aNumber) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetAdjustableArrowCapMiddleInset failed' with: status]!

width
	"Answer the width of the receiver's cap."

	| status width |
	width := FLOAT new.
	(status := GdiplusLibrary default gdipGetAdjustableArrowCapWidth: self asParameter width: width)
		= Ok ifFalse: [GdiplusError signal: 'GdipGetAdjustableArrowCapWidth failed' with: status].
	^width value!

width: aNumber 
	"Set the width of the receiver's arrow cap."

	| status |
	(status := GdiplusLibrary default gdipSetAdjustableArrowCapWidth: self asParameter width: aNumber) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetAdjustableArrowCapWidth failed' with: status]! !

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

