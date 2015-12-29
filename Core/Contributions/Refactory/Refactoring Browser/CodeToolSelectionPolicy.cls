"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Object subclass: #CodeToolSelectionPolicy
	instanceVariableNames: 'name codeModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CodeToolSelectionPolicy comment: ''!

CodeToolSelectionPolicy guid: (GUID fromString: '{A8B6C1BB-0E73-11D5-B80B-000102677BBF}')!

!CodeToolSelectionPolicy categoriesForClass!Unclassified! !
!CodeToolSelectionPolicy methodsFor!

= aCodeToolSelectionPolicy 
	self class = aCodeToolSelectionPolicy class ifFalse: [^false].
	^self name = aCodeToolSelectionPolicy name!

codeToolClassForApplication: aSymbol 
	^CodeTool!

codeToolClassForClass: aBehavior 
	^CodeTool!

codeToolClassForProtocol: aSymbol andClass: aBehavior 
	^CodeTool!

codeToolClassForSelector: aSymbol andClass: aBehavior 
	^CodeTool!

copy
	^(super copy)
		postCopy;
		yourself!

for: aCodeModel 
	codeModel := aCodeModel!

hash
	^self name hash!

name
	^name!

named: aString 
	name := aString!

nothingSelectedCodeToolClass
	^CodeTool!

postCopy!

toolClass
	| class protocol selector application |
	class := codeModel selectedClass.
	class isNil 
		ifTrue: 
			[application := codeModel application.
			^application isNil 
				ifTrue: [self nothingSelectedCodeToolClass]
				ifFalse: [self codeToolClassForApplication: application]].
	protocol := codeModel protocol.
	protocol isNil ifTrue: [^self codeToolClassForClass: class].
	selector := codeModel selector.
	^selector isNil 
		ifTrue: [self codeToolClassForProtocol: protocol andClass: class]
		ifFalse: [self codeToolClassForSelector: selector andClass: class]! !
!CodeToolSelectionPolicy categoriesFor: #=!comparing!public! !
!CodeToolSelectionPolicy categoriesFor: #codeToolClassForApplication:!accessing/classes!public! !
!CodeToolSelectionPolicy categoriesFor: #codeToolClassForClass:!accessing/classes!public! !
!CodeToolSelectionPolicy categoriesFor: #codeToolClassForProtocol:andClass:!accessing/classes!public! !
!CodeToolSelectionPolicy categoriesFor: #codeToolClassForSelector:andClass:!accessing/classes!public! !
!CodeToolSelectionPolicy categoriesFor: #copy!*-unclassified!public! !
!CodeToolSelectionPolicy categoriesFor: #for:!initialize/release!public! !
!CodeToolSelectionPolicy categoriesFor: #hash!comparing!public! !
!CodeToolSelectionPolicy categoriesFor: #name!accessing!public! !
!CodeToolSelectionPolicy categoriesFor: #named:!initialize/release!public! !
!CodeToolSelectionPolicy categoriesFor: #nothingSelectedCodeToolClass!accessing/classes!public! !
!CodeToolSelectionPolicy categoriesFor: #postCopy!*-unclassified!public! !
!CodeToolSelectionPolicy categoriesFor: #toolClass!accessing!public! !

!CodeToolSelectionPolicy class methodsFor!

named: aString 
	^(self new)
		named: aString;
		yourself! !
!CodeToolSelectionPolicy class categoriesFor: #named:!instance creation!public! !

