"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISubMatches
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ISubMatches guid: (IID fromString: '{3F4DACB3-160D-11D2-A8E9-00104B365C9F}')!
ISubMatches comment: '<ISubMatches> is a wrapper class for the COM interface ''VBScript_RegExp_55.ISubMatches'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3F4DACB3-160D-11D2-A8E9-00104B365C9F), 
	hidden, 
	dual, 
	nonextensible
]
interface ISubMatches : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall Item(
		[in]long index,
		[out, retval]VARIANT* pSubMatch);
	[id(0x00000001), propget]
	HRESULT __stdcall Count(
		[out, retval]long* pCount);
	[id(0xfffffffc), propget]
	HRESULT __stdcall _NewEnum(
		[out, retval]IUnknown** ppEnum);
};
'!
!ISubMatches categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!ISubMatches methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject
!

asArray
	^(0 to: self count - 1) collect: [:each | self item: each]!

count
	"Answer the <sdword> value of the 'Count' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Count: answer.
	^answer asObject
!

get__NewEnum: ppEnum
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** ppEnum);"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall!

get_Count: pCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* pCount);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall!

get_Item: index pSubMatch: pSubMatch
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]long index,
			[out, retval]VARIANT* pSubMatch);"

	<virtual stdcall: hresult 8 sdword variant*>
	^self invalidCall!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <variant> value of the 'Item' property of the receiver."

	| answer |
	answer := VARIANT new.
	self
		get_Item: index
		pSubMatch: answer.
	^answer asObject
! !
!ISubMatches categoriesFor: #_newEnum!**auto generated**!properties!public! !
!ISubMatches categoriesFor: #asArray!converting!public! !
!ISubMatches categoriesFor: #count!**auto generated**!properties!public! !
!ISubMatches categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-ISubMatches!private! !
!ISubMatches categoriesFor: #get_Count:!**auto generated**!COM Interfaces-ISubMatches!private! !
!ISubMatches categoriesFor: #get_Item:pSubMatch:!**auto generated**!COM Interfaces-ISubMatches!private! !
!ISubMatches categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ISubMatches categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ISubMatches categoriesFor: #item:!**auto generated**!properties!public! !

!ISubMatches class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SubMatches) for which the receiver is the default interface."

	^CLSID fromString: '{3F4DACC0-160D-11D2-A8E9-00104B365C9F}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.ISubMatches'
		ISubMatches defineTemplate"

	self
		defineFunction: #get_Item:pSubMatch:
			argumentTypes: 'sdword variant*';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
! !
!ISubMatches class categoriesFor: #clsid!**auto generated**!constants!private! !
!ISubMatches class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

