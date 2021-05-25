"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.ClassRefactoring subclass: #'Tools.CopyClassRefactoring'
	instanceVariableNames: 'newName class superclass'
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CopyClassRefactoring guid: (Core.GUID fromString: '{c6843969-c4d4-4f0f-8de1-ceae5725b831}')!
Tools.CopyClassRefactoring comment: ''!
!Tools.CopyClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Tools.CopyClassRefactoring methodsFor!

className: aName newName: aNewName superclass: aClass
	self className: aName.
	"If the new name is unqualified, preserve the original namespace of the class."
	newName := ((BindingReference isQualifiedName: aNewName)
				ifTrue: [aNewName]
				ifFalse: 
					[| parts |
					parts := $. split: aName.
					parts at: parts size put: aNewName.
					$. join: parts])
					asSymbol.
	class := self model classNamed: className.
	superclass := self classObjectFor: aClass.
	^self!

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
!Tools.CopyClassRefactoring categoriesFor: #className:newName:superclass:!initializing!private! !
!Tools.CopyClassRefactoring categoriesFor: #copyClass!private!transforming! !
!Tools.CopyClassRefactoring categoriesFor: #copyClassVarsTo:!private!transforming! !
!Tools.CopyClassRefactoring categoriesFor: #copyImportsTo:!private!transforming! !
!Tools.CopyClassRefactoring categoriesFor: #copyInstVarsTo:!private!transforming! !
!Tools.CopyClassRefactoring categoriesFor: #copyMethodsFrom:to:!private!transforming! !
!Tools.CopyClassRefactoring categoriesFor: #displayOn:!displaying!public! !
!Tools.CopyClassRefactoring categoriesFor: #preconditions!preconditions!public! !
!Tools.CopyClassRefactoring categoriesFor: #storeOn:!printing!public! !
!Tools.CopyClassRefactoring categoriesFor: #superclass!accessing!private! !
!Tools.CopyClassRefactoring categoriesFor: #superclass:!accessing!private! !
!Tools.CopyClassRefactoring categoriesFor: #transform!public!transforming! !

!Tools.CopyClassRefactoring class methodsFor!

clone: aClass as: aNewName superclass: superClass
	^self new className: aClass fullName newName: aNewName superclass: superClass!

model: aRBNamespace clone: aClass as: aNewName superclass: superClass
	^self new
		model: aRBNamespace;
		className: aClass fullName newName: aNewName superclass: superClass! !
!Tools.CopyClassRefactoring class categoriesFor: #clone:as:superclass:!instance creation!public! !
!Tools.CopyClassRefactoring class categoriesFor: #model:clone:as:superclass:!instance creation!public! !

