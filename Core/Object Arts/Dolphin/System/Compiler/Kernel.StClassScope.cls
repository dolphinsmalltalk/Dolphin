"Filed out from Dolphin Smalltalk"!

Kernel.StSemanticScope subclass: #'Kernel.StClassScope'
	instanceVariableNames: 'methodClass environment instanceVariables selfVariable superVariable metaScope staticVariables'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StClassScope guid: (Core.GUID fromString: '{b221d07f-4ae8-400c-b48e-28b90fca0050}')!
Kernel.StClassScope comment: ''!
!Kernel.StClassScope categoriesForClass!Kernel-Objects! !
!Kernel.StClassScope methodsFor!

classScope
	^self!

clearVariableCache
	staticVariables := LookupTable new!

environment
	^environment ifNil: [methodClass environment]!

environment: aNamespace
	environment := aNamespace!

instanceVariables
	^instanceVariables
		ifNil: 
			[| names count |
			names := methodClass allInstanceVariableNames.
			instanceVariables := LookupTable new: (count := names size).
			1 to: count
				do: 
					[:i |
					| v |
					v := names at: i.
					instanceVariables at: v
						put: (StInstanceVariable scope: self index: i name: v)].
			instanceVariables]!

metaScope
	^metaScope
		ifNil: 
			[metaScope := methodClass isMeta
						ifTrue: [self]
						ifFalse: [StClassScope methodClass: methodClass metaclass environment: environment]]!

methodClass
	^methodClass!

methodClass: aClassDescription environment: aNamespaceOrNil
	"Private - Initialize the receiver. The environment (namespace) argument should be nil if the class' environment is to be used."

	methodClass := aClassDescription.
	environment := aNamespaceOrNil.
	self clearVariableCache.
	^self!

outer
	^nil!

resolveIdentifier: aString
	^(self instanceVariables lookup: aString)
		ifNil: 
			[staticVariables at: aString
				ifAbsentPutClean: 
					[(methodClass fullBindingFor: aString environment: self environment)
						ifNotNil: [:b | StStaticVariable scope: self binding: b]]]!

selfVariable
	^selfVariable
		ifNil: 
			[selfVariable := StSelfVariable new
						scope: self;
						yourself]!

superVariable
	^superVariable
		ifNil: 
			[superVariable := StSuperVariable new
						scope: self;
						yourself]! !
!Kernel.StClassScope categoriesForMethods!
classScope!accessing!public! !
clearVariableCache!initializing!public! !
environment!accessing!public! !
environment:!accessing!public! !
instanceVariables!accessing!public! !
metaScope!accessing!public! !
methodClass!accessing!public! !
methodClass:environment:!initializing!private! !
outer!accessing!public! !
resolveIdentifier:!operations!private! !
selfVariable!operations!public! !
superVariable!operations!public! !
!

!Kernel.StClassScope class methodsFor!

methodClass: aClassDescription
	^self methodClass: aClassDescription environment: aClassDescription environment!

methodClass: aClassDescription environment: aNamespace
	^self new
		methodClass: aClassDescription environment: aNamespace! !
!Kernel.StClassScope class categoriesForMethods!
methodClass:!instance creation!public! !
methodClass:environment:!instance creation!public! !
!

