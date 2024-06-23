"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.MatrixInitializer'
	instanceVariableNames: 'elements'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.MatrixInitializer guid: (Core.GUID fromString: '{1a1a5ea6-6151-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.MatrixInitializer comment: ''!

!Graphics.Gdiplus.MatrixInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [self species == anObject species and: [elements = anObject elements]]!

basicCreateHandle
	| gpMatrix |
	gpMatrix := Handle new.
	elements
		ifNil: [Gdip gdipCreateMatrix: gpMatrix]
		ifNotNil: 
			[Gdip
				gdipCreateMatrix2: (elements at: 1)
				m12: (elements at: 2)
				m21: (elements at: 3)
				m22: (elements at: 4)
				dx: (elements at: 5)
				dy: (elements at: 6)
				matrix: gpMatrix].
	^gpMatrix!

elements
	^elements ?? #(1.0 0.0 0.0 1.0 0.0 0.0)!

elements: anArray
	elements := FLOATArray marshal: anArray.
	^self!

hash
	"Answer the <integer> hash value for the receiver."

	^(self species hash + elements hash) hashMultiply!

initializeFromHandle: aHandle
	"Private - Cache all the attributes of the native Gdiplus Matrix identified by the specified <External.Handle> into the receiver."

	| bool |
	aHandle ifNil: [^self].
	bool := UInt32Bytes new.
	Gdip gdipIsMatrixIdentity: aHandle result: bool.
	(bool int32AtOffset: 0) == 0 ifFalse: [^self].
	elements := FLOATArray new: 6.
	Gdip gdipGetMatrixElements: aHandle matrixOut: elements!

isIdentity
	"Answer whether the receiver is an identity matrix, i.e. (1, 0, 0, 1, 0, 0)"

	^elements isNil!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

printAttributesOn: aStream
	self isIdentity
		ifTrue: [aStream nextPutAll: #identity]
		ifFalse: 
			[aStream
				nextPutAll: #fromArray:;
				nextPutAll: ' #('.
			elements do: [:each | each printOn: aStream significantFigures: 9] separatedBy: [aStream space].
			aStream nextPut: $)]!

printGdiplusObject: aGdiplusObject on: aStream
	self isIdentity
		ifTrue: 
			[aStream
				print: aGdiplusObject class;
				space;
				nextPutAll: #identity]
		ifFalse: [super printGdiplusObject: aGdiplusObject on: aStream]! !

!Graphics.Gdiplus.MatrixInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
elements!accessing!public! !
elements:!initializing!private! !
hash!comparing!public! !
initializeFromHandle:!private!realizing/unrealizing! !
isIdentity!public!testing! !
isSelfEvaluating!public!testing! !
printAttributesOn:!printing!private! !
printGdiplusObject:on:!printing!public! !
!

!Graphics.Gdiplus.MatrixInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneMatrix: aHandle cloneMatrix: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDeleteMatrix: aHandle!

fromArray: anArray
	^self new elements: anArray!

identity
	^self new!

m11: aReal11 m12: aReal12 m21: aReal21 m22: aReal22 dx: aReal31 dy: aReal32
	^self fromArray: {aReal11. aReal12. aReal21. aReal22. aReal31. aReal32}! !

!Graphics.Gdiplus.MatrixInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
fromArray:!instance creation!public! !
identity!instance creation!public! !
m11:m12:m21:m22:dx:dy:!instance creation!public! !
!

