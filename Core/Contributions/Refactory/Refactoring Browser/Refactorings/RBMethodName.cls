"Filed out from Dolphin Smalltalk"!

Object subclass: #RBMethodName
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBMethodName guid: (GUID fromString: '{93e47b87-9470-40bd-8893-a811fd4bee6b}')!

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

!RBMethodName categoriesForMethods!
arguments!accessing!public! !
arguments:!accessing!public! !
isValid!public!testing! !
methodClass!accessing!public! !
moveArgument:before:!accessing!public! !
postCopy!copying!public! !
scope!public! !
selector!accessing!public! !
selector:!accessing!public! !
selectorSymbol!public!refactoring! !
setSelector:arguments:!public! !
!

!RBMethodName class methodsFor!

new
	^self selector: #'' arguments: #()!

selector: aSymbol arguments: stringCollection 
	^(self basicNew)
		setSelector: aSymbol arguments: stringCollection;
		yourself! !

!RBMethodName class categoriesForMethods!
new!instance creation!public! !
selector:arguments:!instance creation!public! !
!

