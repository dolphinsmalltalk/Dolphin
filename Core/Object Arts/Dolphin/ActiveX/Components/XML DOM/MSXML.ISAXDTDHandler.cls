"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.ISAXDTDHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISAXDTDHandler guid: (OS.COM.IID fromString: '{e15c1baf-afb3-4d60-8c36-19a8c45defed}')!
MSXML.ISAXDTDHandler comment: '<ISAXDTDHandler> is a wrapper class for the COM interface ''MSXML2.ISAXDTDHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXDTDHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(E15C1BAF-AFB3-4D60-8C36-19A8C45DEFED), 
	helpstring("ISAXDTDHandler interface"), 
	hidden
]
interface ISAXDTDHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall notationDecl(
		[in]unsigned short* pwchName,
		[in]int cchName,
		[in]unsigned short* pwchPublicId,
		[in]int cchPublicId,
		[in]unsigned short* pwchSystemId,
		[in]int cchSystemId);
	[id(0x60010001)]
	HRESULT __stdcall unparsedEntityDecl(
		[in]unsigned short* pwchName,
		[in]int cchName,
		[in]unsigned short* pwchPublicId,
		[in]int cchPublicId,
		[in]unsigned short* pwchSystemId,
		[in]int cchSystemId,
		[in]unsigned short* pwchNotationName,
		[in]int cchNotationName);
};
'!
!MSXML.ISAXDTDHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISAXDTDHandler methodsFor!

NotationDecl: pwchName cchName: cchName pwchPublicId: pwchPublicId cchPublicId: cchPublicId pwchSystemId: pwchSystemId cchSystemId: cchSystemId
	"Invoke the notationDecl() method of the COM object.

		HRESULT __stdcall notationDecl(
			[in]unsigned short* pwchName,
			[in]int cchName,
			[in]unsigned short* pwchPublicId,
			[in]int cchPublicId,
			[in]unsigned short* pwchSystemId,
			[in]int cchSystemId);"

	<virtual stdcall: hresult 4 word* sdword word* sdword word* sdword>
	^self invalidCall: _failureCode!

UnparsedEntityDecl: pwchName cchName: cchName pwchPublicId: pwchPublicId cchPublicId: cchPublicId pwchSystemId: pwchSystemId cchSystemId: cchSystemId pwchNotationName: pwchNotationName cchNotationName: cchNotationName
	"Invoke the unparsedEntityDecl() method of the COM object.

		HRESULT __stdcall unparsedEntityDecl(
			[in]unsigned short* pwchName,
			[in]int cchName,
			[in]unsigned short* pwchPublicId,
			[in]int cchPublicId,
			[in]unsigned short* pwchSystemId,
			[in]int cchSystemId,
			[in]unsigned short* pwchNotationName,
			[in]int cchNotationName);"

	<virtual stdcall: hresult 5 word* sdword word* sdword word* sdword word* sdword>
	^self invalidCall: _failureCode! !
!MSXML.ISAXDTDHandler categoriesFor: #NotationDecl:cchName:pwchPublicId:cchPublicId:pwchSystemId:cchSystemId:!**auto generated**!COM Interfaces-ISAXDTDHandler!public! !
!MSXML.ISAXDTDHandler categoriesFor: #UnparsedEntityDecl:cchName:pwchPublicId:cchPublicId:pwchSystemId:cchSystemId:pwchNotationName:cchNotationName:!**auto generated**!COM Interfaces-ISAXDTDHandler!public! !

!MSXML.ISAXDTDHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXDTDHandler'
		ISAXDTDHandler defineTemplate"

	self
		defineFunction: #NotationDecl:cchName:pwchPublicId:cchPublicId:pwchSystemId:cchSystemId:
			argumentTypes: 'word* sdword word* sdword word* sdword';
		defineFunction: #UnparsedEntityDecl:cchName:pwchPublicId:cchPublicId:pwchSystemId:cchSystemId:pwchNotationName:cchNotationName:
			argumentTypes: 'word* sdword word* sdword word* sdword word* sdword'
! !
!MSXML.ISAXDTDHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

