"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVSSItems
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSItems guid: (IID fromString: '{783CD4E5-9D54-11CF-B8EE-00608CC9A71F}')!
IVSSItems comment: '<IVSSItems> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSItems'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe items collection interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSItems categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSItems methodsFor!

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

get_Item: sItem ppIItem: ppIItem
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in] VARIANT sItem,
			[out, retval] IVSSItem** ppIItem);
	"

	<virtual stdcall: hresult 9 VARIANT IVSSItem**>
	^self invalidCall
!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: sItem 
	"Answer the <IVSSItem> value of the 'Item' property of the receiver."

	| answer |
	answer := IVSSItem newPointer.
	self
		get_Item: sItem asVariant
		ppIItem: answer.
	^answer asObject
! !
!IVSSItems categoriesFor: #_newEnum!**auto generated**!methods!public! !
!IVSSItems categoriesFor: #_NewEnum:!**auto generated**!COM Interfaces-IVSSItems!private! !
!IVSSItems categoriesFor: #count!**auto generated**!properties!public! !
!IVSSItems categoriesFor: #get_Count:!COM Interfaces-IVSSItems!private! !
!IVSSItems categoriesFor: #get_Item:ppIItem:!COM Interfaces-IVSSItems!private! !
!IVSSItems categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVSSItems categoriesFor: #item:!**auto generated**!properties!public! !

