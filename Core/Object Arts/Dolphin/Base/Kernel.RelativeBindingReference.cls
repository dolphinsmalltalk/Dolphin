"Filed out from Dolphin Smalltalk"!

Kernel.FullBindingReference
	subclass: #'Kernel.RelativeBindingReference'
	instanceVariableNames: 'scope'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RelativeBindingReference guid: (Core.GUID fromString: '{48e74cb4-00b3-4999-b434-cfea5b961756}')!
Kernel.RelativeBindingReference comment: '`RelativeBindingReference`s represent partially-qualified `BindingReferences`.

  # Instance Variables:
  `scope`		`<bindingScope>`. The namespace from which relative binding resolution should start.


'!
!Kernel.RelativeBindingReference categoriesForClass!System-Namespaces! !
!Kernel.RelativeBindingReference methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point, and the same privacy.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property such that two equal references would always bind to the same variable if bound at the same time."

	"Implementation Note: This implementation depends on the fact that for absolute references the context is always nil, and for (useful) relative references, the context is not nil."

	^self == anObject or: 
			[self class == anObject class and: 
					[self pathString = anObject pathString and: 
							[private == anObject isPrivate and: 
									[| otherScope |
									otherScope := anObject bindingScope.
									otherScope localScope == scope localScope and: [scope environment == otherScope environment]]]]]!

asFullyQualifiedReference
	"Answer a<BindingReference> that references the same binding as the receiver does currently in its home context, but from Smalltalk or Root."

	^self bindingOrNil
		ifNil: 
			[self class newFull: self environmentName , PathSeparatorString , self unqualifiedName
				private: private]
		ifNotNil: 
			[:var |
			var fullyQualifiedReference
				isPrivate: private;
				yourself]!

asNamespaceImport
	"Answer a<NamespaceImport> that references the same binding as the receiver, the value of which is assumed to be an <importableNamespace>."

	^self asFullyQualifiedReference asNamespaceImport!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	| identifier |
	identifier := self pathString.
	^(identifier includes: PathSeparator)
		ifTrue: [RelativePathStringPrefix , identifier]
		ifFalse: [identifier]!

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

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| identifier |
	identifier := self pathString.
	(identifier includes: PathSeparator) ifTrue: [aPuttableStream nextPutAll: RelativePathStringPrefix].
	aPuttableStream nextPutAll: identifier!

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
				nextPut: PathSeparator;
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
			[self class
				pathString: pathString
				path: path
				private: true
				scope: scope]!

scope
	"Private - Answer the <bindingScope> in which the reference was created. For relative references this is used to determine the start point for binding resolution and must never be nil."

	^scope!

setScope: anObject
	"Private - Sent by Compiler."

	<mutable>
	scope := anObject! !
!Kernel.RelativeBindingReference categoriesForMethods!
=!comparing!public! !
asFullyQualifiedReference!converting!public! !
asNamespaceImport!converting!public! !
asString!converting!public! !
baseClass!accessing!public! !
bindingScope!accessing!public! !
displayOn:!displaying!public! !
environmentName!accessing!public! !
hash!comparing!public! !
home!accessing!public! !
isRelative!public!testing! !
private!converting!public! !
scope!accessing!private! !
setScope:!initializing!private! !
!

!Kernel.RelativeBindingReference class methodsFor!

pathString: aString path: anArray private: aBoolean scope: aBindingScope
	aBindingScope ifNil: [self error: 'Relative binding references require a scope'].
	^(self
		pathString: aString
		path: anArray
		private: aBoolean)
		setScope: aBindingScope;
		yourself!

stbConvertFromVersion1: anArray
	"Private - Version 2 - no change at this level"

	| newInstance |
	newInstance := self basicNew.
	1 to: anArray size do: [:i | newInstance instVarAt: i put: (anArray at: i)].
	^newInstance! !
!Kernel.RelativeBindingReference class categoriesForMethods!
pathString:path:private:scope:!instance creation!private! !
stbConvertFromVersion1:!binary filing!private! !
!

