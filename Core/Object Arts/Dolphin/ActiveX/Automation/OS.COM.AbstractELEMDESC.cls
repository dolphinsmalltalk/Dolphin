"Filed out from Dolphin Smalltalk 7"!

OS.COM.OLEStructure subclass: #'OS.COM.AbstractELEMDESC'
	instanceVariableNames: 'owner tdesc'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_tdescElem' -> 16r0
	}!
OS.COM.AbstractELEMDESC guid: (Core.GUID fromString: '{24cbeadb-8708-4bb1-a28d-207ebd2a8c8e}')!
OS.COM.AbstractELEMDESC isNonInstantiable: true!
OS.COM.AbstractELEMDESC comment: ''!
!OS.COM.AbstractELEMDESC categoriesForClass!External-Data-Structured-COM! !
!OS.COM.AbstractELEMDESC methodsFor!

analyzer
	"Private - Answer the <AXTypeInfoAnalyzer> from which the receiver originated."

	^owner analyzer!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self tdesc classDesc!

indirections
	"Answer the number of levels by which this element is indirect, e.g. if a reference parameter
	then this will usually be 1, if a value  parameter then 0."

	^self classDesc value!

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
	"Private - Answer the <TYPEDESC> value of the receiver's 'tdescElem' field."

	^TYPEDESC fromAddress: bytes yourAddress!

typeName
	"Answer the Dolphin external type name for the type described by the receiver."

	^self tdesc typeName! !
!OS.COM.AbstractELEMDESC categoriesFor: #analyzer!accessing!private! !
!OS.COM.AbstractELEMDESC categoriesFor: #classDesc!accessing!private! !
!OS.COM.AbstractELEMDESC categoriesFor: #indirections!accessing!public! !
!OS.COM.AbstractELEMDESC categoriesFor: #isVariant!private!testing! !
!OS.COM.AbstractELEMDESC categoriesFor: #objectClass!accessing!public! !
!OS.COM.AbstractELEMDESC categoriesFor: #owner!accessing!private! !
!OS.COM.AbstractELEMDESC categoriesFor: #owner:!accessing!private! !
!OS.COM.AbstractELEMDESC categoriesFor: #tdesc!accessing!public! !
!OS.COM.AbstractELEMDESC categoriesFor: #tdescElem!**compiled accessors**!private! !
!OS.COM.AbstractELEMDESC categoriesFor: #typeName!accessing!public! !

!OS.COM.AbstractELEMDESC class methodsFor!

defineFields
	"Define the shared fields of the ELEMDESC and ARRAYDESC structures.
		self compileDefinition.
	"

	self defineField: #tdescElem type: (StructureField type: TYPEDESC) beReadOnly beNonBrowsable! !
!OS.COM.AbstractELEMDESC class categoriesFor: #defineFields!public!template definition! !

