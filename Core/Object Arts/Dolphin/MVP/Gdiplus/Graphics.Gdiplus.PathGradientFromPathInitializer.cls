"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.PathGradientBrushInitializer
	subclass: #'Graphics.Gdiplus.PathGradientFromPathInitializer'
	instanceVariableNames: 'path'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientFromPathInitializer guid: (Core.GUID fromString: '{24f2dee8-57f6-4e28-a553-6d886de15dda}')!
Graphics.Gdiplus.PathGradientFromPathInitializer comment: ''!
!Graphics.Gdiplus.PathGradientFromPathInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [super = anObject and: [path = anObject path]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreatePathGradientFromPath: path asParameter polyGradient: gpHandle.
	^gpHandle!

defaultCenterColor
	^Color.White!

hash
	"Answer the <integer> hash value for the receiver."

	^(super hash + path hash) hashMultiply!

path
	^path!

path: aGraphicsPath wrapMode: aWrapModeConstant
	path := aGraphicsPath.
	wrapMode := aWrapModeConstant.
	centerColor := self defaultCenterColor.
	^self!

printAttributesOn: aStream
	aStream
		nextPutAll: #path:;
		space;
		print: path.
	super printAttributesOn: aStream! !
!Graphics.Gdiplus.PathGradientFromPathInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
defaultCenterColor!constants!private! !
hash!comparing!public! !
path!accessing!private! !
path:wrapMode:!initializing!private! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.PathGradientFromPathInitializer class methodsFor!

stbConvertFrom: anSTBClassFormat
	^[:data | self path: (data at: 2) wrapMode: WrapModeClamp]! !
!Graphics.Gdiplus.PathGradientFromPathInitializer class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
!

