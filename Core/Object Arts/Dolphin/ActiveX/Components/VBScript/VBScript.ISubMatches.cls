"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'VBScript.ISubMatches'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
VBScript.ISubMatches guid: (OS.COM.IID fromString: '{3f4dacb3-160d-11d2-a8e9-00104b365c9f}')!
VBScript.ISubMatches comment: '`ISubMatches` is a wrapper class for the COM interface ''VBScript_RegExp_55.ISubMatches'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4dacb3-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
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
```
'!
!VBScript.ISubMatches categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!VBScript.ISubMatches methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject!

asArray
	| variant answer count |
	variant := VARIANT new.
	count := self count.
	answer := Array new: count.
	1 to: count do: [:i |
			self get_Item: i - 1 pSubMatch: variant.
			answer at: i put: variant value.
			variant basicFree].
	^answer!

count
	"Answer the <sdword> value of the 'Count' property of the receiver."

	| answer |
	answer := ByteArray newFixed: 4.
	self get_Count: answer.
	^answer int32AtOffset: 0!

get__NewEnum: ppEnum
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** ppEnum);"

	<virtual stdcall: hresult 10 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: pCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* pCount);"

	<virtual stdcall: hresult 9 int32*>
	^self invalidCall: _failureCode!

get_Item: index pSubMatch: pSubMatch
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]long index,
			[out, retval]VARIANT* pSubMatch);"

	<virtual stdcall: hresult 8 int32 variant*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <String> value of the indexed sub-match."

	| answer variant |
	variant := VARIANT new.
	self get_Item: index pSubMatch: variant.
	answer := variant value.
	variant free.
	^answer! !
!VBScript.ISubMatches categoriesForMethods!
_newEnum!**auto generated**!properties!public! !
asArray!converting!public! !
count!properties!public! !
get__NewEnum:!**auto generated**!COM Interfaces-ISubMatches!private! !
get_Count:!**auto generated**!COM Interfaces-ISubMatches!private! !
get_Item:pSubMatch:!**auto generated**!COM Interfaces-ISubMatches!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
item:!properties!public! !
!

!VBScript.ISubMatches class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SubMatches) for which the receiver is the default interface."

	^CLSID fromString: '{3f4dacc0-160d-11d2-a8e9-00104b365c9f}'
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
!VBScript.ISubMatches class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!public! !
!

