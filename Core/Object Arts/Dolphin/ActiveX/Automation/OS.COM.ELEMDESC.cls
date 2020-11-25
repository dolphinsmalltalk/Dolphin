"Filed out from Dolphin Smalltalk 7"!

AbstractELEMDESC subclass: #ELEMDESC
	instanceVariableNames: 'param'
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_paramdesc' -> 16r8
	}!
ELEMDESC guid: (GUID fromString: '{c06f3b77-0868-11d3-93af-00a024ca708a}')!
ELEMDESC comment: 'ELEMDESC is an <ExternalStructure> class to represent the AX Automation structure of the same name.

ELEMDESC contains type and marshalling information for a variable, a function, or a function parameter.

Structure Member Variables:
	tdesc		<TYPEDESC>. Type information
	paramdesc	<PARAMDESC>. Description of parameter.

Instance Variables:
	owner		<FUNCDESC>| <VARDESC>. Type lib function or variable description to which this element belongs
	param		<PARAMDESC>. Cached paramdesc structure.
	tdesc		<TYPEDESC>. Cached tdesc structure
'!
!ELEMDESC categoriesForClass!External-Data-Structured-COM! !
!ELEMDESC methodsFor!

defaultValue
	"Answer a <VARIANT> which is the default value for the parameter described
	by the receiver, or nil if it doesn't have a default value."

	^self param defaultValue!

hasDefaultValue
	^self param hasDefaultValue!

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
!ELEMDESC categoriesFor: #defaultValue!accessing!public! !
!ELEMDESC categoriesFor: #hasDefaultValue!development!helpers!private! !
!ELEMDESC categoriesFor: #isIn!public!testing! !
!ELEMDESC categoriesFor: #isOptional!public!testing! !
!ELEMDESC categoriesFor: #isOut!public!testing! !
!ELEMDESC categoriesFor: #isRetVal!public!testing! !
!ELEMDESC categoriesFor: #param!accessing!public! !
!ELEMDESC categoriesFor: #paramdesc!**compiled accessors**!public! !

!ELEMDESC class methodsFor!

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
!ELEMDESC class categoriesFor: #defineFields!public!template definition! !
!ELEMDESC class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

