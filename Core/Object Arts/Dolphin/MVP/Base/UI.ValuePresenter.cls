"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'UI.ValuePresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValuePresenter guid: (Core.GUID fromString: '{87b4c689-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ValuePresenter comment: 'ValuePresenter is a <valuePresenter>s that presents the contents of a <valueModel> within a <valueView>.

When designing a <presenter> it is necessary to make an initial decision as to how its model data should be displayed and edited. If the model is a mutable object, in that it is legal (and sensible) to modify it in place, then it is usual to treat it as a simple <presenter> and create a class descended directly from Presenter itself. If, on the other hand, the model is to be immutable then the presenter should be implemented as a <valuePresenter>. If the identity of the underlying model data must remain unchanged then use a standard <presenter>. If this is not the case then a <valuePresenter> will be more suitable.

In many cases a <valuePresenter> will be implemented as a subclass of ValuePresenter. However, this is not essential and instances of ValuePresenter can be created and use directly.

'!
!UI.ValuePresenter categoriesForClass!MVP-Presenters! !
!UI.ValuePresenter methodsFor!

findDetails
	"Required so can be used with a TextEdit view."

	^nil!

model: anObject
	"Set the model of the receiver to be a value model on anObject. Usually anObject is expected
	to be a ValueModel itself. If not, it is automatically wrapped in a valueHolder. 
	Register with it's #valueChanged event"

	| valueModel |
	valueModel := anObject asValue.
	super model: valueModel.
	valueModel when: #valueChanged send: #onValueChanged to: self!

onValueChanged
	"The value held by the receiver's model has changed.
	The default is to trigger a #valueChanged event off the receiver"

	self trigger: #valueChanged!

setValue: anObject
	"Private - Set the model data of the receiver to be anObject but without propagating
	any change triggers"

	self model setValue: anObject.
!

value
	"Answer the model value of the receiver. Any view changes may first need to be flushed."

	"#53: N.B. Do not send #value to a ValuePresenter when handling the #valueChanged event from
	that presenter, because at that time the MVP triad is in an inconsistent state with respect
	to the value - the view may not yet have been updated with the new model value. If the
	presenter's value is accessed then any old value in the view will be flushed back to the
	model before the view itself has been updated with the new model value. To access the
	current value inside a #valueChanged event handler you must go directly to the model, i.e.
	<presenter> model value."

	self view notNil ifTrue: [ self view updateModel ].
	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject"

	self model value: anObject.
! !
!UI.ValuePresenter categoriesForMethods!
findDetails!accessing!public! !
model:!accessing!public! !
onValueChanged!event handling!public! !
setValue:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
!

UI.ValuePresenter methodProtocol: #value attributes: #(#readOnly) selectors: #(#value #value:)!
UI.ValuePresenter methodProtocol: #valuePresenter attributes: #(#readOnly) selectors: #(#value #value:)!

!UI.ValuePresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!UI.ValuePresenter class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
!

