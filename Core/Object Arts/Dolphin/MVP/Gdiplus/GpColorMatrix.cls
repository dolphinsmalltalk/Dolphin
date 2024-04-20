"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GpColorMatrix
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_m'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpColorMatrix guid: (GUID fromString: '{6b5ab37e-5cc3-447e-99ef-9135f516ccc0}')!

GpColorMatrix addClassConstant: '_OffsetOf_m' value: 16r0!

GpColorMatrix comment: '<GpColorMatrix> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorMatrix'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(6B5AB37E-5CC3-447E-99EF-9135F516CCC0)]
struct tagGpColorMatrix {
	single m[5][5];
} GpColorMatrix;
'!

!GpColorMatrix categoriesForClass!Unclassified! !

!GpColorMatrix methodsFor!

asArray
	^self m!

atPoint: aPoint
	^bytes floatAtOffset: ((aPoint x - 1) * 5 + aPoint y - 1) * 4!

atPoint: aPoint put: aNumber
	bytes floatAtOffset: ((aPoint x - 1) * 5 + aPoint y - 1) * 4 put: aNumber!

closeTo: aNumber
	^self closeTo: aNumber precision: 0.0000001!

closeTo: aColorMatrix precision: aFloat
	^self m closeTo: aColorMatrix asArray precision: aFloat!

m
	"Answer the <FLOATArray> value of the receiver's 'm' field."

	^FLOATArray fromAddress: bytes yourAddress length: 25!

m: aFLOATArray
	"Set the receiver's 'm' field to the value of the argument, aFLOATArray"

	| size |
	size := aFLOATArray byteSize min: ##(25 * FLOATArray elementSize).
	aFLOATArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_m + 1)
		to: size
		startingAt: 1!

row: rowInteger col: colInteger
	^bytes floatAtOffset: ((rowInteger - 1) * 5 + colInteger - 1) * 4!

row: rowInteger col: colInteger put: aNumber
	bytes floatAtOffset: ((rowInteger - 1) * 5 + colInteger - 1) * 4 put: aNumber! !

!GpColorMatrix categoriesForMethods!
asArray!converting!public! !
atPoint:!accessing!public! !
atPoint:put:!accessing!public! !
closeTo:!public! !
closeTo:precision:!public! !
m!**compiled accessors**!public! !
m:!**compiled accessors**!public! !
row:col:!accessing!public! !
row:col:put:!accessing!public! !
!

!GpColorMatrix class methodsFor!

defineFields
	"Define the fields of the GpColorMatrix structure.
		GpColorMatrix compileDefinition
	
		typedef [uuid(6B5AB37E-5CC3-447E-99EF-9135F516CCC0), helpstring('Color matrix')]
		struct tagGpColorMatrix {
			float m[5][5];
		} GpColorMatrix;
"

	self
		defineField: #m type: (ArrayField type: FLOATArray length: 25) offset: 0.
	self byteSize: 100!

getFieldNames
	^#(#m)!

identity
	"Answer an instance of the receiver that represents an identity matrix."

	^self basicNew
		bytes: #[0 0 128 63 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 63 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 63 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 63 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 128 63]
					shallowCopy;
		yourself!

withAll: anArray
	"Answer an instance created from anArray. anArray must have 25 <Number> elements"

	| floats |
	anArray size == 25
		ifFalse: [InvalidArgumentError signal: 'ColorMatrix requires 25 elements' with: 'anArray'].
	floats := FLOATArray marshal: anArray.
	^floats == anArray
		ifTrue: 
			[self newBuffer
				m: floats;
				yourself]
		ifFalse: 
			[self basicNew
				bytes: floats bytes;
				yourself]! !

!GpColorMatrix class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
identity!instance creation!public! !
withAll:!instance creation!public! !
!

