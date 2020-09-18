"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.HatchBrushInitializer'
	instanceVariableNames: 'style forecolor backcolor'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.HatchBrushInitializer guid: (Core.GUID fromString: '{1a1a5ea5-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.HatchBrushInitializer comment: ''!
!Graphics.Gdiplus.HatchBrushInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.HatchBrushInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateHatchBrush: style
		forecol: forecolor argbCode
		backcol: backcolor argbCode
		brush: gpHandle.
	^gpHandle!

style: aNumber forecolor: foreColor backcolor: backColor
	style := aNumber.
	forecolor := foreColor.
	backcolor := backColor! !
!Graphics.Gdiplus.HatchBrushInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.HatchBrushInitializer categoriesFor: #style:forecolor:backcolor:!initializing!private! !

!Graphics.Gdiplus.HatchBrushInitializer class methodsFor!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self new 
		style: aNumber
		forecolor: foreARGB
		backcolor: backARGB! !
!Graphics.Gdiplus.HatchBrushInitializer class categoriesFor: #style:forecolor:backcolor:!instance creation!public! !

