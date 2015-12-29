"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #ELEMDESC
	instanceVariableNames: 'owner param tdesc'
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
ELEMDESC guid: (GUID fromString: '{C06F3B77-0868-11D3-93AF-00A024CA708A}')!
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

analyzer
	"Private - Answer the <AXTypeInfoAnalyzer> from which the receiver originated."

	^owner analyzer!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self tdesc classDesc!

defaultValue
	"Answer a <VARIANT> which is the default value for the parameter described
	by the receiver, or nil if it doesn't have a default value."

	^self param defaultValue!

hasDefaultValue
	^self param hasDefaultValue!

indirections
	"Answer the number of levels by which this element is indirect, e.g. if a reference parameter
	then this will usually be 1, if a value  parameter then 0."

	^self classDesc value!

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

isVariant
	"Private - Answer whether the receiver is describing an element of VARIANT type."

	^self tdesc vartype == VT_VARIANT!

objectClass
	"Answer the class of Smalltalk object used to wrap the type of this element."

	^self classDesc key!

owner
	"Private - Answer the value of the receiver's ''owner'' instance variable."

	^owner!

owner: struct
	"Private - Set the value of the receiver's 'owner' instance variable to the <AXTypeInfoStructure> 
	argument, struct. Answer the receiver."

	owner := struct!

param
	"Answer a <PARAMDESC> describing the parameter associated with the receiver."

	param isNil ifTrue: [param := self paramdesc].
	^param!

paramdesc
	"Answer the receiver's paramdesc field as a Smalltalk object."

	^PARAMDESC fromAddress: bytes yourAddress + ##(self offsetOf: #paramdesc)!

tdesc
	"Answer a <TYPEDESC> which is the type of the elmement described by the receiver.
	Implementation Note: Set the back-pointer to be the same as the receiver's, since it
	is the destruction of the <AXTypeInfoStructure> which we wish to postpone for the
	lifetime of the TYPEDESC."

	tdesc isNil 
		ifTrue: 
			[tdesc := (self tdescElem)
						owner: owner;
						yourself].
	^tdesc!

tdescElem
	"Answer the receiver's tdescElem field as a Smalltalk object."

	^TYPEDESC fromAddress: bytes yourAddress!

typeName
	"Answer the Dolphin external type name for the type described by the receiver."

	^self tdesc typeName! !
!ELEMDESC categoriesFor: #analyzer!accessing!private! !
!ELEMDESC categoriesFor: #classDesc!accessing!private! !
!ELEMDESC categoriesFor: #defaultValue!accessing!public! !
!ELEMDESC categoriesFor: #hasDefaultValue!development!helpers!private! !
!ELEMDESC categoriesFor: #indirections!accessing!public! !
!ELEMDESC categoriesFor: #isIn!public!testing! !
!ELEMDESC categoriesFor: #isOptional!public!testing! !
!ELEMDESC categoriesFor: #isOut!public!testing! !
!ELEMDESC categoriesFor: #isRetVal!public!testing! !
!ELEMDESC categoriesFor: #isVariant!private!testing! !
!ELEMDESC categoriesFor: #objectClass!accessing!public! !
!ELEMDESC categoriesFor: #owner!accessing!private! !
!ELEMDESC categoriesFor: #owner:!accessing!private! !
!ELEMDESC categoriesFor: #param!accessing!public! !
!ELEMDESC categoriesFor: #paramdesc!**compiled accessors**!public! !
!ELEMDESC categoriesFor: #tdesc!accessing!public! !
!ELEMDESC categoriesFor: #tdescElem!**compiled accessors**!public! !
!ELEMDESC categoriesFor: #typeName!accessing!public! !

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

	self
		defineField: #tdescElem	type: (StructureField type: TYPEDESC) beReadOnly;
		defineField: #paramdesc	type: (StructureField type: PARAMDESC) beReadOnly! !
!ELEMDESC class categoriesFor: #defineFields!initializing!public! !

