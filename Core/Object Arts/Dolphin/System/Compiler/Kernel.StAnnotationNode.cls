"Filed out from Dolphin Smalltalk"!

Kernel.StTagNode subclass: #'Kernel.StAnnotationNode'
	instanceVariableNames: 'selector arguments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StAnnotationNode guid: (Core.GUID fromString: '{e65cb014-8373-4447-9994-f337d37f7544}')!
Kernel.StAnnotationNode comment: ''!
!Kernel.StAnnotationNode categoriesForClass!System-Compiler! !
!Kernel.StAnnotationNode methodsFor!

= anObject
	^self == anObject or: 
			[self class = anObject class
				and: [selector == anObject selector and: [arguments = anObject arguments]]]!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitAnnotationNode: self!

argumentCount
	^arguments size!

arguments
	^arguments!

selector
	^selector!

setSelector: aSymbol arguments: anArray
	selector := aSymbol asSymbol.
	arguments := anArray asArray.
	^self! !
!Kernel.StAnnotationNode categoriesFor: #=!comparing!public! !
!Kernel.StAnnotationNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StAnnotationNode categoriesFor: #argumentCount!accessing!public! !
!Kernel.StAnnotationNode categoriesFor: #arguments!accessing!public! !
!Kernel.StAnnotationNode categoriesFor: #selector!accessing!public! !
!Kernel.StAnnotationNode categoriesFor: #setSelector:arguments:!initializing!private! !

!Kernel.StAnnotationNode class methodsFor!

selector: aSymbol arguments: anArrayOfStLiteralValueNode
	^self new setSelector: aSymbol arguments: anArrayOfStLiteralValueNode! !
!Kernel.StAnnotationNode class categoriesFor: #selector:arguments:!instance creation!public! !

