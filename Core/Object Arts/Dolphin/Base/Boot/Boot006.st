| emptyBlock |
VMLibrary default primRegistryAt: 7 put: nil.
emptyBlock := Compiler evaluate: '[]'.
emptyBlock method isImmutable: true.
VMLibrary default primRegistryAt: 7 put: emptyBlock!

Object withAllSubclassesDo: [:each | each classPool associationsDo: [:assoc | assoc becomeA: VariableBinding]]!

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

SourceFiler removeSelectors: #(#isSourceOnly #isSourceOnly:)!

Object subclass: #SourceFiler
	instanceVariableNames: 'stream evaluationContext flags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SourceFiler addClassConstant: 'SourceOnlyMask' value: 1!

!SourceFiler methodsFor!

isSourceOnly
	^flags anyMask: SourceOnlyMask!

isSourceOnly: aBoolean
	flags := flags mask: SourceOnlyMask set: aBoolean!

setStream: aPuttableStream
	stream := aPuttableStream.
	flags := 0! !

ChunkSourceFiler allInstances do: [:each | each setStream: each stream]!

ChunkSourceFiler addClassConstant: 'NormalizeEolsMask' value: 2!

!ChunkSourceFiler methodsFor!

normalizeLineEndings
	^flags anyMask: NormalizeEolsMask!

normalizeLineEndings: aBoolean
	flags := flags mask: NormalizeEolsMask set: aBoolean! !

Delay addClassVariable: 'HighestResolution' value: 1000!

"Remove some methods that will fail to compile when class vars are redefined"

#(denormalized setExceptionMask: initialize fmax fminNormalized) do: [:each | Float class removeSelector: each ifAbsent: []].
#(printOn:) do: [:each | Float removeSelector: each ifAbsent: []]!

| var |
var := (Delay classPool associationAt: 'TimerMax').
(Array with: Delay with: Delay class) do: [:each | 
	(each whichSelectorsReferTo: var) do: [:s | each removeSelector: s]]!

(Array with: STBClassConversion>>#version:prefix:filer: with: STBInFiler>>#readClassLocator: 
		with: STBInFiler>>#basicNext with: STBInFiler>>#readClassData:) do: [:each |
	each methodClass removeSelector: each selector]!

"Remove obsolete constants pools"
Smalltalk removeKey: #STBPrefixConstants!

Win32Constants at: 'ATTACH_PARENT_PROCESS' put: -1!

SourceManager default fileIn: 'Core\Object Arts\Dolphin\Base\BootSessionManager.cls'!
SessionManager current reloadSystemPackage!
