"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Tools.ParseContext'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ParseContext guid: (Core.GUID fromString: '{88b6a925-fc76-48fb-822c-c16b6cfd16f9}')!

Tools.ParseContext isNonInstantiable: true!

Tools.ParseContext comment: ''!

!Tools.ParseContext methodsFor!

environment
	^self subclassResponsibility!

methodClass
	^self subclassResponsibility!

owningPackage
	^self methodClass owningPackage!

resolveIdentifier: aString
	aString = 'self' ifTrue: [^self scope selfVariable].
	aString = 'super' ifTrue: [^self scope superVariable].
	aString = 'thisContext' ifTrue: [^self scope thisContextVariable].
	^self scope resolveIdentifier: aString!

scope
	^StClassScope methodClass: self methodClass environment: self environment!

species
	^ParseContext! !

!Tools.ParseContext categoriesForMethods!
environment!accessing!public! !
methodClass!accessing!public! !
owningPackage!accessing!public! !
resolveIdentifier:!public! !
scope!public! !
species!accessing!public! !
!

Tools.ParseContext methodProtocol: #parseContext attributes: #(#readOnly) selectors: #(#environment #methodClass #owningPackage #resolveIdentifier:)!

!Tools.ParseContext class methodsFor!

method: aCompiledMethod
	^MethodParseContext new method: aCompiledMethod!

methodClass: aClass
	^self methodClass: aClass environment: aClass environment!

methodClass: aClass environment: aNamespace
	^ClassParseContext new methodClass: aClass environment: aNamespace! !

!Tools.ParseContext class categoriesForMethods!
method:!instance creation!public! !
methodClass:!instance creation!public! !
methodClass:environment:!instance creation!public! !
!

