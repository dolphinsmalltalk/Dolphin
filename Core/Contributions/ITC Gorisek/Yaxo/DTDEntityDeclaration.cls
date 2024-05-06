"Filed out from Dolphin Smalltalk"!

Object subclass: #DTDEntityDeclaration
	instanceVariableNames: 'name value ndata'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'contextBehavior'!

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

!DTDEntityDeclaration categoriesForMethods!
bypass!behaviors!public! !
forbidden!behaviors!public! !
include!behaviors!public! !
includedInLiteral!behaviors!public! !
name!accessing!public! !
name:!accessing!public! !
ndata!accessing!public! !
ndata:!accessing!public! !
reference!behaviors!public! !
registerIn:!invocation!public! !
value!accessing!public! !
value:!accessing!public! !
valueForContext:!invocation!public! !
!

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

!DTDEntityDeclaration class categoriesForMethods!
behaviorForContext:!accessing!public! !
contextBehavior!accessing!public! !
initialize!class initialization!public! !
leadIn!accessing!public! !
name:value:!instance creation!public! !
!

