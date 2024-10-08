﻿"Filed out from Dolphin Smalltalk"!

OS.COM.AbstractELEMDESC
	subclass: #'OS.COM.ELEMDESC'
	instanceVariableNames: 'param index custData'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: { '_ELEMDESC_Size' -> 16r10. '_OffsetOf_paramdesc' -> 16r8 }!

OS.COM.ELEMDESC guid: (Core.GUID fromString: '{c06f3b77-0868-11d3-93af-00a024ca708a}')!

OS.COM.ELEMDESC comment: 'ELEMDESC is an <ExternalStructure> class to represent the AX Automation structure of the same name.

ELEMDESC contains type and marshalling information for a variable, a function, or a function parameter.

Structure Member Variables:
	tdesc		<TYPEDESC>. Type information
	paramdesc	<PARAMDESC>. Description of parameter.

Instance Variables:
	owner		<FUNCDESC>| <VARDESC>. Type lib function or variable description to which this element belongs
	param		<PARAMDESC>. Cached paramdesc structure.
	tdesc		<TYPEDESC>. Cached tdesc structure
'!

!OS.COM.ELEMDESC categoriesForClass!External-Data-Structured-COM! !

!OS.COM.ELEMDESC methodsFor!

customAttributes
	"Answer the collection of custom attributes defined on the member. This is a lookup table
	mapping <GUID> attribute id to the attribute value, usally a string."

	^self getCustData!

defaultValue
	"Answer a <VARIANT> which is the default value for the parameter described
	by the receiver, or nil if it doesn't have a default value."

	^self param defaultValue!

getAllCustData
	^owner analyzer tlbInterface getAllParamCustData: owner index indexParam: index!

getCustData
	^custData ifNil: [custData := self getAllCustData]!

hasDefaultValue
	^self param hasDefaultValue!

index: anInteger 
	index := anInteger!

isIn
	"Answer whether the receiver is describing an input argument."

	#todo.	"This needs to take account of argument type - singly indirected char* and void*, for example, 
			need to always be 'in' to have an argument expected to wrapper method"
	^self param isIn!

isOptional
	"Answer whether the receiver is describing a an optional parameter."

	^self param isOptional!

isOut
	"Answer whether the receiver is describing an output argument.
	Note that it is possible for the direction not to be specified, in which case we
	assume that it is for input only (is this right?"

	^self param isOut!

isRetVal
	"Answer whether the receiver is describing a retval (i.e. return value) argument."

	^self param isRetVal!

param
	"Answer a <PARAMDESC> describing the parameter associated with the receiver."

	param isNil ifTrue: [param := self paramdesc].
	^param!

paramdesc
	"Answer the <PARAMDESC> value of the receiver's 'paramdesc' field."

	^PARAMDESC fromAddress: bytes yourAddress + _OffsetOf_paramdesc! !

!OS.COM.ELEMDESC categoriesForMethods!
customAttributes!accessing!public! !
defaultValue!accessing!public! !
getAllCustData!accessing!private! !
getCustData!accessing!private! !
hasDefaultValue!development!helpers!private! !
index:!initializing!public! !
isIn!public!testing! !
isOptional!public!testing! !
isOut!public!testing! !
isRetVal!public!testing! !
param!accessing!public! !
paramdesc!**compiled accessors**!public! !
!

!OS.COM.ELEMDESC class methodsFor!

byteSize
	^_ELEMDESC_Size!

defineFields
	"Define the fields of the ELEMDESC structure.

		ELEMDESC compileDefinition.

		typedef struct tagELEMDESC {
			TYPEDESC tdescElem;             /* the type of the element */
			PARAMDESC paramdesc;    /* info about the parameter */
			};
		ELEMDESC, * LPELEMDESC;
	"

	super defineFields.
	self defineField: #paramdesc type: (StructureField type: PARAMDESC) beReadOnly!

getFieldNames
	^#(#tdescElem #paramdesc)! !

!OS.COM.ELEMDESC class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

