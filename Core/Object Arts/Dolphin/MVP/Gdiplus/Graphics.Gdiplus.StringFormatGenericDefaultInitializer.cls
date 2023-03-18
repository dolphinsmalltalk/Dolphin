"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.StringFormatGenericInitializer
	subclass: #'Graphics.Gdiplus.StringFormatGenericDefaultInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatGenericDefaultInitializer guid: (Core.GUID fromString: '{c8f38621-766b-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.StringFormatGenericDefaultInitializer comment: ''!
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipStringFormatGetGenericDefault: gpHandle.
	^gpHandle!

isGenericDefault
	^true!

printAttributesOn: aStream
	aStream nextPutAll: #genericDefault! !
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
isGenericDefault!public!testing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.StringFormatGenericDefaultInitializer class methodsFor!

stbConvertFrom: anSTBClassFormat
	^[:data | self genericDefault]!

uninitialize
	GenericDefault := nil! !
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

