"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.ParseContext'
	instanceVariableNames: 'methodClass environment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ParseContext guid: (Core.GUID fromString: '{baace1bc-c211-4bc6-97f4-f9a962cf169c}')!
Tools.ParseContext comment: ''!
!Tools.ParseContext categoriesForClass!Kernel-Objects! !
!Tools.ParseContext methodsFor!

environment
	^environment!

methodClass
	^methodClass!

methodClass: aClass environment: aNamespace
	methodClass := aClass.
	environment := aNamespace.
	^self!

owningPackage
	^methodClass owningPackage!

printOn: aStream
	aStream
		print: self class;
		nextPutAll: ' methodClass: ';
		print: methodClass;
		nextPutAll: ' environment: ';
		print: environment! !
!Tools.ParseContext categoriesFor: #environment!accessing!public! !
!Tools.ParseContext categoriesFor: #methodClass!accessing!public! !
!Tools.ParseContext categoriesFor: #methodClass:environment:!initializing!private! !
!Tools.ParseContext categoriesFor: #owningPackage!accessing!public! !
!Tools.ParseContext categoriesFor: #printOn:!printing!public! !

Tools.ParseContext methodProtocol: #parseContext attributes: #(#readOnly) selectors: #(#environment #methodClass #owningPackage)!

!Tools.ParseContext class methodsFor!

methodClass: aClass environment: aNamespace
	<primitive: 157>
	^self new methodClass: aClass environment: aNamespace! !
!Tools.ParseContext class categoriesFor: #methodClass:environment:!instance creation!public! !

