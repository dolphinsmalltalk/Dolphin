"Filed out from Dolphin Smalltalk"!

DTDEntityDeclaration subclass: #DTDParameterEntityDeclaration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DTDParameterEntityDeclaration guid: (GUID fromString: '{d99f2ec2-dcb6-4bc6-aba4-571ef1a16782}')!
DTDParameterEntityDeclaration comment: ''!
!DTDParameterEntityDeclaration categoriesForClass!XML-Parser! !
!DTDParameterEntityDeclaration methodsFor!

includePE
	"Return my expanded value."
	^self include!

notRecognized
	SAXMalformedException signal: 'Malformed entity.'!

registerIn: aParser
	aParser parameterEntity: self name put: self! !
!DTDParameterEntityDeclaration categoriesForMethods!
includePE!behaviors!public! !
notRecognized!behaviors!public! !
registerIn:!invocation!public! !
!

!DTDParameterEntityDeclaration class methodsFor!

initialize
	"
	DTDParameterEntityDeclaration initialize
	"

	contextBehavior := Dictionary new.
	contextBehavior
		at: #content put: #notRecognized:;
		at: #attributeValueContent put: #notRecognized:;
		at: #attributeValue put: #notRecognized:;
		at: #entityValue put: #include:;
		at: #dtd put: #includePE:!

leadIn
	^'%'! !
!DTDParameterEntityDeclaration class categoriesForMethods!
initialize!class initialization!public! !
leadIn!accessing!public! !
!

