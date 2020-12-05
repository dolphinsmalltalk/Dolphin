"Filed out from Dolphin Smalltalk 7"!

MSXML.XmlDomVisitor subclass: #'MSXML.XmlFormatter'
	instanceVariableNames: 'stream indent line newlineNeeded'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.XmlFormatter guid: (Core.GUID fromString: '{1fc00789-e5c1-4f68-9d36-e5ba475b97f3}')!
MSXML.XmlFormatter comment: '`XmlFormatter` is an `XmlDomVisitor` that pretty-prints an XML node tree. Where appropriate it follows the W3C Canonical XML recommendation (http://www.w3.org/TR/xml-c14n), although it does not remove nodes (such as redundant namespace attributes) as described in that document. Also it will reformat mixed-content nodes where the text content is not in an immediate child. This may be incorrect in a markup document where inter-node whitespace is significant, but for the majority of data documents such whitespace is irrelevent.

Example usage:
```
	doc := MSXML.IXMLDOMDocument3 new.
	doc setProperty_: ''ProhibitDTD'' value: false.
	doc setProperty_: ''ResolveExternals'' value: true.
	doc loadURL: ''http://www.w3.org/XML/Test/faq.xml''.
	original := doc xml.

	formatter := MSXML.XmlFormatter new.
	reformatted := formatter format: doc.
	
	DiffBrowser show compare: original id: ''Original'' and: reformatted id: ''Reformatted''
```'!
!MSXML.XmlFormatter categoriesForClass!Kernel-Objects! !
!MSXML.XmlFormatter methodsFor!

format: anIXMLDOMNode 
	| answer |
	self initialize.
	self visitNode: anIXMLDOMNode.
	answer := stream contents.
	^answer!

indent: anInteger around: aBlock 
	indent := indent + anInteger.
	^aBlock ensure: [indent := indent - anInteger]!

indentAround: aBlock 
	^self indent: 1 around: aBlock!

initialize
	indent := 0.
	line := 1.
	newlineNeeded := false.
	stream := String writeStream!

newline
	stream crtab: indent.
	line := line + 1!

newlineIfNeeded
	newlineNeeded 
		ifTrue: 
			[newlineNeeded := false.
			self newline]!

startTag: aString 
	stream
		nextPut: $<;
		nextPutAll: aString!

visitAttribute: anIXMLDOMAttribute
	stream nextPutAll: anIXMLDOMAttribute xml!

visitAttributes: anIXMLDOMNode 
	anIXMLDOMNode attributes associations asSortedCollection do: 
			[:each | 
			"Redundant empty namespace declarations are removed"
			(each key = 'xmlns' and: 
					[each value isEmpty and: 
							[| parent |
							parent := anIXMLDOMNode parentNode.
							parent notNil and: [parent namespaceURI isEmpty]]]) 
				ifFalse: 
					[stream space.
					self visitNode: each]]!

visitCharacterData: anIXMLDOMCharacterData
	stream nextPutAll: anIXMLDOMCharacterData xml!

visitComment: anIXMLDOMComment
	self newlineIfNeeded.
	stream
		nextPutAll: '<!!--';
		nextPutAll: anIXMLDOMComment data;
		nextPutAll: '-->'.
	indent = 0 ifTrue: [newlineNeeded := true]!

visitDocument: anIXMLDOMDocument
	super visitNodeChildren: anIXMLDOMDocument!

visitDocumentType: anIXMLDOMDocumentType
	self newlineIfNeeded.
	stream nextPutAll: anIXMLDOMDocumentType xml.
	self assert: [indent = 0].
	newlineNeeded := true.
	^self.
	stream
		nextPutAll: '<!!DOCTYPE ';
		display: anIXMLDOMDocumentType name;
		nextPutAll: ' ['.
	self newline.
	self indentAround: 
			[anIXMLDOMDocumentType notations do: 
					[:each |
					self newline.
					self visitNode: each].
			anIXMLDOMDocumentType entities do: 
					[:each |
					self newline.
					self visitNode: each]].
	self newline.
	stream nextPutAll: ']>'!

visitElement: anIXMLDOMElement
	| tag childNodes hasText textNodes |
	tag := anIXMLDOMElement tagName.
	self newlineIfNeeded.
	self startTag: tag.
	self visitAttributes: anIXMLDOMElement.
	childNodes := anIXMLDOMElement childNodes asArray.
	#todo.	"Need to handle the different content types separately. If text only, emit as is, retaining whitespace. If mixed (or element only) then strip existing whitespace and reformat if all text is whitespace. This won't work in all cases where text is significant, but is probably sufficient for reformatting data documents."
	"If there is any text, we must emit the nodes preserving whitespace, if there are no text
	nodes apart from whitespace, then we emit only the non-text nodes."
	textNodes := childNodes select: [:each | each formatAsText].
	hasText := textNodes anySatisfy: [:each | each xml trimBlanks notEmpty].
	hasText
		ifTrue: 
			[stream nextPut: $>.
			self indentAround: 
					[childNodes do: 
							[:each |
							newlineNeeded := false.
							self visitNode: each]]]
		ifFalse: 
			[childNodes := childNodes difference: textNodes.
			childNodes isEmpty
				ifTrue: 
					[| xml |
					"Try and preserve the original format of empty elements"
					xml := anIXMLDOMElement xml.
					(xml endsWith: '/>')
						ifTrue: 
							[newlineNeeded := true.
							stream nextPutAll: '/>'.
							^self]
						ifFalse: [stream nextPut: $>]]
				ifFalse: 
					[stream nextPut: $>.
					newlineNeeded := true.
					self indentAround: 
							[childNodes do: 
									[:each |
									newlineNeeded := true.
									self visitNode: each]].
					self newlineIfNeeded]].
	newlineNeeded := true.
	stream
		nextPutAll: '</';
		nextPutAll: tag;
		nextPut: $>!

visitEntity: anIXMLDOMEntity
	self newlineIfNeeded.
	self startTag: '!!ENTITY'.
	stream
		space;
		display: anIXMLDOMEntity key;
		space;
		display: anIXMLDOMEntity value;
		nextPut: $>.
	newlineNeeded := true!

visitEntityReference: anIXMLDOMEntityReference
	stream nextPutAll: anIXMLDOMEntityReference xml!

visitNodeChildren: anIXMLDOMNode 
	self indentAround: [super visitNodeChildren: anIXMLDOMNode]!

visitNotation: anIXMLDOMNotation
	^self shouldNotImplement!

visitProcessingInstruction: anIXMLDOMProcessingInstruction
	| data |
	newlineNeeded
		ifTrue: 
			[newlineNeeded := false.
			indent = 0 ifTrue: [self newline]].
	stream
		nextPutAll: '<?';
		nextPutAll: anIXMLDOMProcessingInstruction target.
	data := anIXMLDOMProcessingInstruction data.
	data notEmpty
		ifTrue: 
			[stream
				space;
				nextPutAll: data].
	stream nextPutAll: '?>'.
	indent = 0 ifTrue: [newlineNeeded := true]! !
!MSXML.XmlFormatter categoriesFor: #format:!operations!public! !
!MSXML.XmlFormatter categoriesFor: #indent:around:!formatting!private! !
!MSXML.XmlFormatter categoriesFor: #indentAround:!formatting!private! !
!MSXML.XmlFormatter categoriesFor: #initialize!operations!public! !
!MSXML.XmlFormatter categoriesFor: #newline!public! !
!MSXML.XmlFormatter categoriesFor: #newlineIfNeeded!private!visiting! !
!MSXML.XmlFormatter categoriesFor: #startTag:!private! !
!MSXML.XmlFormatter categoriesFor: #visitAttribute:!public! !
!MSXML.XmlFormatter categoriesFor: #visitAttributes:!private! !
!MSXML.XmlFormatter categoriesFor: #visitCharacterData:!private! !
!MSXML.XmlFormatter categoriesFor: #visitComment:!public! !
!MSXML.XmlFormatter categoriesFor: #visitDocument:!public!visiting! !
!MSXML.XmlFormatter categoriesFor: #visitDocumentType:!public!visiting! !
!MSXML.XmlFormatter categoriesFor: #visitElement:!public! !
!MSXML.XmlFormatter categoriesFor: #visitEntity:!public!visiting! !
!MSXML.XmlFormatter categoriesFor: #visitEntityReference:!public!visiting! !
!MSXML.XmlFormatter categoriesFor: #visitNodeChildren:!private!visiting! !
!MSXML.XmlFormatter categoriesFor: #visitNotation:!public!visiting! !
!MSXML.XmlFormatter categoriesFor: #visitProcessingInstruction:!public! !

