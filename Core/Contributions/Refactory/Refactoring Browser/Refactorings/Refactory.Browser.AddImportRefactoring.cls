"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassImportsRefactoring
	subclass: #'Refactory.Browser.AddImportRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddImportRefactoring guid: (Core.GUID fromString: '{cb2e95e5-b56c-42ab-8b49-9d6c81248d43}')!
Refactory.Browser.AddImportRefactoring comment: ''!
!Refactory.Browser.AddImportRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.AddImportRefactoring methodsFor!

import: aNamespace into: aClass
	self import: (self classObjectFor: aNamespace) fullyQualifiedReference class: aClass!

importsPrecondition
	^RBCondition withBlock: [(class importsNamespace: import) not]
		errorString: [class displayString , ' <1?does not import:already imports> ' , import printString]!

modifyClassImports
	class addImport: import!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addImport: ';
		print: import;
		nextPutAll: ' to: '.
	class storeOn: aStream.
	aStream nextPut: $)! !
!Refactory.Browser.AddImportRefactoring categoriesForMethods!
import:into:!initializing!private! !
importsPrecondition!private! !
modifyClassImports!private!transforming! !
storeOn:!printing!public! !
!

!Refactory.Browser.AddImportRefactoring class methodsFor!

model: aRBModel addImport: aBindingReference to: aClass
	^self new
		model: aRBModel;
		import: aBindingReference class: aClass! !
!Refactory.Browser.AddImportRefactoring class categoriesForMethods!
model:addImport:to:!public! !
!

