"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusRegionInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusRegionInitializer guid: (GUID fromString: '{c8f38620-766b-11d7-b609-00e0987e8081}')!

GdiplusRegionInitializer comment: ''!

!GdiplusRegionInitializer categoriesForClass!Unclassified! !

!GdiplusRegionInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
	self library gdipCreateRegion: gpHandle.
	^gpHandle! !

!GdiplusRegionInitializer categoriesForMethods!
createHandle!private! !
!

!GdiplusRegionInitializer class methodsFor!

default
	^Default ifNil: [Default := self basicNew]!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver to be stripped by clearing lazy initialized class variable
	which holds an instance of the receiver."

	Default := nil! !

!GdiplusRegionInitializer class categoriesForMethods!
default!instance creation!private! !
new!development!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

