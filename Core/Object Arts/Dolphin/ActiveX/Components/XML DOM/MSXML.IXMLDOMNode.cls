"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IXMLDOMNode'
	instanceVariableNames: ''
	classVariableNames: 'NodeTypes VarTypeToXMLDataType'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMNode guid: (OS.COM.IID fromString: '{2933bf80-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMNode comment: '<IXMLDOMNode> is a wrapper class for the COM interface ''MSXML.IXMLDOMNode'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is the generic interface for a single node in the DOM document tree. In the Dolphin wrapping of the DOM you should rarely, if ever, see instances of this interface since we automatically downcast to the correct specialized type of node (using the nodeType) whenever an interface method returns an interface of this generic type.'!
!MSXML.IXMLDOMNode categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMNode methodsFor!

= anObject 
	^self class == anObject class and: [self childNodes = anObject childNodes]!

addCDATASection: sectionName
	"Create and append a new CDATA section to the receiver with the <readableString> name, 
	sectionName. Answer an <IXMLDOMCDATASection> on the new node."

	| node doc |
	doc := self ownerDocument.
	node := doc createCDATASection: sectionName.
	self appendChild: node.
	^node
!

addComment: data
	"Create and append a new comment node to the receiver with the specified content.
	Answer an <IXMLDOMComment> on the new node."

	| node doc |
	doc := self ownerDocument.
	node := doc createComment: data.
	self appendChild: node.
	^node
!

addElement: baseName
	"Create and append a new element node to the receiver with the <readableString> name, 
	baseName. Answer an <IXMLDOMElement> on the new node."

	| node doc |
	doc := self ownerDocument.
	node := doc createElement: baseName.
	self appendChild: node.
	^node
!

addProcessingInstruction: target data: data 
	"Create and append a new processing instruction node to the receiver.
	Answer an <IXMLDOMProcessingInstruction> interface no the new node."

	| node doc |
	doc := self ownerDocument.
	node := doc createProcessingInstruction: target data: data.
	self appendChild: node.
	^node!

addTextNode: text
	"Create and append a new text node to the receiver with the <readableString> contents, 
	text. Answer an <IXMLDOMText> on the new node."

	| node doc |
	doc := self ownerDocument.
	node := doc createTextNode: text.
	self appendChild: node.
	^node!

appendChild: newChild
	"Answer the <IXMLDOMNode> result of invoking the appendChild() method of the COM object.
	Helpstring: append a child node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self AppendChild: newChild outNewChild: answer.
	^answer asObject!

AppendChild: newChild outNewChild: outNewChild
	"Private - Invoke the appendChild() method of the COM object.
	Helpstring: append a child node

		HRESULT __stdcall appendChild(
			[in]IXMLDOMNode* newChild,
			[out, retval]IXMLDOMNode** outNewChild);"

	<virtual stdcall: hresult 22 IXMLDOMNode* IXMLDOMNode**>
	^self invalidCall: _failureCode!

asImplType
	"Attempt to 'cast' the receiver down from IDispatch to its actual derived interface
	class if type information is available, and a wrapper class has previously been generated
	for the interface. This may be a bit slow, which is why we don't do it by default in 
	#asObject, but it can be very handy and is completely safe."

	^self notNull ifTrue: [
		self class == ##(self)
			ifTrue: [self downCast]
			ifFalse: [self]]
!

asObject
	"Answer the <Object> value represented by the receiver.
	Implementation Note: Override to do a downcast where required.
	Note that null results are quite common in the DOM where one might 
	expect errors, and these are (as usual) mapped to nil."

	^self asImplType!

attributes
	"Answer the <IXMLDOMNamedNodeMap> value of the 'attributes' property of the receiver.
	Helpstring: 'the collection of the node''s attributes'.
	Implementation Note: Originally auto-generated, but modified to return a Smalltalk
	style <Dictionary>. Also we treat attempts to access the attributes of a text only node
	as an error, rather than returning a null."

	| answer |
	answer := IXMLDOMNamedNodeMap newPointer.
	self get_attributes: answer.
	answer isNull
		ifTrue: [self error: 'Node does not (cannot) have any attributes, e.g. it is a text only node'].
	^DOMAttributeMap onInterface: answer parentNode: self!

baseName
	"Answer the <bstr> value of the 'baseName' property of the receiver.
	Helpstring: the base name of the node (nodename with the prefix stripped off)"

	| answer |
	answer := BSTR new.
	self get_baseName: answer.
	^answer asObject!

childNodes
	"Answer the a <sequencedReadableCollection> on the <IXMLDOMNodeList> 
	value of the 'childNodes' property of the receiver.
	Helpstring: 'the collection of the node''s children'
	Implementation Note: Originally auto-generated, but modified to return a Smalltalk
	style <collection>."

	| answer |
	answer := IXMLDOMNodeList newPointer.
	self get_childNodes: answer.
	^DOMNodeList on: answer!

cloneNode: deep
	"Answer the <IXMLDOMNode> result of invoking the cloneNode() method of the COM object."

	| answer |
	answer := IXMLDOMNode newPointer.
	self CloneNode: deep cloneRoot: answer.
	^answer asObject!

CloneNode: deep cloneRoot: cloneRoot
	"Private - Invoke the cloneNode() method of the COM object.

		HRESULT __stdcall cloneNode(
			[in]VARIANT_BOOL deep,
			[out, retval]IXMLDOMNode** cloneRoot);"

	<virtual stdcall: hresult 25 varbool IXMLDOMNode**>
	^self invalidCall: _failureCode!

dataType
	"Answer the <variant> value of the 'dataType' property of the receiver.
	Helpstring: the data type of the node"

	| answer |
	answer := VARIANT new.
	self get_dataType: answer.
	^answer asObject!

dataType: dataTypeName
	"Set the 'dataType' property of the receiver to the <bstr> value of the argument.
	Helpstring: the data type of the node"

	self put_dataType: dataTypeName!

definition
	"Answer the <IXMLDOMNode> value of the 'definition' property of the receiver.
	Helpstring: pointer to the definition of the node in the DTD or schema"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_definition: answer.
	^answer asObject!

downCast
	"Attempt to 'cast' the receiver down to a derived dual interface class 
	if type information is available, and a wrapper class has previously been generated
	for the interface.
	Implementation Note: Override because there is a much faster way to do this
	with DOM nodes because there is a type id in the base interface."

	| specializedClass |
	^self class == (specializedClass := self nodeTypes at: self nodeType ifAbsent: [IXMLDOMNode])
		ifTrue: [self]
		ifFalse: [self queryInterface: specializedClass]!

firstChild
	"Answer the <IXMLDOMNode> value of the 'firstChild' property of the receiver.
	Helpstring: first child of the node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_firstChild: answer.
	^answer asObject!

get_attributes: attributeMap
	"Private - Get the value of the 'attributes' property of the receiver.

		HRESULT __stdcall attributes(
			[out, retval]IXMLDOMNamedNodeMap** attributeMap);"

	<virtual stdcall: hresult 18 IXMLDOMNamedNodeMap**>
	^self invalidCall: _failureCode!

get_baseName: nameString
	"Private - Get the value of the 'baseName' property of the receiver.

		HRESULT __stdcall baseName(
			[out, retval]BSTR* nameString);"

	<virtual stdcall: hresult 42 bstr*>
	^self invalidCall: _failureCode!

get_childNodes: childList
	"Private - Get the value of the 'childNodes' property of the receiver.

		HRESULT __stdcall childNodes(
			[out, retval]IXMLDOMNodeList** childList);"

	<virtual stdcall: hresult 13 IXMLDOMNodeList**>
	^self invalidCall: _failureCode!

get_dataType: dataTypeName
	"Private - Get the value of the 'dataType' property of the receiver.

		HRESULT __stdcall dataType(
			[out, retval]VARIANT* dataTypeName);"

	<virtual stdcall: hresult 33 variant*>
	^self invalidCall: _failureCode!

get_definition: definitionNode
	"Private - Get the value of the 'definition' property of the receiver.

		HRESULT __stdcall definition(
			[out, retval]IXMLDOMNode** definitionNode);"

	<virtual stdcall: hresult 30 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_firstChild: firstChild
	"Private - Get the value of the 'firstChild' property of the receiver.

		HRESULT __stdcall firstChild(
			[out, retval]IXMLDOMNode** firstChild);"

	<virtual stdcall: hresult 14 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_lastChild: lastChild
	"Private - Get the value of the 'lastChild' property of the receiver.

		HRESULT __stdcall lastChild(
			[out, retval]IXMLDOMNode** lastChild);"

	<virtual stdcall: hresult 15 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_namespaceURI: namespaceURI
	"Private - Get the value of the 'namespaceURI' property of the receiver.

		HRESULT __stdcall namespaceURI(
			[out, retval]BSTR* namespaceURI);"

	<virtual stdcall: hresult 40 bstr*>
	^self invalidCall: _failureCode!

get_nextSibling: nextSibling
	"Private - Get the value of the 'nextSibling' property of the receiver.

		HRESULT __stdcall nextSibling(
			[out, retval]IXMLDOMNode** nextSibling);"

	<virtual stdcall: hresult 17 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_nodeName: name
	"Private - Get the value of the 'nodeName' property of the receiver.

		HRESULT __stdcall nodeName(
			[out, retval]BSTR* name);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_nodeType: type
	"Private - Get the value of the 'nodeType' property of the receiver.

		HRESULT __stdcall nodeType(
			[out, retval]DOMNodeType* type);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_nodeTypedValue: typedValue
	"Private - Get the value of the 'nodeTypedValue' property of the receiver.

		HRESULT __stdcall nodeTypedValue(
			[out, retval]VARIANT* typedValue);"

	<virtual stdcall: hresult 31 variant*>
	^self invalidCall: _failureCode!

get_nodeTypeString: nodeType
	"Private - Get the value of the 'nodeTypeString' property of the receiver.

		HRESULT __stdcall nodeTypeString(
			[out, retval]BSTR* nodeType);"

	<virtual stdcall: hresult 26 bstr*>
	^self invalidCall: _failureCode!

get_nodeValue: value
	"Private - Get the value of the 'nodeValue' property of the receiver.

		HRESULT __stdcall nodeValue(
			[out, retval]VARIANT* value);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall: _failureCode!

get_ownerDocument: xmldomDocument
	"Private - Get the value of the 'ownerDocument' property of the receiver.

		HRESULT __stdcall ownerDocument(
			[out, retval]IXMLDOMDocument** XMLDOMDocument);"

	<virtual stdcall: hresult 24 IXMLDOMDocument**>
	^self invalidCall: _failureCode!

get_parentNode: parent
	"Private - Get the value of the 'parentNode' property of the receiver.

		HRESULT __stdcall parentNode(
			[out, retval]IXMLDOMNode** parent);"

	<virtual stdcall: hresult 12 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_parsed: isParsed
	"Private - Get the value of the 'parsed' property of the receiver.

		HRESULT __stdcall parsed(
			[out, retval]VARIANT_BOOL* isParsed);"

	<virtual stdcall: hresult 39 varbool*>
	^self invalidCall: _failureCode!

get_prefix: prefixString
	"Private - Get the value of the 'prefix' property of the receiver.

		HRESULT __stdcall prefix(
			[out, retval]BSTR* prefixString);"

	<virtual stdcall: hresult 41 bstr*>
	^self invalidCall: _failureCode!

get_previousSibling: previousSibling
	"Private - Get the value of the 'previousSibling' property of the receiver.

		HRESULT __stdcall previousSibling(
			[out, retval]IXMLDOMNode** previousSibling);"

	<virtual stdcall: hresult 16 IXMLDOMNode**>
	^self invalidCall: _failureCode!

get_specified: isSpecified
	"Private - Get the value of the 'specified' property of the receiver.

		HRESULT __stdcall specified(
			[out, retval]VARIANT_BOOL* isSpecified);"

	<virtual stdcall: hresult 29 varbool*>
	^self invalidCall: _failureCode!

get_text: text
	"Private - Get the value of the 'text' property of the receiver.

		HRESULT __stdcall text(
			[out, retval]BSTR* text);"

	<virtual stdcall: hresult 27 bstr*>
	^self invalidCall: _failureCode!

get_xml: xmlString
	"Private - Get the value of the 'xml' property of the receiver.

		HRESULT __stdcall xml(
			[out, retval]BSTR* xmlString);"

	<virtual stdcall: hresult 35 bstr*>
	^self invalidCall: _failureCode!

hasChildNodes
	"Answer the <varbool> result of invoking the hasChildNodes() method of the COM object."

	| answer |
	answer := VARIANT_BOOL new.
	self HasChildNodes: answer.
	^answer asObject!

HasChildNodes: hasChild
	"Private - Invoke the hasChildNodes() method of the COM object.

		HRESULT __stdcall hasChildNodes(
			[out, retval]VARIANT_BOOL* hasChild);"

	<virtual stdcall: hresult 23 varbool*>
	^self invalidCall: _failureCode!

innerXML
	"Answer the XML text of all child nodes of the receiver."

	^self childNodes xml!

insertBefore: newChild refChild: refChild
	"Answer the <IXMLDOMNode> result of invoking the insertBefore() method of the COM object.
	Helpstring: insert a child node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		InsertBefore: newChild
		refChild: refChild asVariant
		outNewChild: answer.
	^answer asObject!

InsertBefore: newChild refChild: refChild outNewChild: outNewChild
	"Private - Invoke the insertBefore() method of the COM object.
	Helpstring: insert a child node

		HRESULT __stdcall insertBefore(
			[in]IXMLDOMNode* newChild,
			[in]VARIANT refChild,
			[out, retval]IXMLDOMNode** outNewChild);"

	<virtual stdcall: hresult 19 IXMLDOMNode* variant IXMLDOMNode**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isText
	"Answer whether this is a text only node."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

lastChild
	"Answer the <IXMLDOMNode> value of the 'lastChild' property of the receiver.
	Helpstring: last child of the node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_lastChild: answer.
	^answer asObject!

namespaceURI
	"Answer the <bstr> value of the 'namespaceURI' property of the receiver.
	Helpstring: the URI for the namespace applying to the node"

	| answer |
	answer := BSTR new.
	self get_namespaceURI: answer.
	^answer asObject!

nextSibling
	"Answer the <IXMLDOMNode> value of the 'nextSibling' property of the receiver.
	Helpstring: right sibling of the node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_nextSibling: answer.
	^answer asObject!

nodeName
	"Answer the <bstr> value of the 'nodeName' property of the receiver.
	Helpstring: name of the node"

	| answer |
	answer := BSTR new.
	self get_nodeName: answer.
	^answer asObject!

nodeType
	"Answer the <sdword> value of the 'nodeType' property of the receiver.
	Helpstring: the node's type"

	| answer |
	answer := SDWORD new.
	self get_nodeType: answer.
	^answer asObject!

nodeTypedValue
	"Answer the <variant> value of the 'nodeTypedValue' property of the receiver.
	Helpstring: get the strongly typed value of the node"

	| answer |
	answer := VARIANT new.
	self get_nodeTypedValue: answer.
	^answer asObject!

nodeTypedValue: typedValue
	"Set the 'nodeTypedValue' property of the receiver to the <variant> value of the argument.
	Helpstring: get the strongly typed value of the node"

	self put_nodeTypedValue: typedValue asVariant!

nodeTypes
	^##((Array new: 12)
		at: NODE_ELEMENT put: IXMLDOMElement;
		at: NODE_ATTRIBUTE put: IXMLDOMAttribute;
		at: NODE_TEXT put: IXMLDOMText;
		at: NODE_CDATA_SECTION put: IXMLDOMCDATASection;
		at: NODE_ENTITY_REFERENCE put: IXMLDOMEntityReference;
		at: NODE_ENTITY put: IXMLDOMEntity;
		at: NODE_PROCESSING_INSTRUCTION put: IXMLDOMProcessingInstruction;
		at: NODE_COMMENT put: IXMLDOMComment;
		at: NODE_DOCUMENT put: IXMLDOMDocument;
		at: NODE_DOCUMENT_TYPE put: IXMLDOMDocumentType;
		at: NODE_DOCUMENT_FRAGMENT put: IXMLDOMDocumentFragment;
		at: NODE_NOTATION put: IXMLDOMNotation;
		yourself)!

nodeTypeString
	"Answer the <bstr> value of the 'nodeTypeString' property of the receiver.
	Helpstring: the type of node in string form"

	| answer |
	answer := BSTR new.
	self get_nodeTypeString: answer.
	^answer asObject!

nodeValue
	"Answer the <variant> value of the 'nodeValue' property of the receiver.
	Helpstring: value stored in the node"

	| answer |
	answer := VARIANT new.
	self get_nodeValue: answer.
	^answer asObject!

nodeValue: value
	"Set the 'nodeValue' property of the receiver to the <variant> value of the argument.
	Helpstring: value stored in the node"

	self put_nodeValue: value asVariant!

ownerDocument
	"Answer the <IXMLDOMDocument> value of the 'ownerDocument' property of the receiver.
	Helpstring: document that contains the node"

	| answer |
	answer := IXMLDOMDocument newPointer.
	self get_ownerDocument: answer.
	^answer asObject!

parentNode
	"Answer the <IXMLDOMNode> value of the 'parentNode' property of the receiver.
	Helpstring: parent of the node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_parentNode: answer.
	^answer asObject!

parsed
	"Answer the <varbool> value of the 'parsed' property of the receiver.
	Helpstring: has sub-tree been completely parsed"

	| answer |
	answer := VARIANT_BOOL new.
	self get_parsed: answer.
	^answer asObject!

prefix
	"Answer the <bstr> value of the 'prefix' property of the receiver.
	Helpstring: the prefix for the namespace applying to the node"

	| answer |
	answer := BSTR new.
	self get_prefix: answer.
	^answer asObject!

previousSibling
	"Answer the <IXMLDOMNode> value of the 'previousSibling' property of the receiver.
	Helpstring: left sibling of the node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_previousSibling: answer.
	^answer asObject!

printValueOn: aStream
	aStream print: ([self nodeName] on: HRESULTError
				do: [:e | [self contents] on: HRESULTError do: [:e2 | bytes]])!

put_dataType: dataTypeName
	"Private - Set the value of the 'dataType' property of the object wrapped by the 
	 receiver to the <bstr> argument, dataTypeName.

		HRESULT __stdcall dataType(
			[in]BSTR dataTypeName);"

	<virtual stdcall: hresult 34 bstr>
	^self invalidCall: _failureCode!

put_nodeTypedValue: typedValue
	"Private - Set the value of the 'nodeTypedValue' property of the object wrapped by the 
	 receiver to the <variant> argument, typedValue.

		HRESULT __stdcall nodeTypedValue(
			[in]VARIANT typedValue);"

	<virtual stdcall: hresult 32 variant>
	^self invalidCall: _failureCode!

put_nodeValue: value
	"Private - Set the value of the 'nodeValue' property of the object wrapped by the 
	 receiver to the <variant> argument, value.

		HRESULT __stdcall nodeValue(
			[in]VARIANT value);"

	<virtual stdcall: hresult 10 variant>
	^self invalidCall: _failureCode!

put_text: text
	"Private - Set the value of the 'text' property of the object wrapped by the 
	 receiver to the <bstr> argument, text.

		HRESULT __stdcall text(
			[in]BSTR text);"

	<virtual stdcall: hresult 28 bstr>
	^self invalidCall: _failureCode!

removeChild: childNode
	"Answer the <IXMLDOMNode> result of invoking the removeChild() method of the COM object.
	Helpstring: remove a child node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self RemoveChild: childNode oldChild: answer.
	^answer asObject!

RemoveChild: childNode oldChild: oldChild
	"Private - Invoke the removeChild() method of the COM object.
	Helpstring: remove a child node

		HRESULT __stdcall removeChild(
			[in]IXMLDOMNode* childNode,
			[out, retval]IXMLDOMNode** oldChild);"

	<virtual stdcall: hresult 21 IXMLDOMNode* IXMLDOMNode**>
	^self invalidCall: _failureCode!

replaceChild: newChild oldChild: oldChild
	"Answer the <IXMLDOMNode> result of invoking the replaceChild() method of the COM object.
	Helpstring: replace a child node"

	| answer |
	answer := IXMLDOMNode newPointer.
	self
		ReplaceChild: newChild
		oldChild: oldChild
		outOldChild: answer.
	^answer asObject!

ReplaceChild: newChild oldChild: oldChild outOldChild: outOldChild
	"Private - Invoke the replaceChild() method of the COM object.
	Helpstring: replace a child node

		HRESULT __stdcall replaceChild(
			[in]IXMLDOMNode* newChild,
			[in]IXMLDOMNode* oldChild,
			[out, retval]IXMLDOMNode** outOldChild);"

	<virtual stdcall: hresult 20 IXMLDOMNode* IXMLDOMNode* IXMLDOMNode**>
	^self invalidCall: _failureCode!

selectNodes: queryString
	"Answer a <sequencedReadableCollection> on the <IXMLDOMNodeList> result 
	<IXMLDOMNodeList> result of invoking the COM Object's selectNodes() method.
	Helpstring: 'execute query on the subtree'.
	Implementation Note: Originally auto-generated, but modified to answer a Smalltalk	
	style <collection>."

	| answer |
	answer := IXMLDOMNodeList newPointer.
	self SelectNodes: queryString resultList: answer.
	^DOMNodeList on: answer!

SelectNodes: queryString resultList: resultList
	"Private - Invoke the selectNodes() method of the COM object.
	Helpstring: execute query on the subtree

		HRESULT __stdcall selectNodes(
			[in]BSTR queryString,
			[out, retval]IXMLDOMNodeList** resultList);"

	<virtual stdcall: hresult 37 bstr IXMLDOMNodeList**>
	^self invalidCall: _failureCode!

selectSingleNode: queryString
	"Answer the <IXMLDOMNode> result of invoking the selectSingleNode() method of the COM object.
	Helpstring: execute query on the subtree"

	| answer |
	answer := IXMLDOMNode newPointer.
	self SelectSingleNode: queryString resultNode: answer.
	^answer asObject!

SelectSingleNode: queryString resultNode: resultNode
	"Private - Invoke the selectSingleNode() method of the COM object.
	Helpstring: execute query on the subtree

		HRESULT __stdcall selectSingleNode(
			[in]BSTR queryString,
			[out, retval]IXMLDOMNode** resultNode);"

	<virtual stdcall: hresult 38 bstr IXMLDOMNode**>
	^self invalidCall: _failureCode!

setNodeTypeAndValue: anObject
	"Set the 'dataType' and 'nodeTypedValue' properties of the receiver to the 
	<VARIANT> equivalent of the <Object> argument, using its type to set
	the appropriate XML Data Type."

	| value vt dataType |
	value := anObject asVariant.
	vt := value vartype.
	dataType := VarTypeToXMLDataType at: vt
				ifAbsent: 
					[value := value changeType: VT_BSTR.
					'string'].
	dataType isNil 
		ifTrue: [
			"Arrange so that nodeTypedValue will return 'nil'"
			self put_text: nil; put_dataType: 'char']
		ifFalse: 
			[self
				put_text: nil;
				put_dataType: dataType;
				put_nodeTypedValue: value]
!

specified
	"Answer the <varbool> value of the 'specified' property of the receiver.
	Helpstring: indicates whether node is a default value"

	| answer |
	answer := VARIANT_BOOL new.
	self get_specified: answer.
	^answer asObject!

text
	"Answer the <bstr> value of the 'text' property of the receiver.
	Helpstring: text content of the node and subtree"

	| bstr text |
	bstr := BSTR new.
	self get_text: bstr.
	text := bstr asString.
	bstr free.
	^text!

text: text
	"Set the 'text' property of the receiver to the <bstr> value of the argument.
	Helpstring: text content of the node and subtree"

	self put_text: text!

transformNode: stylesheet
	"Answer the <bstr> result of invoking the transformNode() method of the COM object.
	Helpstring: apply the stylesheet to the subtree"

	| answer |
	answer := BSTR new.
	self TransformNode: stylesheet xmlString: answer.
	^answer asObject!

TransformNode: stylesheet xmlString: xmlString
	"Private - Invoke the transformNode() method of the COM object.
	Helpstring: apply the stylesheet to the subtree

		HRESULT __stdcall transformNode(
			[in]IXMLDOMNode* stylesheet,
			[out, retval]BSTR* xmlString);"

	<virtual stdcall: hresult 36 IXMLDOMNode* bstr*>
	^self invalidCall: _failureCode!

transformNodeToObject: stylesheet outputObject: outputObject
	"Invoke the transformNodeToObject() method of the COM object.
	Helpstring: apply the stylesheet to the subtree, returning the result through a document or a stream"

	^self TransformNodeToObject: stylesheet outputObject: outputObject asVariant!

TransformNodeToObject: stylesheet outputObject: outputObject
	"Private - Invoke the transformNodeToObject() method of the COM object.
	Helpstring: apply the stylesheet to the subtree, returning the result through a document or a stream

		HRESULT __stdcall transformNodeToObject(
			[in]IXMLDOMNode* stylesheet,
			[in]VARIANT outputObject);"

	<virtual stdcall: hresult 43 IXMLDOMNode* variant>
	^self invalidCall: _failureCode!

xml
	"Answer the <bstr> value of the 'xml' property of the receiver.
	Helpstring: return the XML source for the node and each of its descendants"

	| answer |
	answer := BSTR new.
	self get_xml: answer.
	^answer asObject! !
!MSXML.IXMLDOMNode categoriesFor: #=!comparing!public! !
!MSXML.IXMLDOMNode categoriesFor: #addCDATASection:!adding!public! !
!MSXML.IXMLDOMNode categoriesFor: #addComment:!adding!public! !
!MSXML.IXMLDOMNode categoriesFor: #addElement:!adding!public! !
!MSXML.IXMLDOMNode categoriesFor: #addProcessingInstruction:data:!adding!public! !
!MSXML.IXMLDOMNode categoriesFor: #addTextNode:!adding!public! !
!MSXML.IXMLDOMNode categoriesFor: #appendChild:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #AppendChild:outNewChild:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #asImplType!converting!public! !
!MSXML.IXMLDOMNode categoriesFor: #asObject!converting!public! !
!MSXML.IXMLDOMNode categoriesFor: #attributes!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #baseName!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #childNodes!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #cloneNode:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #CloneNode:cloneRoot:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #dataType!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #dataType:!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #definition!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #downCast!converting!public! !
!MSXML.IXMLDOMNode categoriesFor: #firstChild!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #get_attributes:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_baseName:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_childNodes:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_dataType:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_definition:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_firstChild:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_lastChild:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_namespaceURI:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_nextSibling:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_nodeName:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_nodeType:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_nodeTypedValue:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_nodeTypeString:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_nodeValue:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_ownerDocument:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_parentNode:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_parsed:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_prefix:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_previousSibling:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_specified:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_text:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #get_xml:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #hasChildNodes!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #HasChildNodes:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #innerXML!accessing!public! !
!MSXML.IXMLDOMNode categoriesFor: #insertBefore:refChild:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #InsertBefore:refChild:outNewChild:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IXMLDOMNode categoriesFor: #isText!public!testing! !
!MSXML.IXMLDOMNode categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IXMLDOMNode categoriesFor: #lastChild!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #namespaceURI!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nextSibling!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeName!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeType!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeTypedValue!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeTypedValue:!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeTypes!constants!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeTypeString!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeValue!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #nodeValue:!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #ownerDocument!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #parentNode!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #parsed!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #prefix!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #previousSibling!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #printValueOn:!printing!private! !
!MSXML.IXMLDOMNode categoriesFor: #put_dataType:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #put_nodeTypedValue:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #put_nodeValue:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #put_text:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #removeChild:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #RemoveChild:oldChild:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #replaceChild:oldChild:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #ReplaceChild:oldChild:outOldChild:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #selectNodes:!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #SelectNodes:resultList:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #selectSingleNode:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #SelectSingleNode:resultNode:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #setNodeTypeAndValue:!accessing!public! !
!MSXML.IXMLDOMNode categoriesFor: #specified!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #text!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #text:!**auto generated**!properties!public! !
!MSXML.IXMLDOMNode categoriesFor: #transformNode:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #TransformNode:xmlString:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #transformNodeToObject:outputObject:!**auto generated**!methods!public! !
!MSXML.IXMLDOMNode categoriesFor: #TransformNodeToObject:outputObject:!**auto generated**!COM Interfaces-IXMLDOMNode!private! !
!MSXML.IXMLDOMNode categoriesFor: #xml!**auto generated**!properties!public! !

!MSXML.IXMLDOMNode class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMNode'
		IXMLDOMNode defineTemplate"

	self
		defineFunction: #get_nodeName:
			argumentTypes: 'bstr*';
		defineFunction: #get_nodeValue:
			argumentTypes: 'variant*';
		defineFunction: #put_nodeValue:
			argumentTypes: 'variant';
		defineFunction: #get_nodeType:
			argumentTypes: 'sdword*';
		defineFunction: #get_parentNode:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #get_childNodes:
			argumentTypes: 'IXMLDOMNodeList**';
		defineFunction: #get_firstChild:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #get_lastChild:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #get_previousSibling:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #get_nextSibling:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #get_attributes:
			argumentTypes: 'IXMLDOMNamedNodeMap**';
		defineFunction: #InsertBefore:refChild:outNewChild:
			argumentTypes: 'IXMLDOMNode* variant IXMLDOMNode**';
		defineFunction: #ReplaceChild:oldChild:outOldChild:
			argumentTypes: 'IXMLDOMNode* IXMLDOMNode* IXMLDOMNode**';
		defineFunction: #RemoveChild:oldChild:
			argumentTypes: 'IXMLDOMNode* IXMLDOMNode**';
		defineFunction: #AppendChild:outNewChild:
			argumentTypes: 'IXMLDOMNode* IXMLDOMNode**';
		defineFunction: #HasChildNodes:
			argumentTypes: 'varbool*';
		defineFunction: #get_ownerDocument:
			argumentTypes: 'IXMLDOMDocument**';
		defineFunction: #CloneNode:cloneRoot:
			argumentTypes: 'varbool IXMLDOMNode**';
		defineFunction: #get_nodeTypeString:
			argumentTypes: 'bstr*';
		defineFunction: #get_text:
			argumentTypes: 'bstr*';
		defineFunction: #put_text:
			argumentTypes: 'bstr';
		defineFunction: #get_specified:
			argumentTypes: 'varbool*';
		defineFunction: #get_definition:
			argumentTypes: 'IXMLDOMNode**';
		defineFunction: #get_nodeTypedValue:
			argumentTypes: 'variant*';
		defineFunction: #put_nodeTypedValue:
			argumentTypes: 'variant';
		defineFunction: #get_dataType:
			argumentTypes: 'variant*';
		defineFunction: #put_dataType:
			argumentTypes: 'bstr';
		defineFunction: #get_xml:
			argumentTypes: 'bstr*';
		defineFunction: #TransformNode:xmlString:
			argumentTypes: 'IXMLDOMNode* bstr*';
		defineFunction: #SelectNodes:resultList:
			argumentTypes: 'bstr IXMLDOMNodeList**';
		defineFunction: #SelectSingleNode:resultNode:
			argumentTypes: 'bstr IXMLDOMNode**';
		defineFunction: #get_parsed:
			argumentTypes: 'varbool*';
		defineFunction: #get_namespaceURI:
			argumentTypes: 'bstr*';
		defineFunction: #get_prefix:
			argumentTypes: 'bstr*';
		defineFunction: #get_baseName:
			argumentTypes: 'bstr*';
		defineFunction: #TransformNodeToObject:outputObject:
			argumentTypes: 'IXMLDOMNode* variant'
!

initialize
	"Private - Initialize the receiver's class variables.
		IXMLDOMNode initialize
	"

	super initialize.	"COMInterfaces are unusual in that must supersend class initialize"
	VarTypeToXMLDataType := IdentityDictionary new.
	VarTypeToXMLDataType
		at: VT_BOOL put: 'boolean';
		at: VT_BSTR put: 'string';
		at: VT_CLSID put: 'uuid';
		at: VT_CY put: 'number';
		at: VT_DATE put: 'dateTime';
		at: VT_DECIMAL put: 'number';
		at: VT_EMPTY put: nil;
		at: VT_ERROR put: 'i4';
		at: VT_FILETIME put: 'dateTime';
		at: VT_HRESULT put: 'i4';
		at: VT_I1 put: 'i1';
		at: VT_I2 put: 'i2';
		at: VT_I4 put: 'i4';
		at: VT_I8 put: 'i8';
		at: VT_INT put: 'i4';
		at: VT_LPSTR put: 'string';
		at: VT_LPWSTR put: 'string';
		at: VT_NULL put: nil;
		at: VT_R4 put: 'r4';
		at: VT_R8 put: 'r8';
		at: VT_UINT put: 'ui4';
		at: VT_UI1 put: 'ui1';
		at: VT_UI2 put: 'ui2';
		at: VT_UI4 put: 'ui4';
		at: VT_UI8 put: 'ui8';
		shrink! !
!MSXML.IXMLDOMNode class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!MSXML.IXMLDOMNode class categoriesFor: #initialize!initializing!private! !

