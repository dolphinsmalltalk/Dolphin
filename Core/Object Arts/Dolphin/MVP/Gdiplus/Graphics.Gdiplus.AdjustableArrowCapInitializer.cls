"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractCustomLineCapInitializer subclass: #'Graphics.Gdiplus.AdjustableArrowCapInitializer'
	instanceVariableNames: 'height width isFilled middleInset'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AdjustableArrowCapInitializer guid: (Core.GUID fromString: '{c1fcc801-8763-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.AdjustableArrowCapInitializer comment: ''!
!Graphics.Gdiplus.AdjustableArrowCapInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[super = anObject and: 
					[height = anObject height and: 
							[width = anObject width
								and: [isFilled = anObject isFilled and: [self middleInset = anObject middleInset]]]]]!

applyAdditionalAttributes: gpHandle
	super applyAdditionalAttributes: gpHandle.
	middleInset = 0
		ifFalse: [Gdip gdipSetAdjustableArrowCapMiddleInset: gpHandle middleInset: middleInset asFloat]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateAdjustableArrowCap: height
		width: width
		isFilled: isFilled
		cap: gpHandle.
	^gpHandle!

fillStateOf: anAdjustableArrowCap set: aBoolean
	Gdip gdipSetAdjustableArrowCapFillState: anAdjustableArrowCap handle fillState: aBoolean.
	isFilled := aBoolean!

hash
	"Answer the <integer> hash value for the receiver."

	^((((super hash + self middleInset hash) hashMultiply + height hash) hashMultiply + width hash)
		hashMultiply + isFilled hash)
		hashMultiply!

height
	^height!

height: heightReal width: widthReal isFilled: isFilledBoolean
	widthScale := 1.
	strokeJoin := LineJoinMiter.
	height := heightReal.
	width := widthReal.
	isFilled := isFilledBoolean.
	middleInset := 0.
	^self!

heightOf: anAdjustableArrowCap set: aNumber
	Gdip gdipSetAdjustableArrowCapHeight: anAdjustableArrowCap handle height: aNumber asFloat.
	height := aNumber!

initializeFromHandle: aGpAdjustableArrowCap
	"Private - Cache all the attributes of the native Gdiplus AdjustableArrowCap identified by the specified <External.Handle> into the receiver."

	| buf |
	"Basic attrributes - height, width, isFilled"
	buf := ByteArray newFixed: 4.
	Gdip gdipGetAdjustableArrowCapHeight: aGpAdjustableArrowCap height: buf.
	height := buf floatAtOffset: 0.
	Gdip gdipGetAdjustableArrowCapWidth: aGpAdjustableArrowCap width: buf.
	width := buf floatAtOffset: 0.
	Gdip gdipGetAdjustableArrowCapFillState: aGpAdjustableArrowCap fillState: buf.
	isFilled := (buf dwordAtOffset: 0) ~~ 0.
	"Extra attributes - can be set after creation, and should be persisted if set. The first two are inherited; strokeJoin and widthScale."
	super initializeFromHandle: aGpAdjustableArrowCap.
	Gdip gdipGetAdjustableArrowCapMiddleInset: aGpAdjustableArrowCap middleInset: buf.
	middleInset := buf floatAtOffset: 0!

isFilled
	^isFilled!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^widthScale = 1 and: [middleInset = 0 and: [strokeJoin == LineJoinMiter]]!

middleInset
	^middleInset ?? 0!

middleInset: aNumber
	middleInset := aNumber = 0 ifFalse: [aNumber]!

middleInsetOf: anAdjustableArrowCap set: aNumber
	Gdip gdipSetAdjustableArrowCapMiddleInset: anAdjustableArrowCap handle middleInset: aNumber asFloat.
	self middleInset: aNumber!

printAttributesOn: aStream
	aStream
		nextPutAll: 'height: ';
		print: height;
		nextPutAll: ' width: ';
		print: width;
		nextPutAll: ' isFilled: ';
		print: isFilled.
	middleInset = 0
		ifFalse: 
			[aStream
				nextPutAll: '; ';
				nextPutAll: #middleInset:;
				space;
				print: middleInset].
	super printAttributesOn: aStream!

width
	^width!

widthOf: anAdjustableArrowCap set: aNumber
	Gdip gdipSetAdjustableArrowCapWidth: anAdjustableArrowCap handle width: aNumber asFloat.
	width := aNumber! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer categoriesForMethods!
=!comparing!public! !
applyAdditionalAttributes:!private!realizing/unrealizing! !
basicCreateHandle!private!realizing/unrealizing! !
fillStateOf:set:!attributes!private! !
hash!comparing!public! !
height!accessing!private! !
height:width:isFilled:!initializing!private! !
heightOf:set:!attributes!private! !
initializeFromHandle:!initializing!private! !
isFilled!accessing!private! !
isSelfEvaluating!public!testing! !
middleInset!accessing!private! !
middleInset:!accessing!private! !
middleInsetOf:set:!attributes!private! !
printAttributesOn:!printing!private! !
width!accessing!private! !
widthOf:set:!attributes!private! !
!

!Graphics.Gdiplus.AdjustableArrowCapInitializer class methodsFor!

height: heightReal width: widthReal isFilled: isFilledBoolean
	^self new 
		height: heightReal
		width: widthReal
		isFilled: isFilledBoolean!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	self
		height: (data at: 2)
		width: (data at: 3)
		isFilled: (data at: 4)]! !
!Graphics.Gdiplus.AdjustableArrowCapInitializer class categoriesForMethods!
height:width:isFilled:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
!

