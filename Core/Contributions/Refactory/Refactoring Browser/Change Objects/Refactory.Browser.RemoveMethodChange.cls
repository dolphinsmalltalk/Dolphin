"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryMethodChange subclass: #'Refactory.Browser.RemoveMethodChange'
	instanceVariableNames: ''
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
	^AddMethodChange compile: (self methodSourceFor: selector) in: self changeClass!

changeString
	^'Remove <1d>>><2s>' << {classReference. self selector}!

hash
	^selector hash!

primitiveExecute
	^self changeClass removeSelector: selector!

printOn: aStream
	aStream
		display: classReference;
		space;
		nextPutAll: #removeSelector:;
		space;
		nextPutAll: selector;
		nextPut: $!!!

source
	"After this change has been applied, the method will have no source."

	#rbFix. "For common interface with AddMethodChange"
	^''! !
!Refactory.Browser.RemoveMethodChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
changeString!printing!public! !
hash!comparing!public! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
source!accessing!public! !
!

!Refactory.Browser.RemoveMethodChange class methodsFor!

remove: aSymbol from: aClass 
	^(self new)
		changeClass: aClass;
		selector: aSymbol;
		yourself! !
!Refactory.Browser.RemoveMethodChange class categoriesForMethods!
remove:from:!instance creation!public! !
!

