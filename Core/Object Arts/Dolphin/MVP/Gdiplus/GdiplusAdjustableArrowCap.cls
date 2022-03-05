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

exampleGdipAACArrowCap
	"This example displays several lines with arrow caps, showing the effects of changing aspects.

		self exampleGdipAACArrowCap showExample
	"

	| bitmap graphics arrowCap pen |
	bitmap := GdiplusBitmap extent: 350 @ 300.
	graphics := bitmap graphics.
	arrowCap := GdiplusAdjustableArrowCap 
				height: 10
				width: 5
				isFilled: false.
	pen := GdiplusPen red width: 2.
	pen customEndCap: arrowCap.
	graphics drawLine: (20 @ 20 extent: 250 @ 0) pen: pen.
	pen customStartCap: arrowCap.
	arrowCap isFilled: true.
	pen customEndCap: arrowCap.
	graphics drawLine: (20 @ 70 extent: 250 @ 0) pen: pen.
	pen customStartCap: arrowCap.
	arrowCap height: 20.
	pen customEndCap: arrowCap.
	graphics drawLine: (20 @ 120 extent: 250 @ 0) pen: pen.
	pen customStartCap: arrowCap.
	arrowCap width: 10.
	pen customEndCap: arrowCap.
	graphics drawLine: (20 @ 170 extent: 250 @ 0) pen: pen.
	pen customStartCap: arrowCap.
	arrowCap middleInset: 5.
	pen customEndCap: arrowCap.
	graphics drawLine: (20 @ 220 extent: 250 @ 0) pen: pen.
	pen customStartCap: arrowCap.
	pen customEndCap: GdiplusCustomLineCap new.
	graphics drawLine: (20 @ 270 extent: 250 @ 0) pen: pen.
	^bitmap!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self fromInitializer: (GdiplusAdjustableArrowCapInitializer 
				height: heightReal
				width: widthReal
				isFilled: isFilledBoolean)!

strokePath: aStrokePath
	^self shouldNotImplement! !
!GdiplusAdjustableArrowCap class categoriesForMethods!
exampleGdipAACArrowCap!examples!public!unit tests! !
height:width:isFilled:!instance creation!public! !
strokePath:!instance creation!public! !
!

