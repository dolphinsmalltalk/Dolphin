"Filed out from Dolphin Smalltalk"!

Object subclass: #ProtocolANYSpec
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProtocolANYSpec guid: (GUID fromString: '{63019e4c-0fec-4287-8010-09f64c6c6b1b}')!

ProtocolANYSpec comment: ''!

!ProtocolANYSpec categoriesForClass!Unclassified! !

!ProtocolANYSpec methodsFor!

<= comperand
	"Answer whether the receiver is less than or equal to comperand. 
	Note: This is to allow protocols to be sorted with the default sort block."

	(comperand isKindOf: ProtocolSpec protocol) | (comperand isKindOf: ProtocolSpec protocolANY)
		ifFalse: [self error: 'Comperand not a ProtocolSpec.'].
	^self protocolName asLowercase <= comperand protocolName asLowercase!

= comperand 
	"Answer whether the receiver is considered equal (contains same elements) to comperand."

	^ (comperand species == self species)
		and: [self protocolName == comperand protocolName]!

addUndefinedProtocolNames

	^ self!

allConformsToProtocolNames
	"Answer the names of all protocols to which the receiver conforms including super protocols."

	| tmpList |
	tmpList := self conformsToProtocolNames.
	self conformsToProtocolNames
		do: [:aProtocollName | tmpList addAll: (ProtocolSpec protocolNamed: aProtocollName) allConformsToProtocolNames].
	^tmpList!

allMessageSelectors
	"Answer all of selectors which make up the receiver's protocol and all protocols to which the receiver conforms."

	| tmpList |
	tmpList := self messageSelectors.
	self allConformsToProtocolNames
		do: [:aProtocollName | tmpList addAll: (ProtocolSpec protocolNamed: aProtocollName) messageSelectors].
	^tmpList!

conformingBehaviors
	"Answer all classes in class then metaclass hierarchy order (i.e. superclasses first) as all conform to the receiver. 
	Note: Return value is a <OrderedCollection> of  class or metaclass objects."
	| answer |
	answer := OrderedCollection new: 10.
	Smalltalk allClasses do: [:class | 
		answer addLast: class.
		answer addLast: class class].
	^ answer!

conformsToMessageSelectors
	"Answer all of selectors which make up all protocols to which the receiver conforms."

	| tmpList |
	tmpList := ProtocolSpec defaultMessageSpecificationCollection.
	self allConformsToProtocolNames
		do: [:aProtocollName | tmpList addAll: (ProtocolSpec protocolNamed: aProtocollName) messageSelectors].
	^tmpList!

conformsToProtocolNames
	"Answer an empty list of protocol names to which the receiver conforms."

	^ProtocolSpec defaultConformsToCollection!

displayOn: targetStream 
	"Append the receiver to targetStream in a format that a user would want to see."

	targetStream nextPut: $<;
	 nextPutAll: self protocolName;
	 nextPut: $>!

fileOutOnSIFFiler: programFiler 
	"Do nothing as the receiver is created by protocol initialization."

	^ self!

hash
	"Answer the hash value for the receiver."

	^ self protocolName hash!

includesSelector: unused 
	"Answer false as the receiver specifies no behavior."

	^ false!

messageOrNilAtSelector: selector
	"Answer nil <ANY> protocol by definition can't have any messages."
	"2000/06/23 Harmon, R. Added to fix bug when TestCaseANSI >>
			#assertSend: is sent with a selector not defined in the
			target protocol or any of its inherited protocols."

	^nil!

messages
	"Answer an empty list of of message specifications of the receiver."

	^ProtocolSpec defaultMessageSpecificationCollection!

messageSelectors
	"Answer an empty list of of selectors which make up the receiver's protocol."

	^ProtocolSpec defaultMessageSpecificationCollection!

printOn: targetStream 
	"Append to targetStream a text representation of the receiver as a developer would want to see it (inspector, etc)."

	targetStream nextPut: $<;
	 nextPutAll: self protocolName;
	 nextPut: $>;
	 nextPut: $(.
	self messageSelectors do: [:selector | targetStream nextPutAll: selector]
		separatedBy: [targetStream nextPutAll: ', '].
	targetStream nextPut: $)!

protocolDescription
	"Answer a description of the receiver."

	^ 'A protocol to which all other protocols conform.' copy!

protocolName
	"Answer the name of the receiver."

	^ProtocolSpec protocolANYName!

removeAllSelectors: unused 
	"Signal an error as the receiver specifies no behavior."

	self error: 'Protocol <' , self protocolName , '> specifies no behavior.'!

removeSelector: unused 
	"Signal an error as the receiver specifies no behavior."

	self error: 'Protocol <' , self protocolName , '> specifies no behavior.'!

removeSelector: unused1 ifAbsent: unused2 
	"Signal an error as the receiver specifies no behavior."

	self error: 'Protocol <' , self protocolName , '> specifies no behavior.'!

renameToProtocolName: unused 
	"Signal an error as the receiver can not be renamed."

	self error: 'Protocol <' , self protocolName , '> can not be renamed.'!

selectorsInBehavior: classOrMetaclass 
	"Answer an empty list of selectors ofcorresponding messages as all classes and metaclasses conform to the receiver but it specifies no behavior."

	^ Set new!

wrkAllConformsToMessageSelectorsTo: aDict visited: visitedProtocols
	self messageSelectors do: 
			[:aMessageSelector |
			(aDict includesKey: aMessageSelector) ifFalse: [aDict at: aMessageSelector put: self protocolName]].
	visitedProtocols add: self protocolName.
	self conformsToProtocolNames do: 
			[:aProtoName |
			(visitedProtocols includes: aProtoName)
				ifFalse: 
					[(ProtocolSpec protocolNamed: aProtoName) wrkAllConformsToMessageSelectorsTo: aDict
						visited: visitedProtocols]]! !

!ProtocolANYSpec categoriesForMethods!
<=!public! !
=!public! !
addUndefinedProtocolNames!public! !
allConformsToProtocolNames!public! !
allMessageSelectors!public! !
conformingBehaviors!public! !
conformsToMessageSelectors!public! !
conformsToProtocolNames!public! !
displayOn:!public! !
fileOutOnSIFFiler:!public! !
hash!public! !
includesSelector:!public! !
messageOrNilAtSelector:!public! !
messages!public! !
messageSelectors!public! !
printOn:!public! !
protocolDescription!public! !
protocolName!public! !
removeAllSelectors:!public! !
removeSelector:!public! !
removeSelector:ifAbsent:!public! !
renameToProtocolName:!public! !
selectorsInBehavior:!public! !
wrkAllConformsToMessageSelectorsTo:visited:!public! !
!

!ProtocolANYSpec class methodsFor!

new
	"Raise an exception as this is an inappropriate message."

	^ self shouldNotImplement!

privateNewProtocolANY
	"Private -"
	| newProtocol |
	newProtocol := self basicNew.
	^ newProtocol! !

!ProtocolANYSpec class categoriesForMethods!
new!public! !
privateNewProtocolANY!public! !
!

