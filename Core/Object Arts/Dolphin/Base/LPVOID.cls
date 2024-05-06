"Filed out from Dolphin Smalltalk"!

ExternalScalar subclass: #LPVOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LPVOID guid: (GUID fromString: '{87b4c596-026e-11d3-9fd7-00a0cc3e4a32}')!

LPVOID comment: 'LPVOID is an <ExternalStructure> class useful for representing pointers to arbitrary external memory blocks. In most respects LPVOID behaves like <ExternalAddress>, except that instances may be allocated using #newBuffer which can be passed to #lpvoid arguments without the VM implicitly dereferencing the address (i.e. the behaviour will be the same as if an ExternalAddress had been passed to an lppvoid parameter). LPVOID is also a pointer object, and can thus add instance variables to hold additional state.

LPVOID is useful, for example, where references to pointers (i.e. VOID**) are required, an example being COM [out] pointer parameters. The VM also passes instances of LPVOID as lpvoid input parameters to callbacks and COM method implementations.

It is important to realise that LPVOID (and subclasses) are unlike other ExternalStructures in that they are already pointers, and therefore they already incorporate one level of indirection. Thus:
1) #value answers the pointed at address in the case of doubly-indirect (reference) instances, or the address itself for internal buffer instances.
2) The class method #fromAddress: will answer a pointer to a pointer, i.e. a double-indirection. This means that, for example, the subclass LPWSTR is useful as an element class for a <StructureArray> of LPWSTR pointers (as expected), but that ''LPWSTR fromAdddress: aUnicodeString yourAddress'' is not valid.'!

!LPVOID categoriesForClass!External-Data-Unstructured! !

!LPVOID methodsFor!

asExternalAddress
	"Answer the address contained in or referenced by the receiver."

	^self value!

value
	"Answer the <ExternalAddress> value of the receiver's 'value' field."

	^(bytes uintPtrAtOffset: _OffsetOf_value) asExternalAddress!

value: anExternalAddress
	"Set the receiver's 'value' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_value put: anExternalAddress! !

!LPVOID categoriesForMethods!
asExternalAddress!converting!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!LPVOID class methodsFor!

defineFields
	"Define the fields of the LPVOID 'structure'.
		LPVOID compileDefinition
	"

	self defineField: #value type: LPVOIDField new beOverride!

new
	"Answer a new instance of the receiver.
	Implementation Note: LPVOID and its subclasses represent pointers, and are typically
	used for double indirections, thus a reference is normally required."

	^self newPointer! !

!LPVOID class categoriesForMethods!
defineFields!public!template definition! !
new!instance creation!public! !
!

