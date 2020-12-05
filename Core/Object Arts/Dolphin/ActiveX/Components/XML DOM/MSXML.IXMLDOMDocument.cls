"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNode subclass: #'MSXML.IXMLDOMDocument'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMDocument guid: (OS.COM.IID fromString: '{2933bf81-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMDocument comment: '<IXMLDOMDocument> is a wrapper class for the COM interface ''MSXML.IXMLDOMDocument'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent documents, i.e. it represents the top node of the XML DOM tree.'!
!MSXML.IXMLDOMDocument categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMDocument methodsFor!

Abort
	"Invoke the abort() method of the COM object.
	Helpstring: abort an asynchronous download

		HRESULT __stdcall abort();"

	<virtual stdcall: hresult 65>
	^self invalidCall: _failureCode!

async
	"Answer the <varbool> value of the 'async' property of the receiver.
	Helpstring: flag for asynchronous download"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_async: answer.
	^answer asObject
!

async: isAsync
	"Set the 'async' property of the receiver to the <varbool> value of the argument.
	Helpstring: flag for asynchronous download"

	self put_async: isAsync
!

createAttribute: name
	"Answer the <IXMLDOMAttribute> result of invoking the createAttribute() method of the COM object.
	Helpstring: create an attribute node"

	| answer |
	answer := IXMLDOMAttribute newPointer.
	self CreateAttribute: name attribute: answer.
	^answer asObject!

CreateAttribute: name attribute: attribute
	"Private - Invoke the createAttribute() method of the COM object.
	Helpstring: create an attribute node

		HRESULT __stdcall createAttribute(
			[in]BSTR name,
			[out, retval]IXMLDOMAttribute** attribute);"

	<virtual stdcall: hresult 54 bstr IXMLDOMAttribute**>
	^self invalidCall: _failureCode!

createCDATASection: data
	"Answer the <IXMLDOMCDATASection> result of invoking the createCDATASection() method of the COM object.
	Helpstring: create a CDATA section node"

	| answer |
	answer := IXMLDOMCDATASection newPointer.
	self CreateCDATASection: data cdata: answer.
	^answer asObject!

CreateCDATASection: data cdata: cdata
	"Private - Invoke the createCDATASection() method of the COM object.
	Helpstring: create a CDATA section node

		HRESULT __stdcall createCDATASection(
			[in]BSTR data,
			[out, retval]IXMLDOMCDATASection** cdata);"

	<virtual stdcall: hresult 52 bstr IXMLDOMCDATASection**>
	^self invalidCall: _failureCode!

createComment: data
	"Answer the <IXMLDOMComment> result of invoking the createComment() method of the COM object.
	Helpstring: create a comment node"

	| answer |
	answer := IXMLDOMComment newPointer.
	self CreateComment: data comment: answer.
	^answer asObject!

CreateComment: data comment: comment
	"Private - Invoke the createComment() method of the COM object.
	Helpstring: create a comment node

		HRESULT __stdcall createComment(
			[in]BSTR data,
			[out, retval]IXMLDOMComment** comment);"

	<virtual stdcall: hresult 51 bstr IXMLDOMComment**>
	^self invalidCall: _failureCode!

createDocumentFragment
	"Answer the <IXMLDOMDocumentFragment> result of invoking the createDocumentFragment() method of the COM object.
	Helpstring: create a DocumentFragment node"

	| answer |
	answer := IXMLDOMDocumentFragment newPointer.
	self CreateDocumentFragment: answer.
	^answer asObject!

CreateDocumentFragment: docFrag
	"Private - Invoke the createDocumentFragment() method of the COM object.
	Helpstring: create a DocumentFragment node

		HRESULT __stdcall createDocumentFragment(
			[out, retval]IXMLDOMDocumentFragment** docFrag);"

	<virtual stdcall: hresult 49 IXMLDOMDocumentFragment**>
	^self invalidCall: _failureCode!

createElement: tagName
	"Answer the <IXMLDOMElement> result of invoking the createElement() method of the COM object.
	Helpstring: create an Element node"

	| answer |
	answer := IXMLDOMElement newPointer.
	self CreateElement: tagName element: answer.
	^answer asObject!

CreateElement: tagName element: element
	"Private - Invoke the createElement() method of the COM object.
	Helpstring: create an Element node

		HRESULT __stdcall createElement(
			[in]BSTR tagName,
			[out, retval]IXMLDOMElement** element);"

	<virtual stdcall: hresult 48 bstr IXMLDOMElement**>
	^self invalidCall: _failureCode!

createEntityReference: name
	"Answer the <IXMLDOMEntityReference> result of invoking the createEntityReference() method of the COM object.
	Helpstring: create an entity reference node"

	| answer |
	answer := IXMLDOMEntityReference newPointer.
	self CreateEntityReference: name entityRef: answer.
	^answer asObject!

CreateEntityReference: name entityRef: entityRef
	"Private - Invoke the createEntityReference() method of the COM object.
	Helpstring: create an entity reference node

		HRESULT __stdcall createEntityReference(
			[in]BSTR name,
			[out, retval]IXMLDOMEntityReference** entityRef);"

	<virtual stdcall: hresult 55 bstr IXMLDOMEntityReference**>
	^self invalidCall: _failureCode!

createNode: type name: name namespaceURI: namespaceURI
	"Answer the <IXMLDOMNode> result of invoking the createNode() method of the COM object.
	Helpstring: create a node of the specified node type and name"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		CreateNode: type asVariant
		name: name
		namespaceURI: namespaceURI
		node: answer.
	^answer asObject!

CreateNode: type name: name namespaceURI: namespaceURI node: node
	"Private - Invoke the createNode() method of the COM object.
	Helpstring: create a node of the specified node type and name

		HRESULT __stdcall createNode(
			[in]VARIANT type,
			[in]BSTR name,
			[in]BSTR namespaceURI,
			[out, retval]IXMLDOMNode** node);"

	<virtual stdcall: hresult 57 variant bstr bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

createProcessingInstruction: target data: data
	"Answer the <IXMLDOMProcessingInstruction> result of invoking the createProcessingInstruction() method of the COM object.
	Helpstring: create a processing instruction node"

	| answer |
	answer := IXMLDOMProcessingInstruction newPointer.
	self
		CreateProcessingInstruction: target
		data: data
		pi: answer.
	^answer asObject!

CreateProcessingInstruction: target data: data pi: pi
	"Private - Invoke the createProcessingInstruction() method of the COM object.
	Helpstring: create a processing instruction node

		HRESULT __stdcall createProcessingInstruction(
			[in]BSTR target,
			[in]BSTR data,
			[out, retval]IXMLDOMProcessingInstruction** pi);"

	<virtual stdcall: hresult 53 bstr bstr IXMLDOMProcessingInstruction**>
	^self invalidCall: _failureCode!

createTextNode: data
	"Answer the <IXMLDOMText> result of invoking the createTextNode() method of the COM object.
	Helpstring: create a text node"

	| answer |
	answer := IXMLDOMText newPointer.
	self CreateTextNode: data text: answer.
	^answer asObject!

CreateTextNode: data text: text
	"Private - Invoke the createTextNode() method of the COM object.
	Helpstring: create a text node

		HRESULT __stdcall createTextNode(
			[in]BSTR data,
			[out, retval]IXMLDOMText** text);"

	<virtual stdcall: hresult 50 bstr IXMLDOMText**>
	^self invalidCall: _failureCode!

doctype
	"Answer the <IXMLDOMDocumentType> value of the 'doctype' property of the receiver.
	Helpstring: node corresponding to the DOCTYPE"

	| answer |
	answer := IXMLDOMDocumentType newPointer.
	self get_doctype: answer.
	^answer asObject!

documentElement
	"Answer the <IXMLDOMElement> value of the 'documentElement' property of the receiver.
	Helpstring: the root of the tree"

	| answer |
	answer := IXMLDOMElement newPointer.
	self get_documentElement: answer.
	^answer asObject!

get_async: isAsync
	"Private - Get the value of the 'async' property of the receiver.

		HRESULT __stdcall async(
			[out, retval]VARIANT_BOOL* isAsync);"

	<virtual stdcall: hresult 63 varbool*>
	^self invalidCall: _failureCode!

get_doctype: documentType
	"Private - Get the value of the 'doctype' property of the receiver.

		HRESULT __stdcall doctype(
			[out, retval]IXMLDOMDocumentType** documentType);"

	<virtual stdcall: hresult 44 IXMLDOMDocumentType**>
	^self invalidCall: _failureCode!

get_documentElement: domElement
	"Private - Get the value of the 'documentElement' property of the receiver.

		HRESULT __stdcall documentElement(
			[out, retval]IXMLDOMElement** DOMElement);"

	<virtual stdcall: hresult 46 IXMLDOMElement**>
	^self invalidCall: _failureCode!

get_implementation: impl
	"Private - Get the value of the 'implementation' property of the receiver.

		HRESULT __stdcall implementation(
			[out, retval]IXMLDOMImplementation** impl);"

	<virtual stdcall: hresult 45 IXMLDOMImplementation**>
	^self invalidCall: _failureCode!

get_parseError: errorObj
	"Private - Get the value of the 'parseError' property of the receiver.

		HRESULT __stdcall parseError(
			[out, retval]IXMLDOMParseError** errorObj);"

	<virtual stdcall: hresult 61 IXMLDOMParseError**>
	^self invalidCall: _failureCode!

get_preserveWhiteSpace: isPreserving
	"Private - Get the value of the 'preserveWhiteSpace' property of the receiver.

		HRESULT __stdcall preserveWhiteSpace(
			[out, retval]VARIANT_BOOL* isPreserving);"

	<virtual stdcall: hresult 72 varbool*>
	^self invalidCall: _failureCode!

get_readyState: value
	"Private - Get the value of the 'readyState' property of the receiver.

		HRESULT __stdcall readyState(
			[out, retval]long* value);"

	<virtual stdcall: hresult 60 sdword*>
	^self invalidCall: _failureCode!

get_resolveExternals: isResolving
	"Private - Get the value of the 'resolveExternals' property of the receiver.

		HRESULT __stdcall resolveExternals(
			[out, retval]VARIANT_BOOL* isResolving);"

	<virtual stdcall: hresult 70 varbool*>
	^self invalidCall: _failureCode!

get_url: urlString
	"Private - Get the value of the 'url' property of the receiver.

		HRESULT __stdcall url(
			[out, retval]BSTR* urlString);"

	<virtual stdcall: hresult 62 bstr*>
	^self invalidCall: _failureCode!

get_validateOnParse: isValidating
	"Private - Get the value of the 'validateOnParse' property of the receiver.

		HRESULT __stdcall validateOnParse(
			[out, retval]VARIANT_BOOL* isValidating);"

	<virtual stdcall: hresult 68 varbool*>
	^self invalidCall: _failureCode!

getElementsByTagName: tagName
	"Answer a <sequencedReadableCollection> on the <IXMLDOMNodeList> result 
	of invoking the COM Object's getElementsByTagName() method.
	Helpstring: 'build a list of elements by name'.
	Implementation Note: Originally auto-generated, but modified to answer a 
	Smalltalk style <collection>."

	| answer |
	answer := IXMLDOMNodeList newPointer.
	self GetElementsByTagName: tagName resultList: answer.
	^DOMNodeList on: answer!

GetElementsByTagName: tagName resultList: resultList
	"Private - Invoke the getElementsByTagName() method of the COM object.
	Helpstring: build a list of elements by name

		HRESULT __stdcall getElementsByTagName(
			[in]BSTR tagName,
			[out, retval]IXMLDOMNodeList** resultList);"

	<virtual stdcall: hresult 56 bstr IXMLDOMNodeList**>
	^self invalidCall: _failureCode!

implementation
	"Answer the <IXMLDOMImplementation> value of the 'implementation' property of the receiver.
	Helpstring: info on this DOM implementation"

	| answer |
	answer := IXMLDOMImplementation newPointer.
	self get_implementation: answer.
	^answer asObject!

initialize
	"Set up a new instance of the receiver in a standardized manner (e.g. inserting the standard processing instruction to mark
	this as version 1.0 XML, this is useful when the file is saved to a non-XML extension, since otherwise IE5 will not recognise
	as an XML file and will not display the contents."

	self addProcessingInstruction: 'xml' data: 'version="1.0"'!

load: xmlSource
	"Answer the <VARIANT_BOOL> result of invoking the load() method of the COM object.
	Helpstring: load document from the specified XML source"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		Load: xmlSource asVariant
		isSuccessful: answer.
	^answer asObject
!

Load: xmlSource isSuccessful: isSuccessful
	"Private - Invoke the load() method of the COM object.
	Helpstring: load document from the specified XML source

		HRESULT __stdcall load(
			[in]VARIANT xmlSource,
			[out, retval]VARIANT_BOOL* isSuccessful);"

	<virtual stdcall: hresult 59 variant varbool*>
	^self invalidCall: _failureCode!

loadText: xmlString
	"Parse the XML in the <readableString> argument.
	Should a parse error occur, raise a <DOMParseError> exception. If you don't
	want an exception in the case of failure, call the lower level #loadXML: method."

	(self loadXML: xmlString asString) ifFalse: [
		^self parseErrorClass signal: 'Error parsing XML text' with: self parseError]!

loadURL: urlString
	"Load the XML document at the URL specified by the <readableString> argument.
	Should a parser error occur, raise a <DOMParseError> exception. If you don't
	want an exception in the case of failure, call the lower level #load: method."

	(self load: urlString asString) ifFalse: [
		^self parseErrorClass signal: 'Error loading ', urlString printString with: self parseError]!

loadXML: bstrXML
	"Answer the <VARIANT_BOOL> result of invoking the loadXML() method of the COM object.
	Helpstring: load the document from a string"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		LoadXML: bstrXML
		isSuccessful: answer.
	^answer asObject
!

LoadXML: bstrXML isSuccessful: isSuccessful
	"Private - Invoke the loadXML() method of the COM object.
	Helpstring: load the document from a string

		HRESULT __stdcall loadXML(
			[in]BSTR bstrXML,
			[out, retval]VARIANT_BOOL* isSuccessful);"

	<virtual stdcall: hresult 66 bstr varbool*>
	^self invalidCall: _failureCode!

nodeFromID: idString
	"Answer the <IXMLDOMNode> result of invoking the nodeFromID() method of the COM object.
	Helpstring: retrieve node from it's ID"

	| answer |
	answer := IXMLDOMNode newPointer.
	self NodeFromID: idString node: answer.
	^answer asObject!

NodeFromID: idString node: node
	"Private - Invoke the nodeFromID() method of the COM object.
	Helpstring: retrieve node from it's ID

		HRESULT __stdcall nodeFromID(
			[in]BSTR idString,
			[out, retval]IXMLDOMNode** node);"

	<virtual stdcall: hresult 58 bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

ondataavailable: arg1
	"Set the 'ondataavailable' property of the receiver to the <variant> value of the argument.
	Helpstring: register an ondataavailable event handler"

	self put_ondataavailable: arg1 asVariant
!

onreadystatechange: arg1
	"Set the 'onreadystatechange' property of the receiver to the <variant> value of the argument.
	Helpstring: register a readystatechange event handler"

	self put_onreadystatechange: arg1 asVariant
!

ontransformnode: arg1
	"Set the 'ontransformnode' property of the receiver to the <variant> value of the argument.
	Helpstring: register an ontransformnode event handler"

	self put_ontransformnode: arg1 asVariant
!

ownerDocument
	"Answer an <IXMLDOMDocument> on the receiver's owning document (itself in this case)."

	^self!

parseError
	"Answer the <IXMLDOMParseError> value of the 'parseError' property of the receiver.
	Helpstring: get the last parser error"

	| answer |
	answer := IXMLDOMParseError newPointer.
	self get_parseError: answer.
	^answer asObject!

parseErrorClass
	"Private - Answer the class of <Error> to be signalled when parse errors are detected."

	^DOMParseError!

preserveWhiteSpace
	"Answer the <varbool> value of the 'preserveWhiteSpace' property of the receiver.
	Helpstring: indicates whether the parser preserves whitespace"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_preserveWhiteSpace: answer.
	^answer asObject
!

preserveWhiteSpace: isPreserving
	"Set the 'preserveWhiteSpace' property of the receiver to the <varbool> value of the argument.
	Helpstring: indicates whether the parser preserves whitespace"

	self put_preserveWhiteSpace: isPreserving
!

printValueOn: aStream 
	
	[| url |
	url := self url.
	url notEmpty ifTrue: [aStream print: url]] on: HRESULTError
			do: [:e | aStream print: bytes]!

put_async: isAsync
	"Private - Set the value of the 'async' property of the object wrapped by the 
	 receiver to the <varbool> argument, isAsync.

		HRESULT __stdcall async(
			[in]VARIANT_BOOL isAsync);"

	<virtual stdcall: hresult 64 varbool>
	^self invalidCall: _failureCode!

put_ondataavailable: arg1
	"Private - Set the value of the 'ondataavailable' property of the object wrapped by the 
	 receiver to the <variant> argument, arg1.

		HRESULT __stdcall ondataavailable(
			[in]VARIANT arg1);"

	<virtual stdcall: hresult 75 variant>
	^self invalidCall: _failureCode!

put_onreadystatechange: arg1
	"Private - Set the value of the 'onreadystatechange' property of the object wrapped by the 
	 receiver to the <variant> argument, arg1.

		HRESULT __stdcall onreadystatechange(
			[in]VARIANT arg1);"

	<virtual stdcall: hresult 74 variant>
	^self invalidCall: _failureCode!

put_ontransformnode: arg1
	"Private - Set the value of the 'ontransformnode' property of the object wrapped by the 
	 receiver to the <variant> argument, arg1.

		HRESULT __stdcall ontransformnode(
			[in]VARIANT arg1);"

	<virtual stdcall: hresult 76 variant>
	^self invalidCall: _failureCode!

put_preserveWhiteSpace: isPreserving
	"Private - Set the value of the 'preserveWhiteSpace' property of the object wrapped by the 
	 receiver to the <varbool> argument, isPreserving.

		HRESULT __stdcall preserveWhiteSpace(
			[in]VARIANT_BOOL isPreserving);"

	<virtual stdcall: hresult 73 varbool>
	^self invalidCall: _failureCode!

put_resolveExternals: isResolving
	"Private - Set the value of the 'resolveExternals' property of the object wrapped by the 
	 receiver to the <varbool> argument, isResolving.

		HRESULT __stdcall resolveExternals(
			[in]VARIANT_BOOL isResolving);"

	<virtual stdcall: hresult 71 varbool>
	^self invalidCall: _failureCode!

put_validateOnParse: isValidating
	"Private - Set the value of the 'validateOnParse' property of the object wrapped by the 
	 receiver to the <varbool> argument, isValidating.

		HRESULT __stdcall validateOnParse(
			[in]VARIANT_BOOL isValidating);"

	<virtual stdcall: hresult 69 varbool>
	^self invalidCall: _failureCode!

putref_documentElement: domElement
	"Private - Set the value of the 'documentElement' property of the object wrapped by the 
	 receiver to the <IXMLDOMElement*> argument, domElement.

		HRESULT __stdcall documentElement(
			[in]IXMLDOMElement* DOMElement);"

	<virtual stdcall: hresult 47 IXMLDOMElement*>
	^self invalidCall: _failureCode!

readyState
	"Answer the <sdword> value of the 'readyState' property of the receiver.
	Helpstring: get the state of the XML document"

	| answer |
	answer := (SDWORD new).
	self get_readyState: answer.
	^answer asObject
!

resolveExternals
	"Answer the <varbool> value of the 'resolveExternals' property of the receiver.
	Helpstring: indicates whether the parser resolves references to external DTD/Entities/Schema"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_resolveExternals: answer.
	^answer asObject
!

resolveExternals: isResolving
	"Set the 'resolveExternals' property of the receiver to the <varbool> value of the argument.
	Helpstring: indicates whether the parser resolves references to external DTD/Entities/Schema"

	self put_resolveExternals: isResolving
!

save: destination
	"Invoke the save() method of the COM object.
	Helpstring: save the document to a specified destination"

	^self Save: destination asVariant
!

Save: destination
	"Private - Invoke the save() method of the COM object.
	Helpstring: save the document to a specified destination

		HRESULT __stdcall save(
			[in]VARIANT destination);"

	<virtual stdcall: hresult 67 variant>
	^self invalidCall: _failureCode!

setDocumentElement: domElement
	"Set the 'documentElement' property of the receiver to the <IXMLDOMElement*> value of the argument.
	Helpstring: the root of the tree"

	self putref_documentElement: domElement
!

url
	"Answer the <bstr> value of the 'url' property of the receiver.
	Helpstring: get the URL for the loaded XML document"

	| answer |
	answer := BSTR new.
	self get_url: answer.
	^answer asObject
!

validateOnParse
	"Answer the <varbool> value of the 'validateOnParse' property of the receiver.
	Helpstring: indicates whether the parser performs validation"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_validateOnParse: answer.
	^answer asObject
!

validateOnParse: isValidating
	"Set the 'validateOnParse' property of the receiver to the <varbool> value of the argument.
	Helpstring: indicates whether the parser performs validation"

	self put_validateOnParse: isValidating
! !
!MSXML.IXMLDOMDocument categoriesFor: #Abort!**auto generated**!COM Interfaces-IXMLDOMDocument!public! !
!MSXML.IXMLDOMDocument categoriesFor: #async!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #async:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #createAttribute:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateAttribute:attribute:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createCDATASection:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateCDATASection:cdata:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createComment:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateComment:comment:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createDocumentFragment!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateDocumentFragment:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createElement:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateElement:element:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createEntityReference:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateEntityReference:entityRef:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createNode:name:namespaceURI:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateNode:name:namespaceURI:node:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createProcessingInstruction:data:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateProcessingInstruction:data:pi:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #createTextNode:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #CreateTextNode:text:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #doctype!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #documentElement!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #get_async:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_doctype:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_documentElement:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_implementation:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_parseError:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_preserveWhiteSpace:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_readyState:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_resolveExternals:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_url:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #get_validateOnParse:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #getElementsByTagName:!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #GetElementsByTagName:resultList:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #implementation!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #initialize!initializing!public! !
!MSXML.IXMLDOMDocument categoriesFor: #load:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #Load:isSuccessful:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #loadText:!operations!public! !
!MSXML.IXMLDOMDocument categoriesFor: #loadURL:!operations!public! !
!MSXML.IXMLDOMDocument categoriesFor: #loadXML:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #LoadXML:isSuccessful:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #nodeFromID:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #NodeFromID:node:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #ondataavailable:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #onreadystatechange:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #ontransformnode:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #ownerDocument!accessing!public! !
!MSXML.IXMLDOMDocument categoriesFor: #parseError!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #parseErrorClass!constants!private! !
!MSXML.IXMLDOMDocument categoriesFor: #preserveWhiteSpace!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #preserveWhiteSpace:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #printValueOn:!printing!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_async:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_ondataavailable:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_onreadystatechange:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_ontransformnode:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_preserveWhiteSpace:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_resolveExternals:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #put_validateOnParse:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #putref_documentElement:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #readyState!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #resolveExternals!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #resolveExternals:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #save:!**auto generated**!methods!public! !
!MSXML.IXMLDOMDocument categoriesFor: #Save:!**auto generated**!COM Interfaces-IXMLDOMDocument!private! !
!MSXML.IXMLDOMDocument categoriesFor: #setDocumentElement:!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #url!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #validateOnParse!**auto generated**!properties!public! !
!MSXML.IXMLDOMDocument categoriesFor: #validateOnParse:!**auto generated**!properties!public! !

!MSXML.IXMLDOMDocument class methodsFor!

clsid
	"Answer the <CLSID> of the DOMDocument coclass."

	^CLSID fromString: '{88d96a05-f192-11d4-a65f-0040963251e5}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMDocument'
		IXMLDOMDocument defineTemplate"

	self
		defineFunction: #get_doctype:
			argumentTypes: 'IXMLDOMDocumentType**';
		defineFunction: #get_implementation:
			argumentTypes: 'IXMLDOMImplementation**';
		defineFunction: #get_documentElement:
			argumentTypes: 'IXMLDOMElement**';
		defineFunction: #putref_documentElement:
			argumentTypes: 'IXMLDOMElement*';
		defineFunction: #CreateElement:element:
			argumentTypes: 'bstr IXMLDOMElement**';
		defineFunction: #CreateDocumentFragment:
			argumentTypes: 'IXMLDOMDocumentFragment**';
		defineFunction: #CreateTextNode:text:
			argumentTypes: 'bstr IXMLDOMText**';
		defineFunction: #CreateComment:comment:
			argumentTypes: 'bstr IXMLDOMComment**';
		defineFunction: #CreateCDATASection:cdata:
			argumentTypes: 'bstr IXMLDOMCDATASection**';
		defineFunction: #CreateProcessingInstruction:data:pi:
			argumentTypes: 'bstr bstr IXMLDOMProcessingInstruction**';
		defineFunction: #CreateAttribute:attribute:
			argumentTypes: 'bstr IXMLDOMAttribute**';
		defineFunction: #CreateEntityReference:entityRef:
			argumentTypes: 'bstr IXMLDOMEntityReference**';
		defineFunction: #GetElementsByTagName:resultList:
			argumentTypes: 'bstr IXMLDOMNodeList**';
		defineFunction: #CreateNode:name:namespaceURI:node:
			argumentTypes: 'variant bstr bstr IXMLDOMNode**';
		defineFunction: #NodeFromID:node:
			argumentTypes: 'bstr IXMLDOMNode**';
		defineFunction: #Load:isSuccessful:
			argumentTypes: 'variant varbool*';
		defineFunction: #get_readyState:
			argumentTypes: 'sdword*';
		defineFunction: #get_parseError:
			argumentTypes: 'IXMLDOMParseError**';
		defineFunction: #get_url:
			argumentTypes: 'bstr*';
		defineFunction: #get_async:
			argumentTypes: 'varbool*';
		defineFunction: #put_async:
			argumentTypes: 'varbool';
		defineFunction: #Abort;
		defineFunction: #LoadXML:isSuccessful:
			argumentTypes: 'bstr varbool*';
		defineFunction: #Save:
			argumentTypes: 'variant';
		defineFunction: #get_validateOnParse:
			argumentTypes: 'varbool*';
		defineFunction: #put_validateOnParse:
			argumentTypes: 'varbool';
		defineFunction: #get_resolveExternals:
			argumentTypes: 'varbool*';
		defineFunction: #put_resolveExternals:
			argumentTypes: 'varbool';
		defineFunction: #get_preserveWhiteSpace:
			argumentTypes: 'varbool*';
		defineFunction: #put_preserveWhiteSpace:
			argumentTypes: 'varbool';
		defineFunction: #put_onreadystatechange:
			argumentTypes: 'variant';
		defineFunction: #put_ondataavailable:
			argumentTypes: 'variant';
		defineFunction: #put_ontransformnode:
			argumentTypes: 'variant'
!

new
	"When creating a new instance of the receiver we'd like it initialized to include the standard
		<?xml version='1.0' ?> processing instruction."

	^super new initialize! !
!MSXML.IXMLDOMDocument class categoriesFor: #clsid!constants!public! !
!MSXML.IXMLDOMDocument class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!MSXML.IXMLDOMDocument class categoriesFor: #new!instance creation!public! !

