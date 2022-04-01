"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.CreateSubclassDialogTest'
	instanceVariableNames: 'subject'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.CreateSubclassDialogTest guid: (Core.GUID fromString: '{9c6a31f7-b898-43c0-a175-305e0521267d}')!
Tools.Tests.CreateSubclassDialogTest comment: ''!
!Tools.Tests.CreateSubclassDialogTest methodsFor!

tearDown
	subject ifNotNil: [subject destroy].
	^super tearDown!

testNameValidation
	| validationResult nameView |
	subject := CreateSubclassDialog newSubclassOf: Object inPackage: nil.
	nameView := subject view viewNamed: 'className'.
	self deny: subject isVariable.
	self deny: subject isBytes.
	self deny: subject isNonInstantiable.
	#('isVariable' 'isBytes' 'isNonInstantiable')
		do: [:each | self assert: (subject view viewNamed: each) isEnabled].
	"Valid name"
	subject subclassName: 'Blah'.
	self assert: subject canApply.
	"Duplicate name"
	subject subclassName: 'Object'.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Invalid name for new class'.
	self assert: validationResult hint messageText
		equals: ClassBuilder.ErrorAlreadyExists << {Core. 'Object'}.
	"We could in theory define a new Object class in this namespace even if it wouldn't be a very good idea"
	subject namespace: self class environment.
	self assert: subject canApply.
	"Empty name"
	self assert: validationResult presenter view identicalTo: nameView.
	subject subclassName: ''.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Invalid name for new class'.
	self assert: validationResult hint messageText equals: 'Please specify a new class name'.
	self assert: validationResult presenter view identicalTo: nameView.
	"Qualified subclass name"
	subject subclassName: 'Core.Object'.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Invalid name for new class'.
	self assert: validationResult hint messageText equals: 'New class name cannot be qualified'.
	self assert: validationResult presenter view identicalTo: nameView.
	"Invalid class name"
	subject subclassName: '1'.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Invalid name for new class'.
	self assert: validationResult hint messageText equals: 'Invalid class name ''1'''.
	self assert: validationResult presenter view identicalTo: nameView!

testNewNamespaceSubclass
	subject := CreateSubclassDialog newSubclassOf: Namespace inPackage: nil.
	self assert: subject namespace equals: Root.
	self assert: subject subclassFullName equals: ''.
	self deny: subject canApply.
	subject subclassFullName: 'Root.__Namespace__'.
	self assert: subject canApply.
	self assert: subject subclassFullName equals: '__Namespace__'.
	subject subclassFullName: '__Namespace__'.
	self assert: subject subclassFullName equals: 'Smalltalk.__Namespace__'.
	self assert: subject canApply.
	subject namespace: Core.
	self assert: subject canApply.
	self assert: subject subclassFullName equals: 'Core.__Namespace__'!

testNewRootNamespaceSubclass
	subject := CreateSubclassDialog newSubclassOf: Root inPackage: nil.
	self assert: subject namespace equals: Root.
	self assert: subject subclassFullName equals: ''.
	self deny: subject canApply.
	subject subclassFullName: 'Root.__Root__'.
	self assert: subject canApply.
	self assert: subject subclassFullName equals: '__Root__'!

testNewVariableSubclass
	subject := CreateSubclassDialog newSubclassOf: Array inPackage: nil.
	self assert: subject isVariable.
	self deny: subject isBytes.
	#('isVariable' 'isBytes') do: [:each | self deny: (subject view viewNamed: each) isEnabled].
	self assert: (subject view viewNamed: 'isNonInstantiable') isEnabled!

testPackageValidation
	| validationResult packageList |
	subject := CreateSubclassDialog newSubclassOf: Object inPackage: self class owningPackage.
	self assert: subject isPackaged.
	subject subclassName: 'Blah'.
	self assert: subject canApply.
	packageList := subject view viewNamed: 'packages'.
	packageList selections: #().
	self assert: subject isPackaged.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Incomplete input'.
	self assert: validationResult hint messageText equals: 'No package selected'.
	self assert: validationResult presenter view identicalTo: packageList!

testSuperclassValidation
	| validationResult superclassView |
	subject := CreateSubclassDialog newSubclassOf: ByteArray inPackage: nil.
	self assert: subject isVariable.
	self assert: subject isBytes.
	#('isVariable' 'isBytes') do: [:each | self deny: (subject view viewNamed: each) isEnabled].
	self assert: (subject view viewNamed: 'isNonInstantiable') isEnabled.
	subject subclassFullName: 'Tools.Tests.Blah'.
	self assert: subject canApply.
	"Pointer derived from bytes"
	subject isBytes: false.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Incompatible superclass'.
	self assert: validationResult hint messageText equals: ClassBuilder.ErrorPointerSubclassOfBytes.
	superclassView := subject view viewNamed: 'superclass'.
	self assert: validationResult presenter view identicalTo: superclassView.
	"Bytes derived from named pointers"
	subject isBytes: true.
	self assert: subject canApply.
	subject superclass: Association.
	self deny: subject isBytes.
	subject isBytes: true.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Incompatible superclass'.
	self assert: validationResult hint messageText equals: ClassBuilder.ErrorByteSubclassOfFixed.
	self assert: validationResult presenter view identicalTo: superclassView.
	"Bytes derived from indexable pointers"
	subject superclass: Array.
	self deny: subject isBytes.
	subject isBytes: true.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Incompatible superclass'.
	self assert: validationResult hint messageText equals: ClassBuilder.ErrorByteSubclassOfVariable.
	self assert: validationResult presenter view identicalTo: superclassView.
	"Named inst vars derived from indexable"
	subject isBytes: false.
	self deny: subject isVariable.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Incompatible superclass'.
	self assert: validationResult hint messageText equals: ClassBuilder.ErrorFixedSubclassOfVariable.
	self assert: validationResult presenter view identicalTo: superclassView.
	"Unsubclassable superclass"
	subject superclass: SmallInteger.
	self deny: subject canApply.
	validationResult := subject validate.
	self assert: validationResult caption equals: 'Incompatible superclass'.
	self assert: validationResult hint messageText
		equals: ClassBuilder.ErrorUnsubclassable << SmallInteger.
	self assert: validationResult presenter view identicalTo: superclassView! !
!Tools.Tests.CreateSubclassDialogTest categoriesForMethods!
tearDown!private!running! !
testNameValidation!public! !
testNewNamespaceSubclass!public! !
testNewRootNamespaceSubclass!public! !
testNewVariableSubclass!public! !
testPackageValidation!public! !
testSuperclassValidation!public! !
!

