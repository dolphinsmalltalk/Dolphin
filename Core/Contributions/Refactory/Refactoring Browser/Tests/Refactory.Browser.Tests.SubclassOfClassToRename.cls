"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ClassToRename subclass: #'Refactory.Browser.Tests.SubclassOfClassToRename'
	instanceVariableNames: 'rewriteRule1'
	classVariableNames: ''
	imports: #(#{Refactory.Browser.Tests.ClassToRename private})
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.SubclassOfClassToRename guid: (Core.GUID fromString: '{b07793cb-e421-4358-b250-e15c44d940e5}')!
Refactory.Browser.Tests.SubclassOfClassToRename comment: ''!
!Refactory.Browser.Tests.SubclassOfClassToRename categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.SubclassOfClassToRename methodsFor!

calls
	^self rewriteRule1: self name , self rewriteRule1!

calls1
	^self rewriteRule1: (self rewriteRule1: self calls)!

externalReference: aClassToRename _: aClassToRename2
	<stdcall: ClassToRename* dummy Refactory.Browser.Tests.ClassToRename Tests.ClassToRename*>!

name
	^rewriteRule1!

partiallyQualifiedReference1
	^Tests.ClassToRename new!

partiallyQualifiedReference2
	^Browser.Tests.ClassToRename new!

qualifiedReferences
	^{Refactory.Browser.Tests.ClassToRename new.
		Tests.ClassToRename new.
		Browser.Tests.ClassToRename new.
		ClassToRename new}!

rewriteRule1
	^rewriteRule1!

rewriteRule1: anObject
	^rewriteRule1 := anObject!

symbolicReferences
	^#(#ClassToRename #'Tests.ClassToRename' #'Refactory.Browser.Tests.ClassToRename' #'Tools.ClassToRename' #'Smalltalk.ClassToRename')! !
!Refactory.Browser.Tests.SubclassOfClassToRename categoriesForMethods!
calls!accessing!public! !
calls1!accessing!public! !
externalReference:_:!performing!public! !
name!accessing!public! !
partiallyQualifiedReference1!performing!public! !
partiallyQualifiedReference2!performing!public! !
qualifiedReferences!performing!public! !
rewriteRule1!accessing!public! !
rewriteRule1:!accessing!public! !
symbolicReferences!performing!public! !
!

