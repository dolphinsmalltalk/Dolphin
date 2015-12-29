"Filed out from Dolphin Smalltalk X6"!

STBProxy subclass: #STBSingletonProxy
	instanceVariableNames: 'class selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBSingletonProxy guid: (GUID fromString: '{87B4C6F2-026E-11D3-9FD7-00A0CC3E4A32}')!
STBSingletonProxy comment: ''!
!STBSingletonProxy categoriesForClass!System-Binary storage! !
!STBSingletonProxy methodsFor!

class: aClass
	"Set the receiver's class inst var."

	class := aClass!

selector: aSymbol
	"Set the receiver's selector inst var."

	selector := aSymbol!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents.
	We must not use #become: to swap the receiver with the represented
	object. We need to tell inFiler to replace its readMap entry for our answer."

	| anObject |
	anObject := class perform: selector.
	inFiler fixup: anInteger to: anObject.
	^anObject! !
!STBSingletonProxy categoriesFor: #class:!accessing!public! !
!STBSingletonProxy categoriesFor: #selector:!accessing!public! !
!STBSingletonProxy categoriesFor: #stbFixup:at:!converting!public! !

!STBSingletonProxy class methodsFor!

for: aClass 
	#deprecated.
	^self forClass: aClass!

for: aClass using: aSelectorSymbol 
	#deprecated.
	^self forClass: aClass using: aSelectorSymbol!

forClass: aClass 
	"Answers an instance of the receiver that represents the singleton class, aClass.
	It is assumed that aClass will exist in the destination image and #current will
	be sent to it to yield the appropriate singleton instance"

	^self forClass: aClass using: #current!

forClass: aClass using: aSelectorSymbol 
	"Answers an instance of the receiver that represents the singleton class, aClass.
	It is assumed that aClass will exist in the destination image and aSelectorSymbol will
	be sent to it to yield the appropriate singleton instance"

	^(self basicNew)
		class: aClass;
		selector: aSelectorSymbol;
		yourself! !
!STBSingletonProxy class categoriesFor: #for:!instance creation!public! !
!STBSingletonProxy class categoriesFor: #for:using:!instance creation!public! !
!STBSingletonProxy class categoriesFor: #forClass:!instance creation!public! !
!STBSingletonProxy class categoriesFor: #forClass:using:!instance creation!public! !

