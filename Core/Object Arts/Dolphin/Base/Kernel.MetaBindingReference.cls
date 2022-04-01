"Filed out from Dolphin Smalltalk"!

Kernel.BindingReferenceWrapper subclass: #'Kernel.MetaBindingReference'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MetaBindingReference guid: (Core.GUID fromString: '{c54304a7-5aa9-404b-a969-27501f25f612}')!
Kernel.MetaBindingReference comment: '`MetaBindingReference` are `BindingReference`s that resolve to the class of the referenced binding''s value, for example `#{Object class}` is a static literal reference that evaluates to the same object as the expression `#{Object} value class`, i.e. the metaclass of the class `Object`.

`MetaBindingReference` instances are useful for cases such as constructing `MethodName`s that refer to class-side methods. They are used as part of the file out format for packages and allow the list of loose methods to be represented efficiently as literal arrays.
'!
!Kernel.MetaBindingReference categoriesForClass!System-Namespaces! !
!Kernel.MetaBindingReference methodsFor!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	^reference asString , ' class'!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: reference;
		space;
		nextPutAll: #class!

instance
	"Answer a `BindingReference` that resolves to the value of the binding with the receiver's path."

	^reference!

isMeta
	"Is this a meta binding reference?"

	^true!

meta
	"Answer a <BindingReference> that resolves to the class of the value of the binding to which the receiver resolves."

	^self!

shortName
	"Answer the shortest <String> name equivalent to the receiver's pathString that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^super shortName, ' class'!

unqualifiedName
	"Answer the unqualified name part of the receiver (the final component of the name)."

	^super unqualifiedName, ' class'!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!Kernel.MetaBindingReference categoriesForMethods!
asString!converting!public! !
displayOn:!displaying!public! !
instance!accessing!public! !
isMeta!public!testing! !
meta!converting!public! !
shortName!accessing!public! !
unqualifiedName!accessing!public! !
valueOfBinding:!accessing!private! !
!

!Kernel.MetaBindingReference class methodsFor!

instance: aBindingReference
	^(self wrapping: aBindingReference)
		isImmutable: true;
		yourself!

newPath: anArray private: aBoolean scope: aBindingScope
	^self instance: (super
				newPath: anArray
				private: aBoolean
				scope: aBindingScope)!

pathString: aString private: aBoolean scope: aBindingScope
	^self instance: (super
				pathString: aString
				private: aBoolean
				scope: aBindingScope)!

pathString: aString scope: anObject
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self instance: (super pathString: aString scope: anObject)!

stbConvertFrom: anSTBClassFormat
	"Version 0: Did not exist
	Version 1: Introduced
	Version 2: No change"

	^[:data | self instance: (data at: 1)]! !
!Kernel.MetaBindingReference class categoriesForMethods!
instance:!instance creation!public! !
newPath:private:scope:!instance creation!private! !
pathString:private:scope:!instance creation!public! !
pathString:scope:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
!

