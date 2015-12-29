"Filed out from Dolphin Smalltalk X6"!

ValueAspectAdaptor subclass: #ValueModelAspectAdaptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueModelAspectAdaptor guid: (GUID fromString: '{29F1D21E-3179-4FA5-BEFF-50F95911C88A}')!
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
!ValueModelAspectAdaptor categoriesFor: #notifyChanged!private! !
!ValueModelAspectAdaptor categoriesFor: #subject!private! !
!ValueModelAspectAdaptor categoriesFor: #subject:!private! !

