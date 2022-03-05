"Filed out from Dolphin Smalltalk"!

Object subclass: #StyledShadow
	instanceVariableNames: 'color density offset'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
StyledShadow guid: (GUID fromString: '{b7558f23-322b-4c65-ab23-0e43ead228bf}')!
StyledShadow comment: ''!
!StyledShadow categoriesForClass!Unclassified! !
!StyledShadow methodsFor!

color
	^color!

color: aColor 
	color := aColor!

density
	^density!

density: aFloat 
	density := (aFloat min: 100) max: 0!

offset
	^offset!

offset: aPoint 
	offset := aPoint asPoint!

paintShadowOf: path on: graphics 
	"Paint the shadow of path on the receiver. Thanks to
	http://www.codeproject.com/KB/GDI-plus/FuzzyDropShadows.aspx for the method."

	| brush colorBlendColors colorBlendPositions region |
	brush := GdiplusPathGradientBrush path: path.
	brush wrapMode: WrapModeClamp.
	colorBlendColors := Array 
				with: Color none
				with: self shadowColor
				with: self shadowColor.
	colorBlendPositions := #(0.0 0.2 1.0).
	brush blendColors: colorBlendColors positions: colorBlendPositions.
	region := GdiplusRegion fromPath: path.
	graphics clipRegion: region combineMode: CombineModeExclude.
	graphics translateTransform: self offset.
	graphics fillPath: path brush: brush.
	graphics resetClip.
	graphics translateTransform: self offset negated.
	brush free.
	region free!

shadowColor
	^self color alpha: (self density * 255 min: 255)! !
!StyledShadow categoriesForMethods!
color!accessing!public! !
color:!accessing!public! !
density!accessing!public! !
density:!accessing!public! !
offset!accessing!public! !
offset:!accessing!public! !
paintShadowOf:on:!event handling!public! !
shadowColor!event handling!public! !
!

!StyledShadow class methodsFor!

defaultShadowColor
	^Color darkShadow3d!

defaultShadowDensity
	^0.7!

defaultShadowOffset
	^15@15!

new
	^super new	
		color: self defaultShadowColor;
		offset: self defaultShadowOffset;
		density: self defaultShadowDensity! !
!StyledShadow class categoriesForMethods!
defaultShadowColor!public! !
defaultShadowDensity!public! !
defaultShadowOffset!public! !
new!instance creation!public! !
!

