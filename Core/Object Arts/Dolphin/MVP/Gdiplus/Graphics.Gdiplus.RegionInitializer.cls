"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.RegionInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Empty Infinite'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionInitializer guid: (Core.GUID fromString: '{6a87fbfa-ce5b-47de-82f0-a12f020a2178}')!
Graphics.Gdiplus.RegionInitializer isNonInstantiable: true!
Graphics.Gdiplus.RegionInitializer comment: ''!
!Graphics.Gdiplus.RegionInitializer methodsFor!

getRegionData: aGpRegion
	| buf sizeBuf size handle |
	Gdip
		gdipGetRegionDataSize: (handle := aGpRegion asParameter) bufferSize: (sizeBuf := UInt32Bytes new);
		gdipGetRegionData: handle
			buffer: (buf := ByteArray newFixed: (size := sizeBuf asInteger))
			bufferSize: size
			sizeFilled: sizeBuf.
	^buf!

hashGet: aGpRegion
	^(self getRegionData: aGpRegion) hash!

isEmptyRegion: aGdiplusRegion onGraphics: aGdiplusGraphics
	| result graphics |
	result := UInt32Bytes new.
	graphics := aGdiplusGraphics ifNil: [GdiplusGraphics desktop].
	Gdip
		gdipIsEmptyRegion: aGdiplusRegion asParameter
		graphics: graphics asParameter
		result: result.
	^result asBoolean!

isInfiniteRegion: aGdiplusRegion onGraphics: aGdiplusGraphics
	| result graphics |
	result := UInt32Bytes new.
	graphics := aGdiplusGraphics ifNil: [GdiplusGraphics desktop].
	Gdip
		gdipIsInfiniteRegion: aGdiplusRegion asParameter
		graphics: graphics asParameter
		result: result.
	^result asBoolean!

printAttributesOn: aLimitedWriteStream 
! !
!Graphics.Gdiplus.RegionInitializer categoriesForMethods!
getRegionData:!attributes!private! !
hashGet:!attributes!private! !
isEmptyRegion:onGraphics:!public!testing! !
isInfiniteRegion:onGraphics:!public!testing! !
printAttributesOn:!attributes!printing!private! !
!

!Graphics.Gdiplus.RegionInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneRegion: aHandle cloneRegion: clone.
	^clone!

empty
	^Empty ifNil: [Empty := EmptyRegionInitializer basicNew]!

freeHandle: aHandle
	Gdip gdipDeleteRegion: aHandle!

infinite
	^Infinite ifNil: [Infinite := InfiniteRegionInitializer basicNew]!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variables that hold sub-instances of the receiver."

	Infinite := Empty := nil! !
!Graphics.Gdiplus.RegionInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
empty!instance creation!public! !
freeHandle:!private!realizing/unrealizing! !
infinite!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

