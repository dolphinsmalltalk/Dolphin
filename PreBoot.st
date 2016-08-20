"This file contains patches to base system classes that are required in order to be able to reload the base class library,
but which are not yet consolidated into the boot image. Most BCL changes do not require pre-patching, so try without first"!

!Class methodsFor!

addClassConstant: aString value: anObject
	| binding |
	binding := self addClassVarNamed: aString.
	binding isImmutable: false.
	binding value: anObject.
	binding isImmutable: true.
	^binding!

addClassVariable: aString value: anObject
	^(self addClassVarNamed: aString)
		isImmutable: false;
		value: anObject;
		yourself!

addClassVarNamed: aString
	| varName var |
	varName := aString trimBlanks.
	classPool := self classPool.
	(classPool bindingFor: varName) ifNotNil: [:existingVar | ^existingVar].
	(self withAllSubclasses detect: [:each | (each classPool bindingFor: varName) notNil] ifNone: [])
		ifNotNil: [:existingClass | ^self error: aString , ' is already used as a variable name in class ' , existingClass name].
	var := classPool newAssociation: varName value: nil.
	classPool add: var.
	^var! !

!VMLibrary class methodsFor!

hasBytecodeRepresentation: anObject
	"Private - Answer whether the specified object has a special instruction or instructions that when
	executed will push an identical object on the on the stack, e.g. nil, true, false,
	SmallIntegers, Characters."

	^anObject isImmediate or: [anObject isNil or: [anObject == true or: [anObject == false]]]! !
