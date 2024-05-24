"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusImageAttributes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusImageAttributes guid: (GUID fromString: '{c5f76a31-54e8-45a9-905c-14e9d8ae7c0d}')!

GdiplusImageAttributes comment: 'A GdiplusImageAttributes object contains information about how bitmap and metafile colors are manipulated during rendering.  Accessors are available to adjust color, grayscale, gamma, brightness, transparency, and more.  Typically you will initialize an instance, change some settings, and pass the instance to a GdiplusGraphics drawImage method.'!

!GdiplusImageAttributes categoriesForClass!Unclassified! !

!GdiplusImageAttributes methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDisposeImageAttributes: handle!

colorKeys: aColorAdjustTypeConstant colorLow: lowARGB colorHigh: highARGB
	GdiplusLibrary default
		gdipSetImageAttributesColorKeys: self asParameter
		type: aColorAdjustTypeConstant
		enableFlag: true asParameter
		colorLow: lowARGB argbCode
		colorHigh: highARGB argbCode!

colorMatrix: aColorMatrix
	"Set the receiver's color-adjustment matrix."

	self 
		colorMatrix: aColorMatrix
		type: ColorAdjustTypeDefault
		mode: ColorMatrixFlagsDefault!

colorMatrix: aColorMatrix type: aColorAdjustTypeConstant mode: aColorMatrixFlagsConstant
	"Set the receiver's color-adjustment matrix for a specified category."

	GdiplusLibrary default
		gdipSetImageAttributesColorMatrix: self asParameter
		type: aColorAdjustTypeConstant
		enableFlag: true asParameter
		colorMatrix: aColorMatrix asParameter
		grayMatrix: nil
		flags: aColorMatrixFlagsConstant!

gamma: aFloat
	"Set the receiver's gamma value for all categories that do not have adjustment settings of their own."

	self gamma: aFloat type: ColorAdjustTypeDefault!

gamma: aFloat type: aColorAdjustTypeConstant
	"Set the receiver's gamma value for the specified color adjustment category."

	GdiplusLibrary default
		gdipSetImageAttributesGamma: self asParameter
		type: aColorAdjustTypeConstant
		enableFlag: true asParameter
		gamma: aFloat!

outputChannel: aColorAdjustTypeConstant channelFlags: channelFlags
	GdiplusLibrary default
		gdipSetImageAttributesOutputChannel: self asParameter
		type: aColorAdjustTypeConstant
		enableFlag: true asParameter
		channelFlags: channelFlags!

remapColor: oldColor to: newColor
	self remapColor: oldColor to: newColor type: ColorAdjustTypeDefault!

remapColor: oldColor to: newColor type: anInteger
	| colorMapping status |
	colorMapping := GpColorMap newBuffer.
	colorMapping
		oldColor: oldColor argbCode;
		newColor: newColor argbCode.
	GdiplusLibrary default
		gdipSetImageAttributesRemapTable: self handle
		type: anInteger
		enableFlag: TRUE
		mapSize: 1
		map: colorMapping!

remapTable: aColorMapArray
	^self remapTable: aColorMapArray type: ColorAdjustTypeDefault!

remapTable: aColorMapArray type: aColorAdjustTypeConstant
	GdiplusLibrary default
		gdipSetImageAttributesRemapTable: self asParameter
		type: aColorAdjustTypeConstant
		enableFlag: true asParameter
		mapSize: aColorMapArray size
		map: aColorMapArray!

threshold: aFloat
	"Set the receiver's threshold (transparency range)."

	self threshold: aFloat type: ColorAdjustTypeDefault!

threshold: aFloat type: aColorAdjustTypeConstant
	"Set the receiver's threshold (transparency range) for a specified category."

	GdiplusLibrary default
		gdipSetImageAttributesThreshold: self asParameter
		type: aColorAdjustTypeConstant
		enableFlag: true asParameter
		threshold: aFloat! !

!GdiplusImageAttributes categoriesForMethods!
basicFree!private!realizing/unrealizing! !
colorKeys:colorLow:colorHigh:!accessing!public! !
colorMatrix:!accessing!public! !
colorMatrix:type:mode:!accessing!public! !
gamma:!accessing!public! !
gamma:type:!accessing!public! !
outputChannel:channelFlags:!accessing!public! !
remapColor:to:!accessing!public! !
remapColor:to:type:!accessing!public! !
remapTable:!accessing!public! !
remapTable:type:!accessing!public! !
threshold:!accessing!public! !
threshold:type:!accessing!public! !
!

!GdiplusImageAttributes class methodsFor!

new
	^self fromInitializer: GdiplusImageAttributesInitializer default! !

!GdiplusImageAttributes class categoriesForMethods!
new!instance creation!public! !
!

