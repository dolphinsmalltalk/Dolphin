"Filed out from Dolphin Smalltalk"!

Core.Boolean
	subclass: #'Core.True'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.True guid: (Core.GUID fromString: '{87b4c4fe-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.True comment: 'The True class implements the behavior of the true (logical truth) object.

Trueis a singleton whose sole instance is the object represented by the reserved word, true. true is an identity object (i.e. any reference to true will always answer true when compared with any other using the #== message).

True implement the ANSI protocols <Object> and <boolean>.'!

!Core.True categoriesForClass!Kernel-Objects! !

!Core.True methodsFor!

and: operand 
	"Answer whether the receiver and the result of evaluating the <niladicValuable>,
	 operand, are both true. The argument is only evaluated if the receiver is true."

	"Implementation Note:  The compiler inlines this message if the argument
	is a literal block. The compiler assumes that the receiver will be a boolean,
	so this message cannot be overridden."

	^operand value!

asInteger
	"Answer a sensible integer equivalent of the receiver."

	^1!

asParameter
	"Answer the value of the receiver in a form suitable for passing to an external function call."

	^OS.Win32Constants.TRUE!

ifFalse: operand 
	"Evaluate and answer the result of the evaluating the <niladicValuable>
	argument, operand, if the receiver is false, otherwise answer nil."

	"Implementation Note:  The compiler inlines this message if the argument
	is a literal block. The compiler assumes that the receiver will be a boolean,
	so this message cannot be overridden."

	^nil!

ifFalse: falseOperand ifTrue: trueOperand 
	"Evaluate, and answer the result, of the <niladicValuable>, falseOperand, if 
	the receiver is false, or the <niladicValuable>, trueOperand, if the receiver is 
	true."

	"Implementation Note:  The compiler inlines this message if the arguments
	are literal blocks. The compiler assumes that the receiver will be a boolean,
	so this message cannot be overridden."

	^trueOperand value!

ifTrue: operand 
	"Evaluate and answer the result of the evaluating the <niladicValuable>
	argument, operand, if the receiver is true, otherwise answer nil. "

	"Implementation Note:  The compiler inlines this message if the argument
	is a literal block. The compiler assumes that the receiver will be a boolean,
	so this message cannot be overridden."

	^operand value!

ifTrue: trueOperand ifFalse: falseOperand 
	"Evaluate, and answer the result, of the <niladicValuable>, falseOperand, if 
	the receiver is false, or the <niladicValuable>, trueOperand, if the receiver is 
	true."

	"Implementation Note:  The compiler inlines this message if the arguments
	are literal blocks. The compiler assumes that the receiver will be a boolean,
	so this message cannot be overridden."

	^trueOperand value!

not
	"Answer the logical inverse of the receiver."

	^false
!

or: operand 
	"Answer whether either the receiver or the result of evaluating the
	<niladicValuable> argument, operand, is true. The argument is only
	evaluated if the receiver is false."

	"Implementation Note:  The compiler inlines this message if the argument
	is a literal block. The compiler assumes that the receiver will be a boolean,
	so this message cannot be overridden."

	^self!

printString
	"Answer a <readableString> whose characters are a description of the receiver as a developer would want to see it."

	^'true'!

xor: operand
	"Answer whether either the receiver or the boolean argument <operand> is true, but not both.
	Since the receiver is true, the answer is true only if the argument is false."

	^operand not! !

!Core.True categoriesForMethods!
and:!control flow!public! !
asInteger!converting!public! !
asParameter!converting!public! !
ifFalse:!control flow!public! !
ifFalse:ifTrue:!control flow!public! !
ifTrue:!control flow!public! !
ifTrue:ifFalse:!control flow!public! !
not!logical operations!public! !
or:!control flow!public! !
printString!printing!public! !
xor:!logical operations!public! !
!

