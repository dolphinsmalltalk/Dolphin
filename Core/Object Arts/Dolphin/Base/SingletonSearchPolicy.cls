"Filed out from Dolphin Smalltalk X6"!

SearchPolicy subclass: #SingletonSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SingletonSearchPolicy guid: (GUID fromString: '{0F05B43D-E5E5-41CC-91D2-4E924305AAFB}')!
SingletonSearchPolicy comment: ''!
!SingletonSearchPolicy categoriesForClass!Collections-Support! !
!SingletonSearchPolicy methodsFor!

stbSaveOn: anSTBOutFiler 
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler writePreambleFor: self! !
!SingletonSearchPolicy categoriesFor: #stbSaveOn:!binary filing!public! !

!SingletonSearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^self subclassResponsibility!

stbReadFrom: anSTBInFiler format: anSTBClassConversion 
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	| singleton |
	singleton := self current.
	anSTBInFiler register: singleton.
	^singleton! !
!SingletonSearchPolicy class categoriesFor: #current!instance creation!public! !
!SingletonSearchPolicy class categoriesFor: #stbReadFrom:format:!binary filing!public! !

