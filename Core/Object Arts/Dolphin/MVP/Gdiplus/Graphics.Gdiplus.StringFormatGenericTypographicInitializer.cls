"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.StringFormatInitializer subclass: #'Graphics.Gdiplus.StringFormatGenericTypographicInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatGenericTypographicInitializer guid: (Core.GUID fromString: '{cbe1bbee-b46a-4c95-90e4-d4bec63775e9}')!
Graphics.Gdiplus.StringFormatGenericTypographicInitializer comment: ''!
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipStringFormatGetGenericTypographic: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.StringFormatGenericTypographicInitializer class methodsFor!

uninitialize
	GenericTypographic := nil! !
!Graphics.Gdiplus.StringFormatGenericTypographicInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

