"Filed out from Dolphin Smalltalk X6.2"!

DTDEntityDeclaration subclass: #DTDExternalEntityDeclaration
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DTDExternalEntityDeclaration guid: (GUID fromString: '{5207DAA7-4613-4061-AF6C-804B4D153C68}')!
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

