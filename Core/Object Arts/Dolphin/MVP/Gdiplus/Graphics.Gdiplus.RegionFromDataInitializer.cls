"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.RegionInitializer
	subclass: #'Graphics.Gdiplus.RegionFromDataInitializer'
	instanceVariableNames: 'data'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionFromDataInitializer guid: (Core.GUID fromString: '{15e866fe-f623-407c-8fe1-4c4d184e9a4e}')!
Graphics.Gdiplus.RegionFromDataInitializer comment: ''!
!Graphics.Gdiplus.RegionFromDataInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateRegionRgnData: data
		size: data size
		region: gpHandle.
	^gpHandle!

data
	^data!

data: anObject
	data := anObject!

initializeFromHandle: aGpRegionHandle
	"Private - Cache all the attributes of the native Gdiplus object identified by the specified <External.Handle> into the receiver."

	data := self getRegionData: aGpRegionHandle!

printAttributesOn: aStream
	aStream
		nextPutAll: 'fromBytes: ';
		print: data! !
!Graphics.Gdiplus.RegionFromDataInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
data!accessing!public! !
data:!accessing!private! !
initializeFromHandle:!initializing!private! !
printAttributesOn:!attributes!printing!private! !
!

!Graphics.Gdiplus.RegionFromDataInitializer class methodsFor!

fromBytes: aByteArray
	^self new data: aByteArray! !
!Graphics.Gdiplus.RegionFromDataInitializer class categoriesForMethods!
fromBytes:!instance creation!public! !
!

