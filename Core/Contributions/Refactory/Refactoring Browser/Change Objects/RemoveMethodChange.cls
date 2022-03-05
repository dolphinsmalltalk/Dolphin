"Filed out from Dolphin Smalltalk"!

RefactoryClassChange subclass: #RemoveMethodChange
	instanceVariableNames: 'selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveMethodChange guid: (GUID fromString: '{4789e594-4494-4fee-920c-514289353e57}')!
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
!RemoveMethodChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
changeString!printing!public! !
hash!comparing!public! !
primitiveExecute!private! !
printOn:!printing!public! !
selector!accessing!private! !
selector:!initialize/release!public! !
source!accessing!public! !
!

!RemoveMethodChange class methodsFor!

remove: aSymbol from: aClass 
	^(self new)
		changeClass: aClass;
		selector: aSymbol;
		yourself! !
!RemoveMethodChange class categoriesForMethods!
remove:from:!instance creation!public! !
!

