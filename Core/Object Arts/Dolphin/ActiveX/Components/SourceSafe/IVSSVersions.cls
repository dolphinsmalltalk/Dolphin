"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVSSVersions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSVersions guid: (IID fromString: '{783CD4E7-9D54-11CF-B8EE-00608CC9A71F}')!
IVSSVersions comment: '<IVSSVersions> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSVersions'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe versions collection"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSVersions categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSVersions methodsFor!

_newEnum
	"Answer the <IUnknown> result of invoking the COM Object's _NewEnum() method."

	| answer |
	answer := IUnknown newPointer.
	self
		_NewEnum: answer.
	^answer asObject
!

_NewEnum: ppIEnum
	"Private - Invoke the _NewEnum() method of the COM object wrapped by the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval] IUnknown** ppIEnum);
	"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall
!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true! !
!IVSSVersions categoriesFor: #_newEnum!**auto generated**!methods!public! !
!IVSSVersions categoriesFor: #_NewEnum:!**auto generated**!COM Interfaces-IVSSVersions!private! !
!IVSSVersions categoriesFor: #isVBCollection!**auto generated**!public!testing! !

