"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusHatchBrushInitializer
	instanceVariableNames: 'style forecolor backcolor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusHatchBrushInitializer guid: (GUID fromString: '{1a1a5ea5-6151-11d7-b609-00e0987e8081}')!

GdiplusHatchBrushInitializer comment: ''!

!GdiplusHatchBrushInitializer categoriesForClass!Unclassified! !

!GdiplusHatchBrushInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
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

!GdiplusHatchBrushInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
style:forecolor:backcolor:!initializing!private! !
!

!GdiplusHatchBrushInitializer class methodsFor!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self new 
		style: aNumber
		forecolor: foreARGB
		backcolor: backARGB! !

!GdiplusHatchBrushInitializer class categoriesForMethods!
style:forecolor:backcolor:!instance creation!public! !
!

