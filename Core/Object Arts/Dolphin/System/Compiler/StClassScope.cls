"Filed out from Dolphin Smalltalk 7"!

StSemanticScope subclass: #StClassScope
	instanceVariableNames: 'methodClass instanceVariables'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StClassScope guid: (GUID fromString: '{b221d07f-4ae8-400c-b48e-28b90fca0050}')!
StClassScope comment: ''!
!StClassScope categoriesForClass!Kernel-Objects! !
!StClassScope methodsFor!

lookupVariable: aString
	instanceVariables isNil
		ifTrue: 
			[instanceVariables := LookupTable new: 5.
			methodClass allInstVarNames
				keysAndValuesDo: [:i :v | instanceVariables at: v put: (StInstanceVariable index: i name: v)]].
	^(instanceVariables lookup: aString)
		ifNil: 
			[(methodClass fullBindingFor: aString)
				ifNil: [outer lookupVariable: aString]
				ifNotNil: [:b | StStaticVariable scope: self binding: b]]!

setMethodClass: aClassDescription
	methodClass := aClassDescription.
	self initialize! !
!StClassScope categoriesFor: #lookupVariable:!operations!public! !
!StClassScope categoriesFor: #setMethodClass:!accessing!initializing!private! !

!StClassScope class methodsFor!

methodClass: aClassDescription
	^self new setMethodClass: aClassDescription! !
!StClassScope class categoriesFor: #methodClass:!instance creation!public! !

