"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IVBSAXContentHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IVBSAXContentHandler guid: (OS.COM.IID fromString: '{2ed7290a-4dd5-4b46-bb26-4e4155e77faa}')!
MSXML.IVBSAXContentHandler comment: '<IVBSAXContentHandler> is a wrapper class for the COM interface ''MSXML2.IVBSAXContentHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBSAXContentHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2ED7290A-4DD5-4B46-BB26-4E4155E77FAA), 
	helpstring("IVBSAXContentHandler interface"), 
	dual, 
	nonextensible
]
interface IVBSAXContentHandler : IDispatch
 {
	[id(0x0000052a), propputref, helpstring("Receive an object for locating the origin of SAX document events.")]
	HRESULT __stdcall documentLocator(
		[in]IVBSAXLocator* arg1);
	[id(0x0000052b), helpstring("Receive notification of the beginning of a document.")]
	HRESULT __stdcall startDocument();
	[id(0x0000052c), helpstring("Receive notification of the end of a document.")]
	HRESULT __stdcall endDocument();
	[id(0x0000052d), helpstring("Begin the scope of a prefix-URI Namespace mapping.")]
	HRESULT __stdcall startPrefixMapping(
		[in, out]BSTR* strPrefix,
		[in, out]BSTR* strURI);
	[id(0x0000052e), helpstring("End the scope of a prefix-URI mapping.")]
	HRESULT __stdcall endPrefixMapping(
		[in, out]BSTR* strPrefix);
	[id(0x0000052f), helpstring("Receive notification of the beginning of an element.")]
	HRESULT __stdcall startElement(
		[in, out]BSTR* strNamespaceURI,
		[in, out]BSTR* strLocalName,
		[in, out]BSTR* strQName,
		[in]IVBSAXAttributes* oAttributes);
	[id(0x00000530), helpstring("Receive notification of the end of an element.")]
	HRESULT __stdcall endElement(
		[in, out]BSTR* strNamespaceURI,
		[in, out]BSTR* strLocalName,
		[in, out]BSTR* strQName);
	[id(0x00000531), helpstring("Receive notification of character data.")]
	HRESULT __stdcall characters(
		[in, out]BSTR* strChars);
	[id(0x00000532), helpstring("Receive notification of ignorable whitespace in element content.")]
	HRESULT __stdcall ignorableWhitespace(
		[in, out]BSTR* strChars);
	[id(0x00000533), helpstring("Receive notification of a processing instruction.")]
	HRESULT __stdcall processingInstruction(
		[in, out]BSTR* strTarget,
		[in, out]BSTR* strData);
	[id(0x00000534), helpstring("Receive notification of a skipped entity.")]
	HRESULT __stdcall skippedEntity(
		[in, out]BSTR* strName);
};
'!
!MSXML.IVBSAXContentHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IVBSAXContentHandler methodsFor!

characters: strChars
	"Invoke the characters() method of the COM object.
	Helpstring: Receive notification of character data."

	^self Characters: strChars asBSTR!

Characters: strChars
	"Private - Invoke the characters() method of the COM object.
	Helpstring: Receive notification of character data.

		HRESULT __stdcall characters(
			[in, out]BSTR* strChars);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode!

EndDocument
	"Invoke the endDocument() method of the COM object.
	Helpstring: Receive notification of the end of a document.

		HRESULT __stdcall endDocument();"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode!

endElement: strNamespaceURI strLocalName: strLocalName strQName: strQName
	"Invoke the endElement() method of the COM object.
	Helpstring: Receive notification of the end of an element."

	| outputs |
	outputs := {strNamespaceURI asBSTR. strLocalName asBSTR. strQName asBSTR}.
	self
		EndElement: (outputs basicAt: 1)
		strLocalName: (outputs basicAt: 2)
		strQName: (outputs basicAt: 3).
	^outputs collect: [:each | each asObject]!

EndElement: strNamespaceURI strLocalName: strLocalName strQName: strQName
	"Private - Invoke the endElement() method of the COM object.
	Helpstring: Receive notification of the end of an element.

		HRESULT __stdcall endElement(
			[in, out]BSTR* strNamespaceURI,
			[in, out]BSTR* strLocalName,
			[in, out]BSTR* strQName);"

	<virtual stdcall: hresult 14 bstr* bstr* bstr*>
	^self invalidCall: _failureCode!

endPrefixMapping: strPrefix
	"Invoke the endPrefixMapping() method of the COM object.
	Helpstring: End the scope of a prefix-URI mapping."

	^self EndPrefixMapping: strPrefix asBSTR!

EndPrefixMapping: strPrefix
	"Private - Invoke the endPrefixMapping() method of the COM object.
	Helpstring: End the scope of a prefix-URI mapping.

		HRESULT __stdcall endPrefixMapping(
			[in, out]BSTR* strPrefix);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

ignorableWhitespace: strChars
	"Invoke the ignorableWhitespace() method of the COM object.
	Helpstring: Receive notification of ignorable whitespace in element content."

	^self IgnorableWhitespace: strChars asBSTR!

IgnorableWhitespace: strChars
	"Private - Invoke the ignorableWhitespace() method of the COM object.
	Helpstring: Receive notification of ignorable whitespace in element content.

		HRESULT __stdcall ignorableWhitespace(
			[in, out]BSTR* strChars);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

processingInstruction: strTarget strData: strData
	"Invoke the processingInstruction() method of the COM object.
	Helpstring: Receive notification of a processing instruction."

	| outputs |
	outputs := {strTarget asBSTR. strData asBSTR}.
	self ProcessingInstruction: (outputs basicAt: 1) strData: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

ProcessingInstruction: strTarget strData: strData
	"Private - Invoke the processingInstruction() method of the COM object.
	Helpstring: Receive notification of a processing instruction.

		HRESULT __stdcall processingInstruction(
			[in, out]BSTR* strTarget,
			[in, out]BSTR* strData);"

	<virtual stdcall: hresult 17 bstr* bstr*>
	^self invalidCall: _failureCode!

putref_documentLocator: arg1
	"Private - Set the value of the 'documentLocator' property of the object wrapped by the 
	 receiver to the <IVBSAXLocator*> argument, arg1.

		HRESULT __stdcall documentLocator(
			[in]IVBSAXLocator* arg1);"

	<virtual stdcall: hresult 8 IVBSAXLocator*>
	^self invalidCall: _failureCode!

setDocumentLocator: arg1
	"Set the 'documentLocator' property of the receiver to the <IVBSAXLocator*> value of the argument.
	Helpstring: Receive an object for locating the origin of SAX document events."

	self putref_documentLocator: arg1!

skippedEntity: strName
	"Invoke the skippedEntity() method of the COM object.
	Helpstring: Receive notification of a skipped entity."

	^self SkippedEntity: strName asBSTR!

SkippedEntity: strName
	"Private - Invoke the skippedEntity() method of the COM object.
	Helpstring: Receive notification of a skipped entity.

		HRESULT __stdcall skippedEntity(
			[in, out]BSTR* strName);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall: _failureCode!

StartDocument
	"Invoke the startDocument() method of the COM object.
	Helpstring: Receive notification of the beginning of a document.

		HRESULT __stdcall startDocument();"

	<virtual stdcall: hresult 9>
	^self invalidCall: _failureCode!

startElement: strNamespaceURI strLocalName: strLocalName strQName: strQName oAttributes: oAttributes
	"Invoke the startElement() method of the COM object.
	Helpstring: Receive notification of the beginning of an element."

	| outputs |
	outputs := {strNamespaceURI asBSTR. strLocalName asBSTR. strQName asBSTR}.
	self
		StartElement: (outputs basicAt: 1)
		strLocalName: (outputs basicAt: 2)
		strQName: (outputs basicAt: 3)
		oAttributes: oAttributes.
	^outputs collect: [:each | each asObject]!

StartElement: strNamespaceURI strLocalName: strLocalName strQName: strQName oAttributes: oAttributes
	"Private - Invoke the startElement() method of the COM object.
	Helpstring: Receive notification of the beginning of an element.

		HRESULT __stdcall startElement(
			[in, out]BSTR* strNamespaceURI,
			[in, out]BSTR* strLocalName,
			[in, out]BSTR* strQName,
			[in]IVBSAXAttributes* oAttributes);"

	<virtual stdcall: hresult 13 bstr* bstr* bstr* IVBSAXAttributes*>
	^self invalidCall: _failureCode!

startPrefixMapping: strPrefix strURI: strURI
	"Invoke the startPrefixMapping() method of the COM object.
	Helpstring: Begin the scope of a prefix-URI Namespace mapping."

	| outputs |
	outputs := {strPrefix asBSTR. strURI asBSTR}.
	self StartPrefixMapping: (outputs basicAt: 1) strURI: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

StartPrefixMapping: strPrefix strURI: strURI
	"Private - Invoke the startPrefixMapping() method of the COM object.
	Helpstring: Begin the scope of a prefix-URI Namespace mapping.

		HRESULT __stdcall startPrefixMapping(
			[in, out]BSTR* strPrefix,
			[in, out]BSTR* strURI);"

	<virtual stdcall: hresult 11 bstr* bstr*>
	^self invalidCall: _failureCode! !
!MSXML.IVBSAXContentHandler categoriesFor: #characters:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #Characters:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #EndDocument!**auto generated**!COM Interfaces-IVBSAXContentHandler!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #endElement:strLocalName:strQName:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #EndElement:strLocalName:strQName:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #endPrefixMapping:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #EndPrefixMapping:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #ignorableWhitespace:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #IgnorableWhitespace:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IVBSAXContentHandler categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IVBSAXContentHandler categoriesFor: #processingInstruction:strData:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #ProcessingInstruction:strData:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #putref_documentLocator:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #setDocumentLocator:!**auto generated**!properties!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #skippedEntity:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #SkippedEntity:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #StartDocument!**auto generated**!COM Interfaces-IVBSAXContentHandler!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #startElement:strLocalName:strQName:oAttributes:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #StartElement:strLocalName:strQName:oAttributes:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !
!MSXML.IVBSAXContentHandler categoriesFor: #startPrefixMapping:strURI:!**auto generated**!methods!public! !
!MSXML.IVBSAXContentHandler categoriesFor: #StartPrefixMapping:strURI:!**auto generated**!COM Interfaces-IVBSAXContentHandler!private! !

!MSXML.IVBSAXContentHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBSAXContentHandler'
		IVBSAXContentHandler defineTemplate"

	self
		defineFunction: #putref_documentLocator:
			argumentTypes: 'IVBSAXLocator*';
		defineFunction: #StartDocument;
		defineFunction: #EndDocument;
		defineFunction: #StartPrefixMapping:strURI:
			argumentTypes: 'bstr* bstr*';
		defineFunction: #EndPrefixMapping:
			argumentTypes: 'bstr*';
		defineFunction: #StartElement:strLocalName:strQName:oAttributes:
			argumentTypes: 'bstr* bstr* bstr* IVBSAXAttributes*';
		defineFunction: #EndElement:strLocalName:strQName:
			argumentTypes: 'bstr* bstr* bstr*';
		defineFunction: #Characters:
			argumentTypes: 'bstr*';
		defineFunction: #IgnorableWhitespace:
			argumentTypes: 'bstr*';
		defineFunction: #ProcessingInstruction:strData:
			argumentTypes: 'bstr* bstr*';
		defineFunction: #SkippedEntity:
			argumentTypes: 'bstr*'
! !
!MSXML.IVBSAXContentHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

