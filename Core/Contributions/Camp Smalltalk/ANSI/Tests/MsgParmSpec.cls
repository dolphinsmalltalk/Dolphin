"Filed out from Dolphin Smalltalk"!

Object subclass: #MsgParmSpec
	instanceVariableNames: 'parmName parmProtocols parmAliasingAttribute'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MsgParmSpec guid: (GUID fromString: '{c7af3382-899b-43cc-b598-00e1f2aee1a5}')!
MsgParmSpec comment: ''!
!MsgParmSpec categoriesForClass!Unclassified! !
!MsgParmSpec methodsFor!

parmAliasingAttribute
	"Answer the protocol message parameter specification parameter aliasing attribute."

	^ parmAliasingAttribute!

parmName
	"Answer the protocol message parameter specification parameter name."

	^ parmName!

parmProtocolNames
	"Answer the protocol names this protocol message parameter specification conforms to. 
	Note: The protocol names is a <Set> of <symbol>s."

	^ parmProtocols!

printOn: targetStream 
	"Append to targetStream a text representation of the receiver as a developer would want to see it (inspector, etc)."

	targetStream nextPutAll: self class name;
	 nextPut: $(;
	 nextPutAll: self parmName;
	 space.
	self parmProtocolNames do: [:protocolName | targetStream nextPut: $<;
		 nextPutAll: protocolName;
		 nextPut: $>]
		separatedBy: [targetStream nextPutAll: '|'].
	targetStream space; nextPutAll: self parmAliasingAttribute; nextPut: $)!

setParmName: name protocolNames: protocolNames aliasing: aliasingAttribute 
	"Private - ."
	parmName := name.
	parmProtocols := protocolNames.
	parmAliasingAttribute := aliasingAttribute!

storeSIFOn: targetStream 
	"Append to targetStream, a <puttableStream>, the ASCII representation of the receiver in SIF from which the receiver can be rebuilt but NOT reinstantiated via evaluate."
	#todo."??? Find better way to keep SIF knowledge out of model ???"
	targetStream nextPutAll: '#('.
	parmName asString printOn: targetStream.
	targetStream space; nextPut: $'.
	parmProtocols do: [:protocolName | targetStream nextPutAll: protocolName asString]
		separatedBy: [targetStream space].
	targetStream nextPut: $'.
	targetStream nextPutAll: ' #'.
	parmAliasingAttribute asString printOn: targetStream.
	targetStream nextPutAll: ')'!

storeSIFString
	"Answer a <readableString>, a representation of the receiver in SIF from which the receiver can be rebuilt but NOT reinstantiated via evaluate."
	| aStream |
	aStream := WriteStream on: (String new: 50).
	self storeSIFOn: aStream.
	^ aStream contents! !
!MsgParmSpec categoriesForMethods!
parmAliasingAttribute!public! !
parmName!public! !
parmProtocolNames!public! !
printOn:!public! !
setParmName:protocolNames:aliasing:!public! !
storeSIFOn:!public! !
storeSIFString!public! !
!

!MsgParmSpec class methodsFor!

aliasingAttributes
	"Answer a list of protocol message parameter aliasing attribute constants.
	Note: The list is a <Set> of <symbol>s."

	^ Set
		with: self parmAliasingAttributeCaptured
		with: self parmAliasingAttributeUncaptured
		with: self parmAliasingAttributeUnspecified!

new
	"Raise an exception as this is an inappropriate message."

	^ self shouldNotImplement!

newCapturedParmName: nameIn protocolNames: protocolNames 
	"Answer a new protocol message parameter specification for parameter named, nameIn, conforming to the protocols named, protocolNames, and with a captured aliasing attribute. 
	Note: protocolNames must be a <collection> of <symbol>s."

	^ self
		privateNewParmName: nameIn
		protocolNames: protocolNames
		aliasing: self parmAliasingAttributeCaptured!

newParmName: nameIn protocolNames: protocolNames aliasing: attributeIn 
	"Answer a new protocol message parameter specification for parameter named, nameIn, conforming to the protocols named, protocolNames, and with an aliasing attribute, attributeIn. 
	Note: protocolNames must be a <collection> of <symbol>s."

	(self aliasingAttributes includes: attributeIn)
		ifFalse: [self error: 'Protocol msg. parameter aliasing attribute not valid.'].
	^ self
		privateNewParmName: nameIn
		protocolNames: protocolNames
		aliasing: attributeIn!

newUncapturedParmName: nameIn protocolNames: protocolNames 
	"Answer a new protocol message parameter specification for parameter named, nameIn, conforming to the protocols named, protocolNames, and with a uncaptured aliasing attribute. 
	Note: protocolNames must be a <collection> of <symbol>s."

	^ self
		privateNewParmName: nameIn
		protocolNames: protocolNames
		aliasing: self parmAliasingAttributeUncaptured!

newUnspecifiedParmName: nameIn protocolNames: protocolNames 
	"Answer a new protocol message parameter specification for parameter named, nameIn, conforming to the protocols named, protocolNames, and with a unspecified aliasing attribute. 
	Note: protocolNames must be a <collection> of <symbol>s."

	^ self
		privateNewParmName: nameIn
		protocolNames: protocolNames
		aliasing: self parmAliasingAttributeUnspecified!

parmAliasingAttributeCaptured
	"Answer the captured protocol message parameter specification parameter aliasing attribute constant."

	^ #'captured'!

parmAliasingAttributeUncaptured
	"Answer the uncaptured protocol message parameter specification parameter aliasing attribute constant."

	^ #'uncaptured'!

parmAliasingAttributeUnspecified
	"Answer the unspecified protocol message parameter specification parameter aliasing attribute constant."

	^ #'unspecified'!

privateNewParmName: nameIn protocolNames: protocolNames aliasing: aliasingAttribute 
	"Private -"
	| protocolNamesTmp |
	(nameIn isKindOf: String)
		ifFalse: [self error: 'parameter name not a String.'].
	protocolNamesTmp := self privateValidProtocolNames: protocolNames ifError: [^ self error: 'Protocol msg.parameter protocol names not a <collection> of <symbol>s.'].
	^ super new
		setParmName: nameIn
		protocolNames: protocolNamesTmp
		aliasing: aliasingAttribute!

privateValidProtocolNames: protocolNamesIn ifError: errorBlock
	"Private -"

	| protocolNamesTmp |
	(protocolNamesIn isKindOf: Collection) ifFalse: [^errorBlock value].
	protocolNamesTmp := ProtocolSpec defaultProtocolNameCollection.
	protocolNamesIn do: 
			[:protocolName |
			(protocolName isKindOf: Symbol) ifFalse: [^errorBlock value].
			protocolNamesTmp add: protocolName].
	^protocolNamesTmp! !
!MsgParmSpec class categoriesForMethods!
aliasingAttributes!public! !
new!public! !
newCapturedParmName:protocolNames:!public! !
newParmName:protocolNames:aliasing:!public! !
newUncapturedParmName:protocolNames:!public! !
newUnspecifiedParmName:protocolNames:!public! !
parmAliasingAttributeCaptured!public! !
parmAliasingAttributeUncaptured!public! !
parmAliasingAttributeUnspecified!public! !
privateNewParmName:protocolNames:aliasing:!public! !
privateValidProtocolNames:ifError:!public! !
!

