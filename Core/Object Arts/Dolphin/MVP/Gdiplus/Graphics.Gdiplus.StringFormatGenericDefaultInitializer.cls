"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.StringFormatInitializer subclass: #'Graphics.Gdiplus.StringFormatGenericDefaultInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.StringFormatGenericDefaultInitializer guid: (Core.GUID fromString: '{c8f38621-766b-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.StringFormatGenericDefaultInitializer comment: ''!
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipStringFormatGetGenericDefault: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.StringFormatGenericDefaultInitializer class methodsFor!

uninitialize
	GenericDefault := nil! !
!Graphics.Gdiplus.StringFormatGenericDefaultInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

