"Filed out from Dolphin Smalltalk"!

ValueAdaptor subclass: #CompositeValueAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CompositeValueAdaptor guid: (GUID fromString: '{c2011d89-6b90-4844-a5e9-fd4edf82239d}')!

CompositeValueAdaptor comment: 'CompositeValueAdaptor is a <valueModel> that provides access to the individual aspects of a composite object through ValueAspectAdaptors, but which treats changes through those aspect adaptors as changes to the whole composite object, i.e. any change to one of its individual aspect causes a CompositeValueAdaptor to trigger a #valueChanged event. This is a useful when implementing a <ValuePresenter> for a composite object that is considered immutable by its clients.'!

!CompositeValueAdaptor categoriesForClass!MVP-Models! !

!CompositeValueAdaptor methodsFor!

aspectValue: aSymbol 
	"Answer a <ValueAspectAdapter> that provides access to the named aspect of our subject model.
	The aspect adaptor is monitored for any changes that are made through it."

	^(ValueAspectAdaptor subject: subject aspect: aSymbol)
		when: #valueChanged
			send: #onAspectChanged
			to: self;
		yourself!

displayOn: aStream 
	"Append a short textual description of the receiver to, aStream, such as would be appropriate for display to an end-user."

	subject displayOn: aStream!

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

!CompositeValueAdaptor categoriesForMethods!
aspectValue:!accessing!public! !
displayOn:!displaying!public! !
onAspectChanged!event handling!private! !
setValue:!accessing!private! !
value!accessing!public! !
!

