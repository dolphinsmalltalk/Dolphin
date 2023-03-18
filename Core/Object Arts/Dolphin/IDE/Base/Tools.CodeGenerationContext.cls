"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.CodeGenerationContext'
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

nextPut: aCharacter 
	^writeStream nextPut: aCharacter!

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
!Tools.CodeGenerationContext categoriesForMethods!
contents!private! !
environment!accessing!public! !
nextPut:!public! !
printClass:!operations!public! !
setTargetClass:!accessing!initializing!private! !
targetClass!accessing!public! !
writeStream!accessing!public! !
!

!Tools.CodeGenerationContext class methodsFor!

targetClass: aClass
	^self new setTargetClass: aClass! !
!Tools.CodeGenerationContext class categoriesForMethods!
targetClass:!instance creation!public! !
!

