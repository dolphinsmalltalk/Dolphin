"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IXMLDocument
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDocument guid: (IID fromString: '{F52E2B61-18A1-11D1-B105-00805F49916B}')!
IXMLDocument comment: '<IXMLDocument> is a wrapper class for the COM interface ''MSXML2.IXMLDocument'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXMLDocument loads and saves XML document. This is obsolete. You should use IDOMDocument or IXMLDOMDocument."

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(F52E2B61-18A1-11D1-B105-00805F49916B), 
	helpstring("IXMLDocument loads and saves XML document. This is obsolete. You should use IDOMDocument or IXMLDOMDocument."), 
	hidden, 
	dual
]
interface IXMLDocument : IDispatch
 {
	[id(0x00010065), propget, helpstring("get root IXMLElement of the XML document.")]
	HRESULT __stdcall root(
		[out, retval]IXMLElement** p);
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
		[out, retval]IXMLElement** ppElem);
};
'!
!IXMLDocument categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IXMLDocument methodsFor!

charset
	"Answer the <bstr> value of the 'charset' property of the receiver.
	Helpstring: get encoding."

	| answer |
	answer := BSTR new.
	self get_charset: answer.
	^answer asObject
!

charset: p
	"Set the 'charset' property of the receiver to the <bstr> value of the argument.
	Helpstring: get encoding."

	self put_charset: p
!

createElement: vType
	"Answer the <IXMLElement> result of invoking the createElement() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 createElement: vType
		 var1: VARIANT unspecified!

createElement: vType var1: var1
	"Answer the <IXMLElement> result of invoking the createElement() method of the COM object.
	Helpstring: create different types of IXMLElements."

	| answer |
	answer := IXMLElement newPointer.
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
			[out, retval]IXMLElement** ppElem);"

	<virtual stdcall: hresult 21 variant variant IXMLElement**>
	^self invalidCall!

doctype
	"Answer the <bstr> value of the 'doctype' property of the receiver.
	Helpstring: get document type."

	| answer |
	answer := BSTR new.
	self get_doctype: answer.
	^answer asObject
!

dtdURL
	"Answer the <bstr> value of the 'dtdURL' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_dtdURL: answer.
	^answer asObject
!

fileModifiedDate
	"Answer the <bstr> value of the 'fileModifiedDate' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_fileModifiedDate: answer.
	^answer asObject
!

fileSize
	"Answer the <bstr> value of the 'fileSize' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_fileSize: answer.
	^answer asObject
!

fileUpdatedDate
	"Answer the <bstr> value of the 'fileUpdatedDate' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_fileUpdatedDate: answer.
	^answer asObject
!

get_charset: p
	"Private - Get the value of the 'charset' property of the receiver.

		HRESULT __stdcall charset(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall!

get_doctype: p
	"Private - Get the value of the 'doctype' property of the receiver.

		HRESULT __stdcall doctype(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 19 bstr*>
	^self invalidCall!

get_dtdURL: p
	"Private - Get the value of the 'dtdURL' property of the receiver.

		HRESULT __stdcall dtdURL(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall!

get_fileModifiedDate: p
	"Private - Get the value of the 'fileModifiedDate' property of the receiver.

		HRESULT __stdcall fileModifiedDate(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall!

get_fileSize: p
	"Private - Get the value of the 'fileSize' property of the receiver.

		HRESULT __stdcall fileSize(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall!

get_fileUpdatedDate: p
	"Private - Get the value of the 'fileUpdatedDate' property of the receiver.

		HRESULT __stdcall fileUpdatedDate(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall!

get_mimeType: p
	"Private - Get the value of the 'mimeType' property of the receiver.

		HRESULT __stdcall mimeType(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall!

get_readyState: pl
	"Private - Get the value of the 'readyState' property of the receiver.

		HRESULT __stdcall readyState(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 15 sdword*>
	^self invalidCall!

get_root: p
	"Private - Get the value of the 'root' property of the receiver.

		HRESULT __stdcall root(
			[out, retval]IXMLElement** p);"

	<virtual stdcall: hresult 8 IXMLElement**>
	^self invalidCall!

get_url: p
	"Private - Get the value of the 'url' property of the receiver.

		HRESULT __stdcall url(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall!

get_version: p
	"Private - Get the value of the 'version' property of the receiver.

		HRESULT __stdcall version(
			[out, retval]BSTR* p);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall!

mimeType
	"Answer the <bstr> value of the 'mimeType' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_mimeType: answer.
	^answer asObject
!

put_charset: p
	"Private - Set the value of the 'charset' property of the object wrapped by the 
	 receiver to the <bstr> argument, p.

		HRESULT __stdcall charset(
			[in]BSTR p);"

	<virtual stdcall: hresult 17 bstr>
	^self invalidCall!

put_url: p
	"Private - Set the value of the 'url' property of the object wrapped by the 
	 receiver to the <bstr> argument, p.

		HRESULT __stdcall url(
			[in]BSTR p);"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall!

readyState
	"Answer the <sdword> value of the 'readyState' property of the receiver.
	Helpstring: get ready state."

	| answer |
	answer := (SDWORD new).
	self get_readyState: answer.
	^answer asObject
!

root
	"Answer the <IXMLElement> value of the 'root' property of the receiver.
	Helpstring: get root IXMLElement of the XML document."

	| answer |
	answer := IXMLElement newPointer.
	self get_root: answer.
	^answer asObject
!

url
	"Answer the <bstr> value of the 'url' property of the receiver.
	Helpstring: set URL to load an XML document from the URL."

	| answer |
	answer := BSTR new.
	self get_url: answer.
	^answer asObject
!

url: p
	"Set the 'url' property of the receiver to the <bstr> value of the argument.
	Helpstring: set URL to load an XML document from the URL."

	self put_url: p
!

version
	"Answer the <bstr> value of the 'version' property of the receiver.
	Helpstring: get XML version number."

	| answer |
	answer := BSTR new.
	self get_version: answer.
	^answer asObject
! !
!IXMLDocument categoriesFor: #charset!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #charset:!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #createElement:!**auto generated**!methods!public! !
!IXMLDocument categoriesFor: #createElement:var1:!**auto generated**!methods!public! !
!IXMLDocument categoriesFor: #CreateElement:var1:ppElem:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #doctype!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #dtdURL!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #fileModifiedDate!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #fileSize!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #fileUpdatedDate!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #get_charset:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_doctype:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_dtdURL:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_fileModifiedDate:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_fileSize:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_fileUpdatedDate:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_mimeType:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_readyState:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_root:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_url:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #get_version:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #mimeType!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #put_charset:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #put_url:!**auto generated**!COM Interfaces-IXMLDocument!private! !
!IXMLDocument categoriesFor: #readyState!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #root!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #url!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #url:!**auto generated**!properties!public! !
!IXMLDocument categoriesFor: #version!**auto generated**!properties!public! !

!IXMLDocument class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDocument'
		IXMLDocument defineTemplate"

	self
		defineFunction: #get_root:
			argumentTypes: 'IXMLElement**';
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
			argumentTypes: 'variant variant IXMLElement**'
! !
!IXMLDocument class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

