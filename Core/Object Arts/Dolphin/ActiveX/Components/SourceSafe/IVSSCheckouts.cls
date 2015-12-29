"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVSSCheckouts
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSCheckouts guid: (IID fromString: '{8903A770-F55F-11CF-9227-00AA00A1EB95}')!
IVSSCheckouts comment: '<IVSSCheckouts> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSCheckouts'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe checkouts collection interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSCheckouts categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSCheckouts methodsFor!

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

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall
!

count
	"Answer the <sdword> value of the 'Count' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self
		get_Count: answer.
	^answer asObject
!

get_Count: piCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval] long* piCount);
	"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Item: sItem ppICheckout: ppICheckout
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in] VARIANT sItem,
			[out, retval] IVSSCheckout** ppICheckout);
	"

	<virtual stdcall: hresult 9 VARIANT IVSSCheckout**>
	^self invalidCall
!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: sItem 
	"Answer the <IVSSCheckout> value of the 'Item' property of the receiver."

	| answer |
	answer := IVSSCheckout newPointer.
	self
		get_Item: sItem asVariant
		ppICheckout: answer.
	^answer asObject
! !
!IVSSCheckouts categoriesFor: #_newEnum!**auto generated**!methods!public! !
!IVSSCheckouts categoriesFor: #_NewEnum:!**auto generated**!COM Interfaces-IVSSCheckouts!private! !
!IVSSCheckouts categoriesFor: #count!**auto generated**!properties!public! !
!IVSSCheckouts categoriesFor: #get_Count:!COM Interfaces-IVSSCheckouts!private! !
!IVSSCheckouts categoriesFor: #get_Item:ppICheckout:!COM Interfaces-IVSSCheckouts!private! !
!IVSSCheckouts categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVSSCheckouts categoriesFor: #item:!**auto generated**!properties!public! !

