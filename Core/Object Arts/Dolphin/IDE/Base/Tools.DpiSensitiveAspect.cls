"Filed out from Dolphin Smalltalk"!

Tools.Aspect
	subclass: #'Tools.DpiSensitiveAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DpiSensitiveAspect guid: (Core.GUID fromString: '{acb456c1-e1fa-48f7-8270-781bcfa7168a}')!

Tools.DpiSensitiveAspect comment: ''!

!Tools.DpiSensitiveAspect categoriesForClass!Attribute-Definition! !

!Tools.DpiSensitiveAspect methodsFor!

readFrom: aDpiAwareObject
	^aDpiAwareObject inDpiAwarenessContextDo: [aDpiAwareObject perform: self getSelector]!

species
	^Aspect!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver to valueObject."

	subjectObject inDpiAwarenessContextDo: [subjectObject perform: self putSelector with: valueObject]! !

!Tools.DpiSensitiveAspect categoriesForMethods!
readFrom:!indirect accessing!private! !
species!accessing!public! !
writeInto:value:!indirect accessing!private! !
!

