"Filed out from Dolphin Smalltalk 7"!

UI.ValueAspectAdaptor subclass: #'UI.ValueModelAspectAdaptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValueModelAspectAdaptor guid: (Core.GUID fromString: '{29f1d21e-3179-4fa5-beff-50f95911c88a}')!
UI.ValueModelAspectAdaptor comment: ''!
!UI.ValueModelAspectAdaptor categoriesForClass!Unclassified! !
!UI.ValueModelAspectAdaptor methodsFor!

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
!UI.ValueModelAspectAdaptor categoriesFor: #notifyChanged!private! !
!UI.ValueModelAspectAdaptor categoriesFor: #subject!private! !
!UI.ValueModelAspectAdaptor categoriesFor: #subject:!private! !

