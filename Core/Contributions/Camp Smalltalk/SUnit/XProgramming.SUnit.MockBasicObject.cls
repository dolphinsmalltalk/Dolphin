"Filed out from Dolphin Smalltalk"!

Kernel.ProtoObject
	subclass: #'XProgramming.SUnit.MockBasicObject'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockBasicObject guid: (Core.GUID fromString: '{dda60fb8-7580-4e67-b1da-cbd9e6735314}')!

XProgramming.SUnit.MockBasicObject comment: ''!

!XProgramming.SUnit.MockBasicObject methodsFor!

doesNotUnderstand: aMessage
	| selector |
	selector := aMessage selector.
	(selector == #printString or: [selector == #displayString]) ifTrue: [^self basicPrintString].
	^super doesNotUnderstand: aMessage!

initialize
!

on: aSelector
	"Teach to return self on a message whose selector is aSelector"

	self on: aSelector respond: self!

on: aSelector respond: anObject
	"Teach to return anObject on a message whose selector is aSelector"

	self
		on: aSelector
		withArguments: nil
		respond: anObject!

on: aSelector verify: aBlock
	self
		on: aSelector
		withArguments: nil
		verify: aBlock!

on: aSelector with: anObject
	"Teach to return self on a message whose selector is aSelector and argument is anObject.
	The test will fail if the message argument does not correspond to anObject."

	self
		on: aSelector
		withArguments: { anObject }
		respond: self!

on: aSelector with: anObject respond: anotherObject
	"Teach to return anotherObject on a message whose selector is aSelector and argument is anObject.
	The test will fail if the message argument does not correspond to anObject."

	self
		on: aSelector
		withArguments: { anObject }
		verify: [anotherObject]!

on: aSymbol with: anObject verify: aBlock
	self
		on: aSymbol
		withArguments: { anObject }
		verify: aBlock!

on: aSelector with: anObject with: anotherObject
	"Teach to return self on a message whose selector is aSelector and arguments are anObject and anotherObject"

	self
		on: aSelector
		withArguments: { anObject. anotherObject }
		respond: self!

on: aSelector with: anObject with: anotherObject respond: aResponseObject
	"Teach to return anotherObject on a message whose selector is aSelector and arguments are is anObject and anotherObject.
	The test will fail if the message arguments do not correspond to anObject and anotherObject."

	self
		on: aSelector
		withArguments: { anObject. anotherObject }
		verify: [aResponseObject]!

on: aSymbol with: anObject with: anotherObject verify: aBlock
	self
		on: aSymbol
		withArguments: { anObject. anotherObject }
		verify: aBlock!

on: aSymbol with: anObject with: anotherObject with: aThirdObject
	self
		on: aSymbol
		withArguments: { anObject. anotherObject. aThirdObject }
		respond: self!

on: aSelector with: anObject with: anotherObject with: aThirdObject respond: aResponseObject
	self
		on: aSelector
		withArguments: { anObject. anotherObject. aThirdObject }
		verify: [aResponseObject]!

on: aSymbol with: anObject with: anotherObject with: aThirdObject verify: aBlock
	self
		on: aSymbol
		withArguments: { anObject. anotherObject. aThirdObject }
		verify: aBlock!

on: aSelector withArguments: aCollection
	"Teach to return self on a message whose selector is aSelector and arguments are held in aCollection.
	The test will fail if the message arguments do not correspond to the ones in aCollection."

	self
		on: aSelector
		withArguments: aCollection
		respond: self!

on: aSelector withArguments: anArray respond: anObject
	"Teach to return anObject on a message whose selector is aSelector and arguments are held in anArray.
	The test will fail if the message arguments do not correspond to the ones in anArray."

	self
		on: aSelector
		withArguments: anArray
		verify: [anObject]!

on: aSymbol withArguments: anArray verify: aBlock
	^Error subclassResponsibility: #on:withArguments:verify:! !

!XProgramming.SUnit.MockBasicObject categoriesForMethods!
doesNotUnderstand:!exceptions!public! !
initialize!initialization!private! !
on:!public!teaching / returning self! !
on:respond:!public!teaching / returning a value! !
on:verify:!public!teaching / verifying! !
on:with:!public!teaching / returning self! !
on:with:respond:!public!teaching / returning a value! !
on:with:verify:!public!teaching / verifying! !
on:with:with:!public!teaching / returning self! !
on:with:with:respond:!public!teaching / returning a value! !
on:with:with:verify:!public!teaching / verifying! !
on:with:with:with:!public!teaching / returning self! !
on:with:with:with:respond:!public!teaching / returning a value! !
on:with:with:with:verify:!public!teaching / verifying! !
on:withArguments:!public!teaching / returning self! !
on:withArguments:respond:!public!teaching / returning a value! !
on:withArguments:verify:!public!teaching / verifying! !
!

!XProgramming.SUnit.MockBasicObject class methodsFor!

new
	^super new initialize! !

!XProgramming.SUnit.MockBasicObject class categoriesForMethods!
new!public! !
!

