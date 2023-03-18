"Filed out from Dolphin Smalltalk"!

OS.COM.AbstractELEMDESC subclass: #'OS.COM.ARRAYDESC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_ARRAYDESC_Size' -> 16r14.
		'_OffsetOf_cDims' -> 16r8.
		'_OffsetOf_rgbounds' -> 16rC
	}!
OS.COM.ARRAYDESC guid: (Core.GUID fromString: '{c06f3b6c-0868-11d3-93af-00a024ca708a}')!
OS.COM.ARRAYDESC comment: '`OS.COM.ARRAYDESC` is an ExternalStructure class to represent the COM Automation ARRAYDESC structure.

ARRAYDESC describes an Automation safe array, specifically the type of the elements, the number of dimensions, and the bounds for each dimension.

Member variables:
	tdescElem	`TYPEDESC` Type of the elements of the array
	cDims		`WORD` Number of dimensions
	rgbounds	`SAFEARRAYBOUND[]` Variable length array containing array dimension bounds'!
!OS.COM.ARRAYDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.ARRAYDESC methodsFor!

cDims
	"Private - Answer the <Integer> value of the receiver's 'cDims' field."

	^bytes uint16AtOffset: _OffsetOf_cDims!

elementCount
	"Private - Answer the total number of elements in all dimensions of the array
	type described by the receiver."

	^self rgbounds inject: 1 into: [:sz :b | sz * b cElements]!

rgbounds
	"Answer the <StructureArray> value of the receiver's 'rgbounds' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_rgbounds
		length: self cDims
		elementClass: SAFEARRAYBOUND! !
!OS.COM.ARRAYDESC categoriesForMethods!
cDims!**compiled accessors**!private! !
elementCount!accessing!private! !
rgbounds!**compiled accessors**!public! !
!

!OS.COM.ARRAYDESC class methodsFor!

byteSize
	^_ARRAYDESC_Size!

defineFields
	"Define the fields of the ARRAYDESC structure.
	N.B. This is a variable length structure, and the type library does not describe it properly.

		ARRAYDESC compileDefinition.

		typedef struct  tagARRAYDESC
		{
			TYPEDESC tdescElem;
			USHORT cDims;
			[size_is(cDims)] SAFEARRAYBOUND rgbounds[];
		}	ARRAYDESC;

	"

	super defineFields.
	self
		defineField: #cDims type: UInt16Field readOnly beNonBrowsable;
		defineField: #rgbounds
			type: (StructureArrayField type: SAFEARRAYBOUND
					arrayLength: (ConformantArrayFieldLength lengthField: #cDims)) beReadOnly!

getFieldNames
	^#(#tdescElem #cDims #rgbounds)! !
!OS.COM.ARRAYDESC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

