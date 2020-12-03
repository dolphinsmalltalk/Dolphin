"Filed out from Dolphin Smalltalk 7"!

External.SCALAR subclass: #'External.LPVOID'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPVOID guid: (Core.GUID fromString: '{87b4c596-026e-11d3-9fd7-00a0cc3e4a32}')!
External.LPVOID comment: 'LPVOID is an <ExternalStructure> class useful for representing pointers to arbitrary external memory blocks. In most respects LPVOID behaves like <ExternalAddress>, except that instances may be allocated using #newBuffer which can be passed to #lpvoid arguments without the VM implicitly dereferencing the address (i.e. the behaviour will be the same as if an ExternalAddress had been passed to an lppvoid parameter). LPVOID is also a pointer object, and can thus add instance variables to hold additional state.

LPVOID is useful, for example, where references to pointers (i.e. VOID**) are required, an example being COM [out] pointer parameters. The VM also passes instances of LPVOID as lpvoid input parameters to callbacks and COM method implementations.

It is important to realise that LPVOID (and subclasses) are unlike other ExternalStructures in that they are already pointers, and therefore they already incorporate one level of indirection. Thus:
1) #value answers the pointed at address in the case of doubly-indirect (reference) instances, or the address itself for internal buffer instances.
2) The class method #fromAddress: will answer a pointer to a pointer, i.e. a double-indirection. This means that, for example, the subclass LPWSTR is useful as an element class for a <StructureArray> of LPWSTR pointers (as expected), but that ''LPWSTR fromAdddress: aUnicodeString yourAddress'' is not valid.'!
!External.LPVOID categoriesForClass!External-Data-Unstructured! !
!External.LPVOID methodsFor!

asExternalAddress
	"Answer the address contained in or referenced by the receiver."

	^self value!

value
	"Answer the <ExternalAddress> value of the receiver's 'value' field."

	^(bytes uintPtrAtOffset: _OffsetOf_value) asExternalAddress!

value: anExternalAddress
	"Set the receiver's 'value' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_value put: anExternalAddress! !
!External.LPVOID categoriesFor: #asExternalAddress!converting!public! !
!External.LPVOID categoriesFor: #value!**compiled accessors**!public! !
!External.LPVOID categoriesFor: #value:!**compiled accessors**!public! !

!External.LPVOID class methodsFor!

defineFields
	"Define the fields of the LPVOID 'structure'.
		LPVOID compileDefinition
	"

	self defineField: #value type: LPVOIDField new beOverride!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

new
	"Answer a new instance of the receiver.
	Implementation Note: LPVOID and its subclasses represent pointers, and are typically
	used for double indirections, thus a reference is normally required."

	^self newPointer!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!External.LPVOID class categoriesFor: #defineFields!public!template definition! !
!External.LPVOID class categoriesFor: #initialize!development!initializing!private! !
!External.LPVOID class categoriesFor: #new!instance creation!public! !
!External.LPVOID class categoriesFor: #uninitialize!class hierarchy-removing!private! !

