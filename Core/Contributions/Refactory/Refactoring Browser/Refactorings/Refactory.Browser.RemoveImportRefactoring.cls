"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassImportsRefactoring
	subclass: #'Refactory.Browser.RemoveImportRefactoring'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RemoveImportRefactoring guid: (Core.GUID fromString: '{1ce4aeb8-662a-4e64-a1b0-b1f64108c693}')!

Refactory.Browser.RemoveImportRefactoring comment: ''!

!Refactory.Browser.RemoveImportRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.RemoveImportRefactoring methodsFor!

importsPrecondition
	^RBCondition withBlock: [class directlyImportsNamespace: import]
		errorString: 
			[class displayString , ' <1?directly imports:does not directly import> ' , import printString]!

modifyClassImports
	class removeImport: import!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' removeImport: ';
		print: import;
		nextPutAll: ' from: '.
	class storeOn: aStream.
	aStream nextPut: $)! !

!Refactory.Browser.RemoveImportRefactoring categoriesForMethods!
importsPrecondition!private! !
modifyClassImports!private!transforming! !
storeOn:!printing!public! !
!

!Refactory.Browser.RemoveImportRefactoring class methodsFor!

model: aRBModel removeImport: aBindingReference from: aClass
	^self new
		model: aRBModel;
		import: aBindingReference asQualifiedReference class: aClass! !

!Refactory.Browser.RemoveImportRefactoring class categoriesForMethods!
model:removeImport:from:!public! !
!

