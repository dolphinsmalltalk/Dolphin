"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RBMethodName'
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBMethodName guid: (Core.GUID fromString: '{93e47b87-9470-40bd-8893-a811fd4bee6b}')!
Refactory.Browser.RBMethodName comment: ''!
!Refactory.Browser.RBMethodName categoriesForClass!Refactory-Support! !
!Refactory.Browser.RBMethodName methodsFor!

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
!Refactory.Browser.RBMethodName categoriesFor: #arguments!accessing!public! !
!Refactory.Browser.RBMethodName categoriesFor: #arguments:!accessing!public! !
!Refactory.Browser.RBMethodName categoriesFor: #isValid!public!testing! !
!Refactory.Browser.RBMethodName categoriesFor: #methodClass!accessing!public! !
!Refactory.Browser.RBMethodName categoriesFor: #moveArgument:before:!accessing!public! !
!Refactory.Browser.RBMethodName categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.RBMethodName categoriesFor: #scope!public! !
!Refactory.Browser.RBMethodName categoriesFor: #selector!accessing!public! !
!Refactory.Browser.RBMethodName categoriesFor: #selector:!accessing!public! !
!Refactory.Browser.RBMethodName categoriesFor: #selectorSymbol!public!refactoring! !
!Refactory.Browser.RBMethodName categoriesFor: #setSelector:arguments:!public! !

!Refactory.Browser.RBMethodName class methodsFor!

new
	^self selector: #'' arguments: #()!

selector: aSymbol arguments: stringCollection 
	^(self basicNew)
		setSelector: aSymbol arguments: stringCollection;
		yourself! !
!Refactory.Browser.RBMethodName class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.RBMethodName class categoriesFor: #selector:arguments:!instance creation!public! !

