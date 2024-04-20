"Filed out from Dolphin Smalltalk"!

Aspect subclass: #DpiSensitiveAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DpiSensitiveAspect guid: (GUID fromString: '{acb456c1-e1fa-48f7-8270-781bcfa7168a}')!

DpiSensitiveAspect comment: ''!

!DpiSensitiveAspect categoriesForClass!Attribute-Definition! !

!DpiSensitiveAspect methodsFor!

readFrom: aDpiAwareObject
	^aDpiAwareObject inDpiAwarenessContextDo: [aDpiAwareObject perform: self getSelector]!

species
	^Aspect!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver to valueObject."

	subjectObject inDpiAwarenessContextDo: [subjectObject perform: self putSelector with: valueObject]! !

!DpiSensitiveAspect categoriesForMethods!
readFrom:!indirect accessing!private! !
species!accessing!public! !
writeInto:value:!indirect accessing!private! !
!

