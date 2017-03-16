"Filed out from Dolphin Smalltalk 7"!

StsPackageProxy subclass: #StsVastPackageProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsVastPackageProxy guid: (GUID fromString: '{f44fda23-a74c-424b-922e-bdb835f80ffd}')!
StsVastPackageProxy comment: ''!
!StsVastPackageProxy categoriesForClass!Kernel-Objects! !
!StsVastPackageProxy methodsFor!

importClassDefinition
	| classProxy tokens str className instVars classInstVars classVars poolDicts |
	className := stream nextLine.
	tokens := className subStrings.
	str := tokens at: 3.
	classProxy := self findOrCreateClassNamed: (str copyFrom: 2 to: str size) asSymbol.
	(str := stream nextLine trimBlanks) subStrings first = 'classInstanceVariableNames:' 
		ifTrue: 
			[classInstVars := self removeEndingSpace: str.
			str := stream nextLine trimBlanks]
		ifFalse: [classInstVars := 'classInstanceVariableNames: '''''].
	instVars := str.
	classVars := stream nextLine trimBlanks.
	str := stream nextLine trimBlanks.
	poolDicts := str copyFrom: 1 to: str size - 1.
	stream nextLine.
	classProxy 
		definition: className , '
	' , (self removeEndingSpace: instVars) , '
	' 
				, (self removeEndingSpace: classVars) , '
	' 
				, (self removeEndingSpace: poolDicts) , '
	' 
				, classInstVars!

importMethodsFor: classProxy public: aBoolean 
	| methodSource method lastMethod |
	lastMethod := false.
	
	[stream nextLine.
	methodSource := stream nextLine.
	[methodSource last = $!! and: [(methodSource at: methodSource size - 1) ~= $!!]] 
		whileFalse: [methodSource := methodSource , '
' , stream nextLine].
	(methodSource copyFrom: methodSource size - 2 to: methodSource size) = '!! !!' 
		ifTrue: 
			[lastMethod := true.
			methodSource := methodSource copyFrom: 1 to: methodSource size - 3]
		ifFalse: [methodSource := methodSource copyFrom: 1 to: methodSource size - 1].
	method := (StsCompiledMethodProxy new)
				methodSource: (self undoubleMarkers: methodSource);
				methodClass: classProxy;
				isPrivate: aBoolean not.
	classProxy methodDictionary at: method selector put: method.
	lastMethod] 
			whileFalse: []!

load
	| str classProxy token className isLoose tokens isSubapplication |
	
	[str := stream nextLine.
	('Application create: *' match: str) or: ['* createSubApplication: *' match: str]] 
			whileFalse: [].
	tokens := str subStrings.
	isSubapplication := (tokens at: 2) = 'createSubApplication:'.
	str := tokens at: 3.
	name := str copyFrom: 2 to: str size.
	isSubapplication not 
		ifTrue: 
			[str := stream nextLine.
			str := (str copyFrom: 1 to: str size - 1) subStrings.
			str size > 1 ifTrue: [prerequisiteNames := str copyFrom: 2 to: str size].
			stream nextLine].
	stream
		nextLine;
		nextLine.
	[(str := stream nextLine) isEmpty] whileFalse: [self importClassDefinition].
	str := stream
				nextLine;
				nextLine;
				nextLine.
	[str first = $!!] whileTrue: 
			[token := str subStrings first.
			className := token copyFrom: 2 to: token size.
			classProxy := self classNamed: className asSymbol.
			(isLoose := classProxy isNil) ifTrue: [classProxy := StsClassProxy new name: className].
			(str subStrings at: 2) = 'class' 
				ifTrue: 
					[classProxy := classProxy metaClass.
					token := str subStrings at: 3]
				ifFalse: [token := str subStrings at: 2].
			self importMethodsFor: classProxy public: token = 'publicMethods'.
			isLoose ifTrue: [looseMethods addAll: classProxy methods].
			str := stream
						nextLine;
						nextLine]!

manualPrerequisites
	^#()! !
!StsVastPackageProxy categoriesFor: #importClassDefinition!public! !
!StsVastPackageProxy categoriesFor: #importMethodsFor:public:!public! !
!StsVastPackageProxy categoriesFor: #load!public! !
!StsVastPackageProxy categoriesFor: #manualPrerequisites!public! !

