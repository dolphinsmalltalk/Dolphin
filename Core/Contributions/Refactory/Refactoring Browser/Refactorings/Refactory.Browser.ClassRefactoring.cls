"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.ClassRefactoring'
	instanceVariableNames: 'className'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassRefactoring guid: (Core.GUID fromString: '{50c0a330-c04d-4855-a513-f97929846e0f}')!
Refactory.Browser.ClassRefactoring isNonInstantiable: true!
Refactory.Browser.ClassRefactoring comment: ''!
!Refactory.Browser.ClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.ClassRefactoring methodsFor!

className
	^className pathString!

className: aString
	self classReference: (BindingReference fullPathString: aString)!

classReference: aBindingReference
	className := aBindingReference referenceInModel: self model!

environment
	^className environment!

environment: aRBNamespaceClass 
	self className: (aRBNamespaceClass fullNameFor: self unqualifiedClassName)!

unqualifiedClassName
	^className unqualifiedName!

unqualifiedClassName: aString
	| path |
	path := className path copy.
	path at: path size put: aString.
	self classReference: (BindingReference newFullPath: path private: false)! !
!Refactory.Browser.ClassRefactoring categoriesForMethods!
className!accessing!public! !
className:!accessing!public! !
classReference:!accessing!public! !
environment!accessing!public! !
environment:!accessing!public! !
unqualifiedClassName!accessing!public! !
unqualifiedClassName:!public! !
!

!Refactory.Browser.ClassRefactoring class methodsFor!

className: aName
	^self new className: aName!

model: aRBModel className: aName
	^self new
		model: aRBModel;
		className: aName;
		yourself! !
!Refactory.Browser.ClassRefactoring class categoriesForMethods!
className:!instance creation!public! !
model:className:!instance creation!public! !
!

