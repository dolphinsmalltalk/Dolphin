"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DTDEntityDeclaration
	instanceVariableNames: 'name value ndata'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'contextBehavior'
	classConstants: {}!
DTDEntityDeclaration guid: (GUID fromString: '{505107dc-2774-4508-bf9d-517bb42532c7}')!
DTDEntityDeclaration comment: ''!
!DTDEntityDeclaration categoriesForClass!XML-Parser! !
!DTDEntityDeclaration methodsFor!

bypass
	"Return my reference as is."
	^self reference!

forbidden
	self error: 'Forbidden reference usage'!

include
	"Return my expanded value."
	^value ifNil: [SAXWarning signal: 'XML undefined entity ' , name printString]!

includedInLiteral
	"Return my expanded value."
	^self include!

name
	^name!

name: aString
	name := aString asSymbol!

ndata
	^ndata!

ndata: aString
	ndata := aString!

reference
	"Return my reference as is."
	^self class leadIn , self name , ';'!

registerIn: aParser
	#swYAXO. "sw added #asString"
	aParser entity: self name asString put: self!

value
	^value!

value: aString
	#swYAXO. "Add recursive check"
	aString = self reference ifTrue: [SAXMalformedException signal: 'A parsed entity must not contain a recursive reference to itself'].

	value := aString!

valueForContext: aContext
	^self perform: (self class behaviorForContext: aContext)! !
!DTDEntityDeclaration categoriesFor: #bypass!behaviors!public! !
!DTDEntityDeclaration categoriesFor: #forbidden!behaviors!public! !
!DTDEntityDeclaration categoriesFor: #include!behaviors!public! !
!DTDEntityDeclaration categoriesFor: #includedInLiteral!behaviors!public! !
!DTDEntityDeclaration categoriesFor: #name!accessing!public! !
!DTDEntityDeclaration categoriesFor: #name:!accessing!public! !
!DTDEntityDeclaration categoriesFor: #ndata!accessing!public! !
!DTDEntityDeclaration categoriesFor: #ndata:!accessing!public! !
!DTDEntityDeclaration categoriesFor: #reference!behaviors!public! !
!DTDEntityDeclaration categoriesFor: #registerIn:!invocation!public! !
!DTDEntityDeclaration categoriesFor: #value!accessing!public! !
!DTDEntityDeclaration categoriesFor: #value:!accessing!public! !
!DTDEntityDeclaration categoriesFor: #valueForContext:!invocation!public! !

!DTDEntityDeclaration class methodsFor!

behaviorForContext: aContext
	^self contextBehavior at: aContext!

contextBehavior
	^contextBehavior!

initialize
	"
	DTDEntityDeclaration initialize
	"

	contextBehavior := Dictionary new.
	contextBehavior
		at: #content put: #include;
		at: #attributeValueContent put: #includedInLiteral;
		at: #attributeValue put: #forbidden;
		at: #entityValue put: #bypass;
		at: #dtd put: #forbidden!

leadIn
	^'&'!

name: aString value: aValueString
	^(self new)
		name: aString;
		value: aValueString;
		yourself! !
!DTDEntityDeclaration class categoriesFor: #behaviorForContext:!accessing!public! !
!DTDEntityDeclaration class categoriesFor: #contextBehavior!accessing!public! !
!DTDEntityDeclaration class categoriesFor: #initialize!class initialization!public! !
!DTDEntityDeclaration class categoriesFor: #leadIn!accessing!public! !
!DTDEntityDeclaration class categoriesFor: #name:value:!instance creation!public! !

