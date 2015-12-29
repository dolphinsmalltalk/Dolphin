"Filed out from Dolphin Smalltalk X6.2"!

DTDEntityDeclaration subclass: #DTDParameterEntityDeclaration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DTDParameterEntityDeclaration guid: (GUID fromString: '{D99F2EC2-DCB6-4BC6-ABA4-571EF1A16782}')!
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
!DTDParameterEntityDeclaration categoriesFor: #includePE!behaviors!public! !
!DTDParameterEntityDeclaration categoriesFor: #notRecognized!behaviors!public! !
!DTDParameterEntityDeclaration categoriesFor: #registerIn:!invocation!public! !

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
!DTDParameterEntityDeclaration class categoriesFor: #initialize!class initialization!public! !
!DTDParameterEntityDeclaration class categoriesFor: #leadIn!accessing!public! !

