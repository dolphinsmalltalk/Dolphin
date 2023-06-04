"Filed out from Dolphin Smalltalk"!

Tools.ParseContext
	subclass: #'Tools.ClassParseContext'
	instanceVariableNames: 'classScope'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ClassParseContext guid: (Core.GUID fromString: '{baace1bc-c211-4bc6-97f4-f9a962cf169c}')!
Tools.ClassParseContext comment: ''!
!Tools.ClassParseContext categoriesForClass!Kernel-Objects! !
!Tools.ClassParseContext methodsFor!

environment
	^classScope environment!

methodClass
	^classScope methodClass!

methodClass: aClass environment: aNamespace
	classScope := StClassScope methodClass: aClass environment: aNamespace.
	^self!

printOn: aStream
	| class env |
	aStream
		print: self species;
		nextPutAll: ' methodClass: '.
	class := self methodClass.
	class printOn: aStream.
	env := self environment.
	env ~~ class environment
		ifTrue: 
			[aStream nextPutAll: ' environment: '.
			env printOn: aStream]!

scope
	^classScope! !
!Tools.ClassParseContext categoriesForMethods!
environment!accessing!public! !
methodClass!accessing!public! !
methodClass:environment:!initializing!private! !
printOn:!printing!public! !
scope!accessing!public! !
!

!Tools.ClassParseContext class methodsFor!

methodClass: aClass
	^self methodClass: aClass environment: aClass environment!

methodClass: aClass environment: aNamespace
	^self new methodClass: aClass environment: aNamespace! !
!Tools.ClassParseContext class categoriesForMethods!
methodClass:!instance creation!public! !
methodClass:environment:!instance creation!public! !
!

