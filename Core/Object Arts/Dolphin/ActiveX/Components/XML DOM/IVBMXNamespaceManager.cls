"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IVBMXNamespaceManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IVBMXNamespaceManager guid: (IID fromString: '{c90352f5-643c-4fbc-bb23-e996eb2d51fd}')!
IVBMXNamespaceManager comment: '<IVBMXNamespaceManager> is a wrapper class for the COM interface ''MSXML2.IVBMXNamespaceManager'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IVBMXNamespaceManager interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(C90352F5-643C-4FBC-BB23-E996EB2D51FD), 
	helpstring("IVBMXNamespaceManager interface"), 
	dual, 
	nonextensible
]
interface IVBMXNamespaceManager : IDispatch
 {
	[id(0x0000057e), propput]
	HRESULT __stdcall allowOverride(
		[in]VARIANT_BOOL fOverride);
	[id(0x0000057e), propget]
	HRESULT __stdcall allowOverride(
		[out, retval]VARIANT_BOOL* fOverride);
	[id(0x0000057f)]
	HRESULT __stdcall reset();
	[id(0x00000580)]
	HRESULT __stdcall pushContext();
	[id(0x00000581)]
	HRESULT __stdcall pushNodeContext(
		[in]IXMLDOMNode* contextNode,
		[in, defaultvalue(true)]VARIANT_BOOL fDeep);
	[id(0x00000582)]
	HRESULT __stdcall popContext();
	[id(0x00000583)]
	HRESULT __stdcall declarePrefix(
		[in]BSTR prefix,
		[in]BSTR namespaceURI);
	[id(0x00000584)]
	HRESULT __stdcall getDeclaredPrefixes(
		[out, retval]IMXNamespacePrefixes** prefixes);
	[id(0x00000585)]
	HRESULT __stdcall getPrefixes(
		[in]BSTR namespaceURI,
		[out, retval]IMXNamespacePrefixes** prefixes);
	[id(0x00000586)]
	HRESULT __stdcall getURI(
		[in]BSTR prefix,
		[out, retval]VARIANT* uri);
	[id(0x00000587)]
	HRESULT __stdcall getURIFromNode(
		[in]BSTR strPrefix,
		[in]IXMLDOMNode* contextNode,
		[out, retval]VARIANT* uri);
};
'!
!IVBMXNamespaceManager categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!IVBMXNamespaceManager methodsFor!

allowOverride
	"Answer the <varbool> value of the 'allowOverride' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_allowOverride: answer.
	^answer asObject
!

allowOverride: fOverride
	"Set the 'allowOverride' property of the receiver to the <varbool> value of the argument."

	self put_allowOverride: fOverride
!

DeclarePrefix: prefix namespaceURI: namespaceURI
	"Invoke the declarePrefix() method of the COM object.

		HRESULT __stdcall declarePrefix(
			[in]BSTR prefix,
			[in]BSTR namespaceURI);"

	<virtual stdcall: hresult 14 bstr bstr>
	^self invalidCall: _failureCode!

get_allowOverride: fOverride
	"Private - Get the value of the 'allowOverride' property of the receiver.

		HRESULT __stdcall allowOverride(
			[out, retval]VARIANT_BOOL* fOverride);"

	<virtual stdcall: hresult 9 varbool*>
	^self invalidCall: _failureCode!

getDeclaredPrefixes
	"Answer the <IMXNamespacePrefixes> result of invoking the getDeclaredPrefixes() method of the COM object."

	| answer |
	answer := IMXNamespacePrefixes newPointer.
	self GetDeclaredPrefixes: answer.
	^answer asObject
!

GetDeclaredPrefixes: prefixes
	"Private - Invoke the getDeclaredPrefixes() method of the COM object.

		HRESULT __stdcall getDeclaredPrefixes(
			[out, retval]IMXNamespacePrefixes** prefixes);"

	<virtual stdcall: hresult 15 IMXNamespacePrefixes**>
	^self invalidCall: _failureCode!

getPrefixes: namespaceURI
	"Answer the <IMXNamespacePrefixes> result of invoking the getPrefixes() method of the COM object."

	| answer |
	answer := IMXNamespacePrefixes newPointer.
	self
		GetPrefixes: namespaceURI
		prefixes: answer.
	^answer asObject
!

GetPrefixes: namespaceURI prefixes: prefixes
	"Private - Invoke the getPrefixes() method of the COM object.

		HRESULT __stdcall getPrefixes(
			[in]BSTR namespaceURI,
			[out, retval]IMXNamespacePrefixes** prefixes);"

	<virtual stdcall: hresult 16 bstr IMXNamespacePrefixes**>
	^self invalidCall: _failureCode!

getURI: prefix
	"Answer the <VARIANT> result of invoking the getURI() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		GetURI: prefix
		uri: answer.
	^answer asObject
!

GetURI: prefix uri: uri
	"Private - Invoke the getURI() method of the COM object.

		HRESULT __stdcall getURI(
			[in]BSTR prefix,
			[out, retval]VARIANT* uri);"

	<virtual stdcall: hresult 17 bstr variant*>
	^self invalidCall: _failureCode!

getURIFromNode: strPrefix contextNode: contextNode
	"Answer the <VARIANT> result of invoking the getURIFromNode() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		GetURIFromNode: strPrefix
		contextNode: contextNode
		uri: answer.
	^answer asObject
!

GetURIFromNode: strPrefix contextNode: contextNode uri: uri
	"Private - Invoke the getURIFromNode() method of the COM object.

		HRESULT __stdcall getURIFromNode(
			[in]BSTR strPrefix,
			[in]IXMLDOMNode* contextNode,
			[out, retval]VARIANT* uri);"

	<virtual stdcall: hresult 18 bstr IXMLDOMNode* variant*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

PopContext
	"Invoke the popContext() method of the COM object.

		HRESULT __stdcall popContext();"

	<virtual stdcall: hresult 13>
	^self invalidCall: _failureCode!

PushContext
	"Invoke the pushContext() method of the COM object.

		HRESULT __stdcall pushContext();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

pushNodeContext: contextNode
	"Invoke the pushNodeContext() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 PushNodeContext: contextNode
		 fDeep: true!

PushNodeContext: contextNode fDeep: fDeep
	"Invoke the pushNodeContext() method of the COM object.

		HRESULT __stdcall pushNodeContext(
			[in]IXMLDOMNode* contextNode,
			[in, defaultvalue(true)]VARIANT_BOOL fDeep);"

	<virtual stdcall: hresult 12 IXMLDOMNode* varbool>
	^self invalidCall: _failureCode!

put_allowOverride: fOverride
	"Private - Set the value of the 'allowOverride' property of the object wrapped by the 
	 receiver to the <varbool> argument, fOverride.

		HRESULT __stdcall allowOverride(
			[in]VARIANT_BOOL fOverride);"

	<virtual stdcall: hresult 8 varbool>
	^self invalidCall: _failureCode!

Reset
	"Invoke the reset() method of the COM object.

		HRESULT __stdcall reset();"

	<virtual stdcall: hresult 10>
	^self invalidCall: _failureCode! !
!IVBMXNamespaceManager categoriesFor: #allowOverride!**auto generated**!properties!public! !
!IVBMXNamespaceManager categoriesFor: #allowOverride:!**auto generated**!properties!public! !
!IVBMXNamespaceManager categoriesFor: #DeclarePrefix:namespaceURI:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!public! !
!IVBMXNamespaceManager categoriesFor: #get_allowOverride:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!private! !
!IVBMXNamespaceManager categoriesFor: #getDeclaredPrefixes!**auto generated**!methods!public! !
!IVBMXNamespaceManager categoriesFor: #GetDeclaredPrefixes:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!private! !
!IVBMXNamespaceManager categoriesFor: #getPrefixes:!**auto generated**!methods!public! !
!IVBMXNamespaceManager categoriesFor: #GetPrefixes:prefixes:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!private! !
!IVBMXNamespaceManager categoriesFor: #getURI:!**auto generated**!methods!public! !
!IVBMXNamespaceManager categoriesFor: #GetURI:uri:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!private! !
!IVBMXNamespaceManager categoriesFor: #getURIFromNode:contextNode:!**auto generated**!methods!public! !
!IVBMXNamespaceManager categoriesFor: #GetURIFromNode:contextNode:uri:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!private! !
!IVBMXNamespaceManager categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IVBMXNamespaceManager categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IVBMXNamespaceManager categoriesFor: #PopContext!**auto generated**!COM Interfaces-IVBMXNamespaceManager!public! !
!IVBMXNamespaceManager categoriesFor: #PushContext!**auto generated**!COM Interfaces-IVBMXNamespaceManager!public! !
!IVBMXNamespaceManager categoriesFor: #pushNodeContext:!**auto generated**!methods!public! !
!IVBMXNamespaceManager categoriesFor: #PushNodeContext:fDeep:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!public! !
!IVBMXNamespaceManager categoriesFor: #put_allowOverride:!**auto generated**!COM Interfaces-IVBMXNamespaceManager!private! !
!IVBMXNamespaceManager categoriesFor: #Reset!**auto generated**!COM Interfaces-IVBMXNamespaceManager!public! !

!IVBMXNamespaceManager class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IVBMXNamespaceManager'
		IVBMXNamespaceManager defineTemplate"

	self
		defineFunction: #put_allowOverride:
			argumentTypes: 'varbool';
		defineFunction: #get_allowOverride:
			argumentTypes: 'varbool*';
		defineFunction: #Reset;
		defineFunction: #PushContext;
		defineFunction: #PushNodeContext:fDeep:
			argumentTypes: 'IXMLDOMNode* varbool';
		defineFunction: #PopContext;
		defineFunction: #DeclarePrefix:namespaceURI:
			argumentTypes: 'bstr bstr';
		defineFunction: #GetDeclaredPrefixes:
			argumentTypes: 'IMXNamespacePrefixes**';
		defineFunction: #GetPrefixes:prefixes:
			argumentTypes: 'bstr IMXNamespacePrefixes**';
		defineFunction: #GetURI:uri:
			argumentTypes: 'bstr variant*';
		defineFunction: #GetURIFromNode:contextNode:uri:
			argumentTypes: 'bstr IXMLDOMNode* variant*'
!

newMXNamespaceManager
	"Answer a new instance of the receiver on the MXNamespaceManager COM object"

	^self onCLSID: (CLSID fromString: '{88D969D5-F192-11D4-A65F-0040963251E5}')
!

newMXNamespaceManager40
	"Answer a new instance of the receiver on the MXNamespaceManager40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969D6-F192-11D4-A65F-0040963251E5}')
!

newMXNamespaceManager60
	"Answer a new instance of the receiver on the MXNamespaceManager60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A11-F192-11D4-A65F-0040963251E5}')
! !
!IVBMXNamespaceManager class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IVBMXNamespaceManager class categoriesFor: #newMXNamespaceManager!**auto generated**!instance creation!public! !
!IVBMXNamespaceManager class categoriesFor: #newMXNamespaceManager40!**auto generated**!instance creation!public! !
!IVBMXNamespaceManager class categoriesFor: #newMXNamespaceManager60!**auto generated**!instance creation!public! !

