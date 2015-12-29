"Filed out from Dolphin Smalltalk 2000 release 4.01"!

CodeToolSelectionPolicy subclass: #SourceSelectionPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SourceSelectionPolicy comment: ''!

SourceSelectionPolicy guid: (GUID fromString: '{A8B6C1BC-0E73-11D5-B80B-000102677BBF}')!

!SourceSelectionPolicy categoriesForClass!Unclassified! !
!SourceSelectionPolicy methodsFor!

classToolClass
	^BrowserClassTool!

codeToolClassForApplication: aSymbol 
	^self classToolClass!

codeToolClassForClass: aBehavior 
	^self classToolClass!

codeToolClassForProtocol: aSymbol andClass: aBehavior 
	^BrowserCodeTool!

codeToolClassForSelector: aSymbol andClass: aBehavior 
	^BrowserCodeTool!

defaultCodeToolClass
	^BrowserCodeTool!

nothingSelectedCodeToolClass
	^self classToolClass! !
!SourceSelectionPolicy categoriesFor: #classToolClass!accessing/classes!public! !
!SourceSelectionPolicy categoriesFor: #codeToolClassForApplication:!accessing/classes!public! !
!SourceSelectionPolicy categoriesFor: #codeToolClassForClass:!accessing/classes!public! !
!SourceSelectionPolicy categoriesFor: #codeToolClassForProtocol:andClass:!*-compilation failures!accessing/classes!public! !
!SourceSelectionPolicy categoriesFor: #codeToolClassForSelector:andClass:!*-compilation failures!accessing/classes!public! !
!SourceSelectionPolicy categoriesFor: #defaultCodeToolClass!*-compilation failures!accessing/classes!public! !
!SourceSelectionPolicy categoriesFor: #nothingSelectedCodeToolClass!accessing/classes!public! !

