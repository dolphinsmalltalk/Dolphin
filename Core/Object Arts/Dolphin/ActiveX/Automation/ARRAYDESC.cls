"Filed out from Dolphin Smalltalk 7"!

AbstractELEMDESC subclass: #ARRAYDESC
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ARRAYDESC guid: (GUID fromString: '{c06f3b6c-0868-11d3-93af-00a024ca708a}')!
ARRAYDESC comment: 'ARRAYDESC is an ExternalStructure class to represent the COM Automation structure of the same name.

ARRAYDESC describes an Automation safe array, specifically the type of the elements, the number of dimensions, and the bounds for each dimension.

Member variables:
	tdescElem		<TYPEDESC> Type of the elements of the array
	cDims		<WORD> Number of dimensions
	rgbounds		<SAFEARRAYBOUND[]> Variable length array containing array dimension bounds'!
!ARRAYDESC categoriesForClass!External-Data-Structured-COM! !
!ARRAYDESC methodsFor!

cDims
	"Answer the <Integer> value of the receiver's 'cDims' field."

	^bytes wordAtOffset: ##(self offsetOf: #cDims)!

elementCount
	"Private - Answer the total number of elements in all dimensions of the array
	type described by the receiver."

	^self rgbounds inject: 1 into: [:sz :b | sz * b cElements]!

rgbounds
	"Answer the <StructureArray> value of the receiver's 'rgbounds' field."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #rgbounds)
		length: self cDims
		elementClass: SAFEARRAYBOUND! !
!ARRAYDESC categoriesFor: #cDims!**compiled accessors**!public! !
!ARRAYDESC categoriesFor: #elementCount!accessing!private! !
!ARRAYDESC categoriesFor: #rgbounds!**compiled accessors**!public! !

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
		defineField: #cDims type: WORDField readOnly;
		defineField: #rgbounds
			type: (ConformantStructureArrayField type: SAFEARRAYBOUND length: #cDims) beReadOnly! !
!ARRAYDESC class categoriesFor: #defineFields!initializing!public! !

