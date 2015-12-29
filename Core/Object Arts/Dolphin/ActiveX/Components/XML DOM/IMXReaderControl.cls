"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IMXReaderControl
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IMXReaderControl guid: (IID fromString: '{808F4E35-8D5A-4FBE-8466-33A41279ED30}')!
IMXReaderControl comment: '<IMXReaderControl> is a wrapper class for the COM interface ''MSXML2.IMXReaderControl'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXReaderControl interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(808F4E35-8D5A-4FBE-8466-33A41279ED30), 
	helpstring("IMXReaderControl interface"), 
	dual, 
	nonextensible
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
'!
!IMXReaderControl categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IMXReaderControl methodsFor!

Abort
	"Invoke the abort() method of the COM object.
	Helpstring: Abort the reader

		HRESULT __stdcall abort();"

	<virtual stdcall: hresult 8>
	^self invalidCall!

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
	^self invalidCall!

Suspend
	"Invoke the suspend() method of the COM object.
	Helpstring: Suspend the reader

		HRESULT __stdcall suspend();"

	<virtual stdcall: hresult 10>
	^self invalidCall! !
!IMXReaderControl categoriesFor: #Abort!**auto generated**!COM Interfaces-IMXReaderControl!public! !
!IMXReaderControl categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IMXReaderControl categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IMXReaderControl categoriesFor: #Resume!**auto generated**!COM Interfaces-IMXReaderControl!public! !
!IMXReaderControl categoriesFor: #Suspend!**auto generated**!COM Interfaces-IMXReaderControl!public! !

!IMXReaderControl class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXReaderControl'
		IMXReaderControl defineTemplate"

	self
		defineFunction: #Abort;
		defineFunction: #Resume;
		defineFunction: #Suspend
! !
!IMXReaderControl class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

