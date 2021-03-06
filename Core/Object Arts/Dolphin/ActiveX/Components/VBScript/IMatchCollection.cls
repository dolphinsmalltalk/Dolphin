﻿"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IMatchCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IMatchCollection guid: (IID fromString: '{3f4daca2-160d-11d2-a8e9-00104b365c9f}')!
IMatchCollection comment: '`IMatchCollection` is a wrapper class for the COM interface ''VBScript_RegExp_55.IMatchCollection'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4daca2-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
]
interface IMatchCollection : IDispatch
 {
	[id(0x00002711), propget]
	HRESULT __stdcall Item(
		[in]long index,
		[out, retval]IDispatch** ppMatch);
	[id(0x00000001), propget]
	HRESULT __stdcall Count(
		[out, retval]long* pCount);
	[id(0xfffffffc), propget]
	HRESULT __stdcall _NewEnum(
		[out, retval]IUnknown** ppEnum);
};
```
'!
!IMatchCollection categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!IMatchCollection methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject!

asArray
	^(0 to: self count - 1) collect: [:each | self item: each]!

count
	"Answer the <sdword> value of the 'Count' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Count: answer.
	^answer asObject!

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

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_Item: index ppMatch: ppMatch
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]long index,
			[out, retval]IDispatch** ppMatch);"

	<virtual stdcall: hresult 8 sdword IDispatch**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: anInteger 
	"Answer the <IMatch> at the specified zero-based <integer> index in the receiver."

	| answer |
	answer := self matchClass newPointer.
	self get_Item: anInteger ppMatch: answer.
	^answer!

matchClass
	^IMatch! !
!IMatchCollection categoriesFor: #_newEnum!**auto generated**!properties!public! !
!IMatchCollection categoriesFor: #asArray!converting!public! !
!IMatchCollection categoriesFor: #count!**auto generated**!properties!public! !
!IMatchCollection categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-IMatchCollection!private! !
!IMatchCollection categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IMatchCollection!private! !
!IMatchCollection categoriesFor: #get_Item:ppMatch:!**auto generated**!COM Interfaces-IMatchCollection!private! !
!IMatchCollection categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IMatchCollection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IMatchCollection categoriesFor: #item:!properties!public! !
!IMatchCollection categoriesFor: #matchClass!constants!private! !

!IMatchCollection class methodsFor!

clsid
	"Private - Answer the CLSID of the associated coclass, MatchCollection, which is
	noncreatable."

	^CLSID fromString: '{3f4daca6-160d-11d2-a8e9-00104b365c9f}'!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IMatchCollection'
		IMatchCollection defineTemplate"

	self
		defineFunction: #get_Item:ppMatch:
			argumentTypes: 'sdword IDispatch**';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**'
! !
!IMatchCollection class categoriesFor: #clsid!constants!private! !
!IMatchCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

