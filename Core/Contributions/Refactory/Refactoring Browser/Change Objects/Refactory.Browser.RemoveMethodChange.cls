"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryClassChange subclass: #'Refactory.Browser.RemoveMethodChange'
	instanceVariableNames: 'selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveMethodChange guid: (Core.GUID fromString: '{4789e594-4494-4fee-920c-514289353e57}')!
Refactory.Browser.RemoveMethodChange comment: ''!
!Refactory.Browser.RemoveMethodChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveMethodChange methodsFor!

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
!Refactory.Browser.RemoveMethodChange categoriesFor: #=!comparing!public! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #hash!comparing!public! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #primitiveExecute!private! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #selector!accessing!private! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #selector:!initialize/release!public! !
!Refactory.Browser.RemoveMethodChange categoriesFor: #source!accessing!public! !

!Refactory.Browser.RemoveMethodChange class methodsFor!

remove: aSymbol from: aClass 
	^(self new)
		changeClass: aClass;
		selector: aSymbol;
		yourself! !
!Refactory.Browser.RemoveMethodChange class categoriesFor: #remove:from:!instance creation!public! !

