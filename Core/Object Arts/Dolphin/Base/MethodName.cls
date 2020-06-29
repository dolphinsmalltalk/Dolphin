"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MethodName
	instanceVariableNames: 'className selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MethodName guid: (GUID fromString: '{22638432-c25d-413a-9087-34a3b4ad2b08}')!
MethodName comment: ''!
!MethodName categoriesForClass!Kernel-Objects! !
!MethodName methodsFor!

<= aMethodName
	"Answer whether the receiver should sort before the argument."

	^className = aMethodName className
		ifTrue: [(selector <==> aMethodName selector) <= 0]
		ifFalse: [className <= aMethodName className]!

= aMethodName
	^self == aMethodName or: 
			[self species == aMethodName species
				and: [selector == aMethodName selector and: [className = aMethodName className]]]!

className
	^className!

className: aBindingReference 
	className := aBindingReference!

className: aBindingReference selector: aSymbol
	className := aBindingReference.
	selector := aSymbol!

hash
	^(className hash + selector hash) hashMultiply!

printOn: aPuttableStream
	aPuttableStream
		display: className;
		nextPutAll: '>>';
		print: selector!

selector
	^selector!

valueOrNil
	^className valueOrNil ifNotNil: [:class | class compiledMethodAt: selector ifAbsent: []]! !
!MethodName categoriesFor: #<=!public! !
!MethodName categoriesFor: #=!comparing!public! !
!MethodName categoriesFor: #className!accessing!public! !
!MethodName categoriesFor: #className:!public! !
!MethodName categoriesFor: #className:selector:!initializing!private! !
!MethodName categoriesFor: #hash!comparing!public! !
!MethodName categoriesFor: #printOn:!printing!public! !
!MethodName categoriesFor: #selector!accessing!public! !
!MethodName categoriesFor: #valueOrNil!public! !

!MethodName class methodsFor!

className: aBindingReference selector: aSymbol
	<primitive: 157>
	^self new 	
		className: aBindingReference selector: aSymbol;
		yourself!

method: aCompiledMethod
	^self className: aCompiledMethod methodClass fullyQualifiedReference selector: aCompiledMethod selector! !
!MethodName class categoriesFor: #className:selector:!public! !
!MethodName class categoriesFor: #method:!public! !

