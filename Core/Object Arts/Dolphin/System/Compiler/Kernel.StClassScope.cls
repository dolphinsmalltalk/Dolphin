"Filed out from Dolphin Smalltalk 7"!

Kernel.StSemanticScope subclass: #'Kernel.StClassScope'
	instanceVariableNames: 'methodClass instanceVariables selfVariable superVariable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StClassScope guid: (Core.GUID fromString: '{b221d07f-4ae8-400c-b48e-28b90fca0050}')!
Kernel.StClassScope comment: ''!
!Kernel.StClassScope categoriesForClass!Kernel-Objects! !
!Kernel.StClassScope methodsFor!

lookupVariable: anStVariableNode
	"Lookup and return an <StVariable> describing the variable definition in this scope matching
	the variable reference specified by the <StVariableNode> argument."

	| identifier |
	identifier := anStVariableNode name.
	anStVariableNode isSpecialVariable ifTrue: [^anStVariableNode specialVariableInScope: self].
	instanceVariables isNil
		ifTrue: 
			[instanceVariables := LookupTable new: 5.
			methodClass allInstVarNames
				keysAndValuesDo: [:i :v | instanceVariables at: v put: (StInstanceVariable index: i name: v)]].
	^(instanceVariables lookup: identifier)
		ifNil: 
			[(methodClass fullBindingFor: identifier) ifNotNil: [:b | StStaticVariable scope: self binding: b]]!

methodClass
	^methodClass!

selfVariable
	^selfVariable
		ifNil: 
			[selfVariable := StSelfVariable new
						scope: self;
						yourself]!

setMethodClass: aClassDescription
	methodClass := aClassDescription.
	self initialize!

superVariable
	^superVariable
		ifNil: 
			[superVariable := StSuperVariable new
						scope: self;
						yourself]! !
!Kernel.StClassScope categoriesFor: #lookupVariable:!operations!public! !
!Kernel.StClassScope categoriesFor: #methodClass!accessing!public! !
!Kernel.StClassScope categoriesFor: #selfVariable!operations!public! !
!Kernel.StClassScope categoriesFor: #setMethodClass:!accessing!initializing!private! !
!Kernel.StClassScope categoriesFor: #superVariable!operations!public! !

!Kernel.StClassScope class methodsFor!

methodClass: aClassDescription
	^self new setMethodClass: aClassDescription! !
!Kernel.StClassScope class categoriesFor: #methodClass:!instance creation!public! !

