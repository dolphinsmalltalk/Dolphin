"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IMXReaderControl'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IMXReaderControl guid: (OS.COM.IID fromString: '{808f4e35-8d5a-4fbe-8466-33a41279ed30}')!
MSXML.IMXReaderControl comment: '`IMXReaderControl` is a wrapper class for the COM interface ''MSXML2.IMXReaderControl'' generated from type information in the ''Microsoft XML, v6.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXReaderControl interface"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(808f4e35-8d5a-4fbe-8466-33a41279ed30), 
	helpstring("IMXReaderControl interface"), 
	nonextensible, 
	dual
]
interface IMXReaderControl : IDispatch
 {
	[id(0x00000576), helpstring("Abort the reader")]
	HRESULT __stdcall abort();
	[id(0x00000577), helpstring("Resume the reader")]
	HRESULT __stdcall resume();
	[id(0x00000578), helpstring("Suspend the reader")]
	HRESULT __stdcall suspend();
};
```
'!
!MSXML.IMXReaderControl categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IMXReaderControl methodsFor!

Abort
	"Invoke the abort() method of the COM object.
	Helpstring: Abort the reader

		HRESULT __stdcall abort();"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

Resume
	"Invoke the resume() method of the COM object.
	Helpstring: Resume the reader

		HRESULT __stdcall resume();"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

Suspend
	"Invoke the suspend() method of the COM object.
	Helpstring: Suspend the reader

		HRESULT __stdcall suspend();"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode! !
!MSXML.IMXReaderControl categoriesFor: #Abort!**auto generated**!COM Interfaces-IMXReaderControl!public! !
!MSXML.IMXReaderControl categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IMXReaderControl categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IMXReaderControl categoriesFor: #Resume!**auto generated**!COM Interfaces-IMXReaderControl!public! !
!MSXML.IMXReaderControl categoriesFor: #Suspend!**auto generated**!COM Interfaces-IMXReaderControl!public! !

!MSXML.IMXReaderControl class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXReaderControl'
		IMXReaderControl defineTemplate"

	self
		defineFunction: #Abort;
		defineFunction: #Resume;
		defineFunction: #Suspend
! !
!MSXML.IMXReaderControl class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

