"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #ARRAYDESC
	instanceVariableNames: 'owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ARRAYDESC guid: (GUID fromString: '{C06F3B6C-0868-11D3-93AF-00A024CA708A}')!
ARRAYDESC comment: 'ARRAYDESC is an ExternalStructure class to represent the COM Automation structure of the same name.

ARRAYDESC describes an Automation safe array, specifically the type of the elements, the number of dimensions, and the bounds for each dimension.

Member variables:
	tdescElem		<TYPEDESC> Type of the elements of the array
	cDims		<WORD> Number of dimensions
	rgbounds		<SAFEARRAYBOUND[]> Variable length array containing array dimension bounds'!
!ARRAYDESC categoriesForClass!External-Data-Structured-COM! !
!ARRAYDESC methodsFor!

analyzer
	"Private - Answer the <AXTypeInfoAnalyzer> from which the receiver originated."

	^owner analyzer!

cDims
	"Answer the receiver's cDims field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cDims)!

elementCount
	"Private - Answer the total number of elements in all dimensions of the array
	type described by the receiver."

	^self rgbounds inject: 1 into: [:sz :b | sz * b cElements]!

owner: struct
	"Private - Set the value of the receiver's 'owner' instance variable to the <AXTypeInfoStructure> 
	argument, struct. Answer the receiver."

	owner := struct!

rgbounds
	"Answer the receiver's rgbounds field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #rgbounds)
		length: self cDims
		elementClass: SAFEARRAYBOUND!

tdesc
	"Answer a <TYPEDESC> which is the type of the elements of the array described by the receiver.
	Implementation Note: Set the back-pointer to be the same as the receiver's, since it
	is the destruction of the <AXTypeInfoStructure> which we wish to postpone for the
	lifetime of the TYPEDESC."

	^self tdescElem
		owner: owner!

tdescElem
	"Answer the receiver's tdescElem field as a Smalltalk object."

	^TYPEDESC fromAddress: bytes yourAddress! !
!ARRAYDESC categoriesFor: #analyzer!accessing!private! !
!ARRAYDESC categoriesFor: #cDims!**compiled accessors**!public! !
!ARRAYDESC categoriesFor: #elementCount!accessing!private! !
!ARRAYDESC categoriesFor: #owner:!accessing!private! !
!ARRAYDESC categoriesFor: #rgbounds!**compiled accessors**!public! !
!ARRAYDESC categoriesFor: #tdesc!accessing!public! !
!ARRAYDESC categoriesFor: #tdescElem!**compiled accessors**!public! !

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

	self
		defineField: #tdescElem type: (StructureField type: TYPEDESC) beReadOnly;
		defineField: #cDims type: WORDField readOnly;
		defineField: #rgbounds
			type: (ConformantStructureArrayField type: SAFEARRAYBOUND length: #cDims) beReadOnly! !
!ARRAYDESC class categoriesFor: #defineFields!initializing!public! !

