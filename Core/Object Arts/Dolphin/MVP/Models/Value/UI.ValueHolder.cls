"Filed out from Dolphin Smalltalk 7"!

UI.ValueModel subclass: #'UI.ValueHolder'
	instanceVariableNames: 'value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValueHolder guid: (Core.GUID fromString: '{87b4c678-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ValueHolder comment: 'A ValueHolder wraps an object and notifies its dependants when that object is replaced. Since ValueHolders are commonly used, there is a short cut available for creating them. Sending #asValue to any object will answer that object wrapped inside a ValueHolder. 

Instance Variables:
	value	<Object> which is the value held by the receiver.

'!
!UI.ValueHolder categoriesForClass!MVP-Models! !
!UI.ValueHolder methodsFor!

setValue: anObject
	"Private - Assigns the value for the receiver without notifying 
	dependents of the change"
	
	value := anObject!

value
	"Answers the value of the receiver"
	
	^value! !
!UI.ValueHolder categoriesFor: #setValue:!accessing!private! !
!UI.ValueHolder categoriesFor: #value!accessing!public! !

!UI.ValueHolder class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

with: anObject
	"Answers an instance of the receiver holding anObject as its value"

	^(self new) setValue: anObject; yourself! !
!UI.ValueHolder class categoriesFor: #icon!constants!public! !
!UI.ValueHolder class categoriesFor: #with:!instance creation!public! !

