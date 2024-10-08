﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'MSXML.ISAXLexicalHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

MSXML.ISAXLexicalHandler guid: (OS.COM.IID fromString: '{7f85d5f5-47a8-4497-bda5-84ba04819ea6}')!

MSXML.ISAXLexicalHandler comment: '<ISAXLexicalHandler> is a wrapper class for the COM interface ''MSXML2.ISAXLexicalHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXLexicalHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(7F85D5F5-47A8-4497-BDA5-84BA04819EA6), 
	helpstring("ISAXLexicalHandler interface"), 
	hidden
]
interface ISAXLexicalHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall startDTD(
		[in]unsigned short* pwchName,
		[in]int cchName,
		[in]unsigned short* pwchPublicId,
		[in]int cchPublicId,
		[in]unsigned short* pwchSystemId,
		[in]int cchSystemId);
	[id(0x60010001)]
	HRESULT __stdcall endDTD();
	[id(0x60010002)]
	HRESULT __stdcall startEntity(
		[in]unsigned short* pwchName,
		[in]int cchName);
	[id(0x60010003)]
	HRESULT __stdcall endEntity(
		[in]unsigned short* pwchName,
		[in]int cchName);
	[id(0x60010004)]
	HRESULT __stdcall startCDATA();
	[id(0x60010005)]
	HRESULT __stdcall endCDATA();
	[id(0x60010006)]
	HRESULT __stdcall comment(
		[in]unsigned short* pwchChars,
		[in]int cchChars);
};
'!

!MSXML.ISAXLexicalHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !

!MSXML.ISAXLexicalHandler methodsFor!

Comment: pwchChars cchChars: cchChars
	"Invoke the comment() method of the COM object.

		HRESULT __stdcall comment(
			[in]unsigned short* pwchChars,
			[in]int cchChars);"

	<virtual stdcall: hresult 10 uint16* int32>
	^self invalidCall: _failureCode!

EndCDATA
	"Invoke the endCDATA() method of the COM object.

		HRESULT __stdcall endCDATA();"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

EndDTD
	"Invoke the endDTD() method of the COM object.

		HRESULT __stdcall endDTD();"

	<virtual stdcall: hresult 5>
	^self invalidCall: _failureCode!

EndEntity: pwchName cchName: cchName
	"Invoke the endEntity() method of the COM object.

		HRESULT __stdcall endEntity(
			[in]unsigned short* pwchName,
			[in]int cchName);"

	<virtual stdcall: hresult 7 uint16* int32>
	^self invalidCall: _failureCode!

StartCDATA
	"Invoke the startCDATA() method of the COM object.

		HRESULT __stdcall startCDATA();"

	<virtual stdcall: hresult 8>
	^self invalidCall: _failureCode!

StartDTD: pwchName cchName: cchName pwchPublicId: pwchPublicId cchPublicId: cchPublicId pwchSystemId: pwchSystemId cchSystemId: cchSystemId
	"Invoke the startDTD() method of the COM object.

		HRESULT __stdcall startDTD(
			[in]unsigned short* pwchName,
			[in]int cchName,
			[in]unsigned short* pwchPublicId,
			[in]int cchPublicId,
			[in]unsigned short* pwchSystemId,
			[in]int cchSystemId);"

	<virtual stdcall: hresult 4 uint16* int32 uint16* int32 uint16* int32>
	^self invalidCall: _failureCode!

StartEntity: pwchName cchName: cchName
	"Invoke the startEntity() method of the COM object.

		HRESULT __stdcall startEntity(
			[in]unsigned short* pwchName,
			[in]int cchName);"

	<virtual stdcall: hresult 6 uint16* int32>
	^self invalidCall: _failureCode! !

!MSXML.ISAXLexicalHandler categoriesForMethods!
Comment:cchChars:!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
EndCDATA!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
EndDTD!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
EndEntity:cchName:!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
StartCDATA!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
StartDTD:cchName:pwchPublicId:cchPublicId:pwchSystemId:cchSystemId:!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
StartEntity:cchName:!**auto generated**!COM Interfaces-ISAXLexicalHandler!public! !
!

!MSXML.ISAXLexicalHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXLexicalHandler'
		ISAXLexicalHandler defineTemplate"

	self
		defineFunction: #StartDTD:cchName:pwchPublicId:cchPublicId:pwchSystemId:cchSystemId:
			argumentTypes: 'word* sdword word* sdword word* sdword';
		defineFunction: #EndDTD;
		defineFunction: #StartEntity:cchName:
			argumentTypes: 'word* sdword';
		defineFunction: #EndEntity:cchName:
			argumentTypes: 'word* sdword';
		defineFunction: #StartCDATA;
		defineFunction: #EndCDATA;
		defineFunction: #Comment:cchChars:
			argumentTypes: 'word* sdword'
! !

!MSXML.ISAXLexicalHandler class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

