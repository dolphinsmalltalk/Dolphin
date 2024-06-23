"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.ImageAttributes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.ImageAttributes guid: (Core.GUID fromString: '{c5f76a31-54e8-45a9-905c-14e9d8ae7c0d}')!

Graphics.Gdiplus.ImageAttributes comment: 'A GdiplusImageAttributes object contains information about how bitmap and metafile colors are manipulated during rendering.  Accessors are available to adjust color, grayscale, gamma, brightness, transparency, and more.  Typically you will initialize an instance, change some settings, and pass the instance to a GdiplusGraphics drawImage method.'!

!Graphics.Gdiplus.ImageAttributes methodsFor!

clone
	"Answer a copy of the receiver."

	^super clone
		initializer: initializer;
		yourself!

colorKeys: aColorAdjustTypeConstant colorLow: lowColor colorHigh: highColor
	Gdip
		gdipSetImageAttributesColorKeys: self handle
		type: aColorAdjustTypeConstant
		enableFlag: TRUE
		colorLow: lowColor argbCode
		colorHigh: highColor argbCode!

colorMatrix: aColorMatrix
	"Set the receiver's color-adjustment matrix."

	self 
		colorMatrix: aColorMatrix
		type: ColorAdjustTypeDefault
		mode: ColorMatrixFlagsDefault!

colorMatrix: aColorMatrix type: aColorAdjustTypeConstant mode: aColorMatrixFlagsConstant
	"Set the receiver's color-adjustment matrix for a specified category."

	Gdip
		gdipSetImageAttributesColorMatrix: self handle
		type: aColorAdjustTypeConstant
		enableFlag: TRUE
		colorMatrix: aColorMatrix asParameter
		grayMatrix: nil
		flags: aColorMatrixFlagsConstant!

gamma: aFloat
	"Set the receiver's gamma value for all categories that do not have adjustment settings of their own."

	self gamma: aFloat type: ColorAdjustTypeDefault!

gamma: aFloat type: aColorAdjustTypeConstant
	"Set the receiver's gamma value for the specified color adjustment category."

	Gdip
		gdipSetImageAttributesGamma: self handle
		type: aColorAdjustTypeConstant
		enableFlag: TRUE
		gamma: aFloat!

initializerClass
	"Private - Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^ImageAttributesInitializer!

outputChannel: aColorAdjustTypeConstant channelFlags: channelFlags
	Gdip
		gdipSetImageAttributesOutputChannel: self handle
		type: aColorAdjustTypeConstant
		enableFlag: TRUE
		channelFlags: channelFlags!

remapColor: oldColor to: newColor
	self remapColor: oldColor to: newColor type: ColorAdjustTypeDefault!

remapColor: oldColor to: newColor type: anInteger
	| colorMapping |
	colorMapping := ColorMap newBuffer.
	colorMapping
		oldColor: oldColor argbCode;
		newColor: newColor argbCode.
	Gdip
		gdipSetImageAttributesRemapTable: self handle
		type: anInteger
		enableFlag: TRUE
		mapSize: 1
		map: colorMapping!

remapTable: aColorMapArray
	^self remapTable: aColorMapArray type: ColorAdjustTypeDefault!

remapTable: aColorMapArray type: aColorAdjustTypeConstant
	Gdip
		gdipSetImageAttributesRemapTable: self handle
		type: aColorAdjustTypeConstant
		enableFlag: TRUE
		mapSize: aColorMapArray size
		map: aColorMapArray!

threshold: aFloat
	"Set the receiver's threshold (transparency range)."

	self threshold: aFloat type: ColorAdjustTypeDefault!

threshold: aFloat type: aColorAdjustTypeConstant
	"Set the receiver's threshold (transparency range) for a specified category."

	Gdip
		gdipSetImageAttributesThreshold: self handle
		type: aColorAdjustTypeConstant
		enableFlag: TRUE
		threshold: aFloat! !

!Graphics.Gdiplus.ImageAttributes categoriesForMethods!
clone!copying!public! !
colorKeys:colorLow:colorHigh:!accessing!public! !
colorMatrix:!accessing!public! !
colorMatrix:type:mode:!accessing!public! !
gamma:!accessing!public! !
gamma:type:!accessing!public! !
initializerClass!constants!private! !
outputChannel:channelFlags:!accessing!public! !
remapColor:to:!accessing!public! !
remapColor:to:type:!accessing!public! !
remapTable:!accessing!public! !
remapTable:type:!accessing!public! !
threshold:!accessing!public! !
threshold:type:!accessing!public! !
!

!Graphics.Gdiplus.ImageAttributes class methodsFor!

new
	^self fromInitializer: ImageAttributesInitializer default! !

!Graphics.Gdiplus.ImageAttributes class categoriesForMethods!
new!instance creation!public! !
!

