"Filed out from Dolphin Smalltalk"!

IUnknown subclass: #ISAXLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
ISAXLocator guid: (IID fromString: '{9b7e472a-0de4-4640-bff3-84d38a051c31}')!
ISAXLocator comment: '<ISAXLocator> is a wrapper class for the COM interface ''MSXML2.ISAXLocator'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXLocator interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(9B7E472A-0DE4-4640-BFF3-84D38A051C31), 
	helpstring("ISAXLocator interface"), 
	hidden
]
interface ISAXLocator : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall getColumnNumber(
		[out, retval]int* pnColumn);
	[id(0x60010001)]
	HRESULT __stdcall getLineNumber(
		[out, retval]int* pnLine);
	[id(0x60010002)]
	HRESULT __stdcall getPublicId(
		[out, retval]unsigned short** ppwchPublicId);
	[id(0x60010003)]
	HRESULT __stdcall getSystemId(
		[out, retval]unsigned short** ppwchSystemId);
};
'!
!ISAXLocator categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!ISAXLocator methodsFor!

getColumnNumber
	"Answer the <SDWORD> result of invoking the getColumnNumber() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetColumnNumber: answer.
	^answer asObject
!

GetColumnNumber: pnColumn
	"Private - Invoke the getColumnNumber() method of the COM object.

		HRESULT __stdcall getColumnNumber(
			[out, retval]int* pnColumn);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

getLineNumber
	"Answer the <SDWORD> result of invoking the getLineNumber() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetLineNumber: answer.
	^answer asObject
!

GetLineNumber: pnLine
	"Private - Invoke the getLineNumber() method of the COM object.

		HRESULT __stdcall getLineNumber(
			[out, retval]int* pnLine);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

getPublicId
	"Answer the <WORD> result of invoking the getPublicId() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self GetPublicId: answer.
	^answer asObject
!

GetPublicId: ppwchPublicId
	"Private - Invoke the getPublicId() method of the COM object.

		HRESULT __stdcall getPublicId(
			[out, retval]unsigned short** ppwchPublicId);"

	<virtual stdcall: hresult 6 word**>
	^self invalidCall: _failureCode!

getSystemId
	"Answer the <WORD> result of invoking the getSystemId() method of the COM object."

	| answer |
	answer := (WORD newBufferClass: COMTaskMemory).
	self GetSystemId: answer.
	^answer asObject
!

GetSystemId: ppwchSystemId
	"Private - Invoke the getSystemId() method of the COM object.

		HRESULT __stdcall getSystemId(
			[out, retval]unsigned short** ppwchSystemId);"

	<virtual stdcall: hresult 7 word**>
	^self invalidCall: _failureCode! !
!ISAXLocator categoriesForMethods!
getColumnNumber!**auto generated**!methods!public! !
GetColumnNumber:!**auto generated**!COM Interfaces-ISAXLocator!private! !
getLineNumber!**auto generated**!methods!public! !
GetLineNumber:!**auto generated**!COM Interfaces-ISAXLocator!private! !
getPublicId!**auto generated**!methods!public! !
GetPublicId:!**auto generated**!COM Interfaces-ISAXLocator!private! !
getSystemId!**auto generated**!methods!public! !
GetSystemId:!**auto generated**!COM Interfaces-ISAXLocator!private! !
!

!ISAXLocator class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXLocator'
		ISAXLocator defineTemplate"

	self
		defineFunction: #GetColumnNumber:
			argumentTypes: 'sdword*';
		defineFunction: #GetLineNumber:
			argumentTypes: 'sdword*';
		defineFunction: #GetPublicId:
			argumentTypes: 'word**';
		defineFunction: #GetSystemId:
			argumentTypes: 'word**'
! !
!ISAXLocator class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

