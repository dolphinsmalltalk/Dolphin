"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.CodeGenerationContext'
	instanceVariableNames: 'writeStream targetClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CodeGenerationContext guid: (Core.GUID fromString: '{6fc5d4b7-7323-48a5-80fa-a0a8b7488433}')!
Tools.CodeGenerationContext comment: ''!
!Tools.CodeGenerationContext categoriesForClass!Kernel-Objects! !
!Tools.CodeGenerationContext methodsFor!

contents
	^writeStream contents!

environment
	^targetClass environment!

printClass: aClass
	self writeStream
		nextPutAll: ((aClass environment == self environment or: 
					[| var |
					var := self environment fullBindingFor: aClass name.
					var notNil and: [var value == aClass]])
				ifTrue: [aClass name]
				ifFalse: [aClass fullName])!

setTargetClass: aClass
	targetClass := aClass.
	writeStream := String smalltalkWriteStream: 256!

targetClass
	^targetClass!

writeStream
	^writeStream! !
!Tools.CodeGenerationContext categoriesFor: #contents!private! !
!Tools.CodeGenerationContext categoriesFor: #environment!accessing!public! !
!Tools.CodeGenerationContext categoriesFor: #printClass:!operations!public! !
!Tools.CodeGenerationContext categoriesFor: #setTargetClass:!accessing!initializing!private! !
!Tools.CodeGenerationContext categoriesFor: #targetClass!accessing!public! !
!Tools.CodeGenerationContext categoriesFor: #writeStream!accessing!public! !

!Tools.CodeGenerationContext class methodsFor!

targetClass: aClass
	^self new setTargetClass: aClass! !
!Tools.CodeGenerationContext class categoriesFor: #targetClass:!instance creation!public! !

