"Filed out from Dolphin Smalltalk 7"!

UI.ControlView subclass: #'UI.ValueConvertingControlView'
	instanceVariableNames: 'typeconverter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValueConvertingControlView guid: (Core.GUID fromString: '{87b4c72a-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ValueConvertingControlView isNonInstantiable: true!
UI.ValueConvertingControlView comment: 'ValueConvertingControlView is the abstract superclass of <view>s that implement Windows controls obeying the <valueValue> protocol. Such views may be associated with any <valueModel>. One important aspect of a ValueConvertingControlView is that it supports a #typeConverter aspect. By supplying a <typeConverter> in this way, it is possible to attachthe view to a wide range of <valueModel>s containing different types of object. The <typeConverter> is responsible for mapping the model''s value to a suitable form in order for the view to display and, for the reverse process, taking a modified view''s content and setting it back as  the appropriate type of object in the model.

Instance Variables:
	typeconverter	<typeConverter> used to convert between model values and display values.

'!
!UI.ValueConvertingControlView categoriesForClass!MVP-Views! !
!UI.ValueConvertingControlView methodsFor!

connectModel
	"Connect the receiver to its model, wiring events, etc.
	ValueConvertingControlViews expect to be connected to a model that obeys the
	ValueModel protocol; i.e. it must generate a #value event when the value it is wrapping 
	is replaced."

	self model ifNotNil: 
			[:m | 
			m 
				when: #valueChanged
				send: #onModelChanged
				to: self]!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(100 @ 25)!

defaultTypeConverter
	"Answers a default type converter to use for the receiver"

	| answer |
	answer := self defaultTypeConverterClass new.
	self initializeNewTypeConverter: answer.
	^answer!

defaultTypeConverterClass
	"Private - Answers a default type converter class for use with the receiver"

	^NullConverter!

displayValue
	"Private - Answer the displayed contents of the receiver.
	Must be overridden by subclasses"

	^self subclassResponsibility!

displayValue: anObject
	"Private - Set the displayed contents of the receiver.
	Must be overridden by subclasses"

	^self subclassResponsibility!

initializeNewTypeConverter: aTypeConverter
	"Private - Hook to enable subclasses to set up a newly created type converter, e.g. to 
	set the left and right null values appropriately."

	"Do nothing by default"

	!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it"

	super onViewCreated.
	model notNil ifTrue: [self onModelChanged].
	^nil!

refreshContents
	"Re-display the receiver with the model's value"

	self 
		displayValue: (self typeconverter convertFromLeftToRight: self model value)!

typeconverter
	"Answer the typeconverter that the receiver uses for converting model
	values to displayable values and vice-versa."

	typeconverter isNil ifTrue: [typeconverter := self defaultTypeConverter].
	^typeconverter!

typeconverter: aTypeConverter
	"Set the typeconverter that the receiver uses for converting model
	values to displayable values and vice-versa to aTypeConverter."

	typeconverter := aTypeConverter.
	self value: typeconverter leftNullValue!

typeconverterClass
	"Answer the class of typeconverter for the receiver"

	^typeconverter isNil 
		ifTrue: [self defaultTypeConverterClass]
		ifFalse: [typeconverter class]!

typeconverterClass: aTypeConverterClass 
	"Set the typeconverter for the receiver to a default instance
	of aTypeConverterClass."

	| converter |
	self typeconverter class == aTypeConverterClass ifTrue: [^self].
	converter := aTypeConverterClass new.
	self initializeNewTypeConverter: converter.
	self typeconverter: converter!

updateModel
	"Private - The displayed value of the receiver has changed so set this
	back into the model after first running through the type converter"

	[self model value: (self typeconverter convertFromRightToLeft: self displayValue)] on: InvalidFormat
		do: 
			[:exception |
			exception beep.
			self
				value: self typeconverter leftNullValue;
				refreshContents	"Ensure that receiver displays null value even if model is unchanged"].
	self invalidateUserInterface!

updateModel: anObject 
	self model value: (self typeconverter convertFromRightToLeft: anObject).
	self invalidateUserInterface!

value
	"Answer the receiver's model value"

	^self model value!

value: anObject
	"Set the receiver's model value to anObject"

	self model value: anObject! !
!UI.ValueConvertingControlView categoriesFor: #connectModel!models!public! !
!UI.ValueConvertingControlView categoriesFor: #defaultExtent!constants!private! !
!UI.ValueConvertingControlView categoriesFor: #defaultTypeConverter!accessing!public! !
!UI.ValueConvertingControlView categoriesFor: #defaultTypeConverterClass!initializing!private! !
!UI.ValueConvertingControlView categoriesFor: #displayValue!private!updating! !
!UI.ValueConvertingControlView categoriesFor: #displayValue:!private!updating! !
!UI.ValueConvertingControlView categoriesFor: #initializeNewTypeConverter:!accessing!private! !
!UI.ValueConvertingControlView categoriesFor: #onViewCreated!event handling!public! !
!UI.ValueConvertingControlView categoriesFor: #refreshContents!public!updating! !
!UI.ValueConvertingControlView categoriesFor: #typeconverter!accessing!public! !
!UI.ValueConvertingControlView categoriesFor: #typeconverter:!accessing!public! !
!UI.ValueConvertingControlView categoriesFor: #typeconverterClass!accessing!public! !
!UI.ValueConvertingControlView categoriesFor: #typeconverterClass:!accessing!public! !
!UI.ValueConvertingControlView categoriesFor: #updateModel!private!updating! !
!UI.ValueConvertingControlView categoriesFor: #updateModel:!private!updating! !
!UI.ValueConvertingControlView categoriesFor: #value!accessing!public! !
!UI.ValueConvertingControlView categoriesFor: #value:!accessing!public! !

UI.ValueConvertingControlView methodProtocol: #value attributes: #(#readOnly) selectors: #(#value #value:)!
UI.ValueConvertingControlView methodProtocol: #valueView attributes: #(#readOnly) selectors: #(#value #value:)!

!UI.ValueConvertingControlView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^nil asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!UI.ValueConvertingControlView class categoriesFor: #defaultModel!models!public! !
!UI.ValueConvertingControlView class categoriesFor: #icon!constants!public! !

