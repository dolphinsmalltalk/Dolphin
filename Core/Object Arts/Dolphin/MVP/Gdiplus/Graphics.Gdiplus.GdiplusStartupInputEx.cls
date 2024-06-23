"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusStartupInput
	subclass: #'Graphics.Gdiplus.GdiplusStartupInputEx'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_GdiplusStartupInputEx_Size' -> 16r14. '_OffsetOf_StartupParameters' -> 16r10 }!

Graphics.Gdiplus.GdiplusStartupInputEx guid: (Core.GUID fromString: '{9fa0e6e5-3e7d-46f3-a441-669977f4627e}')!

Graphics.Gdiplus.GdiplusStartupInputEx comment: ''!

!Graphics.Gdiplus.GdiplusStartupInputEx methodsFor!

StartupParameters: anInteger
	"Set the receiver's 'StartupParameters' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_StartupParameters put: anInteger! !

!Graphics.Gdiplus.GdiplusStartupInputEx categoriesForMethods!
StartupParameters:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.GdiplusStartupInputEx class methodsFor!

byteSize
	^_GdiplusStartupInputEx_Size!

defineFields
	"Define the fields of the GdiplusStartupInputEx structure.
		GdiplusStartupInputEx compileDefinition
	"

	super defineFields.
	self defineField: #StartupParameters type: Int32Field writeOnly!

getFieldNames
	^#(#GdiplusVersion #StartupParameters)! !

!Graphics.Gdiplus.GdiplusStartupInputEx class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

