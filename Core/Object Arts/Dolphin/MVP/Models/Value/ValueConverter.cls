"Filed out from Dolphin Smalltalk 7"!

ValueModel subclass: #ValueConverter
	instanceVariableNames: 'subject typeConverter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ValueConverter guid: (GUID fromString: '{87b4c677-026e-11d3-9fd7-00a0cc3e4a32}')!
ValueConverter comment: 'A ValueConverter sits between a subject <valueModel> and some <value> client of this. It supports the <valueModel> protocol such that when the client attempts to get the subject value it is converted into another type of object that is more palatable to the client. Similarly when the client tries to put a value back into the subject the type can again be converted, this time to suit the subject''s needs.

An assumption is made that the subject will be a <valueModel> and will therefore trigger its own #value events when it is updated. A ValueConverter simply forwards this event to any of its own clients.

Instance Variables:
	subject		<valueModel> subject.
	typeConverter	<typeConverter> for mapping the subject value to another type.

'!
!ValueConverter categoriesForClass!MVP-Models! !
!ValueConverter methodsFor!

format
	"Answers the format of the current type converter. 
	Not all type converters support different formats and where they do, the format
	descriptors are specific to the converter chosen"

	^self typeConverter format!

format: anObject 
	"Sets the format of the current type converter to be aFormatDescriptor. 
	Not all type converters support different formats and where they do, the format
	descriptors are specific to the converter chosen"

	self typeConverter format: anObject!

setValue: aClientObject 
	"Private - Sets aClientObject back into the subjects's value after first converting it
	using the associated type converter."

	self subject 
		value: (self typeConverter convertFromRightToLeft: aClientObject)!

subject
	"Private - Answers the subject model for the receiver"

	^subject!

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
	subject := anObject!

typeConverter
	"Answers the <TypeConverter> being used by the receiver"

	^typeConverter!

typeConverter: aTypeConverter 
	"Sets the <TypeConverter> being used by the receiver."

	typeConverter := aTypeConverter!

value
	"Answer the <Object> value of the receiver."

	^self typeConverter convertFromLeftToRight: self subject value! !
!ValueConverter categoriesFor: #format!accessing!public! !
!ValueConverter categoriesFor: #format:!accessing!public! !
!ValueConverter categoriesFor: #setValue:!accessing!private! !
!ValueConverter categoriesFor: #subject!accessing!private! !
!ValueConverter categoriesFor: #subject:!accessing!private! !
!ValueConverter categoriesFor: #typeConverter!accessing!public! !
!ValueConverter categoriesFor: #typeConverter:!accessing!public! !
!ValueConverter categoriesFor: #value!accessing!public! !

!ValueConverter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Private - An instance of this class requires parameters, use: #subject:typeConverter"

	^self shouldNotImplement!

subject: aValueModel typeConverter: aTypeConverter
	"Answers an instance of the receiver that is a converter of the value of aValueModel
	using aTypeConverter for the conversion process"

	^super new subject: aValueModel; typeConverter: aTypeConverter; yourself! !
!ValueConverter class categoriesFor: #icon!constants!public! !
!ValueConverter class categoriesFor: #new!instance creation!private! !
!ValueConverter class categoriesFor: #subject:typeConverter:!instance creation!public! !

