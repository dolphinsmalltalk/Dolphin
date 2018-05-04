"Filed out from Dolphin Smalltalk 7"!

XmlDomVisitor subclass: #XmlFormatter
	instanceVariableNames: 'stream indent line newlineNeeded'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XmlFormatter guid: (GUID fromString: '{1fc00789-e5c1-4f68-9d36-e5ba475b97f3}')!
XmlFormatter comment: 'XmlFormatter is an <XmlDomVisitor> that pretty-prints an XML node tree. Where appropriate it follows the W3C Canonical XML recommendation (http://www.w3.org/TR/xml-c14n), although it does not remove nodes (such as redundant namespace attributes) as described in that document. Also it will reformat mixed-content nodes where the text content is not in an immediate child. This may be incorrect in a markup document where inter-node whitespace is significant, but for the majority of data documents such whitespace is irrelevent.

Example usage:
	doc := IXMLDOMDocument new.
	doc loadURL: ''http://www.w3.org/XML/Test/faq.xml''.
	original := doc xml.

	formatter := XmlFormatter new.
	reformatted := formatter format: doc.
	
	DiffBrowser compare: original with: reformatted
'!
!XmlFormatter categoriesForClass!Kernel-Objects! !
!XmlFormatter methodsFor!

acceptAttribute: anIXMLDOMAttribute 
	stream nextPutAll: anIXMLDOMAttribute xml!

acceptCharacterData: anIXMLDOMCharacterData 
	stream nextPutAll: anIXMLDOMCharacterData xml!

acceptComment: anIXMLDOMComment 
	self newlineIfNeeded.
	stream
		nextPutAll: '<!!--';
		nextPutAll: anIXMLDOMComment data;
		nextPutAll: '-->'.
	indent = 0 ifTrue: [newlineNeeded := true].!

acceptDocument: anIXMLDOMDocument 
	super visitNodeChildren: anIXMLDOMDocument!

acceptDocumentType: anIXMLDOMDocumentType 
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

acceptElement: anIXMLDOMElement 
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
					["Try and preserve the original format of empty elements"
					| xml |
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

acceptEntity: anIXMLDOMEntity 
	self newlineIfNeeded.
	self startTag: '!!ENTITY'.
	stream
		space;
		display: anIXMLDOMEntity key;
		space;
		display: anIXMLDOMEntity value;
		nextPut: $>.
	newlineNeeded := true!

acceptEntityReference: anIXMLDOMEntityReference 
	stream nextPutAll: anIXMLDOMEntityReference xml!

acceptNotation: anIXMLDOMNotation
	^self shouldNotImplement!

acceptProcessingInstruction: anIXMLDOMProcessingInstruction 
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
	indent = 0 ifTrue: [newlineNeeded := true]!

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

visitNodeChildren: anIXMLDOMNode 
	self indentAround: [super visitNodeChildren: anIXMLDOMNode]! !
!XmlFormatter categoriesFor: #acceptAttribute:!public! !
!XmlFormatter categoriesFor: #acceptCharacterData:!private! !
!XmlFormatter categoriesFor: #acceptComment:!public! !
!XmlFormatter categoriesFor: #acceptDocument:!public!visiting! !
!XmlFormatter categoriesFor: #acceptDocumentType:!public!visiting! !
!XmlFormatter categoriesFor: #acceptElement:!public! !
!XmlFormatter categoriesFor: #acceptEntity:!public!visiting! !
!XmlFormatter categoriesFor: #acceptEntityReference:!public!visiting! !
!XmlFormatter categoriesFor: #acceptNotation:!public!visiting! !
!XmlFormatter categoriesFor: #acceptProcessingInstruction:!public! !
!XmlFormatter categoriesFor: #format:!operations!public! !
!XmlFormatter categoriesFor: #indent:around:!formatting!private! !
!XmlFormatter categoriesFor: #indentAround:!formatting!private! !
!XmlFormatter categoriesFor: #initialize!operations!public! !
!XmlFormatter categoriesFor: #newline!public! !
!XmlFormatter categoriesFor: #newlineIfNeeded!private!visiting! !
!XmlFormatter categoriesFor: #startTag:!private! !
!XmlFormatter categoriesFor: #visitAttributes:!private! !
!XmlFormatter categoriesFor: #visitNodeChildren:!private!visiting! !

