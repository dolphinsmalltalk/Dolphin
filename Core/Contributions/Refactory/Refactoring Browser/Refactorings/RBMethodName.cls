"Filed out from Dolphin Smalltalk XP"!

Object subclass: #RBMethodName
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBMethodName guid: (GUID fromString: '{93E47B87-9470-40BD-8893-A811FD4BEE6B}')!
RBMethodName comment: ''!
!RBMethodName categoriesForClass!Refactory-Support! !
!RBMethodName methodsFor!

arguments
	^arguments!

arguments: nameCollection 
	arguments := nameCollection.
	self changed: #arguments!

isValid
	^(RBCondition checkMethodName: self selector in: self methodClass) and: 
			[self selector argumentCount = self arguments size 
				and: [self arguments asSet size = self arguments size]]!

methodClass
	^Object!

moveArgument: aName before: anotherName 
	arguments remove: aName ifAbsent: [^self].
	arguments add: aName before: anotherName.
	self changed: #arguments!

postCopy
	"Apply any final flourish to the copy that may be required."

	arguments := arguments copy.
	^self!

scope
	^BrowserEnvironment new!

selector
	^selector!

selector: aSymbol 
	#rbFix. "All string arguments too"
	selector := aSymbol asSymbol.
	self changed: #selector!

selectorSymbol
	#rbFix.	"Added"
	^self selector asSymbol!

setSelector: aSymbol arguments: anArray 
	selector := aSymbol.
	arguments := anArray! !
!RBMethodName categoriesFor: #arguments!accessing!public! !
!RBMethodName categoriesFor: #arguments:!accessing!public! !
!RBMethodName categoriesFor: #isValid!public!testing! !
!RBMethodName categoriesFor: #methodClass!accessing!public! !
!RBMethodName categoriesFor: #moveArgument:before:!accessing!public! !
!RBMethodName categoriesFor: #postCopy!copying!public! !
!RBMethodName categoriesFor: #scope!public! !
!RBMethodName categoriesFor: #selector!accessing!public! !
!RBMethodName categoriesFor: #selector:!accessing!public! !
!RBMethodName categoriesFor: #selectorSymbol!public!refactoring! !
!RBMethodName categoriesFor: #setSelector:arguments:!public! !

!RBMethodName class methodsFor!

new
	^self selector: #'' arguments: #()!

selector: aSymbol arguments: stringCollection 
	^(self basicNew)
		setSelector: aSymbol arguments: stringCollection;
		yourself! !
!RBMethodName class categoriesFor: #new!instance creation!public! !
!RBMethodName class categoriesFor: #selector:arguments:!instance creation!public! !

