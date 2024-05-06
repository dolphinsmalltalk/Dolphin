"Filed out from Dolphin Smalltalk"!

Object subclass: #MsgReturnSpec
	instanceVariableNames: 'returnValueProtocols returnValueAliasingAttribute'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MsgReturnSpec guid: (GUID fromString: '{a23f1e93-ec7b-47d3-ae61-3f992842c38e}')!

MsgReturnSpec comment: ''!

!MsgReturnSpec categoriesForClass!Unclassified! !

!MsgReturnSpec methodsFor!

isConformingReturnClass: returnClass 
	"Answer true if the class, returnClass, of the result of sending a message conforms to the receiver, else false."

	self returnValueProtocolNames 
		do: [:protocolName | (returnClass conformsToAnsiProtocolNamed: protocolName) ifTrue: [^true]].
	^false!

printOn: targetStream 
	"Append to targetStream a text representation of the receiver as a developer would want to see it (inspector, etc)."

	targetStream nextPutAll: self class name;
	 nextPut: $(.
	self returnValueProtocolNames do: [:protocolName |
		targetStream nextPut: $<;
		 nextPutAll: protocolName;
		 nextPut: $>]
		separatedBy: [targetStream nextPutAll: '|'].
	targetStream space; nextPutAll: self returnValueAliasingAttribute; nextPut: $)!

returnValueAliasingAttribute
	"Answer the protocol message return value aliasing attribute."

	^ returnValueAliasingAttribute!

returnValueProtocolNames
	"Answer the protocol names the protocol message return value conforms to."

	^ returnValueProtocols!

setProtocolNames: protocolNames aliasing: aliasingAttribute 
	"Private - ."

	returnValueProtocols := protocolNames.
	returnValueAliasingAttribute := aliasingAttribute!

storeSIFOn: targetStream 
	"Append to targetStream, a <puttableStream>, the ASCII representation of the receiver in SIF from which the receiver can be rebuilt but NOT reinstantiated via evaluate."

	#todo."??? Find better way to keep SIF knowledge out of model ???"
	targetStream nextPutAll: '#('.
	targetStream space; nextPut: $'.
	returnValueProtocols do: [:protocolName | targetStream nextPutAll: protocolName asString]
		separatedBy: [', ' printOn: targetStream].
	targetStream nextPut: $'.
	targetStream nextPutAll: ' #'.
	returnValueAliasingAttribute asString printOn: targetStream.
	targetStream nextPutAll: ')'!

storeSIFString
        "Answer a <readableString>, a representation of the receiver in SIF from which the receiver
can be rebuilt but NOT reinstantiated via evaluate."
        | aStream |
        aStream := WriteStream on: (String new: 50).
        self storeSIFOn: aStream.
        ^ aStream contents! !

!MsgReturnSpec categoriesForMethods!
isConformingReturnClass:!public! !
printOn:!public! !
returnValueAliasingAttribute!public! !
returnValueProtocolNames!public! !
setProtocolNames:aliasing:!public! !
storeSIFOn:!public! !
storeSIFString!public! !
!

!MsgReturnSpec class methodsFor!

aliasingAttributes
	"Answer a list of protocol message return value aliasing attribute constants.
	Note: The list is a <Set> of <symbol>s."
	^ Set
		with: self returnValueAliasingAttributeNew
		with: self returnValueAliasingAttributeState
		with: self returnValueAliasingAttributeUnspecified!

new
	"Raise an exception as this is an inappropriate message."

	^ self shouldNotImplement!

newRetValNewProtocolNames: protocolNames 
	"Answer a new return value specification indicating a protocol message's return value has a new aliasing attribute and conforms to the protocols named, protocolNames. 
	Note: protocolNames must be a <collection> of <symbol>s."

	^ self privateNewRetValProtocolNames: protocolNames aliasing: self returnValueAliasingAttributeNew!

newRetValProtocolNames: protocolNames aliasing: aliasingAttribute 
	"Answer a new return value specification indicating a protocol message's return value conforms to the protocols named, protocolNames, and has an aliasing attribute, aliasingAttribute. 
	Note: protocolNames must be a <collection> of <symbol>s."

	^ self privateNewRetValProtocolNames: protocolNames aliasing: aliasingAttribute!

newRetValStateProtocolNames: protocolNames 
	"Answer a new return value specification indicating a protocol message's return value has a state aliasing attribute and conforms to the protocols named, protocolNames. 
	Note: protocolNames must be a <collection> of <symbol>s."

	^ self privateNewRetValProtocolNames: protocolNames aliasing: self returnValueAliasingAttributeState!

newRetValUnspecifiedProtocolNames: protocolNames 
	"Answer a new return value specification indicating a protocol message's return value has a unspecified aliasing attribute and conforms to the protocols named, protocolNames."

	^ self privateNewRetValProtocolNames: protocolNames aliasing: self returnValueAliasingAttributeUnspecified!

privateNewRetValProtocolNames: protocolNames aliasing: aliasingAttribute 
	"Private -"
	| protocolNamesTmp |
	(self aliasingAttributes includes: aliasingAttribute)
		ifFalse: [self error: 'Protocol msg. return value aliasing attribute not valid.'].
	protocolNamesTmp := self privateValidProtocolNames: protocolNames ifError: [^ self error: 'Protocol msg. return value protocol names not a <collection> of <symbol>s.'].
	^ super new setProtocolNames: protocolNamesTmp aliasing: aliasingAttribute!

privateValidProtocolNames: protocolNamesIn ifError: errorBlock
	"Private -"

	| protocolNamesTmp |
	(protocolNamesIn isKindOf: Collection) ifFalse: [^errorBlock value].
	protocolNamesTmp := ProtocolSpec defaultProtocolNameCollection.
	protocolNamesIn do: 
			[:protocolName |
			(protocolName isKindOf: Symbol) ifFalse: [^errorBlock value].
			protocolNamesTmp add: protocolName].
	^protocolNamesTmp!

returnValueAliasingAttributeNew
	"Answer a protocol message return value new aliasing attribute constant."

	^ #'new'!

returnValueAliasingAttributeState
	"Answer a protocol message return value state aliasing attribute constant."

	^ #'state'!

returnValueAliasingAttributeUnspecified
	"Answer a protocol message return value unspecified aliasing attribute constant."

	^ #'unspecified'! !

!MsgReturnSpec class categoriesForMethods!
aliasingAttributes!public! !
new!public! !
newRetValNewProtocolNames:!public! !
newRetValProtocolNames:aliasing:!public! !
newRetValStateProtocolNames:!public! !
newRetValUnspecifiedProtocolNames:!public! !
privateNewRetValProtocolNames:aliasing:!public! !
privateValidProtocolNames:ifError:!public! !
returnValueAliasingAttributeNew!public! !
returnValueAliasingAttributeState!public! !
returnValueAliasingAttributeUnspecified!public! !
!

