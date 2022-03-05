"Filed out from Dolphin Smalltalk"!

ProtocolANYSpec subclass: #ProtocolSpec
	instanceVariableNames: 'name conformsTo description messageSpecifications'
	classVariableNames: 'ClassProtocols DefaultConvTable FixNum OperatorTable Protocols UnaryConvTable UndefinedConformsToNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProtocolSpec guid: (GUID fromString: '{6ada6ff6-f587-4936-8a22-fe3e0022efec}')!
ProtocolSpec comment: ''!
!ProtocolSpec categoriesForClass!Unclassified! !
!ProtocolSpec methodsFor!

<= comperand
	"Answer whether the receiver is less than or equal to comperand. 
	Note: This is to allow protocols to be sorted with the default sort block."

	(comperand isKindOf: ProtocolSpec protocol) | (comperand isKindOf: ProtocolSpec protocolANY)
		ifFalse: [self error: 'Comperand not a ProtocolSpec.'].
	^self protocolName asLowercase <= comperand protocolName asLowercase!

addAllMessages: protocolMsgSpecList 
	"Add if not already present all the protocol messages in the list, protocolMsgSpecList, to the set of messages included in the receiver's protocol.
	Note: protocolMsgSpecList must be a <collection> of <protocolMessageSpec>s,"

	protocolMsgSpecList do: [:msgSpec | self addMessage: msgSpec]!

addMessage: aProtocolMsgSpec
	"Add if not already present the protocol message, aProtocolMsgSpec, to the set of messages included in the receiver's protocol."

	(aProtocolMsgSpec isKindOf: ProtocolSpec protocolMsgSpec)
		ifFalse: [self error: 'Protocol message not a ProtocolMsgSpec.'].
	(self includesSelector: aProtocolMsgSpec messageSelector)
		ifFalse: 
			[messageSpecifications isNil
				ifTrue: [messageSpecifications := ProtocolSpec defaultMessageSpecificationCollection].
			messageSpecifications add: aProtocolMsgSpec.
			self addUndefinedProtocolNamesInMsgSpec: aProtocolMsgSpec]!

addUndefinedProtocolNames
	"Private - ."

	messageSpecifications isNil ifTrue: [^ self].
	messageSpecifications do: [:msgSpec | self addUndefinedProtocolNamesInMsgSpec: msgSpec]!

addUndefinedProtocolNamesInMsgSpec: aProtocolMsgSpec
	"Private - ."

	aProtocolMsgSpec allReferredToProtocolNames do: 
			[:protoName |
			(ProtocolSpec includesProtocolNamed: protoName asSymbol)
				ifFalse: [ProtocolSpec addUndefinedProtocolName: protoName asSymbol]]!

conformingBehaviors
	"Answer all the classes which conform to the receiver in class hierarchy order (i.e. superclasses first). 
	Note: Return value is a <OrderedCollection> of  class or metaclass objects."

	| answer |
	answer := OrderedCollection new: 10.
	Smalltalk allClasses do: 
			[:class | 
			(class conformsToAnsiProtocolNamed: self protocolName) ifTrue: [answer addLast: class].
			(class class conformsToAnsiProtocolNamed: self protocolName) 
				ifTrue: [answer addLast: class class]].
	^answer!

conformsToProtocolNames
	"Answer the protocol names to which the receiver conforms."

	^ conformsTo!

displayOn: targetStream 
	"Append the receiver to targetStream in a format that a user would want to see."

	targetStream nextPut: $<;
	 nextPutAll: self protocolName;
	 nextPut: $>!

errorSelectorNotFound: selector 
	"Private -"
	self error: 'Protocol ' , self printString , ' message "' , selector , '" not found'!

fileOutOnSIFFiler: programFiler 
	"File out the receiver definition and its message definitions on ANSI SIF filer, programFiler."

	#todo."??? Add annotations ???"
	programFiler
		fileOutProtocolDefinitionOf: self protocolName
		conformsToProtocolNames: self conformsToProtocolNames
		description: self protocolDescription
		annotations: Dictionary new.
	self messages asSortedCollection do: [:messageSpec | messageSpec fileOutOnSIFFiler: programFiler protocol: self protocolName]!

hash
	"Answer the hash value for the receiver."

	^ self protocolName hash!

includesSelector: selector 
	"Answer whether the receiver includes the selector, selector."

	^ self messageSelectors includes: selector!

inheritedMessageOrNilAtSelector: selector
	| msg |
	conformsTo do: [:protocolName | msg := (ProtocolSpec protocolNamed: protocolName)
			messageOrNilAtSelector: selector.
			msg notNil ifTrue: [^msg]].
	^nil!

messageAtSelector: selector
	"Answer the message spec. at selector."
	| msg |
	msg := self messageOrNilAtSelector: selector.
	msg notNil ifTrue: [^msg].
	self error: 'Protocol message spec. at selector: "', selector, '" not found.'!

messageOrNilAtSelector: selector

	messageSpecifications isNil ifTrue: [
		^self inheritedMessageOrNilAtSelector: selector].
	^messageSpecifications 
		detect: [ :protocol | protocol messageSelector = selector]
		ifNone: [^self inheritedMessageOrNilAtSelector: selector].!

messages
	"Answer a list of message specifications of the receiver. 
	Note: Return value is a <Set> of <protocolMessageSpec>s,"

	messageSpecifications isNil ifTrue: [^ProtocolSpec defaultMessageSpecificationCollection].
	^messageSpecifications!

messageSelectors
	"Answer the list of selectors which make up the receiver's protocol. 
	Note: Return value is a <Set> of <symbol>s,"

	messageSpecifications isNil ifTrue: [^ProtocolSpec defaultMessageSpecificationCollection].
	^messageSpecifications collect: [:msgSpec | msgSpec messageSelector]!

newProtocolName: protocolName conformsToProtocolNames: conformsToList
	"Private - ."

	name := protocolName.
	conformsTo := conformsToList!

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

	description isNil ifTrue: [^ProtocolSpec defaultEmptyDescription].
	^description!

protocolDescription: newDescription 
	"Set the receiver's description to newDescription. 
	Note: If newDescription is empty then description is set to nil."

	(newDescription isKindOf: String)
		ifFalse: [self error: 'Protocol description not a String.'].
	newDescription isEmpty
		ifTrue: [description := nil]
		ifFalse: [description := newDescription]!

protocolName
	"Answer the name of the receiver."

	^ name!

removeAllSelectors: selectorList 
	"After removing from the receiver all the messages with selectors, selectorList, answer them. 
	Note: selectorList must be a <collection> of  <symbol>s."
	| messageSpecs |
	messageSpecs := Set new.
	selectorList do: [:selector | messageSpecs add: (self removeSelector: selector)].
	^ messageSpecs!

removeSelector: selector 
	"Answer the message with selector, selector, after removing it from the receiver."

	^ self removeSelector: selector
		ifAbsent: [self errorSelectorNotFound: selector]!

removeSelector: selector ifAbsent: notFoundBlock 
	"Answer the message with selector, selector, after removing it from the receiver."
	| aProtocolMsgSpec |
	aProtocolMsgSpec := messageSpecifications
		detect: [:msgSpec | msgSpec messageSelector = selector]
		ifNone: [^ notFoundBlock value].
	^ messageSpecifications remove: aProtocolMsgSpec!

renameToProtocolName: newName
	"Rename the receiver protocol to have the new name, newName and update any conforming class or metaclass."

	| conformingList |
	(ProtocolSpec includesProtocolNamed: newName)
		ifTrue: [^self error: 'Duplicate protocol name: "' , newName , '".'].
	conformingList := self conformingBehaviors.
	conformingList do: [:classOrMetaclass | classOrMetaclass removeAnsiProtocolNamed: self protocolName].
	self setProtocolName: newName.
	ProtocolSpec privateRehashProtocols.
	conformingList do: [:classOrMetaclass | classOrMetaclass addProtocolNamed: newName]!

selectorsInBehavior: classOrMetaclass 
	"If the class or metaclass, classOrMetaclass, conforms to the receiver answer all the selectors in which have corresponding messages, else an empty list. 
	Note: Return value is a <Set> of <symbol>s,"

	(classOrMetaclass conformsToAnsiProtocolNamed: self protocolName) 
		ifTrue: 
			[^(classOrMetaclass selectors select: [:selector | self includesSelector: selector]) asSet].
	^Set new!

setProtocolName: protocolName 
	"Private - ."

	name := protocolName!

zremoveClass: classOrMetaclass 
	"Remove the receiver's name from the class or the metaclass, classOrMetaclass, list of protocol names. 	??not that great an idea???"

	classOrMetaclass removeAnsiProtocolNamed: self protocolName! !
!ProtocolSpec categoriesForMethods!
<=!public! !
addAllMessages:!public! !
addMessage:!public! !
addUndefinedProtocolNames!public! !
addUndefinedProtocolNamesInMsgSpec:!public! !
conformingBehaviors!public! !
conformsToProtocolNames!public! !
displayOn:!public! !
errorSelectorNotFound:!public! !
fileOutOnSIFFiler:!public! !
hash!public! !
includesSelector:!public! !
inheritedMessageOrNilAtSelector:!public! !
messageAtSelector:!public! !
messageOrNilAtSelector:!public! !
messages!public! !
messageSelectors!public! !
newProtocolName:conformsToProtocolNames:!public! !
printOn:!public! !
protocolDescription!public! !
protocolDescription:!public! !
protocolName!public! !
removeAllSelectors:!public! !
removeSelector:!public! !
removeSelector:ifAbsent:!public! !
renameToProtocolName:!public! !
selectorsInBehavior:!public! !
setProtocolName:!public! !
zremoveClass:!public! !
!

!ProtocolSpec class methodsFor!

addUndefinedProtocolName: protocolName 
	"Private - ."

	(protocolName isKindOf: Symbol)
		ifFalse: [self error: 'Protocol name not a Symbol.'].
	UndefinedConformsToNames add: protocolName!

allAnsiProtocols
	"Answer all Protocols in the system."

	^Protocols!

allProtocolNames
	"Answer the names of all Protocols in the system."

	^ (Protocols collect: [:protocol | protocol protocolName]) asSet!

allProtocolNamesSorted
	"Answer the names of all Protocols in the system sorted ignoring case."

	^ (Protocols collect: [:protocol | protocol protocolName]) asSortedCollection sortBlock: [:x :y | x asLowercase <= y asLowercase]!

classProtocols
	^ClassProtocols!

defaultConformsToCollection
	"Private - Answer an <Set>, the default conformsTo collection."

	^ Set new!

defaultEmptyDescription
	"Private - Answer an <String>, the default empty description."

	^ String new!

defaultMessageSpecificationCollection
	"Private - Answer an <Set>, the default messageSpecification collection."

	^ Set new!

defaultProtocolCollection
	"Private - Answer an <Set>, the default protocol collection."

	^ Set new!

defaultProtocolNameCollection
	"Private - Answer an <Set>, the default protocol name collection."

	^ Set new!

defaultReturnProtocolNameReceiver: receiver operand: operand 
	"Answer the return value conforms-to protocol name of a message performing arithmetic, arithmetic progressions, and conversion on numerical quantities involving receiver and operand.
	Note: The result type of most numeric opeations is based upon the operand type.  The Default Result Type for all operand types except <Fraction> is the type to which the operands have been converted according to the Default ConversionTable.  If the converted operand type is <Fraction> the Default Result Type is <rational>.  In all cases where the type of the return value differs from the default result type  it is noted in the operation's description."
	| receiverProto operandProto convertedOperandType |
	receiverProto := self instanceProtocol: receiver.
	operandProto := self instanceProtocol: operand.
	convertedOperandType := (DefaultConvTable at: receiverProto)
				at: operandProto.
	convertedOperandType = #'Fraction' ifTrue: [^ #'rational'].
	^ convertedOperandType!

defaultSpecSectionsCollection
	"Private - Answer an <Dictionary>, the default SpecSections collection."

	^ Dictionary new!

errorProtocolNotFound: protocolName 
	"Private -"

	self error: 'Protocol <' , protocolName , '> not found'!

fileOutAllProtocolsSIFFiler: programFiler 
	"File out all protocol definitions on ANSI SIF filer, programFiler."

	| allProtos |
	allProtos := self allAnsiProtocols asSortedCollection.
	allProtos remove: (self protocolNamed: self protocolANYName) ifAbsent: [].
	self fileOutSIFAllProtocolsDescOnFiler: programFiler.
	allProtos do: [:protocol | protocol fileOutOnSIFFiler: programFiler]!

fileOutSIFAllProtocolsDescOnFiler: programFiler 
	"Private - File out an all-protocols program description in ANSI SIF format on the programFiler."
	| annotations |
	annotations := Dictionary new.
	annotations at: 'createdByApp' put: self portFunc dialectNameVersionString.
	annotations at: 'createdDateTime' put: self portFunc currentDateTimeString.
	programFiler
		fileOutProgramDescName: 'AllProto'
		prerequisiteProgramNames: (Set with: 'ACSProS')
		programAnnotations: annotations!

fileOutSIFAllProtocolsToFileLocator: pathNameExt
	"File out all protocol definitions in ANSI SIF to fileLocator, pathNameExt. 
	Note: Protocols are NOT defined in SIF, thus only a reader with macro enhancement will install protocols from the file.  All other conforming readers will ignore the contents as comments."

	| aFileStream programFiler |
	aFileStream := FileStream write: pathNameExt.
	
	[programFiler := ProtocolSpec newWriterOn: aFileStream.
	"SIF"
	self fileOutAllProtocolsSIFFiler: programFiler]
			ensure: [aFileStream close]!

includesProtocolNamed: protocolName 
	"Answer whether the named protocol exists."

	(protocolName isKindOf: Symbol)
		ifFalse: [self error: 'Protocol name not a Symbol.'].
	Protocols detect: [:protocol | protocol protocolName = protocolName]
		ifNone: [^ false].
	^ true!

initialize
	"Class initialization.  Example: 
	 
	ProtocolSpec initialize
	"

        ClassProtocols := LookupTable new.
	self initializeProtocols.
	self initializeDefaultConversionTable.
	self initializeUnaryConversionTable.
	self initializeOperatorTable!

initializeDefaultConversionTable
	"Discard all existing protocols.  Example: 
	 
	self protocolManager protocol initializeDefaultConversionTable
	"
	| tmp |
	DefaultConvTable := Dictionary new.
	tmp := Dictionary new.
	tmp at: #'integer' put: #'integer'.
	tmp at: #'scaledDecimal' put: #'scaledDecimal'.
	tmp at: #'Fraction' put: #'Fraction'.
	tmp at: #'Float' put: #'Float'.
	DefaultConvTable at: #'integer' put: tmp.
	tmp := Dictionary new.
	tmp at: #'integer' put: #'scaledDecimal'.
	tmp at: #'scaledDecimal' put: #'scaledDecimal'.
	tmp at: #'Fraction' put: #'Fraction'.
	tmp at: #'Float' put: #'Float'.
	DefaultConvTable at: #'scaledDecimal' put: tmp.
	tmp := Dictionary new.
	tmp at: #'integer' put: #'Fraction'.
	tmp at: #'scaledDecimal' put: #'Fraction'.
	tmp at: #'Fraction' put: #'Fraction'.
	tmp at: #'Float' put: #'Float'.
	DefaultConvTable at: #'Fraction' put: tmp.
	tmp := Dictionary new.
	tmp at: #'integer' put: #'Float'.
	tmp at: #'scaledDecimal' put: #'Float'.
	tmp at: #'Fraction' put: #'Float'.
	tmp at: #'Float' put: #'Float'.
	DefaultConvTable at: #'Float' put: tmp!

initializeOperatorTable
	"Discard all existing protocols.  Example: 
	 
	self protocolManager initializeOperatorTable
	"

	OperatorTable := Dictionary new.
	OperatorTable at: #'=' put: 'equalityOp'.
	OperatorTable at: #'==' put: 'identityOp'.
	OperatorTable at: #'~=' put: 'notEqualityOp'.
	OperatorTable at: #'~~' put: 'notIdentityOp'.
	OperatorTable at: #'&' put: 'andOp'.
	OperatorTable at: #'|' put: 'orOp'.
	OperatorTable at: #'<' put: 'lessThanOp'.
	OperatorTable at: #'<=' put: 'lessThanOrEqualToOp'.
	OperatorTable at: #'>' put: 'greaterThanOp'.
	OperatorTable at: #'>=' put: 'greaterThanOrEqualToOp'.
	OperatorTable at: #'*' put: 'multiplyOp'.
	OperatorTable at: #'+' put: 'addOp'.
	OperatorTable at: #'-' put: 'subtractOp'.
	OperatorTable at: #'/' put: 'divideOp'.
	OperatorTable at: #'//' put: 'integerDivideOp'.
	OperatorTable at: #'\\' put: 'remainderIntegerDivideOp'.
	OperatorTable at: #',' put: 'concatenateOp'!

initializeProtocols
	"Discard all existing protocols.  Example: 
	 
	self protocolManager protocol initializeProtocols
	"
	| nameList |
	(Protocols notNil and: [Protocols size > 1])
		ifTrue: 
			[nameList := String new.
			"Not just protocol <ANY>"
			(Protocols asArray copyFrom: 1 to: (3 min: Protocols size))
				do: [:protocol | nameList := nameList , protocol protocolName]
				separatedBy: [nameList := nameList , ', '].
			Protocols size > 3 ifTrue: [nameList := nameList , ' ...'].
			(self portFunc promptYesNo: 'You are about to lose protocols (' , nameList , ').  Do it?')
				ifFalse: ["Do NOT discard existing protocols."
					^ self]].
	UndefinedConformsToNames := self defaultProtocolNameCollection.
	Protocols := self defaultProtocolCollection.
	Protocols add: (SUnitNameResolver classNamed: #'ProtocolANYSpec') privateNewProtocolANY!

initializeUnaryConversionTable
	"Discard all existing protocols.  Example: 
	 
	self protocolManager protocol initializeDefaultConversionTable
	"

	UnaryConvTable := Dictionary new.
	UnaryConvTable at: #'integer' put: #'rational'.
	UnaryConvTable at: #'Fraction' put: #'rational'.
	UnaryConvTable at: #'rational' put: #'rational'.
	UnaryConvTable at: #'scaledDecimal' put: #'scaledDecimal'.
	UnaryConvTable at: #'Float' put: #'Float'!

instanceProtocol: number 
	"Answer the conforms-to protocol name of number."

	#(#integer #Float #Fraction #scaledDecimal) 
		do: [:protoName | (number class conformsToAnsiProtocolNamed: protoName) ifTrue: [^protoName]].
	self error: 'Instance does not conforms to any numeric protocol.'!

methodSelector: messagePattern
	| sourceStream selectorStream token |
	sourceStream := ReadStream on: messagePattern trimBlanks.
	sourceStream contents isEmpty ifTrue: [^nil].
	token := self nextTokenFrom: sourceStream.
	token isNil ifTrue: [^nil].
	token last = $:
		ifFalse: 
			["Binary or unary selector."
			^token].
	selectorStream := WriteStream on: (String new: 20).
	
	[(token isNil or: [token isEmpty]) not and: 
			[token last = $: & ((token includes: $") not & (token includes: $') not & (token includes: $|) not)]]
			whileTrue: 
				[selectorStream nextPutAll: token.
				self nextTokenFrom: sourceStream.	"Get keyword."
				token := self nextTokenFrom: sourceStream].
	^selectorStream contents!

new
	"ProtocolSpecs must be unique for any particular name, and must be instantiated with the #name: method."

	^ self shouldNotImplement!

newMessagePattern: messagePattern forProtocolNamed: protocolName synopsis: messageSynopsis definedIn: definedInProtocolName definition: messageDefinition refinedIn: refinedInProtocolName refinement: messageRefinement parameters: parmList returnRule: returnValueRule errors: messageErrors
	"Create a new protocol message specification with message, messagePattern, etc. to protocol named protocolName."

	| newParmSpecs newReturnSpecs secDict |
	newParmSpecs := self parametersFromList: parmList.
	newReturnSpecs := Set
				with: (ProtocolSpec protocolMsgReturnValueRuleSpec newRetValRuleSourceCode: returnValueRule).
	secDict := self
				specSectionsFromSynopsis: messageSynopsis
				definedIn: definedInProtocolName
				definition: messageDefinition
				refinedIn: refinedInProtocolName
				refinement: messageRefinement
				errors: messageErrors.
	(self protocolNamed: protocolName) addMessage: (self protocolMsgSpec
				newSelector: (self methodSelector: messagePattern , ' ') asSymbol
				specSections: secDict
				specsForEachParm: newParmSpecs
				specsForEachReturnValue: newReturnSpecs)!

newMessagePattern: messagePattern forProtocolNamed: protocolName synopsis: messageSynopsis definedIn: definedInProtocolName definition: messageDefinition refinedIn: refinedInProtocolName refinement: messageRefinement parameters: parmList returnValues: returnValuesList errors: messageErrors
	"Create a new protocol message specification with message, messagePattern, etc. to protocol named protocolName."

	| newParmSpecs newReturnSpec secDict |
	newParmSpecs := self parametersFromList: parmList.
	newReturnSpec := returnValuesList collect: 
					[:anArray |
					ProtocolSpec protocolMsgReturnValueSpec newRetValProtocolNames: (Set with: (anArray at: 1) asSymbol)
						aliasing: (anArray at: 2)].
	secDict := self
				specSectionsFromSynopsis: messageSynopsis
				definedIn: definedInProtocolName
				definition: messageDefinition
				refinedIn: refinedInProtocolName
				refinement: messageRefinement
				errors: messageErrors.
	(self protocolNamed: protocolName) addMessage: (self protocolMsgSpec
				newSelector: (self methodSelector: messagePattern , ' ') asSymbol
				specSections: secDict
				specsForEachParm: newParmSpecs
				specsForEachReturnValue: newReturnSpec)!

newProtocolNamed: protocolName conformsToProtocolNames: conformsToList 
	"Answer a new protocol with the specified name, protocolName that conforms to the protocols named in conformsToList."

	^ self privateNewProtocolNamed: protocolName conformsToProtocolNames: conformsToList!

nextTokenFrom: sourceStream
	| startPos len |
	sourceStream skipSeparators.
	sourceStream atEnd ifTrue: [^nil].
	startPos := sourceStream position.
	len := 0.
	[sourceStream atEnd] whileFalse: 
			[sourceStream next isSeparator
				ifTrue: 
					[sourceStream position: startPos.
					^sourceStream next: len].
			len := len + 1].
	sourceStream position: startPos.
	^sourceStream next: len!

parametersFromList: parmList
	"Private - Create a new protocol message specification with message, messagePattern, etc. to protocol named protocolName."

	| newParmSpecs names |
	newParmSpecs := parmList collect: 
					[:anArray |
					names := (anArray at: 2) subStrings collect: [:nameString | name asSymbol].
					ProtocolSpec protocolMsgParmSpec
						newParmName: (anArray at: 1)
						protocolNames: names
						aliasing: (anArray at: 3)].
	^newParmSpecs!

privateNewProtocolNamed: protocolName conformsToProtocolNames: conforms 
	"Private -"
	| newProtocol conformsTmp |
	(self includesProtocolNamed: protocolName)
		ifTrue: [^ self error: 'Protocol named "' , protocolName , '" already exists.'].
	conformsTmp := self privateValidConformsToProtocolNames: conforms ifError: [^ self error: 'Protocol conforms-to list not a <collection> of existing protocol name <symbol>s.'].
	(protocolName isKindOf: Symbol)
		ifFalse: [self error: 'Protocol name not a Symbol.'].
	newProtocol := self basicNew.
	newProtocol newProtocolName: protocolName conformsToProtocolNames: conformsTmp.
	Protocols add: newProtocol.
	(UndefinedConformsToNames includes: protocolName)
		ifTrue: [UndefinedConformsToNames remove: protocolName].
	^ newProtocol!

privateRehashProtocols
	"Private -"

	Protocols rehash!

privateValidConformsToProtocolNames: protocolNamesIn ifError: errorBlock
	"Private -"

	| protocolNamesTmp |
	(protocolNamesIn isKindOf: Collection) ifFalse: [^errorBlock value].
	protocolNamesIn isEmpty ifTrue: [^errorBlock value].
	protocolNamesIn isEmpty ifTrue: [^errorBlock value].
	protocolNamesTmp := ProtocolSpec defaultProtocolNameCollection.
	protocolNamesIn do: 
			[:protocolName |
			(protocolName isKindOf: Symbol) ifFalse: [^errorBlock value].
			(ProtocolSpec includesProtocolNamed: protocolName)
				ifFalse: [ProtocolSpec addUndefinedProtocolName: protocolName].
			protocolNamesTmp add: protocolName].
	^protocolNamesTmp!

protocol
	"Answer the protocol class object."

	^ SUnitNameResolver classNamed: #'ProtocolSpec'!

protocolANY
	"Answer the protocol <ANY> class object."

	^ SUnitNameResolver classNamed: #'ProtocolANYSpec'!

protocolANYName
	"Answer the protocol <ANY> name."

	^ #'ANY'!

protocolMsgParmSpec
	"Answer the protocol message parameter specification class object."

	^ SUnitNameResolver classNamed: #'MsgParmSpec'!

protocolMsgReturnValueRuleSpec
	"Answer the protocol message return value rule specification class object."

	^ SUnitNameResolver classNamed: #'MsgReturnRuleSpec'!

protocolMsgReturnValueSpec
	"Answer the protocol message return value specification class object."

	^ SUnitNameResolver classNamed: #'MsgReturnSpec'!

protocolMsgSpec
	"Answer the protocol message specification class object."

	^ SUnitNameResolver classNamed: #'ProtocolMsgSpec'!

protocolNamed: protocolName 
	"Answer the protocol named protocolName."

	(protocolName isKindOf: Symbol)
		ifFalse: [self error: 'Protocol name not a Symbol.'].
	^ Protocols detect: [:protocol | protocol protocolName = protocolName]
		ifNone: [self error: 'Protocol named: "' , protocolName , '" not found.']!

protocolsInNameList: protocolNameList 
	"Answer the list of protocols named in protocolNameList."

	^ (protocolNameList collect: [:protocolName | self protocolNamed: protocolName]) asSet!

purgeUnused
	"Answer a list of protocols which are not currently implemented by any class or metaclass in the system after removing them. 
	Note: This might take a while.  Example: 
	 
	1 protocolManager purgeUnused
	"
	#todo."Fix??? don't forget to leave <ANY> even though no class explicity conforms?? "
	Error notYetImplemented!

removeAnsiProtocolNamed: protocolName
	"Remove the protocol named, protocolName, from the system. 
	Note: Protocol <ANY> can not be removed."

	| conformingList targetProtocol |
	protocolName = ProtocolSpec protocolANYName
		ifTrue: [self error: 'Protocol <' , protocolName , '> can not be removed.'].
	targetProtocol := self protocolNamed: protocolName.
	conformingList := targetProtocol conformingBehaviors.
	conformingList do: 
			[:classOrMetaclass |
			(classOrMetaclass ansiProtocolNames includes: protocolName)
				ifTrue: [classOrMetaclass removeAnsiProtocolNamed: protocolName]].
	Protocols remove: targetProtocol
		ifAbsent: [self error: 'Protocol named: "' , protocolName , '" not found.']!

renameProtocolNamed: oldName to: newName 
	"Rename the protocol named oldName to have the new name, newName. and update any conforming class or metaclass."
	| targetProtocol |
	targetProtocol := self protocolNamed: oldName.
	targetProtocol renameToProtocolName: newName!

specSectionsFromSynopsis: messageSynopsis definedIn: definedInProtocolName definition: messageDefinition refinedIn: refinedInProtocolName refinement: messageRefinement errors: messageErrors
	"Private - Create a new specification sections with parms and return it."

	| secDict |
	secDict := ProtocolSpec defaultSpecSectionsCollection.
	definedInProtocolName isEmpty ifFalse: [secDict at: #DefinedIn put: definedInProtocolName].
	messageDefinition isEmpty ifFalse: [secDict at: #Definition put: messageDefinition].
	messageErrors isEmpty ifFalse: [secDict at: #Errors put: messageErrors].
	refinedInProtocolName isEmpty ifFalse: [secDict at: #RefinedIn put: refinedInProtocolName].
	messageRefinement isEmpty ifFalse: [secDict at: #Refinement put: messageRefinement].
	messageSynopsis isEmpty ifFalse: [secDict at: #Synopsis put: messageSynopsis].
	^secDict!

unaryReturnProtocolNameReceiver: receiver 
	"Answer the return value conforms-to protocol name of a unary message performing arithmetic, arithmetic progressions, and conversion on numerical quantities sent to receiver."
	| receiverProto |
	receiverProto := self instanceProtocol: receiver.
	^ UnaryConvTable at: receiverProto!

undefinedConformsToProtocolNames
	"Answer the undefined conforms-to protocol names in the system."

	^ UndefinedConformsToNames!

uninitialize
	ClassProtocols := Protocols := DefaultConvTable := UnaryConvTable := OperatorTable.!

wrkAllRuleReturnValueList
	"Private - Answers a Dictionary of protocols containing messages with return value specified by a rule.  The key is the protocol name and the value is a Dictionarys of message selector keys and  return value spec. set with one MsgReturnRuleSpec containing the rule source code.  Example use: 
	 
	(FileStream readOnlyFileNamed: 
	'C:\Dev\ANSI\ANSIGood\Squeak\AProtos.st.chg' 
	) fileIn. 
	1 protocolManager wrkAllRuleReturnValueList
	"

	| protocolsWithRuleList msgSelRuleCodeList |
	protocolsWithRuleList := Dictionary new.
	ProtocolSpec allAnsiProtocols do: 
			[:protocol |
			protocol messages do: 
					[:msg |
					msg isReturnValueSpecByRule
						ifTrue: 
							[msgSelRuleCodeList := protocolsWithRuleList at: protocol protocolName
										ifAbsent: [protocolsWithRuleList at: protocol protocolName put: Dictionary new].
							msgSelRuleCodeList at: msg messageSelector put: msg specForEachReturnValueList]]].
	^protocolsWithRuleList!

wrkAssocGlobalGenUnitTestsForProtocolGroup: protocolGroupName protocolGlobalsClassSideGenTests: protocolGlobalsClassSideGenTests 
	"Private - Generate unit test stub classes for protocol group named, protocolGroupName.  Parameter protocolGlobalsClassSideGenTests array has the protocol name, correspnding global classes, instance or class side protocol ind, and generate unit test ind.  It will generate the methods specified by protocol and conforms-To protocols in the test class for each protocol global class (or protocol inheritance tree leaf).
	The test method naming convention I use is: 
	 
	instance side protocolmethods:	testInstXselector	testInstXselectorX 
	class side protocol methods:		testClsXselector	testClsXselectorX 
	conformsTo protocol methods:	testConToXselector testConToXselectorX 
	operator (+, ==, /, etc) methods:	testInstXadditionOp	testInstXfixOp1 
	 
	The operator test methods testInstXfixOp1 have to be hand editted to change test method selector to testInstXoperatorNameOp.  Example use: 
	
	"
	| assocGlobalClasses genUnitTestSw isClassSideProtocolSw protocolName |
	protocolGlobalsClassSideGenTests
		do: 
			[:parmArray | 
			protocolName := parmArray at: 1.
			assocGlobalClasses := parmArray at: 2.
			isClassSideProtocolSw := (parmArray at: 3)
						= 'class'.
			genUnitTestSw := (parmArray at: 4)
						= 'UT'.
			self
				wrkAssocProtocolNamed: protocolName
				toClassesNamed: assocGlobalClasses
				isClassSideProtocol: isClassSideProtocolSw.
			genUnitTestSw
				ifTrue: [self
						wrkGenTestClassForProtocol: protocolName
						inProtocolGroupNamed: protocolGroupName
						isClassSideProtocol: isClassSideProtocolSw]]!

wrkAssocProtocolNamed: protocolName toClassesNamed: assocGlobalClassesArray isClassSideProtocol: isClassSideProtocolSw 
	"Private - Assign a protocol to a list of ANSI class globals."
	| classSymbol |
	assocGlobalClassesArray
		do: 
			[:className | 
			classSymbol := className asSymbol.
			isClassSideProtocolSw
				ifTrue: [(SUnitNameResolver classNamed: classSymbol) class addProtocolNamed: protocolName]
				ifFalse: [(SUnitNameResolver classNamed: classSymbol)
						addProtocolNamed: protocolName]]!

wrkChkTestsForProtocol: protocolName inProtocolGroupNamed: protocolGroupName isClassSideProtocol: isClassSideProtocolSw
	"Private - Generate test suite stub methods for the directly specified messages and all conforms-To protocols of protocol named, protocolName, in protocol group named, protocolGroupName.  Parameter isClassSideProtocolSw indicates an instance or class side protocol. 
	The test method naming convention I use is: 
	 
	instance side protocol methods:	testInstXselector	testInstXselectorX 
	class side protocol methods:		testClsXselector	testClsXselectorX 
	conformsTo protocol methods:	testConToXselector testConToXselectorX 
	operator (+, ==, /, etc) methods:	testInstXadditionOp	testInstXfixOp1 
	 
	The operator test methods testInstXfixOp1 have to be hand editted to change test method selector to testInstXoperatorNameOp.  Example use:
	"

	| protocol testSelNameSymbol protocolNameSymbolTmp sourceTmp aDict visitedProtocols testClass s1 s2 |
	protocol := ProtocolSpec protocolNamed: protocolName asSymbol.
	FixNum := 0.
	testClass := self wrkTestClassForProtocol: protocolName inProtocolGroupNamed: protocolGroupName.
	"Build a message selector->protocol dictionary of the directly specified and all conforms-To protocols messages"
	aDict := Dictionary new.
	visitedProtocols := Set new.
	protocol wrkAllConformsToMessageSelectorsTo: aDict visited: visitedProtocols.
	"Generate test suite methods"
	aDict keysAndValuesDo: 
			[:msgSel :aProtocolName |
			testSelNameSymbol := (self wrkTestMethdodNameFrom: msgSel) asSymbol.
			(testClass includesSelector: testSelNameSymbol)
				ifTrue: 
					[sourceTmp := (testClass sourceMethodAt: testSelNameSymbol) asString.
					s1 := (sourceTmp indexOf: $<) + 1.
					s2 := (sourceTmp indexOf: $>) - 1.
					protocolNameSymbolTmp := (sourceTmp copyFrom: s1 to: s2) asSymbol.
					self halt.
					protocolNameSymbolTmp = aProtocolName ifFalse: [self halt]]]!

wrkGenerateMethdodsInTestClassNamed: testClassName forProtocolNamed: protocolName inProtocolGroupNamed: protocolGroupName isClassSideProtocol: isClassSideProtocolSw
	"Private - Generate test suite stub methods in test class named, testClassName, for protocol named, protocolName, in protocol group named, protocolGroupName, that is an instance side protocol (isClassSideProtocolSw = false) or class side protocol (isClassSideProtocolSw = true). 
	I name instance side protocol test methods %testInstXselector% & %testInstXselectorX% for Class >>#selector & Class >>#selector:. 
	I name class side protocol test methods %testClsXselector% &  %testClsXselectorX% for Class >>#selector & Class >>#selector:. 
	I name operator (+, ==, /, etc) test methods %testInstXfixOp1% Class >>#selector & Class >>#+.   I number these fixes sequentially starting with 1. 
	The operator (+, ==, /, etc) test methods %testInstXfixOp1% have to be hand editted to change test method selector to %testInstXadditionOp% (identityOp, divisionOp, etc). 
	Example use: 
	 
	1 protocolManager 
	wrkGenerateMethdodsInTestClassNamed: 'CharacterFactoryProtocolTest' 
	forProtocolNamed: #'Character factory' 
	inProtocolGroupNamed: 'Numeric' 
	isClassSideProtocol: true. 
	1 protocolManager 
	wrkGenerateMethdodsInTestClassNamed: 'CharacterProtocolTest' 
	forProtocolNamed: #'Character' 
	inProtocolGroupNamed: 'Numeric' 
	isClassSideProtocol: false.
	"

	| protocol testSelName instOrClass classOrMetaclassObj fixNum commentTmp opTable |
	opTable := Dictionary new.
	opTable at: #= put: 'equalityOp'.
	opTable at: #== put: 'identityOp'.
	opTable at: #~= put: 'notEqualityOp'.
	opTable at: #~~ put: 'notIdentityOp'.
	opTable at: #& put: 'andOp'.
	opTable at: #| put: 'orOp'.
	opTable at: #< put: 'lessThanOp'.
	opTable at: #<= put: 'lessThanOrEqualToOp'.
	opTable at: #> put: 'greaterThanOp'.
	opTable at: #>= put: 'greaterThanOrEqualToOp'.
	opTable at: #* put: 'multiplyOp'.
	opTable at: #+ put: 'addOp'.
	opTable at: #- put: 'subtractOp'.
	opTable at: #/ put: 'divideOp'.
	opTable at: #// put: 'integerDivideOp'.
	opTable at: #\\ put: 'remainderIntegerDivideOp'.
	protocol := ProtocolSpec protocolNamed: protocolName.
	"Generate test suite class method >>#suite :"
	classOrMetaclassObj := (SUnitNameResolver classNamed: testClassName asSymbol) class.
	classOrMetaclassObj
		compile: 'suite
	| testSuite |
	testSuite := TestSuite new.
	self selectors do: [ :selector |
		(selector indexOfSubCollection: ''test'') = 1 ifTrue: [
			testSuite addTest: (self selector: selector)
	]	].
	^testSuite
'.
	classOrMetaclassObj classify: #suite under: 'instance creation'.
	"Generate test suite instance methods >>#testInstXetc or >>#testClsXetc :"
	isClassSideProtocolSw ifTrue: [instOrClass := 'Cls'] ifFalse: [instOrClass := 'Inst'].
	fixNum := 0.
	protocol messageSelectors do: 
			[:msgSel |
			msgSel isInfix
				ifTrue: 
					[(opTable includesKey: msgSel)
						ifTrue: [testSelName := 'test' , instOrClass , 'X' , (opTable at: msgSel)]
						ifFalse: 
							[fixNum := fixNum + 1.
							testSelName := 'test' , instOrClass , 'XfixOp' , fixNum printString]]
				ifFalse: 
					[testSelName := 'test' , instOrClass , 'X'
								, (msgSel asString collect: [:char | char = $: ifTrue: [$X] ifFalse: [char]])].
			commentTmp := '" ' , msgSel , ' "'.
			classOrMetaclassObj := SUnitNameResolver classNamed: testClassName asSymbol.
			classOrMetaclassObj
				compile: testSelName , '
	' , commentTmp , '
	#''' , protocolGroupName , '''.
'.
			classOrMetaclassObj classify: testSelName asSymbol under: 'testing']!

wrkGenTestClassForProtocol: protocolName inProtocolGroupNamed: protocolGroupName isClassSideProtocol: isClassSideProtocolSw
	"Private - Generate test suite stub methods for the directly specified messages and all conforms-To protocols of protocol named, protocolName, in protocol group named, protocolGroupName.  Parameter isClassSideProtocolSw indicates an instance or class side protocol. 
	The test method naming convention I use is: 
	 
	instance side protocol methods:	testInstXselector	testInstXselectorX 
	class side protocol methods:		testClsXselector	testClsXselectorX 
	conformsTo protocol methods:	testConToXselector testConToXselectorX 
	operator (+, ==, /, etc) methods:	testInstXadditionOp	testInstXfixOp1 
	 
	The operator test methods testInstXfixOp1 have to be hand editted to change test method selector to testInstXoperatorNameOp.  Example use:
	"

	| protocol testSelName commentTmp aDict visitedProtocols testClass |
	protocol := ProtocolSpec protocolNamed: protocolName asSymbol.
	FixNum := 0.
	testClass := self wrkTestClassForProtocol: protocolName inProtocolGroupNamed: protocolGroupName.
	"Build a message selector->protocol dictionary of the directly specified and all conforms-To protocols messages"
	aDict := Dictionary new.
	visitedProtocols := Set new.
	protocol wrkAllConformsToMessageSelectorsTo: aDict visited: visitedProtocols.
	"Generate test suite methods"
	aDict keysAndValuesDo: 
			[:msgSel :aProtocolName |
			testSelName := self wrkTestMethdodNameFrom: msgSel.
			commentTmp := '" <' , aProtocolName , '>#' , msgSel , ' "'.
			testClass compile: testSelName , '
	' , commentTmp , '
	#''' , protocolGroupName , '''.
'.
			testClass classify: testSelName asSymbol under: 'testing']!

wrkTestClassForProtocol: protocolName inProtocolGroupNamed: protocolGroupName 
	"Private - Answer a unit test class for protocol named, protocolName, in group named, protocolGroupName."
	| testClassName tmp classObj |
	testClassName := String new.
	tmp := protocolName subStrings.
	tmp
		do: 
			[:protocolNameParts | 
			protocolNameParts at: 1 put: (protocolNameParts at: 1) asUppercase.
			testClassName := testClassName , protocolNameParts].
	testClassName := (testClassName , 'ANSITest') asSymbol.
	classObj := [(SUnitNameResolver classNamed: #'TestCaseProtocol')
				subclass: testClassName
				instanceVariableNames: ''
				classVariableNames: ''
				poolDictionaries: ''
				category: 'Tests-ANSI-' , protocolGroupName]
				on: Error
				do: 
					[:except | 
					except messageText: 'Error compiling class definition of : "' , testClassName , '" - ' , except description.
					except resignalAs: Warning].
	^ classObj!

wrkTestMethdodNameFrom: messageSelector 
	"Private - Answer a generated test suite stub method name from messageSelector. fixNum which may be incremented if a test methdod name is generated that must be fixed up by hand."
	| testSelName |
	messageSelector isInfix
		ifTrue: [(OperatorTable includesKey: messageSelector)
				ifTrue: [testSelName := 'testX' , (OperatorTable at: messageSelector)]
				ifFalse: 
					[FixNum := FixNum + 1.
					testSelName := 'testXfixOp' , FixNum printString]]
		ifFalse: [testSelName := 'testX' , (messageSelector asString
							collect: [:char | char = $:
									ifTrue: [$X]
									ifFalse: [char]])].
	^ testSelName!

xCommonTasks
	"The following are tasks comonly performed:"

	"Initialize the list of protocol objects:"

	ProtocolSpec initializeProtocols.
	"Remove protocol objects not currently assigned to any class or metaclass 
	(Answers a list.  This might take a while.):"
	ProtocolSpec purgeUnused.
	"Remove protocol object:"
	ProtocolSpec removeAnsiProtocolNamed: #classDescription.
	"Answer the sorted list of protocol name symbols:"
	ProtocolSpec allProtocolNamesSorted.
	"Answer the list of protocol name symbols:"
	ProtocolSpec allProtocolNames.
	"Answer the list of undefined conforms-to protocol name symbols:"
	ProtocolSpec undefinedConformsToProtocolNames.
	"Answer the list of conforming classes or metaclasses:"
	(ProtocolSpec protocolNamed: #integer) conformingBehaviors.
	"Answer the list of conforms-to protocol name symbols:"
	(ProtocolSpec protocolNamed: 'Object class' asSymbol) allConformsToProtocolNames.
	"-> Set (ANY Object instantiator classDescription )"
	"Answer the list of all of selectors which make up the protocol 
	and all protocols to which the it conforms:"
	(ProtocolSpec protocolNamed: 'Object class' asSymbol) allMessageSelectors.
	"Answer the list of all of selectors which make up the protocol:"
	(ProtocolSpec protocolNamed: 'Object class' asSymbol) conformsToMessageSelectors.
	ProtocolSpec includesProtocolNamed: #Object.
	"-> true"
	"Assign or query classes or metaclasses:"
	(SUnitNameResolver classNamed: #Symbol) addProtocolNamed: #Object.
	ExceptionSet removeAnsiProtocolNamed: #exceptionSet.
	ExceptionSet ansiProtocolNames.
	"-> Set (exceptionSet )"
	ExceptionSet class ansiProtocolNames.
	"->  Set ()"
	ExceptionSet conformsToAnsiProtocolNamed: #Object.
	"-> true"
	ExceptionSet class conformsToAnsiProtocolNamed: #Object.
	"-> true"
	Symbol conformsToAnsiProtocolNamed: #Object.
	"-> true"
	true class ansiProtocolNames.
	"-> Set ()"
	true class conformsToAnsiProtocolNamed: #boolean!

xGlobalsImplementAllMsgsOfProtocolNamed: protoName
	"Answer the a Dictionary containing the conforming global class or metaclass name and corresponding missing selector symbol of protocol named, protoName.  Example: 
	 
	1 protocolManager 
	xGlobalsImplementAllMsgsOfProtocolNamed: #'Character factory'
	"

	| protocol missingMsg conformingBehaviorObjs |
	protocol := ProtocolSpec protocolNamed: protoName.
	conformingBehaviorObjs := (ProtocolSpec protocolNamed: 'Character factory' asSymbol)
				conformingBehaviors.
	missingMsg := Dictionary new.
	protocol messageSelectors do: 
			[:msgSel |
			conformingBehaviorObjs do: 
					[:classOrMetaclassObj |
					(classOrMetaclassObj includesSelector: msgSel)
						ifFalse: [missingMsg at: classOrMetaclassObj name put: msgSel]]].
	^missingMsg!

xMessagesAndReturnValuesOfProtocolNamed: protoName
	"Answer the a string containing the messages and their corresponding return values of protocol named, protoName.  Example: 
	 
	1 protocolManager 
	xMessagesAndReturnValuesOfProtocolNamed: #'instantiator'
	"

	| protocol aStream |
	aStream := WriteStream on: (String new: 500).
	aStream cr.
	protocol := ProtocolSpec protocolNamed: protoName.
	protocol messages asSortedCollection do: 
			[:msg |
			msg messageSelector printOn: aStream.
			aStream nextPutAll: '->'.
			msg specForEachReturnValueList printOn: aStream.
			aStream cr].
	aStream contents!

xMsgSpecListOfSelector: selector inProtocolNamed: protoName
	"Answer the list of msg specs for msg with selector, selector, in protocol named, protoName.  Example: 
	 
	1 protocolManager 
	xMsgSpecListOfSelector: #',' 
	inProtocolNamed: #'exceptionSelector'
	"

	| msgSpec proto |
	proto := ProtocolSpec protocolNamed: protoName.
	msgSpec := proto messageAtSelector: selector.
	^msgSpec specForEachReturnValueList!

xRemoveMsgSpecSelectors: selectorList fromProtocolNamed: protoName
	"Answer the list of msg specs with selectors, selectorList, after removing the msg specs from protocol named, protoName.  Example: 
	1 protocolManager 
	xRemoveMsgSpecSelectors: #(#'name') 
	fromProtocolNamed: #'classDescription'
	"

	| proto |
	proto := ProtocolSpec protocolNamed: protoName.
	^proto removeAllSelectors: selectorList!

xRuleSourceOfMsgSelector: selector inProtocolNamed: protoName
	"Answer the return value rule block source of msg with selector, selector, in protocol named, protoName.  Example: 
	 
	1 protocolManager 
	xRuleSourceOfMsgSelector: #'+' 
	inProtocolNamed: #'number'
	"

	| msgSpec proto |
	proto := ProtocolSpec protocolNamed: protoName.
	msgSpec := proto messageAtSelector: selector.
	^msgSpec specForEachReturnValueList asArray first returnValueRuleBlockSource! !
!ProtocolSpec class categoriesForMethods!
addUndefinedProtocolName:!public! !
allAnsiProtocols!public! !
allProtocolNames!public! !
allProtocolNamesSorted!public! !
classProtocols!public! !
defaultConformsToCollection!public! !
defaultEmptyDescription!public! !
defaultMessageSpecificationCollection!public! !
defaultProtocolCollection!public! !
defaultProtocolNameCollection!public! !
defaultReturnProtocolNameReceiver:operand:!public! !
defaultSpecSectionsCollection!public! !
errorProtocolNotFound:!public! !
fileOutAllProtocolsSIFFiler:!public! !
fileOutSIFAllProtocolsDescOnFiler:!public! !
fileOutSIFAllProtocolsToFileLocator:!public! !
includesProtocolNamed:!public! !
initialize!public! !
initializeDefaultConversionTable!public! !
initializeOperatorTable!public! !
initializeProtocols!public! !
initializeUnaryConversionTable!public! !
instanceProtocol:!public! !
methodSelector:!private! !
new!public! !
newMessagePattern:forProtocolNamed:synopsis:definedIn:definition:refinedIn:refinement:parameters:returnRule:errors:!public! !
newMessagePattern:forProtocolNamed:synopsis:definedIn:definition:refinedIn:refinement:parameters:returnValues:errors:!public! !
newProtocolNamed:conformsToProtocolNames:!public! !
nextTokenFrom:!private! !
parametersFromList:!public! !
privateNewProtocolNamed:conformsToProtocolNames:!public! !
privateRehashProtocols!public! !
privateValidConformsToProtocolNames:ifError:!public! !
protocol!public! !
protocolANY!public! !
protocolANYName!public! !
protocolMsgParmSpec!public! !
protocolMsgReturnValueRuleSpec!public! !
protocolMsgReturnValueSpec!public! !
protocolMsgSpec!public! !
protocolNamed:!public! !
protocolsInNameList:!public! !
purgeUnused!public! !
removeAnsiProtocolNamed:!public! !
renameProtocolNamed:to:!public! !
specSectionsFromSynopsis:definedIn:definition:refinedIn:refinement:errors:!public! !
unaryReturnProtocolNameReceiver:!public! !
undefinedConformsToProtocolNames!public! !
uninitialize!public! !
wrkAllRuleReturnValueList!public! !
wrkAssocGlobalGenUnitTestsForProtocolGroup:protocolGlobalsClassSideGenTests:!public! !
wrkAssocProtocolNamed:toClassesNamed:isClassSideProtocol:!public! !
wrkChkTestsForProtocol:inProtocolGroupNamed:isClassSideProtocol:!public! !
wrkGenerateMethdodsInTestClassNamed:forProtocolNamed:inProtocolGroupNamed:isClassSideProtocol:!public! !
wrkGenTestClassForProtocol:inProtocolGroupNamed:isClassSideProtocol:!public! !
wrkTestClassForProtocol:inProtocolGroupNamed:!public! !
wrkTestMethdodNameFrom:!public! !
xCommonTasks!public! !
xGlobalsImplementAllMsgsOfProtocolNamed:!public! !
xMessagesAndReturnValuesOfProtocolNamed:!public! !
xMsgSpecListOfSelector:inProtocolNamed:!public! !
xRemoveMsgSpecSelectors:fromProtocolNamed:!public! !
xRuleSourceOfMsgSelector:inProtocolNamed:!public! !
!

