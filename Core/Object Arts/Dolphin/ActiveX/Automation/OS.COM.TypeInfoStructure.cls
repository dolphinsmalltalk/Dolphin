"Filed out from Dolphin Smalltalk 7"!

OS.COM.FinalizableStructure subclass: #'OS.COM.TypeInfoStructure'
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TypeInfoStructure guid: (Core.GUID fromString: '{c06f3b66-0868-11d3-93af-00a024ca708a}')!
OS.COM.TypeInfoStructure isNonInstantiable: true!
OS.COM.TypeInfoStructure comment: 'AXTypeInfoStructure is the class of <ExternalStructure>s representing the OLE Automation structures used in conjunction with <ITypeInfo>. AXTypeInfoStructure itself is abstract.

Note that all subinstances of the receiver are allocated by an ITypeInfo and must be released by that same ITypeInfo. We achieve this by a backpointer to the allocating ITypeInfo/AXTypeInfoAnalyzer, and by marking the subinstance as finalizable. This does mean that holding onto one of these structures will cause the originating ITypeInfo to persist as well.

Instance variables:
	piTypeInfo	<ITypeInfo> which allocated the struct and which must free it.
	analyzer		<AXTypeInfoAnalyzer> which wraps piTypeInfo, and can analyze the receiver (may be nil)
'!
!OS.COM.TypeInfoStructure categoriesForClass!External-Data-Structured-COM! !
!OS.COM.TypeInfoStructure methodsFor!

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
!OS.COM.TypeInfoStructure categoriesFor: #analyzer!accessing!private! !
!OS.COM.TypeInfoStructure categoriesFor: #analyzer:!accessing!private! !
!OS.COM.TypeInfoStructure categoriesFor: #free!public!realizing/unrealizing! !
!OS.COM.TypeInfoStructure categoriesFor: #fullName!accessing!public! !
!OS.COM.TypeInfoStructure categoriesFor: #initializePointer!initializing!private! !
!OS.COM.TypeInfoStructure categoriesFor: #name!accessing!public! !
!OS.COM.TypeInfoStructure categoriesFor: #needsFree!private!realizing/unrealizing! !
!OS.COM.TypeInfoStructure categoriesFor: #tdesc!accessing!private! !
!OS.COM.TypeInfoStructure categoriesFor: #typeName!accessing!public! !
!OS.COM.TypeInfoStructure categoriesFor: #vtName!accessing!private! !

!OS.COM.TypeInfoStructure class methodsFor!

clear: addressOrBytes
	"We can't free an arbitrary type info structure given its address, because we need to pass it
	back to its originating <ITypeInfo>, therefore these structures can't be stored in
	as values in a <StructureArray>."

	^self shouldNotImplement! !
!OS.COM.TypeInfoStructure class categoriesFor: #clear:!public!realizing/unrealizing! !

