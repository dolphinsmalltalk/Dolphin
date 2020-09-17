"Filed out from Dolphin Smalltalk 7"!

Core.Model subclass: #'UI.AspectBuffer'
	instanceVariableNames: 'subject subjectCopy aspects gate isValidBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.AspectBuffer guid: (Core.GUID fromString: '{87b4c666-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.AspectBuffer comment: 'An AspectBuffer is used to buffer changes to the aspects of a subject object. These changes are held in a copy of the subject until the buffer receives an #apply message. A client of the buffer can request an aspect for the subject using #aspectValue: and it will receive an appropriate <ValueAspectAdapter>. Only the aspects that have been explicitly requested and then modified will be updated back to the subject when #apply is received.  
 
In order to be correctly used with an AspectBuffer, a subject object must be able to be sensibly duplicated using #copy. The advantage of keeping a complete copy of the subject within the buffer is that the validity of any changes made to it can be tested using #isValid before the changes are applied back. By default the validation check is made by sending #isValid to the subject copy. This default can be modified  by changing the isValidBlock in the buffer.

Instance Variables:
	subject		<Object> which is the subject whose aspects are being buffered.
	subjectCopy	<Object> copy of the subject.
	aspects		<IdentityDictionary> mapping put selectors of changed aspects to their values.
	gate		<ValueHolder> which when set true apply changes back to the subject.
	isValidBlock	<monadicValuable> to determine of the subject copy is valid before applying changes.

'!
!UI.AspectBuffer categoriesForClass!MVP-Models! !
!UI.AspectBuffer methodsFor!

apply
	"Apply the aspects held by the receiver in the model copy back to the 
	original model"

	aspects do: [:each | 
		self subject perform: each putSelector with: each value ]
!

aspectValue: anAspectSymbol
	"Answer a ValueAspectAdapter for anAspectSymbol of our copied model. 
	If a request for this aspect has already been registered then the same
	adapter model is answered. Otherwise a new one is created and registered
	in our aspects dictionary"

	^aspects at: anAspectSymbol
		ifAbsentPutClean: [ValueAspectAdaptor subject: subjectCopy aspect: anAspectSymbol]!

doesNotUnderstand: aMessage
	"The receiver has not understood aMessage. Most likely this is because it was intended for
	the buffered copy of the subject so we forward to this."

	^aMessage forwardTo: subjectCopy!

gate
	"Answer the gate value model that controls when (and if) changes will be 
	flushed back to the original model."

	^gate!

gate: aValueModelGate
	"Set the gate model to be aValueModelGate. Changes will be flushed back to 
	the original model when the value of aValueModelGate is set
	to true."

	gate := aValueModelGate.
	gate when: #valueChanged send: #onGateChanged to: self.!

initialize
	"Private - Initialize the receiver"

	gate := false asValue.
	aspects := IdentityDictionary new.
	isValidBlock := [:x | x isValid]!

isValid
	"Answer true if the updates to the model copy are valid.
	Evaluate the isValidBlock to check validity of the copy"

	^self isValidBlock value: subjectCopy!

isValidBlock
	"Answer the validation block for the receiver"

	^isValidBlock!

isValidBlock: aOneArgBlock
	"Sets the validation block to aOneArgBlock which will be passed the subject copy
	as its parameter. The block should answer true if the copy can be considered to be
	valid such that it's changes can be applied back to the actual subject"

	isValidBlock := aOneArgBlock!

notifyChanged
	"Notify observers that all aspects of the receiver have changed."

	aspects do: [:each | each notifyChanged]!

onGateChanged
	"Private - Received when the gate has been triggered. 
	Use this to either flush changes back to the subject if required"

	self gate value ifTrue: [ self apply ]!

revert
	"Revert the aspects held by the receiver to their values from the original subject"

	subjectCopy := self subject copy.
	aspects do: [:each | 
		each subject: subjectCopy.
		each notifyChanged ].
!

subject
	"Answer the subject model of the receiver"

	^subject

	!

subject: aSubjectModel
	"Attach the receiver to aSubjectModel. The model must respond intelligently to #copy
	since copy of it is made here to be used as the buffer for future updates"

	subject := aSubjectModel.
	subjectCopy := aSubjectModel copy.
	aspects := IdentityDictionary new!

value
	"Answer the copy of the subject model"

	^subjectCopy! !
!UI.AspectBuffer categoriesFor: #apply!commands!public! !
!UI.AspectBuffer categoriesFor: #aspectValue:!accessing!public! !
!UI.AspectBuffer categoriesFor: #doesNotUnderstand:!exceptions!public! !
!UI.AspectBuffer categoriesFor: #gate!accessing!public! !
!UI.AspectBuffer categoriesFor: #gate:!accessing!not an aspect!public! !
!UI.AspectBuffer categoriesFor: #initialize!initializing!private! !
!UI.AspectBuffer categoriesFor: #isValid!public!testing! !
!UI.AspectBuffer categoriesFor: #isValidBlock!accessing!public! !
!UI.AspectBuffer categoriesFor: #isValidBlock:!accessing!not an aspect!public! !
!UI.AspectBuffer categoriesFor: #notifyChanged!operations!public! !
!UI.AspectBuffer categoriesFor: #onGateChanged!event handling!private! !
!UI.AspectBuffer categoriesFor: #revert!commands!public! !
!UI.AspectBuffer categoriesFor: #subject!accessing!public! !
!UI.AspectBuffer categoriesFor: #subject:!accessing!not an aspect!public! !
!UI.AspectBuffer categoriesFor: #value!accessing!public! !

!UI.AspectBuffer class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Private - Use #subject:"

	self shouldNotImplement!

subject: aSubjectModel
	"Answer an instance of the receiver that buffers the aspects of aSubjectModel"

	^super new subject: aSubjectModel
! !
!UI.AspectBuffer class categoriesFor: #icon!constants!development!public! !
!UI.AspectBuffer class categoriesFor: #new!instance creation!private! !
!UI.AspectBuffer class categoriesFor: #subject:!instance creation!public! !

