"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Brush
	subclass: #'Graphics.Gdiplus.HatchBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ForegroundPercentages'
				-> #[12 12 18 18 23 32 3 6 12 25 37 47 50 62 75 87 94 97 25 25 50 50 37 37 25 25 50 50 50 50 12 12 12 12 12 37 25 22 19 34 30 50 9 11 9 20 75 59 44 50 50 22 39]
		}!

Graphics.Gdiplus.HatchBrush guid: (Core.GUID fromString: '{1a1a5ea4-6151-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.HatchBrush comment: 'A hatch brush paints a background and paints, over that background, a foreground that consists of a pattern of lines, dots, dashes, squares, crosshatch, or some variation of these. The hatch brush consists of two colors: one for the background and one for the foreground.'!

!Graphics.Gdiplus.HatchBrush methodsFor!

backcolor
	^self initializer backcolor!

forecolor
	^self initializer forecolor!

hatchStyle
	^self initializer hatchStyle!

hatchStyleName
	^self initializer hatchStyleName!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^HatchBrushInitializer!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity. For a brush this is usually very approximate."

	| percentage |
	percentage := ForegroundPercentages at: self hatchStyle + 1.
	^self backcolor luminance * ((100 - percentage) / 100.0)
		+ (self forecolor luminance * percentage / 100.0)! !

!Graphics.Gdiplus.HatchBrush categoriesForMethods!
backcolor!accessing!public! !
forecolor!accessing!public! !
hatchStyle!accessing!public! !
hatchStyleName!accessing!public! !
initializerClass!constants!private! !
isSelfEvaluating!public!testing! !
luminance!accessing!public! !
!

!Graphics.Gdiplus.HatchBrush class methodsFor!

initialize
	"
		self initialize
	"

	| percentages |
	percentages := (ByteArray new: Gdiplus.HatchStyleMax + 1)
				at: HatchStyleHorizontal + 1 put: 12;
				at: HatchStyleVertical + 1 put: 12;
				at: HatchStyleForwardDiagonal + 1 put: 18;
				at: HatchStyleBackwardDiagonal + 1 put: 18;
				at: HatchStyleCross + 1 put: 23;
				at: HatchStyleDiagonalCross + 1 put: 32;
				at: HatchStyle05Percent + 1 put: 3;
				at: HatchStyle10Percent + 1 put: 6;
				at: HatchStyle20Percent + 1 put: 12;
				at: HatchStyle25Percent + 1 put: 25;
				at: HatchStyle30Percent + 1 put: 37;
				at: HatchStyle40Percent + 1 put: 47;
				at: HatchStyle50Percent + 1 put: 50;
				at: HatchStyle60Percent + 1 put: 62;
				at: HatchStyle70Percent + 1 put: 75;
				at: HatchStyle75Percent + 1 put: 87;
				at: HatchStyle80Percent + 1 put: 94;
				at: HatchStyle90Percent + 1 put: 97;
				at: HatchStyleLightDownwardDiagonal + 1 put: 25;
				at: HatchStyleLightUpwardDiagonal + 1 put: 25;
				at: HatchStyleDarkDownwardDiagonal + 1 put: 50;
				at: HatchStyleDarkUpwardDiagonal + 1 put: 50;
				at: HatchStyleWideDownwardDiagonal + 1 put: 37;
				at: HatchStyleWideUpwardDiagonal + 1 put: 37;
				at: HatchStyleLightVertical + 1 put: 25;
				at: HatchStyleLightHorizontal + 1 put: 25;
				at: HatchStyleNarrowVertical + 1 put: 50;
				at: HatchStyleNarrowHorizontal + 1 put: 50;
				at: HatchStyleDarkVertical + 1 put: 50;
				at: HatchStyleDarkHorizontal + 1 put: 50;
				at: HatchStyleDashedDownwardDiagonal + 1 put: 12;
				at: HatchStyleDashedUpwardDiagonal + 1 put: 12;
				at: HatchStyleDashedHorizontal + 1 put: 12;
				at: HatchStyleDashedVertical + 1 put: 12;
				at: HatchStyleSmallConfetti + 1 put: 12;
				at: HatchStyleLargeConfetti + 1 put: 37;
				at: HatchStyleZigZag + 1 put: 25;
				at: HatchStyleWave + 1 put: 22;
				at: HatchStyleDiagonalBrick + 1 put: 19;
				at: HatchStyleHorizontalBrick + 1 put: 34;
				at: HatchStyleWeave + 1 put: 30;
				at: HatchStylePlaid + 1 put: 50;
				at: HatchStyleDivot + 1 put: 9;
				at: HatchStyleDottedGrid + 1 put: 11;
				at: HatchStyleDottedDiamond + 1 put: 9;
				at: HatchStyleShingle + 1 put: 20;
				at: HatchStyleTrellis + 1 put: 75;
				at: HatchStyleSphere + 1 put: 59;
				at: HatchStyleSmallGrid + 1 put: 44;
				at: HatchStyleSmallCheckerBoard + 1 put: 50;
				at: HatchStyleLargeCheckerBoard + 1 put: 50;
				at: HatchStyleOutlinedDiamond + 1 put: 22;
				at: HatchStyleSolidDiamond + 1 put: 39;
				yourself.
	self addClassConstant: 'ForegroundPercentages' value: percentages!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self fromInitializer: (HatchBrushInitializer
				style: aNumber
				forecolor: foreARGB
				backcolor: backARGB)! !

!Graphics.Gdiplus.HatchBrush class categoriesForMethods!
initialize!class initialization!public! !
style:forecolor:backcolor:!instance creation!public! !
!

