"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.VariableRefactoring subclass: #'Refactory.Browser.CreateAccessorsForVariableRefactoring'
	instanceVariableNames: 'getterMethod setterMethod classVariable needsReturn'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.CreateAccessorsForVariableRefactoring guid: (Core.GUID fromString: '{c3f653b0-6efe-4cb6-a2a6-781aac3447ec}')!
Refactory.Browser.CreateAccessorsForVariableRefactoring comment: ''!
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring methodsFor!

classVariable: aBoolean 
	classVariable := aBoolean!

createGetterAccessor
	getterMethod := self findGetterMethod.
	getterMethod isNil ifTrue: [getterMethod := self defineGetterMethod]!

createSetterAccessor
	setterMethod := self findSetterMethod.
	setterMethod isNil ifTrue: [setterMethod := self defineSetterMethod]!

defineGetterMethod
	| selector definingClass |
	definingClass := self definingClass.
	selector := self safeMethodNameFor: definingClass
				basedOn: variableName asString.
	#rbFix. "Add private category"
	definingClass 
		compile: ('<1s><n><t>^<2s>' expandMacrosWith: selector with: variableName)
		classified: #(#accessing #private).
	^selector!

defineSetterMethod
	| selector definingClass string |
	definingClass := self definingClass.
	string := self needsReturnForSetter 
				ifTrue: ['<1s> anObject<n><t>^<2s> := anObject']
				ifFalse: ['<1s> anObject<n><t><2s> := anObject'].
	selector := self safeMethodNameFor: definingClass
				basedOn: variableName asString , ':'.
	#rbFix. "Add private category"
	definingClass 
		compile: (string expandMacrosWith: selector with: variableName)
		classified: #(#accessing #private).
	^selector!

definingClass
	^classVariable ifTrue: [class metaclass] ifFalse: [class]!

findGetterMethod
	| definingClass matcher |
	definingClass := self definingClass.
	matcher := ParseTreeSearcher getterMethod: variableName.
	^self possibleGetterSelectors detect: 
			[:each |
			(self
				checkClass: definingClass
				selector: each
				using: matcher) notNil
				and: [(definingClass subclassRedefines: each) not]]
		ifNone: [nil]!

findSetterMethod
	| definingClass matcher |
	definingClass := self definingClass.
	matcher := self needsReturnForSetter
				ifTrue: [ParseTreeSearcher returnSetterMethod: variableName]
				ifFalse: [ParseTreeSearcher setterMethod: variableName].
	^self possibleSetterSelectors detect: 
			[:each |
			(self
				checkClass: definingClass
				selector: each
				using: matcher) notNil
				and: [(definingClass subclassRedefines: each) not]]
		ifNone: [nil]!

getterMethod
	^getterMethod!

methodsReferencingVariable
	^classVariable 
		ifTrue: [self definingClass whichSelectorsReferToClassVariable: variableName]
		ifFalse: 
			[self definingClass whichSelectorsReferToInstanceVariable: variableName]!

needsReturnForSetter
	needsReturn isNil 
		ifTrue: 
			[needsReturn := self 
						usesAssignmentOf: variableName
						in: class
						classVariable: classVariable].
	^needsReturn!

possibleGetterSelectors
	^self methodsReferencingVariable select: [:each | each argumentCount == 0]!

possibleSetterSelectors
	^self methodsReferencingVariable select: [:each | each argumentCount == 1]!

preconditions
	^classVariable 
		ifTrue: [RBCondition definesClassVariable: variableName asSymbol in: class]
		ifFalse: [RBCondition definesInstanceVariable: variableName in: class]!

setterMethod
	^setterMethod!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' variable: '.
	variableName storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPutAll: ' classVariable: '.
	classVariable storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		createGetterAccessor;
		createSetterAccessor!

usesAssignmentOf: aString in: aClass classVariable: isClassVar
	| matcher definingClass |
	matcher := ParseTreeSearcher new.
	matcher
		answer: false;
		matches: aString , ' := ``@object' do: [:aNode :answer | answer or: [aNode isUsed]].
	definingClass := isClassVar ifTrue: [aClass nonMetaclass] ifFalse: [aClass].
	^definingClass withAllSubclasses
		, (isClassVar ifTrue: [definingClass metaclass withAllSubclasses] ifFalse: [#()]) anySatisfy: 
				[:each |
				(isClassVar
					ifTrue: [each whichSelectorsReferToClassVariable: aString]
					ifFalse: [each whichSelectorsReferToInstanceVariable: aString]) anySatisfy: 
							[:sel |
							self
								checkClass: each
								selector: sel
								using: matcher]]! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #classVariable:!initialize/release!public! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #createGetterAccessor!public!transforming! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #createSetterAccessor!public!transforming! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #defineGetterMethod!public!transforming! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #defineSetterMethod!public!transforming! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #definingClass!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #findGetterMethod!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #findSetterMethod!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #getterMethod!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #methodsReferencingVariable!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #needsReturnForSetter!public!testing! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #possibleGetterSelectors!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #possibleSetterSelectors!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #setterMethod!accessing!private! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #transform!public!transforming! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring categoriesFor: #usesAssignmentOf:in:classVariable:!public!testing! !

!Refactory.Browser.CreateAccessorsForVariableRefactoring class methodsFor!

model: aRBNamespace variable: aVarName class: aClass classVariable: aBoolean 
	^(self 
		model: aRBNamespace
		variable: aVarName
		class: aClass)
		classVariable: aBoolean;
		yourself!

variable: aVarName class: aClass classVariable: aBoolean 
	^(self variable: aVarName class: aClass)
		classVariable: aBoolean; yourself! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring class categoriesFor: #model:variable:class:classVariable:!instance creation!public! !
!Refactory.Browser.CreateAccessorsForVariableRefactoring class categoriesFor: #variable:class:classVariable:!instance creation!public! !

