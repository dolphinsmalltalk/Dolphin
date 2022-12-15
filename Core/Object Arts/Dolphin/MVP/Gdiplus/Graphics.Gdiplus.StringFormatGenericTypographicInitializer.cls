"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.StringFormatGenericInitializer subclass: #'Graphics.Gdiplus.StringFormatGenericTypographicInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatGenericTypographicInitializer guid: (Core.GUID fromString: '{cbe1bbee-b46a-4c95-90e4-d4bec63775e9}')!
Graphics.Gdiplus.StringFormatGenericTypographicInitializer comment: ''!
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipStringFormatGetGenericTypographic: gpHandle.
	^gpHandle!

flags
	^##(StringFormatFlagsNoClip | StringFormatFlagsLineLimit | StringFormatFlagsNoFitBlackBox)!

isGenericTypographic
	^true!

printAttributesOn: aStream
	aStream nextPutAll: #genericTypographic!

trimming
	^StringTrimmingNone! !
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
flags!attributes!public! !
isGenericTypographic!public!testing! !
printAttributesOn:!attributes!printing!private! !
trimming!attributes!public! !
!

!Graphics.Gdiplus.StringFormatGenericTypographicInitializer class methodsFor!

stbConvertFrom: anSTBClassFormat
	^[:data | self genericTypographic]!

uninitialize
	GenericTypographic := nil! !
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

