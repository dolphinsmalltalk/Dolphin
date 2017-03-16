"Filed out from Dolphin Smalltalk 7"!

IXMLDocument subclass: #IXMLDocument2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDocument2 guid: (IID fromString: '{2B8DE2FE-8D2D-11D1-B2FC-00C04FD915A9}')!
IXMLDocument2 comment: '<IXMLDocument2> is a wrapper class for the COM interface ''MSXML2.IXMLDocument2'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2B8DE2FE-8D2D-11D1-B2FC-00C04FD915A9), 
	hidden
]
interface IXMLDocument2 : IDispatch
 {
	[id(0x00010065), propget, helpstring("get root IXMLElement of the XML document.")]
	HRESULT __stdcall root(
		[out, retval]IXMLElement2** p);
	[id(0x00010066), hidden, propget, restricted]
	HRESULT __stdcall fileSize(
		[out, retval]BSTR* p);
	[id(0x00010067), hidden, propget, restricted]
	HRESULT __stdcall fileModifiedDate(
		[out, retval]BSTR* p);
	[id(0x00010068), hidden, propget, restricted]
	HRESULT __stdcall fileUpdatedDate(
		[out, retval]BSTR* p);
	[id(0x00010069), propget, helpstring("set URL to load an XML document from the URL.")]
	HRESULT __stdcall url(
		[out, retval]BSTR* p);
	[id(0x00010069), propput, helpstring("set URL to load an XML document from the URL.")]
	HRESULT __stdcall url(
		[in]BSTR p);
	[id(0x0001006a), hidden, propget, restricted]
	HRESULT __stdcall mimeType(
		[out, retval]BSTR* p);
	[id(0x0001006b), propget, helpstring("get ready state.")]
	HRESULT __stdcall readyState(
		[out, retval]long* pl);
	[id(0x0001006d), propget, helpstring("get encoding.")]
	HRESULT __stdcall charset(
		[out, retval]BSTR* p);
	[id(0x0001006d), propput, helpstring("get encoding.")]
	HRESULT __stdcall charset(
		[in]BSTR p);
	[id(0x0001006e), propget, helpstring("get XML version number.")]
	HRESULT __stdcall version(
		[out, retval]BSTR* p);
	[id(0x0001006f), propget, helpstring("get document type.")]
	HRESULT __stdcall doctype(
		[out, retval]BSTR* p);
	[id(0x00010070), hidden, propget, restricted]
	HRESULT __stdcall dtdURL(
		[out, retval]BSTR* p);
	[id(0x0001006c), helpstring("create different types of IXMLElements.")]
	HRESULT __stdcall createElement(
		[in]VARIANT vType,
		[in, optional]VARIANT var1,
		[out, retval]IXMLElement2** ppElem);
	[id(0x00010071), propget, helpstring("get asynchronous loading flag.")]
	HRESULT __stdcall async(
		[out, retval]VARIANT_BOOL* pf);
	[id(0x00010071), propput, helpstring("get asynchronous loading flag.")]
	HRESULT __stdcall async(
		[in]VARIANT_BOOL pf);
};
'!
!IXMLDocument2 categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDocument2 methodsFor!

async
	"Answer the <varbool> value of the 'async' property of the receiver.
	Helpstring: get asynchronous loading flag."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_async: answer.
	^answer asObject
!

async: pf
	"Set the 'async' property of the receiver to the <varbool> value of the argument.
	Helpstring: get asynchronous loading flag."

	self put_async: pf
!

createElement: vType var1: var1
	"Answer the <IXMLElement2> result of invoking the createElement() method of the COM object.
	Helpstring: create different types of IXMLElements."

	| answer |
	answer := IXMLElement2 newPointer.
	self
		CreateElement: vType asVariant
		var1: var1 asVariant
		ppElem: answer.
	^answer asObject
!

CreateElement: vType var1: var1 ppElem: ppElem
	"Private - Invoke the createElement() method of the COM object.
	Helpstring: create different types of IXMLElements.

		HRESULT __stdcall createElement(
			[in]VARIANT vType,
			[in, optional]VARIANT var1,
			[out, retval]IXMLElement2** ppElem);"

	<virtual stdcall: hresult 21 variant variant IXMLElement2**>
	^self invalidCall!

get_async: pf
	"Private - Get the value of the 'async' property of the receiver.

		HRESULT __stdcall async(
			[out, retval]VARIANT_BOOL* pf);"

	<virtual stdcall: hresult 22 varbool*>
	^self invalidCall!

get_root: p
	"Private - Get the value of the 'root' property of the receiver.

		HRESULT __stdcall root(
			[out, retval]IXMLElement2** p);"

	<virtual stdcall: hresult 8 IXMLElement2**>
	^self invalidCall!

put_async: pf
	"Private - Set the value of the 'async' property of the object wrapped by the 
	 receiver to the <varbool> argument, pf.

		HRESULT __stdcall async(
			[in]VARIANT_BOOL pf);"

	<virtual stdcall: hresult 23 varbool>
	^self invalidCall!

root
	"Answer the <IXMLElement2> value of the 'root' property of the receiver.
	Helpstring: get root IXMLElement of the XML document."

	| answer |
	answer := IXMLElement2 newPointer.
	self get_root: answer.
	^answer asObject
! !
!IXMLDocument2 categoriesFor: #async!**auto generated**!properties!public! !
!IXMLDocument2 categoriesFor: #async:!**auto generated**!properties!public! !
!IXMLDocument2 categoriesFor: #createElement:var1:!**auto generated**!methods!public! !
!IXMLDocument2 categoriesFor: #CreateElement:var1:ppElem:!**auto generated**!COM Interfaces-IXMLDocument2!private! !
!IXMLDocument2 categoriesFor: #get_async:!**auto generated**!COM Interfaces-IXMLDocument2!private! !
!IXMLDocument2 categoriesFor: #get_root:!**auto generated**!COM Interfaces-IXMLDocument2!private! !
!IXMLDocument2 categoriesFor: #put_async:!**auto generated**!COM Interfaces-IXMLDocument2!private! !
!IXMLDocument2 categoriesFor: #root!**auto generated**!properties!public! !

!IXMLDocument2 class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (XMLDocument) for which the receiver is the default interface."

	^CLSID fromString: '{CFC399AF-D876-11D0-9C10-00C04FC99C8E}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDocument2'
		IXMLDocument2 defineTemplate"

	self
		defineFunction: #get_root:
			argumentTypes: 'IXMLElement2**';
		defineFunction: #get_fileSize:
			argumentTypes: 'bstr*';
		defineFunction: #get_fileModifiedDate:
			argumentTypes: 'bstr*';
		defineFunction: #get_fileUpdatedDate:
			argumentTypes: 'bstr*';
		defineFunction: #get_url:
			argumentTypes: 'bstr*';
		defineFunction: #put_url:
			argumentTypes: 'bstr';
		defineFunction: #get_mimeType:
			argumentTypes: 'bstr*';
		defineFunction: #get_readyState:
			argumentTypes: 'sdword*';
		defineFunction: #get_charset:
			argumentTypes: 'bstr*';
		defineFunction: #put_charset:
			argumentTypes: 'bstr';
		defineFunction: #get_version:
			argumentTypes: 'bstr*';
		defineFunction: #get_doctype:
			argumentTypes: 'bstr*';
		defineFunction: #get_dtdURL:
			argumentTypes: 'bstr*';
		defineFunction: #CreateElement:var1:ppElem:
			argumentTypes: 'variant variant IXMLElement2**';
		defineFunction: #get_async:
			argumentTypes: 'varbool*';
		defineFunction: #put_async:
			argumentTypes: 'varbool'
! !
!IXMLDocument2 class categoriesFor: #clsid!**auto generated**!constants!private! !
!IXMLDocument2 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

