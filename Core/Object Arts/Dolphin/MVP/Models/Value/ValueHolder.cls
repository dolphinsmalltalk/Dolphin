"Filed out from Dolphin Smalltalk"!

ValueModel subclass: #ValueHolder
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ValueHolder guid: (GUID fromString: '{87b4c678-026e-11d3-9fd7-00a0cc3e4a32}')!

ValueHolder comment: 'A ValueHolder wraps an object and notifies its dependants when that object is replaced. Since ValueHolders are commonly used, there is a short cut available for creating them. Sending #asValue to any object will answer that object wrapped inside a ValueHolder. 

Instance Variables:
	value	<Object> which is the value held by the receiver.

'!

!ValueHolder categoriesForClass!MVP-Models! !

!ValueHolder methodsFor!

setValue: anObject
	"Private - Assigns the value for the receiver without notifying 
	dependents of the change"
	
	value := anObject!

value
	"Answers the value of the receiver"
	
	^value! !

!ValueHolder categoriesForMethods!
setValue:!accessing!private! !
value!accessing!public! !
!

!ValueHolder class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

with: anObject
	"Answers an instance of the receiver holding anObject as its value"

	^(self new) setValue: anObject; yourself! !

!ValueHolder class categoriesForMethods!
icon!constants!public! !
with:!instance creation!public! !
!

