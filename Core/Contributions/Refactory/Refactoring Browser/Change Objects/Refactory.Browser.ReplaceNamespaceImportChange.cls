"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.ReplaceNamespaceImportChange'
	instanceVariableNames: 'oldImport newImport'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ReplaceNamespaceImportChange guid: (Core.GUID fromString: '{8ec281e9-f7e8-4c71-a161-430e19281fb0}')!
Refactory.Browser.ReplaceNamespaceImportChange comment: ''!
!Refactory.Browser.ReplaceNamespaceImportChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.ReplaceNamespaceImportChange methodsFor!

asUndoOperation
	^self class replaceImport: newImport with: oldImport in: self changeClass!

changeString
	^'Replace namespace import <1s> in <2s> in <3s>' expandMacrosWith: oldImport with: newImport with: self displayClassName!

oldImport: oldBindingReference newImport: newBindingReference
	oldImport := oldBindingReference asQualifiedReference.
	newImport := newBindingReference asQualifiedReference!

primitiveExecute
	self changeClass replaceImport: oldImport  with: newImport!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' replaceImport: ';
		print: oldImport;
		nextPutAll: ' with: ';
		print: newImport;
		nextPut: $!!! !
!Refactory.Browser.ReplaceNamespaceImportChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.ReplaceNamespaceImportChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.ReplaceNamespaceImportChange categoriesFor: #oldImport:newImport:!accessing!private! !
!Refactory.Browser.ReplaceNamespaceImportChange categoriesFor: #primitiveExecute!private! !
!Refactory.Browser.ReplaceNamespaceImportChange categoriesFor: #printOn:!printing!public! !

!Refactory.Browser.ReplaceNamespaceImportChange class methodsFor!

replaceImport: oldBindingReference with: newBindingReference in: aClass
	^(self new changeClass: aClass)
		oldImport: oldBindingReference newImport: newBindingReference;
		yourself! !
!Refactory.Browser.ReplaceNamespaceImportChange class categoriesFor: #replaceImport:with:in:!instance creation!public! !

