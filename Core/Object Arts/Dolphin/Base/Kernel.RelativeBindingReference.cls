"Filed out from Dolphin Smalltalk"!

Kernel.BindingReference subclass: #'Kernel.RelativeBindingReference'
	instanceVariableNames: 'scope'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RelativeBindingReference guid: (Core.GUID fromString: '{48e74cb4-00b3-4999-b434-cfea5b961756}')!
Kernel.RelativeBindingReference comment: ''!
!Kernel.RelativeBindingReference categoriesForClass!System-Namespaces! !
!Kernel.RelativeBindingReference methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined 
	at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property based and is such that two equal references will always bind
	to the same variable if bound at the same time."

	"Implementation Note: This implementation depends on the fact that for absolute references the context is always nil, and for (useful) relative references, the context is not nil."

	^self == anObject or: 
			[self class == anObject class and: 
					[self pathString = anObject pathString and: 
							[private == anObject isPrivate and: 
									[| otherScope |
									otherScope := anObject bindingScope.
									otherScope localScope == scope localScope and: [scope environment == otherScope environment]]]]]!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	"Implementation Note: Implemented for compatibility with the reference platform, although not used in Dolphin. The selector is likely to confuse anyone with a C++ background; it has nothing to do with a class' superclass."

	^scope localScope!

bindingScope
	"Answer the <bindingScope> from which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	"Implementation Note: It is an invariant that the context must be non-nil for RelativeBindingReference instances."

	^scope!

environmentName
	"Answer the <String> qualified name of the receiver's full namespace qualifier. This includes the path for the binding scope."

	| stream parts |
	parts := self path.
	stream := String writeStream: 32.
	self bindingScope localScope printFullNameOn: stream.
	1 to: parts size - 1
		do: 
			[:i |
			stream
				nextPut: $.;
				nextPutAll: (parts at: i)].
	^stream contents!

hash
	"Answer the <integer> hash value for the receiver."

	^scope localScope hash hashMultiply + self pathString hash bitAnd: VMConstants.SmallIntegerMax!

home
	"Answer the 'namespace context' for this binding reference."

	"Implementation Note: This is defined for compatibility with the reference platform. It is not used in Dolphin."

	^scope localEnvironment!

isRelative
	"Answer whether the receiver specifies a binding path relative to a specific binding root, or alternatively is an absolute (or fully-qualified) binding reference."

	^true!

private
	^self isPrivate
		ifTrue: [self]
		ifFalse: 
			[BindingReference
				pathString: self pathString
				scope: self bindingScope
				flags: PrivateMask]!

scope
	"Private - Answer the <bindingScope> in which the reference was created. For relative references this is used to determine the start point for binding resolution and must never be nil."

	^scope!

setPath: anArray private: aBoolean scope: anObject
	path := anArray.
	private := aBoolean.
	scope := anObject!

setPathString: aString private: aBoolean scope: anObject
	pathString := aString.
	private := aBoolean.
	scope := anObject!

setScope: anObject
	"Private - Sent by Compiler."

	<mutable>
	scope := anObject! !
!Kernel.RelativeBindingReference categoriesForMethods!
=!comparing!public! !
baseClass!accessing!public! !
bindingScope!accessing!public! !
environmentName!accessing!public! !
hash!comparing!public! !
home!accessing!public! !
isRelative!public!testing! !
private!converting!public! !
scope!accessing!private! !
setPath:private:scope:!initializing!private! !
setPathString:private:scope:!initializing!private! !
setScope:!accessing!private! !
!

!Kernel.RelativeBindingReference class methodsFor!

newPath: anArray private: aBoolean scope: aBindingScope
	aBindingScope isNil ifTrue: [self error: 'Relative binding references require a scope'].
	^self basicNew
		setPath: anArray
		private: aBoolean
		scope: aBindingScope! !
!Kernel.RelativeBindingReference class categoriesForMethods!
newPath:private:scope:!instance creation!private! !
!

