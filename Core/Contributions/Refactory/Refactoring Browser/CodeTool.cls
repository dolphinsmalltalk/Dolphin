"Filed out from Dolphin Smalltalk 2000 release 4.01"!

BrowserApplicationModel subclass: #CodeTool
	instanceVariableNames: 'codeModel'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CodeTool comment: ''!

CodeTool guid: (GUID fromString: '{A8B6C1BD-0E73-11D5-B80B-000102677BBF}')!

!CodeTool categoriesForClass!Unclassified! !
!CodeTool methodsFor!

application
	^codeModel application!

applications
	^codeModel applications!

className
	^codeModel className!

classNames
	^codeModel classNames!

codeModel: aCodeModel 
	codeModel := aCodeModel!

compileMethodsAsPrivate
	^self navigator compileMethodsAsPrivate!

environment
	^self navigator environment
!

isMetaclass
	^codeModel isMetaclass!

isText
	^false!

methods
	^codeModel methods!

navigator
	^codeModel navigator!

nonMetaClass
	^codeModel nonMetaClass!

nonMetaClasses
	^codeModel nonMetaClasses!

protocol
	^codeModel protocol!

protocols
	^codeModel protocols!

selectedClass
	^codeModel selectedClass!

selectedClasses
	^codeModel selectedClasses!

selector
	^codeModel selector!

selectors
	^codeModel selectors! !
!CodeTool categoriesFor: #application!accessing!public! !
!CodeTool categoriesFor: #applications!accessing!public! !
!CodeTool categoriesFor: #className!accessing!public! !
!CodeTool categoriesFor: #classNames!accessing!public! !
!CodeTool categoriesFor: #codeModel:!accessing!public! !
!CodeTool categoriesFor: #compileMethodsAsPrivate!accessing!public! !
!CodeTool categoriesFor: #environment!accessing!public! !
!CodeTool categoriesFor: #isMetaclass!accessing!public! !
!CodeTool categoriesFor: #isText!public!testing! !
!CodeTool categoriesFor: #methods!accessing!public! !
!CodeTool categoriesFor: #navigator!accessing!public! !
!CodeTool categoriesFor: #nonMetaClass!accessing!public! !
!CodeTool categoriesFor: #nonMetaClasses!accessing!public! !
!CodeTool categoriesFor: #protocol!accessing!public! !
!CodeTool categoriesFor: #protocols!accessing!public! !
!CodeTool categoriesFor: #selectedClass!accessing!public! !
!CodeTool categoriesFor: #selectedClasses!accessing!public! !
!CodeTool categoriesFor: #selector!accessing!public! !
!CodeTool categoriesFor: #selectors!accessing!public! !

!CodeTool class methodsFor!

codeModel: aCodeModel 
	^self new codeModel: aCodeModel!

on: aCodeModel 
	^self new codeModel: aCodeModel! !
!CodeTool class categoriesFor: #codeModel:!instance creation!public! !
!CodeTool class categoriesFor: #on:!instance creation!public! !

