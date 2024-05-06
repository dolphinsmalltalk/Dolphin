"Filed out from Dolphin Smalltalk"!

RenameClassRefactoring subclass: #CopyClassRefactoring
	instanceVariableNames: 'superclass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CopyClassRefactoring guid: (GUID fromString: '{c6843969-c4d4-4f0f-8de1-ceae5725b831}')!

CopyClassRefactoring comment: ''!

!CopyClassRefactoring categoriesForClass!Refactory-Refactorings! !

!CopyClassRefactoring methodsFor!

copyClass
	self performComponentRefactoring: (AddClassRefactoring 
				model: self model
				addClass: newName
				superclass: superclass
				subclasses: #()
				category: class category).
	^self model classNamed: newName!

copyClassVarsTo: clone 
	(class allClassVariableNames difference: superclass allClassVariableNames) do: 
			[:each | 
			self performComponentRefactoring: (AddClassVariableRefactoring 
						model: self model
						variable: each
						class: clone)]!

copyInstVarsTo: clone 
	(class allInstanceVariableNames difference: superclass allInstanceVariableNames) do: 
			[:each | 
			self performComponentRefactoring: (AddInstanceVariableRefactoring 
						model: self model
						variable: each
						class: clone)]!

copyMethodsFrom: aRBAbstractClass to: cloneClass 
	aRBAbstractClass selectors do: 
			[:each | 
			| method |
			method := aRBAbstractClass methodFor: each.
			(cloneClass compile: method source classified: (aRBAbstractClass protocolsFor: each)) 
				package: method method owningPackageIfLoose]!

copyPoolsTo: clone 
	class allPoolDictionaryNames 
		do: [:each | (clone definesPoolDictionary: each) ifFalse: [clone addPoolDictionary: each]]	"No refactoring for adding pools"!

displayOn: aStream 
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream
		nextPutAll: 'Clone class ';
		display: className;
		nextPutAll: ' as ';
		display: newName!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: className , ' is not a valid class name') & (superclass isNil 
					ifTrue: [RBCondition empty]
					ifFalse: [((RBCondition isMetaclass: superclass) errorMacro: 'Superclass must not be a metaclass') not]) 
		& (RBCondition isValidClassName: newName) & (RBCondition isGlobal: newName in: self model) not!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' clone: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' as: #';
		nextPutAll: newName;
		nextPutAll: ' superclass: '.
	superclass storeOn: aStream.
	aStream nextPut: $)!

superclass
	^superclass!

superclass: aClass
	superclass := self classObjectFor: aClass.!

transform
	| clone |
	clone := self copyClass.
	self copyInstVarsTo: clone.
	self copyClassVarsTo: clone.
	self copyPoolsTo: clone.
	self copyMethodsFrom: class to: clone.
	self copyMethodsFrom: class metaclass to: clone metaclass! !

!CopyClassRefactoring categoriesForMethods!
copyClass!private!transforming! !
copyClassVarsTo:!private!transforming! !
copyInstVarsTo:!private!transforming! !
copyMethodsFrom:to:!private!transforming! !
copyPoolsTo:!private!transforming! !
displayOn:!displaying!public! !
preconditions!preconditions!public! !
storeOn:!printing!public! !
superclass!accessing!private! !
superclass:!accessing!private! !
transform!public!transforming! !
!

!CopyClassRefactoring class methodsFor!

clone: aClass as: aNewName superclass: superClass 
	^(super rename: aClass to: aNewName)
		superclass: superClass;
		yourself!

model: aRBNamespace clone: aClass as: aNewName superclass: superClass 
	^(super 
		model: aRBNamespace
		rename: aClass
		to: aNewName)
		superclass: superClass;
		yourself! !

!CopyClassRefactoring class categoriesForMethods!
clone:as:superclass:!instance creation!public! !
model:clone:as:superclass:!instance creation!public! !
!

