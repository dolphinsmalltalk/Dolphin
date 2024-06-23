"Filed out from Dolphin Smalltalk"!

Object subclass: #ProtocolMsgSpec
	instanceVariableNames: 'selector parameterSpecifications returnValueSpecifications specSections'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProtocolMsgSpec guid: (GUID fromString: '{49589213-e5b0-4d6a-91ae-67429ef89ee9}')!

ProtocolMsgSpec comment: ''!

!ProtocolMsgSpec categoriesForClass!Unclassified! !

!ProtocolMsgSpec methodsFor!

<= comperand
	"Answer whether the receiver's message selector is less than or equal to comperand's message selector. 
	Note: This is to allow protocol message selectors to be sorted with the default sort block."

	(comperand isKindOf: ProtocolSpec protocolMsgSpec)
		ifFalse: [self error: 'Comperand not a ProtocolSpec.'].
	^self messageSelector <= comperand messageSelector!

= comperand
	"Answer whether the receiver is considered equal (contains same elements) to comperand.  They are equal if both are instances of the same class and have the same message selector."

	^(comperand isKindOf: ProtocolSpec protocolMsgSpec)
		and: [self messageSelector == comperand messageSelector]!

allReferredToProtocolNames
	"Answer a list of protocol names referred to by the receiver."

	| referredToNames protocolName |
	referredToNames := Set new.
	protocolName := self definedInProtocolName.
	protocolName notNil ifTrue: [referredToNames add: protocolName].
	protocolName := self refinedInProtocolName.
	protocolName isNil ifFalse: [referredToNames add: protocolName].
	self specForEachParmList do: [:msgSpecParm | referredToNames addAll: msgSpecParm parmProtocolNames].
	self specForEachReturnValueList do: 
			[:msgSpecReturn |
			(msgSpecReturn isKindOf: ProtocolSpec protocolMsgReturnValueRuleSpec)
				ifFalse: [referredToNames addAll: msgSpecReturn returnValueProtocolNames]].
	^referredToNames!

definedInProtocolName
	"Answer the protocol name in which the receiver is defined, or nil."

	#todo."??? should this be the proto is component of or Definition: sec proto ???"
	specSections isNil ifTrue: [^ nil].
	^ specSections at: #'DefinedIn' ifAbsent: []!

fileOutOnSIFFiler: programFiler protocol: protocolName 
	"File out the receiver definition and its message definitions on ANSI SIF filer, programFiler."
	| parmString returnIsRuleSw returnOrRule tmpStream |
	#todo. "??? Add annotations ???"
	parmString := '#()'.
	self hasParms
		ifTrue: 
			[tmpStream := WriteStream on: (String new: 200).
			tmpStream nextPutAll: '#( '.
			self specForEachParmList do: [:msgParmSpec | msgParmSpec storeSIFOn: tmpStream]
				separatedBy: [tmpStream space].
			tmpStream nextPutAll: ' )'.
			parmString := tmpStream contents].
	returnIsRuleSw := false.
	returnOrRule := '#()'.
	self hasReturnValue
		ifTrue: [self isReturnValueSpecByRule
				ifTrue: 
					[returnIsRuleSw := true.
					returnOrRule := self specForEachReturnValueList asArray first returnValueRuleBlockSource]
				ifFalse: 
					[tmpStream := WriteStream on: (String new: 200).
					tmpStream nextPutAll: '#( '.
					self specForEachReturnValueList do: [:msgReturnSpec | msgReturnSpec storeSIFOn: tmpStream]
						separatedBy: [tmpStream space].
					tmpStream nextPutAll: ' )'.
					returnOrRule := tmpStream contents]].
	programFiler
		fileOutProtocol: protocolName
		message: self messagePattern
		synopsis: self messageSynopsis
		definedIn: self definedInProtocolName
		definition: self messageDefinition
		refinedIn: self refinedInProtocolName
		refinement: self messageRefinement
		parameters: parmString
		returnIsRule: returnIsRuleSw
		returnValuesOrRule: returnOrRule
		errors: self messageErrors
		annotations: Dictionary new!

hash
	"Answer the hash value for the receiver."

	#todo."I'm not sure this tests effectively for the same elements?????"
	^ self messageSelector hash!

hasParms
	"Answer true if receiver has parameter specifications, else false."

	^ parameterSpecifications notNil!

hasReturnValue
	"Answer true if receiver has return value specifications, else false."

	^ returnValueSpecifications notNil!

isConformingReturn: returnObject 
	"Answer true if the result, returnObject, of sending the receiver conforms to the specified return value, else false."
	| returnClass |
	#todo."??? is no return value an error or compliant ???"
	self hasReturnValue ifFalse: [^ true].
	self isReturnValueSpecByRule ifTrue: [^ false].
	returnClass := returnObject class.
	self specForEachReturnValueList
		do: [:returnSpec | (returnSpec isConformingReturnClass: returnClass)
				ifTrue: [^ true]].
	^ false!

isConformingReturn: returnObject opRECEIVER: receiver conformTo: protocolName selector: msgSelector 
	"Answer true if the result, returnObject, of sending the receiver conforms to the protocol in which it is used, or any protocol that conforms to that protocol, else false."

	#todo."??? Figure out how to do this test ???"
	^ self isConformingReturn: returnObject!

isConformingReturn: returnObject ruleReceiver: receiver 
	"Answer true if the result, returnObject, of sending the receiver conforms to the specified return value, else false."

	#todo."??? is no return value an error or compliant ???"
	self hasReturnValue ifFalse: [^ true].
	self isReturnValueSpecByRule ifFalse: [^ false].
	^ self specForEachReturnValueList asArray first isConformingReturnClass: returnObject class ruleReceiver: receiver!

isConformingReturn: returnObject ruleReceiver: receiver operand: operand 
	"Answer true if the result, returnObject, of sending the receiver conforms to the specified return value, else false."

	#todo."??? is no return value an error or compliant ???"
	self hasReturnValue ifFalse: [^ true].
	self isReturnValueSpecByRule ifFalse: [^ false].
	^ self specForEachReturnValueList asArray first
		isConformingReturnClass: returnObject class
		ruleReceiver: receiver
		operand: operand!

isReturnValueSpecByRule
	"Answer true if the receiver return value protocol is detirmined by a rule, else false."

	returnValueSpecifications isNil ifTrue: [^false].
	^returnValueSpecifications anyOne isKindOf: ProtocolSpec protocolMsgReturnValueRuleSpec!

messageDefinition
	"Answer the definition of the receiver, or an empty string."

	#todo."??? should this be the proto is component of or Definition: sec proto ???"
	specSections isNil ifTrue: [^ String new].
	^ specSections at: #'Definition' ifAbsent: [String new]!

messageErrors
	"Answer the errors of the receiver, or an empty string."

	#todo."??? should this be the proto is component of or Definition: sec proto ???"
	specSections isNil ifTrue: [^ String new].
	^ specSections at: #'Errors' ifAbsent: [String new]!

messagePattern
	"Answer the message pattern of the receiver."
	| aStream colonCnt parmNames |
	parmNames := (self specForEachParmList collect: [:msgParmSpec | msgParmSpec parmName]) asArray.
	(selector includes: $:)
		ifFalse: 
			[parmNames size = 0 ifTrue: [^ selector asString].
			parmNames size = 1 ifTrue: [^ selector asString , ' ' , (parmNames at: 1)].
			self error: 'Mis-matched parms & selector.'].
	aStream := WriteStream on: (String new: 200).
	colonCnt := 0.
	selector
		do: [:char | char = $:
				ifTrue: 
					[colonCnt := colonCnt + 1.
					aStream nextPutAll: ': '.
					aStream nextPutAll: (parmNames at: colonCnt).
					colonCnt = parmNames size ifFalse: [aStream space]]
				ifFalse: [aStream nextPut: char]].
	^ aStream contents!

messageRefinement
	"Answer the refinement of the receiver, or an empty string."

	#todo."??? should this be the proto is component of or Definition: sec proto ???"
	specSections isNil ifTrue: [^ String new].
	^ specSections at: #'Refinement' ifAbsent: [String new]!

messageSelector
	"Answer the selector of the receiver."

	^ selector!

messageSynopsis
	"Answer the synopsis of the receiver, or an empty string."

	#todo."??? should this be the proto is component of or Definition: sec proto ???"
	specSections isNil ifTrue: [^ String new].
	^ specSections at: #'Synopsis' ifAbsent: [String new]!

printOn: targetStream 
	"Append to targetStream a text representation of the receiver as a developer would want to see it (inspector, etc)."

	#todo."??? fix ???"
	targetStream nextPutAll: self class name;
	 nextPut: $(;
	 nextPutAll: self messageSelector;
	 nextPut: $(.
	self specForEachParmList do: [:parmSpec | targetStream nextPutAll: parmSpec parmName]
		separatedBy: [targetStream space].
	targetStream nextPutAll: ') '.
	"	self specForEachReturnValueList 
	do: [ :returnSpec | targetStream nextPutAll: returnSpec parmName ] 
	separatedBy: [targetStream space].
	"
	targetStream nextPut: $)!

refinedInProtocolName
	"Answer the protocol name in which the receiver is refined, or nil."

	#todo."??? should this be the proto is component of or Refinement: sec proto ???"
	specSections isNil ifTrue: [^ nil].
	^ specSections at: #'RefinedIn' ifAbsent: []!

setSelector: selectorIn specSections: specSectionsIn specForEachParmList: parmSpecsIn specForEachReturnValueList: returnValueSpecsIn 
	"Private -  
	Note: Assumes all parms have been checked for validity."

	selector := selectorIn.
	specSections := specSectionsIn.
	parameterSpecifications := parmSpecsIn.
	returnValueSpecifications := returnValueSpecsIn!

specForEachParmList
	"Answer the specification for each message parameter list of the receiver."

	parameterSpecifications isNil ifTrue: [^ self class defaultParameterSpecificationCollection].
	^ parameterSpecifications!

specForEachReturnValueList
	"Answer the specification for each message return value list of the receiver."

	returnValueSpecifications isNil ifTrue: [^ self class defaultReturnValueSpecificationCollection].
	^ returnValueSpecifications!

specSections
	"Answer the specification sections of the receiver. 
	Note: specSections must be a <Dictionary> of <symbol> keys and <readableString> values.  Keys are: #'Synopsis' #'DefinedIn' #'Definition' #'RefinedIn' #'Refinement' #'Errors'."

	specSections isNil ifTrue: [^ProtocolSpec defaultSpecSectionsCollection].
	^specSections! !

!ProtocolMsgSpec categoriesForMethods!
<=!public! !
=!public! !
allReferredToProtocolNames!public! !
definedInProtocolName!public! !
fileOutOnSIFFiler:protocol:!public! !
hash!public! !
hasParms!public! !
hasReturnValue!public! !
isConformingReturn:!public! !
isConformingReturn:opRECEIVER:conformTo:selector:!public! !
isConformingReturn:ruleReceiver:!public! !
isConformingReturn:ruleReceiver:operand:!public! !
isReturnValueSpecByRule!public! !
messageDefinition!public! !
messageErrors!public! !
messagePattern!public! !
messageRefinement!public! !
messageSelector!public! !
messageSynopsis!public! !
printOn:!public! !
refinedInProtocolName!public! !
setSelector:specSections:specForEachParmList:specForEachReturnValueList:!public! !
specForEachParmList!public! !
specForEachReturnValueList!public! !
specSections!public! !
!

!ProtocolMsgSpec class methodsFor!

defaultParameterSpecificationCollection
	"Private - Answer a <Set>, the default parameter specification collection object."

	^ Set new!

defaultReturnValueSpecificationCollection
	"Private - Answer a <Set>, the default return value specification collection object."

	^ Set new!

new
	"Raise an exception as this is an inappropriate message."

	^ self shouldNotImplement!

newSelector: selector specSections: specSections specsForEachParm: parmSpecs specsForEachReturnValue: retValSpecs 
	"Answer a new protocol message specification with selector, selector, specSections, specSections, a list of specifications for each parameter, parmSpecs, and a list of specifications for each return value, retValSpecs.
	Note: specSections must be a <Dictionary> of <symbol> keys and <readableString> values, parmSpecs must be a <collection> of <protocolMessageParmSpec>s, retValSpecs, a <collection> of <protocolMessageReturnSpec>s."

	^ self
		privateNewSelector: selector
		specSectionsOrNil: specSections
		specForEachParmOrListOrNil: parmSpecs
		specForEachReturnValueOrListOrNil: retValSpecs!

privateMessagePatternParmListOrNil: parmSpecsIn selector: selectorIn 
	"Private - Answer the message pattern of the receiver."
	| aStream colonCnt parmNames parmSpecsTmp |
	parmSpecsIn isNil
		ifTrue: [parmSpecsTmp := Set new]
		ifFalse: [parmSpecsTmp := parmSpecsIn].
	parmNames := (parmSpecsTmp collect: [:msgParmSpec | msgParmSpec parmName]) asArray.
	(selectorIn includes: $:)
		ifFalse: 
			[parmNames size = 0 ifTrue: [^ selectorIn asString].
			parmNames size = 1 ifTrue: [^ selectorIn asString , ' ' , (parmNames at: 1)].
			self error: 'Mis-matched parms & selectorIn.'].
	aStream := WriteStream on: (String new: 200).
	colonCnt := 0.
	selectorIn do: [:char |
		char = $:
			ifTrue: 
				[colonCnt := colonCnt + 1.
				aStream nextPutAll: ': '.
				aStream nextPutAll: (parmNames at: colonCnt).
				colonCnt = parmNames size ifFalse: [aStream space]]
			ifFalse: [aStream nextPut: char]].
	^ aStream contents!

privateNewSelector: selectorIn specSectionsOrNil: specSectionsIn specForEachParmOrListOrNil: parmSpecsIn specForEachReturnValueOrListOrNil: retValSpecsIn 
	"Private -"
	| newProtocolMsgSpec specSectionsTmp parmSpecsTmp retValSpecsTmp |
	(selectorIn isKindOf: Symbol)
		ifFalse: [self error: 'Protocol msg. spec. selector not a Symbol.'].
	specSectionsTmp := self privateValidSpecSectionsOrNil: specSectionsIn ifError: [^ self error: 'Protocol msg. spec. spec. sections not a Dictionary.'].
	parmSpecsTmp := self
				privateValidParmOrListOrNil: parmSpecsIn
				selector: selectorIn
				ifError: [^ self error: 'Protocol msg. spec. parm not a Collection of ProtocolMsgSpec or nil.'].
	retValSpecsTmp := self privateValidReturnValueOrListOrNil: retValSpecsIn ifError: [^ self error: 'Protocol ret. val. spec. not a Collection of MsgReturnSpec or nil.'].
	newProtocolMsgSpec := super basicNew.
	newProtocolMsgSpec
		setSelector: selectorIn
		specSections: specSectionsTmp
		specForEachParmList: parmSpecsTmp
		specForEachReturnValueList: retValSpecsTmp.
	^ newProtocolMsgSpec!

privateValidParmOrListOrNil: parmSpecsIn selector: selectorIn ifError: errorBlock
	"Private -"

	| parmSpecsTmp colonCnt |
	(parmSpecsIn isKindOf: ProtocolSpec protocolMsgParmSpec)
		ifTrue: [self privateMessagePatternParmListOrNil: (Set with: parmSpecsIn) selector: selectorIn]
		ifFalse: [self privateMessagePatternParmListOrNil: parmSpecsIn selector: selectorIn].
	parmSpecsIn isNil ifTrue: [^nil].
	(parmSpecsIn isKindOf: ProtocolSpec protocolMsgParmSpec)
		ifTrue: 
			[parmSpecsTmp := self defaultParameterSpecificationCollection.
			parmSpecsTmp add: parmSpecsIn.
			^parmSpecsTmp].
	(parmSpecsIn isKindOf: Collection) ifFalse: [^errorBlock value].
	parmSpecsIn isEmpty ifTrue: [^nil].
	colonCnt := (selectorIn select: [:char | char = $:]) size.
	colonCnt > 0
		ifTrue: 
			[colonCnt = parmSpecsIn size
				ifFalse: [self error: 'Protocol msg. spec. number of parms do not match selector.']]
		ifFalse: 
			[parmSpecsIn size = 0 | (parmSpecsIn size = 1)
				ifFalse: [self error: 'Protocol msg. spec. number of parms do not match selector.']].
	parmSpecsTmp := self defaultParameterSpecificationCollection.
	parmSpecsIn do: 
			[:parmSpec |
			(parmSpec isKindOf: ProtocolSpec protocolMsgParmSpec) ifFalse: [^errorBlock value].
			parmSpecsTmp add: parmSpec].
	^parmSpecsTmp!

privateValidReturnValueOrListOrNil: retValSpecsIn ifError: errorBlock
	"Private -"

	| retValSpecsTmp |
	retValSpecsIn isNil ifTrue: [^nil].
	(retValSpecsIn isKindOf: ProtocolSpec protocolMsgReturnValueSpec)
		ifTrue: 
			[retValSpecsTmp := self defaultReturnValueSpecificationCollection.
			retValSpecsTmp add: retValSpecsIn.
			^retValSpecsTmp].
	(retValSpecsIn isKindOf: Collection) ifFalse: [^errorBlock value].
	retValSpecsIn isEmpty ifTrue: [^nil].
	retValSpecsTmp := self defaultReturnValueSpecificationCollection.
	retValSpecsIn do: 
			[:rvSpec |
			(rvSpec isKindOf: ProtocolSpec protocolMsgReturnValueSpec) ifFalse: [^errorBlock value].
			retValSpecsTmp add: rvSpec].
	^retValSpecsTmp!

privateValidSpecSectionsOrNil: specSectionsIn ifError: errorBlock 
	"Private -"
	specSectionsIn isNil ifTrue: [^ nil].
	(specSectionsIn isKindOf: Dictionary)
		ifFalse: [^ errorBlock value].
	specSectionsIn isEmpty ifTrue: [^ nil].
	^ specSectionsIn! !

!ProtocolMsgSpec class categoriesForMethods!
defaultParameterSpecificationCollection!public! !
defaultReturnValueSpecificationCollection!public! !
new!public! !
newSelector:specSections:specsForEachParm:specsForEachReturnValue:!public! !
privateMessagePatternParmListOrNil:selector:!public! !
privateNewSelector:specSectionsOrNil:specForEachParmOrListOrNil:specForEachReturnValueOrListOrNil:!public! !
privateValidParmOrListOrNil:selector:ifError:!public! !
privateValidReturnValueOrListOrNil:ifError:!public! !
privateValidSpecSectionsOrNil:ifError:!public! !
!

