"Filed out from Dolphin Smalltalk"!

ReferencesCategory subclass: #SingleUnarySendMethodCategory
	instanceVariableNames: 'selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SingleUnarySendMethodCategory guid: (GUID fromString: '{0adb321d-bb42-4acf-a21f-49b37095183a}')!

SingleUnarySendMethodCategory comment: 'SingleUnarySendMethodCategory is the class of virtual method categories that dynamically determine their membership to include only those methods which are of a form where their body just sends one unary message to self, for example subclass responsibility methods such as:

	blah
		^self subclassResponsibility
'!

!SingleUnarySendMethodCategory categoriesForClass!System-Support! !

!SingleUnarySendMethodCategory methodsFor!

includesMethod: aCompiledMethod
	"Answer whether the receiver includes the <CompiledMethod> argument. A method is considered
	to be in this category if it consists of a send to self of a particular zero-arg message, and
	nothing else."

	^aCompiledMethod isSimpleSelfSend: literal! !

!SingleUnarySendMethodCategory categoriesForMethods!
includesMethod:!public!testing! !
!

!SingleUnarySendMethodCategory class methodsFor!

initialize
	"Private - Initialize the receiver.
		self initialize.
	"

	self createDefaultInstances!

referenceSymbols
	^#(#subclassResponsibility #shouldNotImplement)! !

!SingleUnarySendMethodCategory class categoriesForMethods!
initialize!initializing!private! !
referenceSymbols!constants!private! !
!

