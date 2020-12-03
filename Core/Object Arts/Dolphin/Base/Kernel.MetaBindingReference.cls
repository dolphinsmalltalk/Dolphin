"Filed out from Dolphin Smalltalk 7"!

Kernel.AbstractBindingReference subclass: #'Kernel.MetaBindingReference'
	instanceVariableNames: 'instance'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MetaBindingReference guid: (Core.GUID fromString: '{c54304a7-5aa9-404b-a969-27501f25f612}')!
Kernel.MetaBindingReference comment: '`BindingReference` wrapper that resolves to the class of the referenced binding''s value. Used to construct `MethodName`s refering to class methods.'!
!Kernel.MetaBindingReference categoriesForClass!System-Namespaces! !
!Kernel.MetaBindingReference methodsFor!

asString
	"Answer a <readableString> that describes the receiver as a qualified name expression in the context of the home namespace."

	^instance asString, ' class'!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^instance bindingOrNil!

context
	"The name context in which resolution of the binding should be initiated."

	^instance context!

context: anObject
	instance context: anObject!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: self pathString;
		space;
		nextPutAll: #class!

flags
	^instance flags!

hash
	"Answer the <integer> hash value for the receiver."

	^instance hash bitXor: 1!

home
	"Answer the home namespace to which this BindingReference is relative."

	^instance home!

instance
	"Answer a `BindingReference` that resolves to the value of the binding with the receiver's path."

	^instance!

isMeta
	"Is this a meta binding reference?"

	^true!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^self instance isPrivate!

isPrivate: aBoolean
	self instance isPrivate: aBoolean!

meta
	"Answer a <BindingReference> that resolves to the class of the value of the binding to which the receiver resolves."

	^self!

path
	"Answer a <sequencedReadableCollection> of <String>, being the component parts of the qualified name in order from the home namespace."

	^instance path!

pathString
	"Answer a <readableString> that expresses the receiver as a qualified name in the context of the home namespace."

	^instance pathString!

setInstance: aBindingReference
	instance := aBindingReference!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!Kernel.MetaBindingReference categoriesFor: #asString!converting!public! !
!Kernel.MetaBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #context!constants!public! !
!Kernel.MetaBindingReference categoriesFor: #context:!public! !
!Kernel.MetaBindingReference categoriesFor: #displayOn:!converting!displaying!public! !
!Kernel.MetaBindingReference categoriesFor: #flags!accessing!private! !
!Kernel.MetaBindingReference categoriesFor: #hash!comparing!public! !
!Kernel.MetaBindingReference categoriesFor: #home!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #instance!converting!public! !
!Kernel.MetaBindingReference categoriesFor: #isMeta!public!testing! !
!Kernel.MetaBindingReference categoriesFor: #isPrivate!public!testing! !
!Kernel.MetaBindingReference categoriesFor: #isPrivate:!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #meta!converting!displaying!public! !
!Kernel.MetaBindingReference categoriesFor: #path!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #pathString!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #setInstance:!converting!private! !
!Kernel.MetaBindingReference categoriesFor: #valueOfBinding:!accessing!private! !

!Kernel.MetaBindingReference class methodsFor!

instance: aBindingReference
	^self basicNew
		setInstance: aBindingReference;
		isImmutable: true;
		yourself!

newPath: anArray context: anObject
	^self instance: (BindingReference newPath: anArray context: anObject)!

pathString: aString context: anObject
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self instance: (BindingReference pathString: aString context: anObject)! !
!Kernel.MetaBindingReference class categoriesFor: #instance:!instance creation!public! !
!Kernel.MetaBindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!Kernel.MetaBindingReference class categoriesFor: #pathString:context:!instance creation!public! !

