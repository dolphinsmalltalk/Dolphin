"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure subclass: #'Graphics.Gdiplus.ColorMatrix'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_ColorMatrix_Size' -> 16r64.
		'_OffsetOf_m' -> 16r0
	}!
Graphics.Gdiplus.ColorMatrix guid: (Core.GUID fromString: '{6b5ab37e-5cc3-447e-99ef-9135f516ccc0}')!
Graphics.Gdiplus.ColorMatrix comment: '<GpColorMatrix> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpColorMatrix'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(6B5AB37E-5CC3-447E-99EF-9135F516CCC0)]
struct tagGpColorMatrix {
	single m[5][5];
} GpColorMatrix;
'!
!Graphics.Gdiplus.ColorMatrix categoriesForClass!Gdiplus-Structs! !
!Graphics.Gdiplus.ColorMatrix methodsFor!

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
!Graphics.Gdiplus.ColorMatrix categoriesForMethods!
asArray!converting!public! !
atPoint:!accessing!public! !
atPoint:put:!accessing!public! !
closeTo:!comparing!public! !
closeTo:precision:!comparing!public! !
m!**compiled accessors**!public! !
m:!**compiled accessors**!public! !
row:col:!accessing!public! !
row:col:put:!accessing!public! !
!

!Graphics.Gdiplus.ColorMatrix class methodsFor!

byteSize
	^_ColorMatrix_Size!

defineFields
	"Define the fields of the ColorMatrix structure.

	ColorMatrix compileDefinition

		typedef [uuid(6b5ab37e-5cc3-447e-99ef-9135f516ccc0), helpstring('Color matrix')]
		struct tagColorMatrix {
			REAL m[5][5];
		} ColorMatrix;
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

	| floats bytes |
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
!Graphics.Gdiplus.ColorMatrix class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
identity!instance creation!public! !
withAll:!instance creation!public! !
!

