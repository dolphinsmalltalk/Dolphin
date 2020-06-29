"Filed out from Dolphin Smalltalk 7"!

IXMLDOMNode subclass: #IXMLDOMDocumentFragment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IXMLDOMDocumentFragment guid: (IID fromString: '{3efaa413-272f-11d2-836f-0000f87a7782}')!
IXMLDOMDocumentFragment comment: '<IXMLDOMDocumentFragment> is a wrapper class for the COM interface ''MSXML.IXMLDOMDocumentFragment'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent document fragments, which are lightweight objects useful for tree insert operatins.

From MSDN:

"The DocumentFragment object can represent a fragment of a document or portion of a document''s tree. This makes it useful when implementing end user commands that allow users to rearrange a document, such as cutting and pasting.

The DocumentFragment node has special, defined behavior for IXMLDOMNode insert operations that makes it especially convenient for developers. When an IXMLDOMDocumentFragment is inserted into a DOMDocument node (or other node that can take children), the children of the DocumentFragment are inserted into the node rather than the DocumentFragment itself. This makes the DocumentFragment useful when the user wants to create nodes that are siblings; the DocumentFragment acts as the parent of these nodes so that the user can employ the standard methods from the IXMLDOMNode interface, such as insertBefore and appendChild.

The children of a DocumentFragment node make up zero or more nodes representing the tops of any subtrees defining the structure of the document. DocumentFragment nodes do not need to be well-formed XML documents (although they do need to follow the rules imposed upon well-formed XML parsed entities, which can have multiple top nodes). For example, a DocumentFragment might have only one child, and that child node could be a Text node. Such a structure model represents neither an HTML document nor a well-formed XML document.

IXMLDOMDocumentFragment has no unique members of its own, but exposes the same members as IXMLDOMNode."'!
!IXMLDOMDocumentFragment categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
