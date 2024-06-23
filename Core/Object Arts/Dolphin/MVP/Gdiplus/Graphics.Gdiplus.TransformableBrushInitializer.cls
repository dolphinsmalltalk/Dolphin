"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BrushInitializer
	subclass: #'Graphics.Gdiplus.TransformableBrushInitializer'
	instanceVariableNames: 'transform wrapMode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.TransformableBrushInitializer guid: (Core.GUID fromString: '{5df7c966-9a06-4596-9a55-a2a6371b1ae2}')!

Graphics.Gdiplus.TransformableBrushInitializer isNonInstantiable: true!

Graphics.Gdiplus.TransformableBrushInitializer comment: ''!

!Graphics.Gdiplus.TransformableBrushInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self species == anObject species
		and: [transform = anObject transform and: [wrapMode = anObject wrapMode]]!

applyAdditionalAttributes: aHandle
	transform ifNotNil: [self gdipSetTransform: aHandle matrix: transform].
	wrapMode == self defaultWrapMode ifFalse: [self gdipSetWrap: aHandle mode: wrapMode]!

cacheTransform: aTransformableBrush
	| matrix |
	matrix := Matrix new.
	self gdipGetTransform: aTransformableBrush handle matrix: matrix.
	self transform: matrix.
	^matrix!

defaultWrapMode
	^WrapModeTile!

gdipGetTransform: aHandle matrix: matrix
	self subclassResponsibility!

gdipMultiplyTransform: aGpBrush matrix: aGpMatrix order: aMatrixOrderConstant
	self subclassResponsibility!

gdipResetTransform: aHandle 
	self subclassResponsibility!

gdipRotateTransform: aHandle angle: aNumber order: aMatrixOrderConstant
	self subclassResponsibility!

gdipScaleTransform: aHandle width: aPoint height: anInteger order: aMatrixOrderConstant
	self subclassResponsibility!

gdipSetTransform: aHandle matrix: aMatrix
	self subclassResponsibility!

gdipSetWrap: aHandle mode: aWrapModeConstant 
	self subclassResponsibility!

gdipTranslateTransform: aHandle dx: aPoint dy: aFloat order: aMatrixOrderConstant
	self subclassResponsibility!

getTransformOf: aTransformableBrush
	^transform ifNil: [^Matrix identity]!

hash
	"Answer the <integer> hash value for the receiver."

	^((self species hash + wrapMode hash) hashMultiply + transform hash) hashMultiply!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^transform isNil!

printAttributesOn: aStream
	wrapMode == self defaultWrapMode
		ifFalse: 
			[aStream nextPutAll: ' wrapMode: '.
			self
				printEnum: wrapMode
				names: WrapModeNames
				on: aStream].
	transform isNil
		ifFalse: 
			[aStream
				nextPutAll: '; transform: ';
				print: transform]!

resetTransformOf: aTransformableBrush
	self gdipResetTransform: aTransformableBrush handle.
	transform := nil!

transform
	^transform!

transform: aMatrix
	transform := (aMatrix isNil or: [aMatrix isIdentity]) ifFalse: [aMatrix]!

transform: aTransformableBrush multiply: aMatrix order: aMatrixOrderConstant
	self
		gdipMultiplyTransform: aTransformableBrush handle
		matrix: aMatrix asParameter
		order: aMatrixOrderConstant.
	^self cacheTransform: aTransformableBrush!

transform: aTransformableBrush rotate: aNumber order: aMatrixOrderConstant
	self
		gdipRotateTransform: aTransformableBrush handle
		angle: aNumber
		order: aMatrixOrderConstant.
	^self cacheTransform: aTransformableBrush!

transform: aTransformableBrush scale: aPoint order: aMatrixOrderConstant
	self
		gdipScaleTransform: aTransformableBrush handle
		width: aPoint x asFloat
		height: aPoint y asFloat
		order: aMatrixOrderConstant.
	^self cacheTransform: aTransformableBrush!

transform: aTransformableBrush translate: aPoint order: aMatrixOrderConstant
	self
		gdipTranslateTransform: aTransformableBrush handle
		dx: aPoint x asFloat
		dy: aPoint y asFloat
		order: aMatrixOrderConstant.
	^self cacheTransform: aTransformableBrush!

transformOf: aTransformableBrush set: aMatrix
	self gdipSetTransform: aTransformableBrush handle matrix: aMatrix.
	self transform: aMatrix!

wrapMode
	^wrapMode!

wrapMode: aHandle set: aWrapModeConstant
	self gdipSetWrap: aHandle mode: aWrapModeConstant.
	wrapMode := aWrapModeConstant! !

!Graphics.Gdiplus.TransformableBrushInitializer categoriesForMethods!
=!comparing!public! !
applyAdditionalAttributes:!private!realizing/unrealizing! !
cacheTransform:!private!transformations! !
defaultWrapMode!constants!private! !
gdipGetTransform:matrix:!attributes!private!transformations! !
gdipMultiplyTransform:matrix:order:!private!transformations! !
gdipResetTransform:!private!transformations! !
gdipRotateTransform:angle:order:!private!transformations! !
gdipScaleTransform:width:height:order:!private!transformations! !
gdipSetTransform:matrix:!private!transformations! !
gdipSetWrap:mode:!attributes!private! !
gdipTranslateTransform:dx:dy:order:!private!transformations! !
getTransformOf:!private!transformations! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
printAttributesOn:!printing!private! !
resetTransformOf:!private!transformations! !
transform!accessing!private! !
transform:!accessing!private!transformations! !
transform:multiply:order:!private!transformations! !
transform:rotate:order:!private!transformations! !
transform:scale:order:!private!transformations! !
transform:translate:order:!private!transformations! !
transformOf:set:!private!transformations! !
wrapMode!accessing!attributes!public! !
wrapMode:set:!attributes!private! !
!

