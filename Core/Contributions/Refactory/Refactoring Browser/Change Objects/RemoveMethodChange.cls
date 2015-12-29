"Filed out from Dolphin Smalltalk XP"!

RefactoryClassChange subclass: #RemoveMethodChange
	instanceVariableNames: 'selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveMethodChange guid: (GUID fromString: '{4789E594-4494-4FEE-920C-514289353E57}')!
RemoveMethodChange comment: ''!
!RemoveMethodChange categoriesForClass!Refactory-Change Objects! !
!RemoveMethodChange methodsFor!

= aRemoveMethodChange 
	super = aRemoveMethodChange ifFalse: [^false].
	^selector = aRemoveMethodChange selector!

asUndoOperation
	^self addMethodChangeClass compile: (self methodSourceFor: selector)
		in: self changeClass!

changeString
	^'Remove <1s>>><2s>' expandMacrosWith: self displayClassName with: self selector!

hash
	^selector hash!

primitiveExecute
	^self changeClass removeSelector: selector!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeSelector: ';
		nextPutAll: selector;
		nextPut: $!!!

selector
	^selector!

selector: aSymbol 
	selector := aSymbol!

source
	"After this change has been applied, the method will have no source."

	#rbFix. "For common interface with AddMethodChange"
	^''! !
!RemoveMethodChange categoriesFor: #=!comparing!public! !
!RemoveMethodChange categoriesFor: #asUndoOperation!converting!public! !
!RemoveMethodChange categoriesFor: #changeString!printing!public! !
!RemoveMethodChange categoriesFor: #hash!comparing!public! !
!RemoveMethodChange categoriesFor: #primitiveExecute!private! !
!RemoveMethodChange categoriesFor: #printOn:!printing!public! !
!RemoveMethodChange categoriesFor: #selector!accessing!private! !
!RemoveMethodChange categoriesFor: #selector:!initialize/release!public! !
!RemoveMethodChange categoriesFor: #source!accessing!public! !

!RemoveMethodChange class methodsFor!

remove: aSymbol from: aClass 
	^(self new)
		changeClass: aClass;
		selector: aSymbol;
		yourself! !
!RemoveMethodChange class categoriesFor: #remove:from:!instance creation!public! !

