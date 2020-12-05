"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RenameClassRefactoring subclass: #'Refactory.Browser.CopyClassRefactoring'
	instanceVariableNames: 'superclass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.CopyClassRefactoring guid: (Core.GUID fromString: '{c6843969-c4d4-4f0f-8de1-ceae5725b831}')!
Refactory.Browser.CopyClassRefactoring comment: ''!
!Refactory.Browser.CopyClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.CopyClassRefactoring methodsFor!

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

copyImportsTo: clone
	class allImports do: [:each | (clone importsNamespace: each) ifFalse: [clone addImport: each]]	"No refactoring for adding pools"!

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

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
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
	self copyImportsTo: clone.
	self copyMethodsFrom: class to: clone.
	self copyMethodsFrom: class metaclass to: clone metaclass! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #copyClass!private!transforming! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #copyClassVarsTo:!private!transforming! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #copyImportsTo:!private!transforming! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #copyInstVarsTo:!private!transforming! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #copyMethodsFrom:to:!private!transforming! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #displayOn:!displaying!public! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #superclass!accessing!private! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #superclass:!accessing!private! !
!Refactory.Browser.CopyClassRefactoring categoriesFor: #transform!public!transforming! !

!Refactory.Browser.CopyClassRefactoring class methodsFor!

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
!Refactory.Browser.CopyClassRefactoring class categoriesFor: #clone:as:superclass:!instance creation!public! !
!Refactory.Browser.CopyClassRefactoring class categoriesFor: #model:clone:as:superclass:!instance creation!public! !

