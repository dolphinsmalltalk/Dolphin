"Filed out from Dolphin Smalltalk"!

AbstractELEMDESC subclass: #ARRAYDESC
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cDims _OffsetOf_rgbounds'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ARRAYDESC guid: (GUID fromString: '{c06f3b6c-0868-11d3-93af-00a024ca708a}')!

ARRAYDESC addClassConstant: '_OffsetOf_cDims' value: 16r8!
ARRAYDESC addClassConstant: '_OffsetOf_rgbounds' value: 16rC!

ARRAYDESC comment: 'ARRAYDESC is an ExternalStructure class to represent the COM Automation structure of the same name.

ARRAYDESC describes an Automation safe array, specifically the type of the elements, the number of dimensions, and the bounds for each dimension.

Member variables:
	tdescElem		<TYPEDESC> Type of the elements of the array
	cDims		<WORD> Number of dimensions
	rgbounds		<SAFEARRAYBOUND[]> Variable length array containing array dimension bounds'!

!ARRAYDESC categoriesForClass!External-Data-Structured-COM! !

!ARRAYDESC methodsFor!

cDims
	"Private - Answer the <Integer> value of the receiver's 'cDims' field."

	^bytes wordAtOffset: _OffsetOf_cDims!

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

!ARRAYDESC categoriesForMethods!
cDims!**compiled accessors**!private! !
elementCount!accessing!private! !
rgbounds!**compiled accessors**!public! !
!

!ARRAYDESC class methodsFor!

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
		defineField: #cDims type: WORDField readOnly beNonBrowsable;
		defineField: #rgbounds
			type: (StructureArrayField type: SAFEARRAYBOUND
					arrayLength: (ConformantArrayFieldLength lengthField: #cDims)) beReadOnly!

getFieldNames
	^#(#tdescElem #cDims #rgbounds)! !

!ARRAYDESC class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

