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

	| status alignment |
	alignment := SDWORD new.
	(status := GdiplusLibrary default gdipGetPenMode: self asParameter penMode: alignment) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenMode failed' with: status].
	^alignment value!

alignment: aPenAlignmentConstant 
	"Set the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	| status |
	(status := GdiplusLibrary default gdipSetPenMode: self asParameter penMode: aPenAlignmentConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPenMode failed' with: status]!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDeletePen: handle!

brush
	"Answer the receiver's brush, used when drawing a line."

	| status type gpHandle class |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipGetPenBrushFill: self asParameter brush: gpHandle) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenBrushFill failed' with: status].
	type := SDWORD new.
	(status := GdiplusLibrary default gdipGetBrushType: gpHandle type: type) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetBrushType failed' with: status].
	class := ##({GdiplusSolidBrush.
				GdiplusHatchBrush.
				GdiplusTextureBrush.
				GdiplusPathGradientBrush.
				GdiplusLinearGradientBrush}) at: type value + 1.
	^class fromOwnedHandle: gpHandle!

brush: aGdiplusBrush 
	"Set the receiver to use aGdiplusBrush when drawing a line."

	| status |
	(status := GdiplusLibrary default gdipSetPenBrushFill: self asParameter
				brush: aGdiplusBrush asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenBrushFill failed' with: status]!

color
	"Answer an ARGB that is the receiver's drawing color."

	| status color |
	color := DWORD new.
	(status := GdiplusLibrary default gdipGetPenColor: self asParameter argb: color) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenColor failed' with: status].
	^Color fromArgbCode: color value!

color: aColor
	"Set the receiver's drawing color to the <Color> argument."

	| status |
	(status := GdiplusLibrary default gdipSetPenColor: self asParameter argb: aColor argbCode) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetPenColor failed' with: status]!

compoundArray
	| status array |
	array := FLOATArray new: self compoundArrayCount.
	(status := GdiplusLibrary default 
				gdipGetPenCompoundArray: self asParameter
				dash: array
				count: array size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenCompoundArray failed' with: status].
	^array asArray!

compoundArray: aRealArray 
	| status |
	self assert: [aRealArray size >= 2].
	self assert: [aRealArray allSatisfy: [:each | each between: 0.0 and: 1.0]].
	self assert: [aRealArray first = 0.0 and: [aRealArray last = 1.0]].
	(status := GdiplusLibrary default 
				gdipSetPenCompoundArray: self asParameter
				dash: (FLOATArray withAll: aRealArray)
				count: aRealArray size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenCompoundArray failed' with: status]!

compoundArrayCount
	"Private - Answer the size of the receiver's compound array."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPenCompoundCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenCompoundCount failed' with: status].
	^count value!

customEndCap
	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipGetPenCustomEndCap: self asParameter customCap: gpHandle) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetPenCustomEndCap failed' with: status].
	^GdiplusCustomLineCap fromOwnedHandle: gpHandle!

customEndCap: aGdiplusCustomLineCap 
	| status |
	(status := GdiplusLibrary default gdipSetPenCustomEndCap: self asParameter
				customCap: aGdiplusCustomLineCap asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenCustomEndCap failed' with: status]!

customStartCap: aGdiplusCustomLineCap 
	| status |
	(status := GdiplusLibrary default gdipSetPenCustomStartCap: self asParameter
				customCap: aGdiplusCustomLineCap asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenCustomStartCap failed' with: status]!

dashCap: aDashCapConstant 
	"Set the dash cap of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPenDashCap197819: self asParameter
				dashCap: aDashCapConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenDashCap197819 failed' with: status]!

dashPattern
	"Answer an array of custom dashes and spaces for the receiver."

	| status array |
	array := FLOATArray new: self dashPatternCount.
	(status := GdiplusLibrary default
				gdipGetPenDashArray: self asParameter
				dash: array
				count: array size) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenDashArray failed' with: status].
	^array asArray!

dashPattern: aRealArray 
	"Set an array of custom dashes and spaces for the receiver."

	| status |
	(status := GdiplusLibrary default 
				gdipSetPenDashArray: self asParameter
				dash: (FLOATArray withAll: aRealArray)
				count: aRealArray size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenDashArray failed' with: status]!

dashPatternCount
	"Private - Answer the size of the receiver's dash pattern array."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPenDashCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenDashCount failed' with: status].
	^count value!

dashStyle: aDashStyleConstant 
	"Set the dash style of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPenDashStyle: self asParameter
				dashStyle: aDashStyleConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenDashStyle failed' with: status]!

endCap: aLineCapConstant 
	| status |
	(status := GdiplusLibrary default gdipSetPenEndCap: self asParameter endCap: aLineCapConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenEndCap failed' with: status]!

lineCap: startCap endCap: endCap dashCap: dashCap 
	| status |
	(status := GdiplusLibrary default 
				gdipSetPenLineCap197819: self asParameter
				startCap: startCap
				endCap: endCap
				dashCap: dashCap) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenLineCap197819 failed' with: status]!

lineJoin: aLineJoinConstant 
	| status |
	(status := GdiplusLibrary default gdipSetPenLineJoin: self asParameter lineJoin: aLineJoinConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPenLineJoin failed' with: status]!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	| status |
	(status := GdiplusLibrary default gdipResetPenTransform: self asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipResetPenTransform failed' with: status]!

rotateTransform: aRealAngle order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipRotatePenTransform: self asParameter
				angle: aRealAngle
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipRotatePenTransform failed' with: status]!

scaleTransform: aRealPoint order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipScalePenTransform: self asParameter
				sx: aRealPoint x
				sy: aRealPoint y
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipScalePenTransform failed' with: status]!

startCap: aLineCapConstant 
	| status |
	(status := GdiplusLibrary default gdipSetPenStartCap: self asParameter startCap: aLineCapConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPenStartCap failed' with: status]!

transform: aGdiplusMatrix 
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPenTransform: self asParameter
				matrix: aGdiplusMatrix asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenTransform failed' with: status]!

width
	"Answer the width of the receiver's stroke."

	| status width |
	width := FLOAT new.
	(status := GdiplusLibrary default gdipGetPenWidth: self asParameter width: width) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenWidth failed' with: status].
	^width asFloat!

width: aNumber 
	"Set the width of the receiver's stroke."

	| status |
	(status := GdiplusLibrary default gdipSetPenWidth: self asParameter width: aNumber) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenWidth failed' with: status]! !

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

