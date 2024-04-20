"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusMatrix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusMatrix guid: (GUID fromString: '{1a1a5ea7-6151-11d7-b609-00e0987e8081}')!

GdiplusMatrix comment: 'GdiplusMatrix represents a 3 ×3 matrix that, in turn, represents an affine transformation. An instance stores only six of the 9 numbers in a 3 ×3 matrix because all 3 ×3 matrices that represent affine transformations have the same third column (0, 0, 1).  An instance is typically used to transform characteristics of another object (see definitions of #transform:).

'!

!GdiplusMatrix categoriesForClass!Unclassified! !

!GdiplusMatrix methodsFor!

asArray
	| status array |
	array := FLOATArray new: 6.
	(status := GdiplusLibrary default gdipGetMatrixElements: self asParameter matrixOut: array) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetMatrixElements failed' with: status].
	^array asArray!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteMatrix: handle!

closeTo: aNumber
	^self closeTo: aNumber precision: 0.0000001!

closeTo: aMatrix precision: precisionFloat
	^self elements closeTo: aMatrix asArray precision: precisionFloat!

createHandle
	^initializer
		ifNil: 
			[| gpMatrix |
			gpMatrix := ExternalHandle new.
			GdiplusLibrary default gdipCreateMatrix: gpMatrix.
			gpMatrix]
		ifNotNil: [initializer createHandle]!

displayOn: aStream
	aStream nextPut: $(.
	self elements do: [:each | each printOn: aStream significantFigures: 6]
		separatedBy: 
			[aStream
				nextPutAll: Locale userDefault listSeparator;
				space].
	aStream nextPut: $)!

elements
	| elements status |
	elements := FLOATArray new: 6.
	(status := GdiplusLibrary default gdipGetMatrixElements: self asParameter matrixOut: elements) == Ok
		ifFalse: [^GdiplusError signal: 'GdipGetMatrixElements failed' with: status].
	^elements!

isIdentity
	"Answer whether the receiver is an identity matrix, i.e. (1, 0, 0, 1, 0, 0)"

	| result status |
	result := ByteArray newFixed: 4.
	(status := GdiplusLibrary default gdipIsMatrixIdentity: self asParameter result: result) == Ok
		ifFalse: [GdiplusError signal: 'GdipIsMatrixIdentity failed' with: status].
	^(result sdwordAtOffset: 0) ~~ 0!

printOn: aStream
	self isIdentity
		ifTrue: 
			[aStream
				print: self class;
				space;
				nextPutAll: #identity]
		ifFalse: 
			[aStream
				nextPut: $(;
				print: self class;
				space;
				display: #fromArray:;
				nextPutAll: ' #('.
			self elements do: [:each | each printOn: aStream significantFigures: 9] separatedBy: [aStream space].
			aStream nextPutAll: '))']!

rotateTransform: aRealAngle
	self rotateTransform: aRealAngle order: MatrixOrderPrepend!

rotateTransform: aRealAngle order: aMatrixOrderConstant 
	| status |
	(status := GdiplusLibrary default 
				gdipRotateMatrix: self asParameter
				angle: aRealAngle
				order: aMatrixOrderConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipRotateMatrix failed' with: status]!

scaleTransform: aPoint
	self scaleTransform: aPoint order: MatrixOrderPrepend!

scaleTransform: aPoint order: aMatrixOrderConstant 
	| status |
	(status := GdiplusLibrary default 
				gdipScaleMatrix: self asParameter
				scaleX: aPoint x asFloat
				scaleY: aPoint y asFloat
				order: aMatrixOrderConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipScaleMatrix failed' with: status]!

shearTransform: aPoint
	self shearTransform: aPoint order: MatrixOrderPrepend!

shearTransform: aPoint order: aMatrixOrderConstant 
	| status |
	(status := GdiplusLibrary default 
				gdipShearMatrix: self asParameter
				shearX: aPoint x asFloat
				shearY: aPoint y asFloat
				order: aMatrixOrderConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipShearMatrix failed' with: status]!

transformPoints: aPointsCollection
	| nativePoints status |
	nativePoints := POINTLArray marshal: aPointsCollection.
	(status := GdiplusLibrary default
				gdipTransformMatrixPointsI: self handle
				pts: nativePoints
				count: aPointsCollection size) == Ok
		ifFalse: [GdiplusError signal: 'GdipTransformMatrixPoints: failed' with: status].
	^nativePoints!

translateTransform: aPoint
	self translateTransform: aPoint order: MatrixOrderPrepend!

translateTransform: aPoint order: aMatrixOrderConstant 
	| status |
	(status := GdiplusLibrary default 
				gdipTranslateMatrix: self asParameter
				offsetX: aPoint x
				offsetY: aPoint y
				order: aMatrixOrderConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipTranslateMatrix failed' with: status]! !

!GdiplusMatrix categoriesForMethods!
asArray!converting!public! !
basicFree!private!realizing/unrealizing! !
closeTo:!comparing!public! !
closeTo:precision:!comparing!public! !
createHandle!private!realizing/unrealizing! !
displayOn:!printing!public! !
elements!accessing!public! !
isIdentity!public!testing! !
printOn:!printing!public! !
rotateTransform:!operations!public! !
rotateTransform:order:!operations!public! !
scaleTransform:!operations!public! !
scaleTransform:order:!operations!public! !
shearTransform:!operations!public! !
shearTransform:order:!operations!public! !
transformPoints:!operations!public! !
translateTransform:!operations!public! !
translateTransform:order:!operations!public! !
!

!GdiplusMatrix class methodsFor!

fromArray: anArray
	^self
		m11: (anArray at: 1)
		m12: (anArray at: 2)
		m21: (anArray at: 3)
		m22: (anArray at: 4)
		m31: (anArray at: 5)
		m32: (anArray at: 6)!

identity
	^self new!

m11: aNumber11 m12: aNumber12 m21: aNumber21 m22: aNumber22 m31: aNumber31 m32: aNumber32
	^self fromInitializer: (GdiplusMatrixInitializer 
				m11: aNumber11 asFloat
				m12: aNumber12 asFloat
				m21: aNumber21 asFloat
				m22: aNumber22 asFloat
				m31: aNumber31 asFloat
				m32: aNumber32 asFloat)!

rectangle: aRectangle point: aPoint
	^self 
		m11: aRectangle left
		m12: aRectangle top
		m21: aRectangle width
		m22: aRectangle height
		m31: aPoint x
		m32: aPoint y! !

!GdiplusMatrix class categoriesForMethods!
fromArray:!instance creation!public! !
identity!public! !
m11:m12:m21:m22:m31:m32:!instance creation!public! !
rectangle:point:!instance creation!public! !
!

