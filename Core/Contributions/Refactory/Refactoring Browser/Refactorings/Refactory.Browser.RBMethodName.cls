"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.RBMethodName'
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBMethodName guid: (Core.GUID fromString: '{93e47b87-9470-40bd-8893-a811fd4bee6b}')!
Refactory.Browser.RBMethodName comment: ''!
!Refactory.Browser.RBMethodName categoriesForClass!Refactory-Support! !
!Refactory.Browser.RBMethodName methodsFor!

argumentCount
	^self arguments size!

arguments
	^arguments!

arguments: nameCollection 
	arguments := nameCollection.
	self changed: #arguments!

conditions
	^(RBCondition isValidMethodName: self selectorSymbol)
		& (RBCondition withBlock: [self selectorSymbol argumentCount = self argumentCount]
				errorString: 
					[| argc |
					argc := self argumentCount.
					argc == 0
						ifTrue: ['Unary selector required']
						ifFalse: 
							[argc == 1
								ifTrue: ['Binary or single keyword selector required']
								ifFalse: ['<1d> keyword selector required' << argc]]])
			& (RBCondition withBlock: [self arguments asSet size = self arguments size]
					errorString: 'Parameter names must be unique')!

isValid
	^self validate value!

methodClass
	^Object!

moveArgument: aName before: anotherName 
	arguments remove: aName ifAbsent: [^self].
	arguments add: aName before: anotherName.
	self changed: #arguments!

originalSelector
	^nil!

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
	arguments := anArray!

validate
	^self conditions validate! !
!Refactory.Browser.RBMethodName categoriesForMethods!
argumentCount!accessing!public! !
arguments!accessing!public! !
arguments:!accessing!public! !
conditions!accessing!public! !
isValid!public!testing! !
methodClass!accessing!public! !
moveArgument:before:!operations!public! !
originalSelector!accessing!public! !
postCopy!copying!public! !
scope!public! !
selector!accessing!public! !
selector:!accessing!public! !
selectorSymbol!accessing!public! !
setSelector:arguments:!public! !
validate!operations!public! !
!

!Refactory.Browser.RBMethodName class methodsFor!

new
	^self selector: #'' arguments: #()!

selector: aSymbol arguments: stringCollection 
	^(self basicNew)
		setSelector: aSymbol arguments: stringCollection;
		yourself! !
!Refactory.Browser.RBMethodName class categoriesForMethods!
new!instance creation!public! !
selector:arguments:!instance creation!public! !
!

