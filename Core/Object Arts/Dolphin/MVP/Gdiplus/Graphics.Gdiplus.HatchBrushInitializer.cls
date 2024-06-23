"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BrushInitializer
	subclass: #'Graphics.Gdiplus.HatchBrushInitializer'
	instanceVariableNames: 'hatchStyle forecolor backcolor'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'HatchStyleNames'
				-> #('HatchStyleHorizontal' 'HatchStyleVertical' 'HatchStyleForwardDiagonal' 'HatchStyleBackwardDiagonal' 'HatchStyleCross' 'HatchStyleDiagonalCross' 'HatchStyle05Percent' 'HatchStyle10Percent' 'HatchStyle20Percent' 'HatchStyle25Percent' 'HatchStyle30Percent' 'HatchStyle40Percent' 'HatchStyle50Percent' 'HatchStyle60Percent' 'HatchStyle70Percent' 'HatchStyle75Percent' 'HatchStyle80Percent' 'HatchStyle90Percent' 'HatchStyleLightDownwardDiagonal' 'HatchStyleLightUpwardDiagonal' 'HatchStyleDarkDownwardDiagonal' 'HatchStyleDarkUpwardDiagonal' 'HatchStyleWideDownwardDiagonal' 'HatchStyleWideUpwardDiagonal' 'HatchStyleLightVertical' 'HatchStyleLightHorizontal' 'HatchStyleNarrowVertical' 'HatchStyleNarrowHorizontal' 'HatchStyleDarkVertical' 'HatchStyleDarkHorizontal' 'HatchStyleDashedDownwardDiagonal' 'HatchStyleDashedUpwardDiagonal' 'HatchStyleDashedHorizontal' 'HatchStyleDashedVertical' 'HatchStyleSmallConfetti' 'HatchStyleLargeConfetti' 'HatchStyleZigZag' 'HatchStyleWave' 'HatchStyleDiagonalBrick' 'HatchStyleHorizontalBrick' 'HatchStyleWeave' 'HatchStylePlaid' 'HatchStyleDivot' 'HatchStyleDottedGrid' 'HatchStyleDottedDiamond' 'HatchStyleShingle' 'HatchStyleTrellis' 'HatchStyleSphere' 'HatchStyleSmallGrid' 'HatchStyleSmallCheckerBoard' 'HatchStyleLargeCheckerBoard' 'HatchStyleOutlinedDiamond' 'HatchStyleSolidDiamond')
		}!

Graphics.Gdiplus.HatchBrushInitializer guid: (Core.GUID fromString: '{1a1a5ea5-6151-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.HatchBrushInitializer comment: ''!

!Graphics.Gdiplus.HatchBrushInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: 
			[self species == anObject species and: 
					[hatchStyle = anObject hatchStyle
						and: [forecolor = anObject forecolor and: [backcolor = anObject backcolor]]]]!

backcolor
	^backcolor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateHatchBrush: hatchStyle
		forecol: forecolor argbCode
		backcol: backcolor argbCode
		brush: gpHandle.
	^gpHandle!

color
	"Not a single colour"

	^self shouldNotImplement!

forecolor
	^forecolor!

hash
	"Answer the <integer> hash value for the receiver."

	^(((self species hash + hatchStyle hash) hashMultiply + forecolor hash) hashMultiply + backcolor hash)
		hashMultiply!

hatchStyle
	^hatchStyle!

hatchStyleName
	^HatchStyleNames at: hatchStyle + 1!

initializeFromHandle: aGpHatchBrushHandle
	"Private - Cache all the attributes of the native Gdiplus HatchBrush identified by the specified <External.Handle> into the receiver."

	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetHatchStyle: aGpHatchBrushHandle hatchStyle: buf.
	hatchStyle := buf asInteger.
	Gdip gdipGetHatchForegroundColor: aGpHatchBrushHandle forecol: buf.
	forecolor := Color fromArgbCode: buf asInteger.
	Gdip gdipGetHatchBackgroundColor: aGpHatchBrushHandle backcol: buf.
	backcolor := Color fromArgbCode: buf asInteger!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

printAttributesOn: aStream
	aStream nextPutAll: 'style: '.
	self
		printEnum: hatchStyle
		names: HatchStyleNames
		on: aStream.
	aStream
		nextPutAll: ' forecolor: ';
		print: forecolor;
		nextPutAll: ' backcolor: ';
		print: backcolor!

style: aNumber forecolor: foreColor backcolor: backColor
	hatchStyle := aNumber.
	forecolor := foreColor.
	backcolor := backColor.
	^self! !

!Graphics.Gdiplus.HatchBrushInitializer categoriesForMethods!
=!comparing!public! !
backcolor!accessing!public! !
basicCreateHandle!private!realizing/unrealizing! !
color!accessing!public! !
forecolor!accessing!public! !
hash!comparing!public! !
hatchStyle!accessing!public! !
hatchStyleName!accessing!public! !
initializeFromHandle:!initializing!private! !
isSelfEvaluating!public!testing! !
printAttributesOn:!printing!private! !
style:forecolor:backcolor:!initializing!private! !
!

!Graphics.Gdiplus.HatchBrushInitializer class methodsFor!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self new 
		style: aNumber
		forecolor: foreARGB
		backcolor: backARGB! !

!Graphics.Gdiplus.HatchBrushInitializer class categoriesForMethods!
style:forecolor:backcolor:!instance creation!public! !
!

