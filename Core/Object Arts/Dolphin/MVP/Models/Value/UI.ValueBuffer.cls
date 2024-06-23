"Filed out from Dolphin Smalltalk"!

UI.ValueHolder
	subclass: #'UI.ValueBuffer'
	instanceVariableNames: 'subject modified gate validater'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ValueBuffer guid: (Core.GUID fromString: '{87b4c67d-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ValueBuffer comment: 'A ValueBuffer can be used to buffer changes to a subject <valueModel>. It presents the same <value> protocol as its subject but, when the value is changed, the change is not immediately passed to the subject. This only happens when the ValueBuffer receives an #apply message to indicate that any changes should be flushed.

Instance Variables:
	subject		<valueModel> being buffered.
	modified		<boolean> indicating whether the subject has been modified.
	gate		<valueModel> which, when set true will apply changes back to the subject.


'!

!UI.ValueBuffer categoriesForClass!MVP-Models! !

!UI.ValueBuffer methodsFor!

apply
	"Apply any buffered changes back to the subject."

	modified 
		ifTrue: 
			[subject value: self value.
			modified := false]!

gate
	"Answer the gate value model that controls when (and if) changes will be flushed back to the
	original model."

	^gate!

gate: aValueModelGate
	"Set the gate model to be aValueModelGate. Changes will be flushed back to the original
	model when the value of aValueModelGate is set to true."

	gate := aValueModelGate.
	gate when: #valueChanged send: #onGateChanged to: self.!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validater := [:val | ValidationResult new]!

isModified
	"Answer whether the buffer is holding a modified value that can be applied. If not then the value is that of the subject."

	^modified!

isValid
	"Answer true if the updates to the model copy are valid. The validater is invoked to check validity of the current value."

	^self validate value == true!

onGateChanged
	"Private - Received when the gate has been triggered. Use this to flush changes back
	to the subject if required"

	self gate value ifTrue: [self apply]!

setValue: anObject 
	"Private - Assigns the value for the receiver without notifying dependents of the change.
	The value is saved in the buffer and not directed to the subject (yet)."

	super setValue: anObject.
	modified := true!

subject
	"Answers the actual subject model"

	^subject!

subject: aSubjectValueModel 
	"Private - Initializes the receiver on aSubjectValueModel"

	gate := false asValue.
	subject := aSubjectValueModel.
	modified := false!

validate
	^self validater value: self value!

validater
	^validater!

validater: aMonadicValuable
	"Sets the validater to the <MonadicValuable> argument, which will be passed the subject copy as its parameter. The validater is expected to answer a <ValidationResult>, the value of which should be true if the copy can be considered to be valid such that its changes can be applied back to the actual subject, or false if not. The <ValidationResult> may optionally contain a validation hint in the form of an <exceptionDescription>."

	validater := aMonadicValuable!

value
	"Answers the value of the receiver. If the value has been modified then answer the buffered
	value otherwise answer that of the subject"

	^modified ifTrue: [value] ifFalse: [subject value]! !

!UI.ValueBuffer categoriesForMethods!
apply!accessing!commands!public! !
gate!accessing!public! !
gate:!accessing!not an aspect!public! !
initialize!initializing!private! !
isModified!public!testing! !
isValid!public!testing! !
onGateChanged!event handling!private! !
setValue:!accessing!private! !
subject!initializing!public! !
subject:!initializing!private! !
validate!operations!public! !
validater!accessing!public! !
validater:!accessing!not an aspect!public! !
value!accessing!public! !
!

!UI.ValueBuffer class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Private - Use #subject:"

	^self shouldNotImplement!

subject: aSubjectValueModel 
	"Answer an instance of the receiver that buffers the value of aSubjectValueModel."

	^super new subject: aSubjectValueModel! !

!UI.ValueBuffer class categoriesForMethods!
icon!constants!public! !
new!instance creation!private! !
subject:!instance creation!public! !
!

