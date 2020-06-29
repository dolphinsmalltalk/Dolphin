"Filed out from Dolphin Smalltalk 7"!

DTDEntityDeclaration subclass: #DTDExternalEntityDeclaration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DTDExternalEntityDeclaration guid: (GUID fromString: '{5207daa7-4613-4061-af6c-804b4d153c68}')!
DTDExternalEntityDeclaration comment: ''!
!DTDExternalEntityDeclaration categoriesForClass!XML-Parser! !
!DTDExternalEntityDeclaration class methodsFor!

initialize
	"
	DTDExternalEntityDeclaration initialize
	"

	contextBehavior := Dictionary new.
	contextBehavior
		at: #content put: #include;
		at: #attributeValueContent put: #includedInLiteral;
		at: #attributeValue put: #forbidden;
		at: #entityValue put: #bypass;
		at: #dtd put: #forbidden! !
!DTDExternalEntityDeclaration class categoriesFor: #initialize!class initialization!public! !

