"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.ISAXContentHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISAXContentHandler guid: (OS.COM.IID fromString: '{1545cdfa-9e4e-4497-a8a4-2bf7d0112c44}')!
MSXML.ISAXContentHandler comment: '<ISAXContentHandler> is a wrapper class for the COM interface ''MSXML2.ISAXContentHandler'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXContentHandler interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(1545CDFA-9E4E-4497-A8A4-2BF7D0112C44), 
	helpstring("ISAXContentHandler interface"), 
	hidden
]
interface ISAXContentHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall putDocumentLocator(
		[in]ISAXLocator* pLocator);
	[id(0x60010001)]
	HRESULT __stdcall startDocument();
	[id(0x60010002)]
	HRESULT __stdcall endDocument();
	[id(0x60010003)]
	HRESULT __stdcall startPrefixMapping(
		[in]unsigned short* pwchPrefix,
		[in]int cchPrefix,
		[in]unsigned short* pwchUri,
		[in]int cchUri);
	[id(0x60010004)]
	HRESULT __stdcall endPrefixMapping(
		[in]unsigned short* pwchPrefix,
		[in]int cchPrefix);
	[id(0x60010005)]
	HRESULT __stdcall startElement(
		[in]unsigned short* pwchNamespaceUri,
		[in]int cchNamespaceUri,
		[in]unsigned short* pwchLocalName,
		[in]int cchLocalName,
		[in]unsigned short* pwchQName,
		[in]int cchQName,
		[in]ISAXAttributes* pAttributes);
	[id(0x60010006)]
	HRESULT __stdcall endElement(
		[in]unsigned short* pwchNamespaceUri,
		[in]int cchNamespaceUri,
		[in]unsigned short* pwchLocalName,
		[in]int cchLocalName,
		[in]unsigned short* pwchQName,
		[in]int cchQName);
	[id(0x60010007)]
	HRESULT __stdcall characters(
		[in]unsigned short* pwchChars,
		[in]int cchChars);
	[id(0x60010008)]
	HRESULT __stdcall ignorableWhitespace(
		[in]unsigned short* pwchChars,
		[in]int cchChars);
	[id(0x60010009)]
	HRESULT __stdcall processingInstruction(
		[in]unsigned short* pwchTarget,
		[in]int cchTarget,
		[in]unsigned short* pwchData,
		[in]int cchData);
	[id(0x6001000a)]
	HRESULT __stdcall skippedEntity(
		[in]unsigned short* pwchName,
		[in]int cchName);
};
'!
!MSXML.ISAXContentHandler categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISAXContentHandler methodsFor!

Characters: pwchChars cchChars: cchChars
	"Invoke the characters() method of the COM object.

		HRESULT __stdcall characters(
			[in]unsigned short* pwchChars,
			[in]int cchChars);"

	<virtual stdcall: hresult 11 word* sdword>
	^self invalidCall: _failureCode!

EndDocument
	"Invoke the endDocument() method of the COM object.

		HRESULT __stdcall endDocument();"

	<virtual stdcall: hresult 6>
	^self invalidCall: _failureCode!

EndElement: pwchNamespaceUri cchNamespaceUri: cchNamespaceUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName pwchQName: pwchQName cchQName: cchQName
	"Invoke the endElement() method of the COM object.

		HRESULT __stdcall endElement(
			[in]unsigned short* pwchNamespaceUri,
			[in]int cchNamespaceUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[in]unsigned short* pwchQName,
			[in]int cchQName);"

	<virtual stdcall: hresult 10 word* sdword word* sdword word* sdword>
	^self invalidCall: _failureCode!

EndPrefixMapping: pwchPrefix cchPrefix: cchPrefix
	"Invoke the endPrefixMapping() method of the COM object.

		HRESULT __stdcall endPrefixMapping(
			[in]unsigned short* pwchPrefix,
			[in]int cchPrefix);"

	<virtual stdcall: hresult 8 word* sdword>
	^self invalidCall: _failureCode!

IgnorableWhitespace: pwchChars cchChars: cchChars
	"Invoke the ignorableWhitespace() method of the COM object.

		HRESULT __stdcall ignorableWhitespace(
			[in]unsigned short* pwchChars,
			[in]int cchChars);"

	<virtual stdcall: hresult 12 word* sdword>
	^self invalidCall: _failureCode!

ProcessingInstruction: pwchTarget cchTarget: cchTarget pwchData: pwchData cchData: cchData
	"Invoke the processingInstruction() method of the COM object.

		HRESULT __stdcall processingInstruction(
			[in]unsigned short* pwchTarget,
			[in]int cchTarget,
			[in]unsigned short* pwchData,
			[in]int cchData);"

	<virtual stdcall: hresult 13 word* sdword word* sdword>
	^self invalidCall: _failureCode!

PutDocumentLocator: pLocator
	"Invoke the putDocumentLocator() method of the COM object.

		HRESULT __stdcall putDocumentLocator(
			[in]ISAXLocator* pLocator);"

	<virtual stdcall: hresult 4 ISAXLocator*>
	^self invalidCall: _failureCode!

SkippedEntity: pwchName cchName: cchName
	"Invoke the skippedEntity() method of the COM object.

		HRESULT __stdcall skippedEntity(
			[in]unsigned short* pwchName,
			[in]int cchName);"

	<virtual stdcall: hresult 14 word* sdword>
	^self invalidCall: _failureCode!

StartDocument
	"Invoke the startDocument() method of the COM object.

		HRESULT __stdcall startDocument();"

	<virtual stdcall: hresult 5>
	^self invalidCall: _failureCode!

StartElement: pwchNamespaceUri cchNamespaceUri: cchNamespaceUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName pwchQName: pwchQName cchQName: cchQName pAttributes: pAttributes
	"Invoke the startElement() method of the COM object.

		HRESULT __stdcall startElement(
			[in]unsigned short* pwchNamespaceUri,
			[in]int cchNamespaceUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[in]ISAXAttributes* pAttributes);"

	<virtual stdcall: hresult 9 word* sdword word* sdword word* sdword ISAXAttributes*>
	^self invalidCall: _failureCode!

StartPrefixMapping: pwchPrefix cchPrefix: cchPrefix pwchUri: pwchUri cchUri: cchUri
	"Invoke the startPrefixMapping() method of the COM object.

		HRESULT __stdcall startPrefixMapping(
			[in]unsigned short* pwchPrefix,
			[in]int cchPrefix,
			[in]unsigned short* pwchUri,
			[in]int cchUri);"

	<virtual stdcall: hresult 7 word* sdword word* sdword>
	^self invalidCall: _failureCode! !
!MSXML.ISAXContentHandler categoriesFor: #Characters:cchChars:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #EndDocument!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #EndElement:cchNamespaceUri:pwchLocalName:cchLocalName:pwchQName:cchQName:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #EndPrefixMapping:cchPrefix:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #IgnorableWhitespace:cchChars:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #ProcessingInstruction:cchTarget:pwchData:cchData:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #PutDocumentLocator:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #SkippedEntity:cchName:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #StartDocument!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #StartElement:cchNamespaceUri:pwchLocalName:cchLocalName:pwchQName:cchQName:pAttributes:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !
!MSXML.ISAXContentHandler categoriesFor: #StartPrefixMapping:cchPrefix:pwchUri:cchUri:!**auto generated**!COM Interfaces-ISAXContentHandler!public! !

!MSXML.ISAXContentHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXContentHandler'
		ISAXContentHandler defineTemplate"

	self
		defineFunction: #PutDocumentLocator:
			argumentTypes: 'ISAXLocator*';
		defineFunction: #StartDocument;
		defineFunction: #EndDocument;
		defineFunction: #StartPrefixMapping:cchPrefix:pwchUri:cchUri:
			argumentTypes: 'word* sdword word* sdword';
		defineFunction: #EndPrefixMapping:cchPrefix:
			argumentTypes: 'word* sdword';
		defineFunction: #StartElement:cchNamespaceUri:pwchLocalName:cchLocalName:pwchQName:cchQName:pAttributes:
			argumentTypes: 'word* sdword word* sdword word* sdword ISAXAttributes*';
		defineFunction: #EndElement:cchNamespaceUri:pwchLocalName:cchLocalName:pwchQName:cchQName:
			argumentTypes: 'word* sdword word* sdword word* sdword';
		defineFunction: #Characters:cchChars:
			argumentTypes: 'word* sdword';
		defineFunction: #IgnorableWhitespace:cchChars:
			argumentTypes: 'word* sdword';
		defineFunction: #ProcessingInstruction:cchTarget:pwchData:cchData:
			argumentTypes: 'word* sdword word* sdword';
		defineFunction: #SkippedEntity:cchName:
			argumentTypes: 'word* sdword'
! !
!MSXML.ISAXContentHandler class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

