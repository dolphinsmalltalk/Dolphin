"Filed out from Dolphin Smalltalk 7"!

Core.Model subclass: #'Refactory.Browser.Tests.ClassToRename'
	instanceVariableNames: 'rewriteRule builder class'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'notUsed'
	classConstants: {}!
Refactory.Browser.Tests.ClassToRename guid: (Core.GUID fromString: '{83c27f52-b80f-487b-bd8c-b4035ca0cf2e}')!
Refactory.Browser.Tests.ClassToRename comment: ''!
!Refactory.Browser.Tests.ClassToRename categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.ClassToRename methodsFor!

method1
	^self method2!

method2
	^self method1!

selfReference
	^ClassToRename new! !
!Refactory.Browser.Tests.ClassToRename categoriesFor: #method1!performing!public! !
!Refactory.Browser.Tests.ClassToRename categoriesFor: #method2!performing!public! !
!Refactory.Browser.Tests.ClassToRename categoriesFor: #selfReference!performing!public! !

!Refactory.Browser.Tests.ClassToRename class methodsFor!

byteSize
	"Defined to allow this class to contain an external method for testing purposes."

	^4!

new
	^super new initialize! !
!Refactory.Browser.Tests.ClassToRename class categoriesFor: #byteSize!accessing!private! !
!Refactory.Browser.Tests.ClassToRename class categoriesFor: #new!performing!public! !

