"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.ParseContext'
	instanceVariableNames: 'classScope'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ParseContext guid: (Core.GUID fromString: '{baace1bc-c211-4bc6-97f4-f9a962cf169c}')!
Tools.ParseContext comment: ''!
!Tools.ParseContext categoriesForClass!Kernel-Objects! !
!Tools.ParseContext methodsFor!

environment
	^classScope environment!

methodClass
	^classScope methodClass!

methodClass: aClass environment: aNamespace
	classScope := StClassScope methodClass: aClass environment: aNamespace.
	^self!

owningPackage
	^self methodClass owningPackage!

printOn: aStream
	aStream
		print: self class;
		nextPutAll: ' methodClass: ';
		print: self methodClass;
		nextPutAll: ' environment: ';
		print: self environment!

scope
	^classScope! !
!Tools.ParseContext categoriesForMethods!
environment!accessing!public! !
methodClass!accessing!public! !
methodClass:environment:!initializing!private! !
owningPackage!accessing!public! !
printOn:!printing!public! !
scope!accessing!public! !
!

Tools.ParseContext methodProtocol: #parseContext attributes: #(#readOnly) selectors: #(#environment #methodClass #owningPackage)!

!Tools.ParseContext class methodsFor!

methodClass: aClass
	^self methodClass: aClass environment: aClass environment!

methodClass: aClass environment: aNamespace
	^self new methodClass: aClass environment: aNamespace! !
!Tools.ParseContext class categoriesForMethods!
methodClass:!instance creation!public! !
methodClass:environment:!instance creation!public! !
!

