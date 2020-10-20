"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'ADODB._Collection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._Collection guid: (OS.COM.IID fromString: '{00000512-0000-0010-8000-00aa006d2ea4}')!
ADODB._Collection comment: '`_Collection` is a wrapper class for the COM interface ''ADODB._Collection'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000512-0000-0010-8000-00aa006d2ea4), 
	nonextensible, 
	dual
]
interface _Collection : IDispatch
 {
	[id(0x00000001), propget, helpcontext(0x0012c91a)]
	HRESULT __stdcall Count(
		[out, retval]long* c);
	[id(0xfffffffc), restricted]
	HRESULT __stdcall _NewEnum(
		[out, retval]IUnknown** ppvObject);
	[id(0x00000002), helpcontext(0x0012c8da)]
	HRESULT __stdcall Refresh();
};
```
'!
!ADODB._Collection categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._Collection methodsFor!

_newEnum
	"Answer the <IUnknown> result of invoking the _NewEnum() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self _NewEnum: answer.
	^answer asObject!

_NewEnum: ppvObject
	"Private - Invoke the _NewEnum() method of the COM object.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** ppvObject);"

	<virtual stdcall: hresult 9 IUnknown**>
	^self invalidCall: _failureCode!

count
	"Answer the <sdword> value of the 'Count' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Count: answer.
	^answer asObject!

get_Count: c
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* c);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

Refresh
	"Invoke the Refresh() method of the COM object.

		HRESULT __stdcall Refresh();"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode!

removeAtIndex: index
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise a <BoundsError> if there is no element with that index."

	^self shouldNotImplement! !
!ADODB._Collection categoriesFor: #_newEnum!**auto generated**!methods!public! !
!ADODB._Collection categoriesFor: #_NewEnum:!**auto generated**!COM Interfaces-_Collection!private! !
!ADODB._Collection categoriesFor: #count!**auto generated**!properties!public! !
!ADODB._Collection categoriesFor: #get_Count:!**auto generated**!COM Interfaces-_Collection!private! !
!ADODB._Collection categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB._Collection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB._Collection categoriesFor: #Refresh!**auto generated**!COM Interfaces-_Collection!public! !
!ADODB._Collection categoriesFor: #removeAtIndex:!public!removing! !

!ADODB._Collection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Collection'
		_Collection defineTemplate"

	self
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #_NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #Refresh
! !
!ADODB._Collection class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

