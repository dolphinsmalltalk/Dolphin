"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #'Kernel.STBSingletonProxy'
	instanceVariableNames: 'class selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STBSingletonProxy guid: (Core.GUID fromString: '{87b4c6f2-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.STBSingletonProxy comment: ''!

!Kernel.STBSingletonProxy categoriesForClass!System-Binary storage! !

!Kernel.STBSingletonProxy methodsFor!

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

!Kernel.STBSingletonProxy categoriesForMethods!
class:!accessing!public! !
selector:!accessing!public! !
stbFixup:at:!converting!public! !
!

!Kernel.STBSingletonProxy class methodsFor!

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

!Kernel.STBSingletonProxy class categoriesForMethods!
forClass:!instance creation!public! !
forClass:using:!instance creation!public! !
!

