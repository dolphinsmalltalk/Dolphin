"Filed out from Dolphin Smalltalk"!

UI.ValueAdaptor
	subclass: #'UI.ValueAspectAdaptor'
	instanceVariableNames: 'aspect putSelector getSelector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ValueAspectAdaptor guid: (Core.GUID fromString: '{87b4c679-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ValueAspectAdaptor comment: 'A ValueAspectAdaptor is capable of adapting an aspect of a subject object and treating this as a <value>. An aspect is considered to be an attribute of an object that can be fetched and set using a pair of accessor methods (aspect and aspect: say). 

ValueAspectAdaptors are typically used in two situations. The first is to adapt an aspect of a model to the generic <value> protocol of #value, #value: messages. This is a common requirement of <dialogPresenter>s which need to present multiple aspects of a model within their sub-presenters. The second is to allow aspects of a domain class which does  not generate change notifications to be used in situations that require them.  

Instance Variables:
	aspect		<Symbol> identifying the aspect
	putSelector	<Symbol> message selector used to set the aspect
	getSelector	<Symbol> message selector used to get the aspect
'!

!UI.ValueAspectAdaptor categoriesForClass!MVP-Models! !

!UI.ValueAspectAdaptor methodsFor!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self == comperand or: [
		self species == comperand species
			and: [self aspect == comperand aspect 
				and: [self subject == comperand subject]]]!

appyTo: anObject
	^anObject perform: self putSelector with: self value!

aspect
	"Private - Answers the aspect of the subject that the receiver is to treat as a value"

	^aspect
!

aspectTriggers: aSymbol
	"Inform the receiver that we expect the subject to trigger aSymbol whenever the aspect is changed."

	subject when: aSymbol send: #notifyChanged to: self
!

beReadOnly
	"Suppress any attempt to write back the value into the subject. Useful for display-only aspects."

	putSelector := #==!

canGet
	"Private - Answer whether the receiver can be read using #value."

	^self subject respondsTo: self getSelector!

canSet
	"Private - Answer whether the receiver can be set using #value:."

	^self subject respondsTo: self putSelector!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: subject;
		nextPut: $[;
		print: self aspect;
		nextPut: $]!

getSelector
	"Private - Answers the selector used for getting the aspect value from the subject"

	^getSelector
!

getValue
	^self subject perform: self getSelector!

hash
	"Answer the <Integer> hash value for the receiver."

	^(self aspect hash bitShift: 1) bitXor: self subject hash!

putSelector
	"Private - Answers the selector used for setting the aspect value into the subject"

	^putSelector ifNil: [putSelector := (aspect , ':') asSymbol]!

setValue: anObject
	"Private - Assigns the value for the receiver without notifying 
	dependents of the change"
	
	self subject perform: self putSelector with: anObject.!

subject: anObject aspect: aSymbol 
	"Private - Sets the subject object and its aspect that is being interfaced
	to by the receiver"

	self subject: anObject.
	aspect := aSymbol.
	getSelector := aspect!

value
	"Answers the <Object> value of the receiver, obtained
	by sending a message to the receiver's subject."

	^self getValue! !

!UI.ValueAspectAdaptor categoriesForMethods!
=!comparing!public! !
appyTo:!commands!public! !
aspect!accessing!private! !
aspectTriggers:!accessing!public! !
beReadOnly!public! !
canGet!private!testing! !
canSet!private!testing! !
displayOn:!displaying!public! !
getSelector!accessing!private! !
getValue!accessing!private! !
hash!comparing!public! !
putSelector!accessing!private! !
setValue:!accessing!private! !
subject:aspect:!initializing!private! !
value!accessing!public! !
!

!UI.ValueAspectAdaptor class methodsFor!

new
	"Private - An instance of this class requires parameters"

	^self shouldNotImplement!

subject: anObject aspect: aSymbol
	"Answers an instance of the receiver that is an interface onto
	an aspect of anObject identified by aSymbol"

	^(super new) subject: anObject aspect: aSymbol; yourself! !

!UI.ValueAspectAdaptor class categoriesForMethods!
new!instance creation!private! !
subject:aspect:!instance creation!public! !
!

