"Filed out from Dolphin Smalltalk 7"!

ImageViewAbstract subclass: #GdiplusImageView
	instanceVariableNames: 'interpolationMode swun2 swun3 imageAttributes swun4 swun5 swun6'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusImageView guid: (GUID fromString: '{eede5c5a-f1e0-4e07-b766-9ea7d3169055}')!
GdiplusImageView comment: 'GdiplusImageView is a <valueView> for displaying static <image>s based on Object-Art''''s ImageView

It can display either GDI or Gdiplus based images.

 - The viewMode can be any of ImageView''''s (#normal, #centered, scale or #scaleToFit) or #scaleBestFit, which is like
	#scaleToFit but only scales down in size
 - The imageBorder can be any of  #(#none #raised #sunken #etched #bump). 
 - The imagePadding is used to provide space for the border to be drawn. For the edge imageBorder''''s 0 or 2 works well.

Instance Variables:
	interpolationMode		<Symbol>
	imageBorder		<Symbol>
	imagePadding		<Number> or <Rectangle> or <Point>
	imageAttributes		<GdiplusImageAttributes> or nil
	swun4			<UndefinedObject>
	swun5			<UndefinedObject>
	swun6			<UndefinedObject>

Class Variables:
	IsEraseBackgroundMask	<SmallInteger>

'!
!GdiplusImageView categoriesForClass!MVP-Views! !
!GdiplusImageView methodsFor!

default: imageExtent in: displayRect 
	"Note: behavior is different from ImageView in that the default is #normal not #scale"

	^self normal: imageExtent in: displayRect!

imageAttributes
	^imageAttributes!

imageAttributes: aGdiplusImageAttributes
	imageAttributes := aGdiplusImageAttributes!

imagePadding
	#deprecated.
	^self insets!

imagePadding: padding 
	"anObject can be <Integer> <Point> or <Rectangle>"

	#deprecated.
	self insets: (padding isInteger 
				ifTrue: 
					[Rectangle 
						left: padding
						top: padding
						right: padding
						bottom: padding]
				ifFalse: 
					[(padding isKindOf: Point) 
						ifTrue: [Rectangle origin: padding corner: padding]
						ifFalse: [(padding isKindOf: Rectangle) ifTrue: [padding]]])!

initialize
	"Private - Initialise the new receiver."

	super initialize.
	interpolationMode := #default!

interpolationMode
	^interpolationMode!

interpolationMode: aSymbol
	"See class method; #interpolationStyleTable"

	interpolationMode := aSymbol.
	self invalidate!

isEraseBackground
	#deprecated.
	^self isWholeBackgroundErased!

isEraseBackground: aBoolean
	#deprecated.
	self isWholeBackgroundErased: aBoolean!

paintImageOn: aCanvas
	| imageRect displayRect graphics |
	"displayRect is the clientRectangle adjusted by the image padding"
	displayRect := self displayRectangle.
	[(image isNil or: 
			[image realize.
			image isRealized not]) ifTrue: [^displayRect]] on: Error
		do: [:e | ^nil].
	"Stop OLEPicture choking"
	(displayRect width <= 0 or: [displayRect height <= 0]) ifTrue: [^nil].

	"imageRect is the destination rectangle to blt"
	imageRect := self calcRectangle: displayRect.
	graphics := GdiplusGraphics fromCanvas: aCanvas.
	graphics interpolationMode: (self class interpolationStyleTable at: self interpolationMode
				ifAbsent: [InterpolationModeDefault]).
	
	[image
		drawOnGraphics: graphics
		at: imageRect topLeft
		extent: imageRect extent
		from: 0 @ 0
		extent: image extent
		unit: nil
		attributes: self imageAttributes]
			on: Error
			do: [:err | err toTrace].
	graphics free.
	^self
		drawBorderOn: aCanvas
		imageRect: imageRect
		displayRect: displayRect! !
!GdiplusImageView categoriesFor: #default:in:!geometry!private! !
!GdiplusImageView categoriesFor: #imageAttributes!accessing!public! !
!GdiplusImageView categoriesFor: #imageAttributes:!accessing!public! !
!GdiplusImageView categoriesFor: #imagePadding!accessing!public! !
!GdiplusImageView categoriesFor: #imagePadding:!accessing!public! !
!GdiplusImageView categoriesFor: #initialize!initializing!private! !
!GdiplusImageView categoriesFor: #interpolationMode!accessing!public! !
!GdiplusImageView categoriesFor: #interpolationMode:!accessing!public! !
!GdiplusImageView categoriesFor: #isEraseBackground!accessing!public! !
!GdiplusImageView categoriesFor: #isEraseBackground:!accessing!public! !
!GdiplusImageView categoriesFor: #paintImageOn:!drawing!private! !

!GdiplusImageView class methodsFor!

interpolationStyles
	^self interpolationStyleTable keys asArray!

interpolationStyleTable
	| dict |
	dict := IdentityDictionary new.
	dict
		at: #default put: InterpolationModeDefault;
		at: #lowQuality put: InterpolationModeLowQuality;
		at: #highQuality put: InterpolationModeHighQuality;
		at: #bilinear put: InterpolationModeBilinear;
		at: #bicubic put: InterpolationModeBicubic;
		at: #nearestNeighbor put: InterpolationModeNearestNeighbor;
		at: #highQualityBilinear put: InterpolationModeHighQualityBilinear;
		at: #highQualityBicubic put: InterpolationModeHighQualityBicubic.
	^dict!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	^(super publishedAspectsOfInstances)
		add: (Aspect choice: #interpolationMode from: self interpolationStyles);
		add: (Aspect name: #imageAttributes);
		yourself!

stbConvert: instVarArray fromVersion: verInteger 
	"Convert from earlier version view by updating and answering the array of instance variables
	(for the View), instVarArray."

	| instVars |
	instVars := instVarArray.
	verInteger < 13 ifTrue: [instVars := super stbConvert: instVarArray fromVersion: verInteger].
	verInteger < 14 ifTrue: [instVars := self stbConvertFromVersion13: instVars].
	^instVars!

stbConvertFromVersion13: anArray 
	| instVars |
	instVars := Array new: 28.
	instVars 
		replaceFrom: 1
		to: 16
		with: anArray
		startingAt: 1.
	instVars at: 17 put: (anArray at: 20).	"image"
	instVars at: 18 put: (anArray at: 21).	"viewMode"
	instVars at: 19 put: (anArray at: 19).	"ivFlags = flag"
	(anArray at: 24) 
		ifNotNil: 
			[:padding | 
			"set insets from padding"
			instVars at: 20
				put: (padding isInteger 
						ifTrue: 
							[Rectangle 
								left: padding
								top: padding
								right: padding
								bottom: padding]
						ifFalse: 
							[(padding isKindOf: Point) 
								ifTrue: [Rectangle origin: padding corner: padding]
								ifFalse: [(padding isKindOf: Rectangle) ifTrue: [padding]]])].
	instVars at: 21 put: nil.	"_dummy"
	instVars 
		replaceFrom: 22
		to: 28
		with: anArray
		startingAt: 22.
	instVars at: 24 put: nil.
	^instVars!

stbVersion
	^14! !
!GdiplusImageView class categoriesFor: #interpolationStyles!constants!public! !
!GdiplusImageView class categoriesFor: #interpolationStyleTable!constants!public! !
!GdiplusImageView class categoriesFor: #publishedAspectsOfInstances!must strip!public! !
!GdiplusImageView class categoriesFor: #stbConvert:fromVersion:!binary filing!public! !
!GdiplusImageView class categoriesFor: #stbConvertFromVersion13:!public! !
!GdiplusImageView class categoriesFor: #stbVersion!public! !

