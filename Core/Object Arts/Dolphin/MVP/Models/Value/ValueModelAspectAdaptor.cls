"Filed out from Dolphin Smalltalk"!

ValueAspectAdaptor subclass: #ValueModelAspectAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueModelAspectAdaptor guid: (GUID fromString: '{29f1d21e-3179-4fa5-beff-50f95911c88a}')!
ValueModelAspectAdaptor comment: ''!
!ValueModelAspectAdaptor categoriesForClass!Unclassified! !
!ValueModelAspectAdaptor methodsFor!

notifyChanged
	super notifyChanged.
	"Notify the ValueModel representing the composite that it has changed."
	settingValue ifFalse: [subject notifyChanged]!

subject
	^subject value!

subject: anObject
	"Private - Sets the subject object that is being interfaced
	to by the receiver and whose value needs converting. If
	the object is nil, then disconnect from any pre-existing
	subject."

	anObject isNil 
		ifTrue: [subject isNil ifFalse: [subject removeEventsTriggeredFor: self]]
		ifFalse: 
			[anObject 
				when: #valueChanged
				send: #trigger:
				to: self
				with: #valueChanged].
	subject := anObject! !
!ValueModelAspectAdaptor categoriesForMethods!
notifyChanged!private! !
subject!private! !
subject:!private! !
!

