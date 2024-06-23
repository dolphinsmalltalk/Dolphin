"Filed out from Dolphin Smalltalk"!

UI.ValueAdaptor
	subclass: #'UI.CompositeValueAdaptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CompositeValueAdaptor guid: (Core.GUID fromString: '{c2011d89-6b90-4844-a5e9-fd4edf82239d}')!

UI.CompositeValueAdaptor comment: 'CompositeValueAdaptor is a <valueModel> that provides access to the individual aspects of a composite object through ValueAspectAdaptors, but which treats changes through those aspect adaptors as changes to the whole composite object, i.e. any change to one of its individual aspect causes a CompositeValueAdaptor to trigger a #valueChanged event. This is useful when implementing a <ValuePresenter> for a composite object that is considered immutable by its clients.'!

!UI.CompositeValueAdaptor categoriesForClass!MVP-Models! !

!UI.CompositeValueAdaptor methodsFor!

aspectValue: aSymbol
	"Answer a <ValueAspectAdapter> that provides access to the named aspect of our subject model.
	The aspect adaptor is monitored for any changes that are made through it."

	^(ValueAspectAdaptor subject: subject aspect: aSymbol)
		when: #valueChanged
			send: #onAspectChanged
			to: self;
		yourself!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	subject displayOn: aPuttableStream!

onAspectChanged
	"Private - An individual aspect of the receiver's subject has been changed through one of
	the <ValueAspectAdaptor>s provided by the receiver. Inform observers of the change to the
	subject."

	self trigger: #valueChanged!

setValue: anObject
	"Private - Assigns the value for the receiver without notifying 
	dependents of the change"
	
	subject := anObject!

value
	"Answers the <Object> value of the receiver, obtained
	by sending a message to the receiver's subject."

	^subject! !

!UI.CompositeValueAdaptor categoriesForMethods!
aspectValue:!accessing!public! !
displayOn:!displaying!public! !
onAspectChanged!event handling!private! !
setValue:!accessing!private! !
value!accessing!public! !
!

