"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVSS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSS guid: (IID fromString: '{783CD4EB-9D54-11CF-B8EE-00608CC9A71F}')!
IVSS comment: '<IVSS> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSS'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe application interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSS categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSS methodsFor!

get_VSSDatabase: ppIVSSDatabase
	"Private - Get the value of the 'VSSDatabase' property of the receiver.

		HRESULT __stdcall VSSDatabase(
			[out, retval] IVSSDatabase** ppIVSSDatabase);
	"

	<virtual stdcall: hresult 8 IVSSDatabase**>
	^self invalidCall
!

vssDatabase
	"Answer the <IVSSDatabase> value of the 'VSSDatabase' property of the receiver."

	| answer |
	answer := IVSSDatabase newPointer.
	self
		get_VSSDatabase: answer.
	^answer asObject
! !
!IVSS categoriesFor: #get_VSSDatabase:!COM Interfaces-IVSS!private! !
!IVSS categoriesFor: #vssDatabase!**auto generated**!properties!public! !

