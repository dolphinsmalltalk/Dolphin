"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'MSXML.ISAXLocator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.ISAXLocator guid: (OS.COM.IID fromString: '{9b7e472a-0de4-4640-bff3-84d38a051c31}')!

MSXML.ISAXLocator comment: '<ISAXLocator> is a wrapper class for the COM interface ''MSXML2.ISAXLocator'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

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

!MSXML.ISAXLocator categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.ISAXLocator methodsFor!

getColumnNumber
	"Answer the <sdword> result of invoking the getColumnNumber() method of the COM object."

	| answer |
	answer := Int32 new.
	self GetColumnNumber: answer.
	^answer asObject!

GetColumnNumber: pnColumn
	"Private - Invoke the getColumnNumber() method of the COM object.

		HRESULT __stdcall getColumnNumber(
			[out, retval]int* pnColumn);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

getLineNumber
	"Answer the <sdword> result of invoking the getLineNumber() method of the COM object."

	| answer |
	answer := Int32 new.
	self GetLineNumber: answer.
	^answer asObject!

GetLineNumber: pnLine
	"Private - Invoke the getLineNumber() method of the COM object.

		HRESULT __stdcall getLineNumber(
			[out, retval]int* pnLine);"

	<virtual stdcall: hresult 5 int32*>
	^self invalidCall: _failureCode!

getPublicId
	"Answer the <word> result of invoking the getPublicId() method of the COM object."

	| answer |
	answer := UInt16 newBufferClass: TaskMemory.
	self GetPublicId: answer.
	^answer asObject!

GetPublicId: ppwchPublicId
	"Private - Invoke the getPublicId() method of the COM object.

		HRESULT __stdcall getPublicId(
			[out, retval]unsigned short** ppwchPublicId);"

	<virtual stdcall: hresult 6 uint16**>
	^self invalidCall: _failureCode!

getSystemId
	"Answer the <word> result of invoking the getSystemId() method of the COM object."

	| answer |
	answer := UInt16 newBufferClass: TaskMemory.
	self GetSystemId: answer.
	^answer asObject!

GetSystemId: ppwchSystemId
	"Private - Invoke the getSystemId() method of the COM object.

		HRESULT __stdcall getSystemId(
			[out, retval]unsigned short** ppwchSystemId);"

	<virtual stdcall: hresult 7 uint16**>
	^self invalidCall: _failureCode! !

!MSXML.ISAXLocator categoriesForMethods!
getColumnNumber!**auto generated**!methods!public! !
GetColumnNumber:!**auto generated**!COM Interfaces-ISAXLocator!private! !
getLineNumber!**auto generated**!methods!public! !
GetLineNumber:!**auto generated**!COM Interfaces-ISAXLocator!private! !
getPublicId!**auto generated**!methods!public! !
GetPublicId:!**auto generated**!COM Interfaces-ISAXLocator!private! !
getSystemId!**auto generated**!methods!public! !
GetSystemId:!**auto generated**!COM Interfaces-ISAXLocator!private! !
!

!MSXML.ISAXLocator class methodsFor!

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

!MSXML.ISAXLocator class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

