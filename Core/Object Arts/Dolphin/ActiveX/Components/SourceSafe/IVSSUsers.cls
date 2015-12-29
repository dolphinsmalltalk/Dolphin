"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IVSSUsers
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSUsers guid: (IID fromString: '{2A0DE0E4-2E9F-11D0-9236-00AA00A1EB95}')!
IVSSUsers comment: '<IVSSUsers> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSUsers'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe users collection interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSUsers categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSUsers methodsFor!

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

get_Item: sItem ppIUser: ppIUser
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in] VARIANT sItem,
			[out, retval] IVSSUser** ppIUser);
	"

	<virtual stdcall: hresult 9 VARIANT IVSSUser**>
	^self invalidCall
!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: sItem 
	"Answer the <IVSSUser> value of the 'Item' property of the receiver."

	| answer |
	answer := IVSSUser newPointer.
	self
		get_Item: sItem asVariant
		ppIUser: answer.
	^answer asObject
! !
!IVSSUsers categoriesFor: #_newEnum!**auto generated**!methods!public! !
!IVSSUsers categoriesFor: #_NewEnum:!**auto generated**!COM Interfaces-IVSSUsers!private! !
!IVSSUsers categoriesFor: #count!**auto generated**!properties!public! !
!IVSSUsers categoriesFor: #get_Count:!COM Interfaces-IVSSUsers!private! !
!IVSSUsers categoriesFor: #get_Item:ppIUser:!COM Interfaces-IVSSUsers!private! !
!IVSSUsers categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVSSUsers categoriesFor: #item:!**auto generated**!properties!public! !

