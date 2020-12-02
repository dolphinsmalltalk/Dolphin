"Filed out from Dolphin Smalltalk 7"!

ClassToRename subclass: #SubclassOfClassToRename
	instanceVariableNames: 'rewriteRule1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SubclassOfClassToRename guid: (GUID fromString: '{b07793cb-e421-4358-b250-e15c44d940e5}')!
SubclassOfClassToRename comment: ''!
!SubclassOfClassToRename categoriesForClass!Refactory-Test data! !
!SubclassOfClassToRename methodsFor!

calls
	^self rewriteRule1: self name , self rewriteRule1!

calls1
	^self rewriteRule1: (self rewriteRule1: self calls)!

name
	^rewriteRule1!

reference
	^ClassToRename new!

rewriteRule1
	^rewriteRule1!

rewriteRule1: anObject
	^rewriteRule1 := anObject!

symbolReference
	^#ClassToRename! !
!SubclassOfClassToRename categoriesFor: #calls!accessing!public! !
!SubclassOfClassToRename categoriesFor: #calls1!accessing!public! !
!SubclassOfClassToRename categoriesFor: #name!accessing!public! !
!SubclassOfClassToRename categoriesFor: #reference!performing!public! !
!SubclassOfClassToRename categoriesFor: #rewriteRule1!accessing!public! !
!SubclassOfClassToRename categoriesFor: #rewriteRule1:!accessing!public! !
!SubclassOfClassToRename categoriesFor: #symbolReference!performing!public! !

