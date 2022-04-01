"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.ChangeObjectTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ChangeObjectTest guid: (Core.GUID fromString: '{5047c9f6-21af-4910-a3d4-51e4c7a94366}')!
Refactory.Browser.Tests.ChangeObjectTest isNonInstantiable: true!
Refactory.Browser.Tests.ChangeObjectTest comment: ''!
!Refactory.Browser.Tests.ChangeObjectTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ChangeObjectTest methodsFor!

subjectClass
	^self subclassResponsibility!

undoClass
	"In most cases changes are undone by another change of the same type"

	^self subjectClass! !
!Refactory.Browser.Tests.ChangeObjectTest categoriesForMethods!
subjectClass!constants!private! !
undoClass!constants!private! !
!

