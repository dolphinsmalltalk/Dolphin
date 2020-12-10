"Filed out from Dolphin Smalltalk 7"!

Tools.ReferencesCategory subclass: #'Tools.SingleUnarySendMethodCategory'
	instanceVariableNames: 'selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SingleUnarySendMethodCategory guid: (Core.GUID fromString: '{0adb321d-bb42-4acf-a21f-49b37095183a}')!
Tools.SingleUnarySendMethodCategory comment: 'SingleUnarySendMethodCategory is the class of virtual method categories that dynamically determine their membership to include only those methods which are of a form where their body just sends one unary message to self, for example subclass responsibility methods such as:

	blah
		^self subclassResponsibility
'!
!Tools.SingleUnarySendMethodCategory categoriesForClass!System-Support! !
!Tools.SingleUnarySendMethodCategory methodsFor!

includesMethod: aCompiledMethod
	"Answer whether the receiver includes the <CompiledMethod> argument. A method is considered
	to be in this category if it consists of a send to self of a particular zero-arg message, and
	nothing else."

	^aCompiledMethod isSimpleSelfSend: literal! !
!Tools.SingleUnarySendMethodCategory categoriesFor: #includesMethod:!public!testing! !

!Tools.SingleUnarySendMethodCategory class methodsFor!

initialize
	"Private - Initialize the receiver.
		self initialize.
	"

	self createDefaultInstances!

referenceSymbols
	^#(#subclassResponsibility #shouldNotImplement)! !
!Tools.SingleUnarySendMethodCategory class categoriesFor: #initialize!initializing!private! !
!Tools.SingleUnarySendMethodCategory class categoriesFor: #referenceSymbols!constants!private! !

