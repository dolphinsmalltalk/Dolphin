"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusPen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusPen guid: (GUID fromString: '{f98f70c8-58ea-4592-bc70-1907f78c8bc8}')!

GdiplusPen comment: 'GdiplusPen is used to draw lines and curves.  In general, where an object has an outside and an inside, GdiplusPen draws the outside and GdiplusBrush is used to fill the inside.'!

!GdiplusPen categoriesForClass!Unclassified! !

!GdiplusPen methodsFor!

alignment
	"Answer the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	| alignment |
	alignment := SDWORD new.
	GdiplusLibrary default gdipGetPenMode: self asParameter penMode: alignment.
	^alignment value!

alignment: aPenAlignmentConstant
	"Set the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	GdiplusLibrary default gdipSetPenMode: self asParameter penMode: aPenAlignmentConstant!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDeletePen: handle!

brush
	"Answer the receiver's brush, used when drawing a line."

	| type gpHandle class |
	gpHandle := ExternalHandle new.
	GdiplusLibrary default gdipGetPenBrushFill: self asParameter brush: gpHandle.
	type := SDWORD new.
	GdiplusLibrary default gdipGetBrushType: gpHandle type: type.
	class := ##({GdiplusSolidBrush.
				GdiplusHatchBrush.
				GdiplusTextureBrush.
				GdiplusPathGradientBrush.
				GdiplusLinearGradientBrush}) at: type value + 1.
	^class fromOwnedHandle: gpHandle!

brush: aGdiplusBrush
	"Set the receiver to use aGdiplusBrush when drawing a line."

	GdiplusLibrary default gdipSetPenBrushFill: self asParameter brush: aGdiplusBrush asParameter!

color
	"Answer an ARGB that is the receiver's drawing color."

	| color |
	color := DWORDBytes new.
	GdiplusLibrary default gdipGetPenColor: self asParameter argb: color.
	^Color fromArgbCode: color value!

color: aColor
	"Set the receiver's drawing color to the <Color> argument."

	GdiplusLibrary default gdipSetPenColor: self asParameter argb: aColor argbCode!

compoundArray
	| array |
	array := FLOATArray new: self compoundArrayCount.
	GdiplusLibrary default
		gdipGetPenCompoundArray: self asParameter
		dash: array
		count: array size.
	^array asArray!

compoundArray: aRealArray
	self assert: [aRealArray size >= 2].
	self assert: [aRealArray allSatisfy: [:each | each between: 0.0 and: 1.0]].
	self assert: [aRealArray first = 0.0 and: [aRealArray last = 1.0]].
	GdiplusLibrary default
		gdipSetPenCompoundArray: self asParameter
		dash: (FLOATArray withAll: aRealArray)
		count: aRealArray size!

compoundArrayCount
	"Private - Answer the size of the receiver's compound array."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPenCompoundCount: self asParameter count: count.
	^count value!

customEndCap
	| gpHandle |
	gpHandle := ExternalHandle new.
	GdiplusLibrary default gdipGetPenCustomEndCap: self asParameter customCap: gpHandle.
	^GdiplusCustomLineCap fromOwnedHandle: gpHandle!

customEndCap: aGdiplusCustomLineCap
	GdiplusLibrary default gdipSetPenCustomEndCap: self asParameter
		customCap: aGdiplusCustomLineCap asParameter!

customStartCap: aGdiplusCustomLineCap
	GdiplusLibrary default gdipSetPenCustomStartCap: self asParameter
		customCap: aGdiplusCustomLineCap asParameter!

dashCap: aDashCapConstant
	"Set the dash cap of the receiver."

	GdiplusLibrary default gdipSetPenDashCap197819: self asParameter dashCap: aDashCapConstant!

dashPattern
	"Answer an array of custom dashes and spaces for the receiver."

	| array |
	array := FLOATArray new: self dashPatternCount.
	GdiplusLibrary default
		gdipGetPenDashArray: self asParameter
		dash: array
		count: array size.
	^array asArray!

dashPattern: aRealArray
	"Set an array of custom dashes and spaces for the receiver."

	GdiplusLibrary default
		gdipSetPenDashArray: self asParameter
		dash: (FLOATArray withAll: aRealArray)
		count: aRealArray size!

dashPatternCount
	"Private - Answer the size of the receiver's dash pattern array."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPenDashCount: self asParameter count: count.
	^count value!

dashStyle: aDashStyleConstant
	"Set the dash style of the receiver."

	GdiplusLibrary default gdipSetPenDashStyle: self asParameter dashStyle: aDashStyleConstant!

endCap: aLineCapConstant
	GdiplusLibrary default gdipSetPenEndCap: self asParameter endCap: aLineCapConstant!

lineCap: startCap endCap: endCap dashCap: dashCap
	GdiplusLibrary default
		gdipSetPenLineCap197819: self asParameter
		startCap: startCap
		endCap: endCap
		dashCap: dashCap!

lineJoin: aLineJoinConstant
	GdiplusLibrary default gdipSetPenLineJoin: self asParameter lineJoin: aLineJoinConstant!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	GdiplusLibrary default gdipResetPenTransform: self asParameter!

rotateTransform: aRealAngle order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipRotatePenTransform: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

scaleTransform: aRealPoint order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipScalePenTransform: self asParameter
		sx: aRealPoint x
		sy: aRealPoint y
		order: aMatrixOrderConstant!

startCap: aLineCapConstant
	GdiplusLibrary default gdipSetPenStartCap: self asParameter startCap: aLineCapConstant!

transform: aGdiplusMatrix
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	GdiplusLibrary default gdipSetPenTransform: self asParameter matrix: aGdiplusMatrix asParameter!

width
	"Answer the width of the receiver's stroke."

	| width |
	width := FLOAT new.
	GdiplusLibrary default gdipGetPenWidth: self asParameter width: width.
	^width asFloat!

width: aNumber
	"Set the width of the receiver's stroke."

	GdiplusLibrary default gdipSetPenWidth: self asParameter width: aNumber! !

!GdiplusPen categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
basicFree!private!realizing/unrealizing! !
brush!accessing!public! !
brush:!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
compoundArray!accessing!public! !
compoundArray:!accessing!public! !
compoundArrayCount!accessing!private! !
customEndCap!accessing!public! !
customEndCap:!accessing!public! !
customStartCap:!accessing!public! !
dashCap:!accessing!public! !
dashPattern!accessing!public! !
dashPattern:!accessing!public! !
dashPatternCount!accessing!private! !
dashStyle:!accessing!public! !
endCap:!accessing!public! !
lineCap:endCap:dashCap:!accessing!public! !
lineJoin:!accessing!public! !
resetTransform!operations!public! !
rotateTransform:order:!operations!public! !
scaleTransform:order:!operations!public! !
startCap:!accessing!public! !
transform:!operations!public! !
width!accessing!public! !
width:!accessing!public! !
!

!GdiplusPen class methodsFor!

black
	^self color: Color black!

blue
	^self color: Color blue!

brush: aGdiplusBrush width: aFloat
	"Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object"

	^self 
		fromInitializer: (GdiplusPenFromBrushInitializer brush: aGdiplusBrush width: aFloat)!

color: aColor
	"Answer an instance of the receiver with the specified color and default width (1.0)."

	^self color: aColor width: nil!

color: anARGB width: aFloat
	"Answer an instance of the receiver with the specified color and width."

	^self fromInitializer: (GdiplusPenFromColorInitializer color: anARGB width: aFloat)!

green
	^self color: Color green!

icon
	"Answers an Icon that can be used to represent this class"

	^Pen icon!

new
	^self black!

red
	^self color: Color red! !

!GdiplusPen class categoriesForMethods!
black!instance creation!public! !
blue!instance creation!public! !
brush:width:!instance creation!public! !
color:!instance creation!public! !
color:width:!instance creation!public! !
green!instance creation!public! !
icon!constants!development!public! !
new!instance creation!public! !
red!instance creation!public! !
!

