"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BrushInitializer
	subclass: #'Graphics.Gdiplus.SolidBrushFromColorInitializer'
	instanceVariableNames: 'color'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.SolidBrushFromColorInitializer guid: (Core.GUID fromString: '{02b80350-515e-40c3-8ec4-b328a7a4bcbb}')!
Graphics.Gdiplus.SolidBrushFromColorInitializer comment: ''!
!Graphics.Gdiplus.SolidBrushFromColorInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [self species == anObject species and: [color = anObject color]]!

basicCreateHandle
	"Private -  SolidBrush(IN const Color& color)
    	{
       	 GpSolidFill *brush = NULL;

	        lastResult = DllExports::GdipCreateSolidFill(color.GetValue(), &brush);
	    };"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateSolidFill: color argbCode brush: gpHandle.
	^gpHandle!

color
	^color!

color: aColor
	color := aColor.
	^self!

colorOf: aSolidBrush set: aColor
	Gdip gdipSetSolidFillColor: aSolidBrush handle color: aColor argbCode.
	color := aColor!

hash
	"Answer the <integer> hash value for the receiver."

	^(self species hash + color hash) hashMultiply!

initializeFromHandle: aGpHatchBrushHandle
	"Private - Cache all the attributes of the native Gdiplus SolidBrush identified by the specified <External.Handle> into the receiver."

	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetSolidFillColor: aGpHatchBrushHandle color: buf.
	color := Color fromArgbCode: buf asInteger!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

printAttributesOn: aStream
	aStream
		nextPutAll: #color:;
		space;
		print: color! !
!Graphics.Gdiplus.SolidBrushFromColorInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
color!accessing!private! !
color:!initializing!private! !
colorOf:set:!attributes!private! !
hash!comparing!public! !
initializeFromHandle:!initializing!private! !
isSelfEvaluating!public!testing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.SolidBrushFromColorInitializer class methodsFor!

color: aColor
	^self new color: aColor! !
!Graphics.Gdiplus.SolidBrushFromColorInitializer class categoriesForMethods!
color:!instance creation!public! !
!

