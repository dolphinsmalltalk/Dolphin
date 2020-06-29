"Filed out from Dolphin Smalltalk 7"!

OLEFinalizableStructure subclass: #AXTypeInfoStructure
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
AXTypeInfoStructure guid: (GUID fromString: '{c06f3b66-0868-11d3-93af-00a024ca708a}')!
AXTypeInfoStructure isAbstract: true!
AXTypeInfoStructure comment: 'AXTypeInfoStructure is the class of <ExternalStructure>s representing the OLE Automation structures used in conjunction with <ITypeInfo>. AXTypeInfoStructure itself is abstract.

Note that all subinstances of the receiver are allocated by an ITypeInfo and must be released by that same ITypeInfo. We achieve this by a backpointer to the allocating ITypeInfo/AXTypeInfoAnalyzer, and by marking the subinstance as finalizable. This does mean that holding onto one of these structures will cause the originating ITypeInfo to persist as well.

Instance variables:
	piTypeInfo	<ITypeInfo> which allocated the struct and which must free it.
	analyzer		<AXTypeInfoAnalyzer> which wraps piTypeInfo, and can analyze the receiver (may be nil)
'!
!AXTypeInfoStructure categoriesForClass!External-Data-Structured-COM! !
!AXTypeInfoStructure methodsFor!

analyzer
	"Private - Answer the value of the receiver's ''analyzer'' instance variable."

	^analyzer!

analyzer: anObject
	"Private - Set the value of the receiver's ''analyzer'' instance variable to the argument, anObject."

	analyzer := anObject!

free
	"Free external resources owned by the receiver.
	N.B. Explicitly freeing an AXTypeInfoStructure may invalidate any of its
	sub-structures, so we clear down the analyzer and typeinfo pointers.
	Implementation Note: Generally speaking we only need to free
	externally owned (i.e. non-null pointer) instances of the receiver."

	super free.
	analyzer := nil!

fullName
	"Answer a fully qualified name for the receiver, useful in debug output etc"

	^self analyzer name, '.', self name!

initializePointer
	"Private - Initialize the receiver (common to internal [value] and
	external [reference] buffers."

	self initialize!

name
	"Answer the name of the variable described by the receiver."

	^self subclassResponsibility!

needsFree
	"Private - Answer whether the receiver requires freeing of any external resources..
	Implementation Note: In this case we tend to have references to externally allocated
	buffers, and these must be free'd by passing them back to the allocating interface."

	^self notNull and: [analyzer notNil]!

tdesc
	"Private - Answer a TYPEDESC for the object described by the receiver."

	^self subclassResponsibility!

typeName
	"Answer a Dolphin external type name for the receiver's type."

	^self tdesc typeName!

vtName
	"Private - Answer the Dolphin external type name for the receiver's variant type."

	^self tdesc vtName! !
!AXTypeInfoStructure categoriesFor: #analyzer!accessing!private! !
!AXTypeInfoStructure categoriesFor: #analyzer:!accessing!private! !
!AXTypeInfoStructure categoriesFor: #free!public!realizing/unrealizing! !
!AXTypeInfoStructure categoriesFor: #fullName!accessing!public! !
!AXTypeInfoStructure categoriesFor: #initializePointer!initializing!private! !
!AXTypeInfoStructure categoriesFor: #name!accessing!public! !
!AXTypeInfoStructure categoriesFor: #needsFree!private!realizing/unrealizing! !
!AXTypeInfoStructure categoriesFor: #tdesc!accessing!private! !
!AXTypeInfoStructure categoriesFor: #typeName!accessing!public! !
!AXTypeInfoStructure categoriesFor: #vtName!accessing!private! !

!AXTypeInfoStructure class methodsFor!

clear: addressOrBytes
	"We can't free an arbitrary type info structure given its address, because we need to pass it
	back to its originating <ITypeInfo>, therefore these structures can't be stored in
	as values in a <StructureArray>."

	^self shouldNotImplement! !
!AXTypeInfoStructure class categoriesFor: #clear:!public!realizing/unrealizing! !

