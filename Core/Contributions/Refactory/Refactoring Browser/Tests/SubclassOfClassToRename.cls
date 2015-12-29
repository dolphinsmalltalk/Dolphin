"Filed out from Dolphin Smalltalk 2000 release 4.01"!

ClassToRename subclass: #SubclassOfClassToRename
	instanceVariableNames: 'rewriteRule1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SubclassOfClassToRename comment: ''!

SubclassOfClassToRename guid: (GUID fromString: '{B07793CB-E421-4358-B250-E15C44D940E5}')!

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

