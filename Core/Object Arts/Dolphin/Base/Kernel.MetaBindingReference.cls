"Filed out from Dolphin Smalltalk 7"!

AbstractBindingReference subclass: #MetaBindingReference
	instanceVariableNames: 'instance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MetaBindingReference guid: (GUID fromString: '{c54304a7-5aa9-404b-a969-27501f25f612}')!
MetaBindingReference comment: '`BindingReference` wrapper that resolves to the class of the referenced binding''s value. Used to construct `MethodName`s refering to class methods.'!
!MetaBindingReference categoriesForClass!System-Namespaces! !
!MetaBindingReference methodsFor!

asString
	"Answer a <readableString> that describes the receiver as a qualified name expression in the context of the home namespace."

	^instance asString, ' class'!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^instance bindingOrNil!

context
	"The name context in which resolution of the binding should be initiated."

	^nil!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: self pathString;
		space;
		nextPutAll: #class!

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
!MetaBindingReference categoriesFor: #asString!converting!public! !
!MetaBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!MetaBindingReference categoriesFor: #context!constants!public! !
!MetaBindingReference categoriesFor: #displayOn:!converting!displaying!public! !
!MetaBindingReference categoriesFor: #hash!comparing!public! !
!MetaBindingReference categoriesFor: #home!accessing!public! !
!MetaBindingReference categoriesFor: #instance!converting!public! !
!MetaBindingReference categoriesFor: #isMeta!public!testing! !
!MetaBindingReference categoriesFor: #meta!converting!displaying!public! !
!MetaBindingReference categoriesFor: #path!accessing!public! !
!MetaBindingReference categoriesFor: #pathString!accessing!public! !
!MetaBindingReference categoriesFor: #setInstance:!converting!private! !
!MetaBindingReference categoriesFor: #valueOfBinding:!accessing!private! !

!MetaBindingReference class methodsFor!

instance: aBindingReference
	^self basicNew
		setInstance: aBindingReference;
		isImmutable: true;
		yourself!

newPath: anArray context: anObject
	^self instance: (BindingReference newPath: anArray context: anObject)!

pathString: aString context: anObject
	"Answer a new sub-instance of the receiver representing the qualified name identified by the <readableString> argument,
	which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method),
	and the new instance will be a ContextualBindingReference with that object as its starting point for resolving the binding."

	^self instance: (BindingReference pathString: aString context: anObject)! !
!MetaBindingReference class categoriesFor: #instance:!instance creation!public! !
!MetaBindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!MetaBindingReference class categoriesFor: #pathString:context:!instance creation!public! !

