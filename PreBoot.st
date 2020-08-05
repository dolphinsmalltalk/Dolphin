Float addClassVariable: 'DefaultDecimalExponents' value: (-3 to: 6)!
#(#thousandSeparator #thousandSeparator:) do: [:each | NUMBERFMTW removeSelector: each]!

!Compiler class methodsFor!

evaluate: aString for: anObject evaluationPools: anArray logged: aBoolean ifFail: failBlock

	^(self
		compileForEvaluation: aString
		in: (anObject ifNotNil: [anObject class])
		evaluationPools: anArray
		flags: 0) method
		ifNotNil: 
			[:expr |
			aBoolean ifTrue: [self sourceManager logEvaluate: aString].
			expr value: anObject withArguments: #()]
		ifNil: [failBlock value]! !
		
!Class methodsFor!

imports
	^(sharedPools ?? #()) collect: [:each | each asQualifiedReference]!

imports: anArray
	sharedPools := anArray asArray!
	
sharedPoolNames
	^(sharedPools ?? #()) collect: [:each | each asSymbol]!

newClassBuilder: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences
	^ClassBuilder new
		superclass: self;
		className: aClassSymbol;
		instanceVariableString: instVarString;
		classVariableString: classVarString;
		imports: anArrayOfBindingReferences;
		yourself!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class, classSymbol, to be a subclass of the receiver with the specified instance variables, class pool, pool dictionaries, class instance variables, and class constants."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArrayOfBindingReferences)
				classConstants: anArrayOfAssociations;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

variableSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class named classSymbol to be a variable subclass (has indexable pointer variables) of the receiver with the specified instance variables, class variables, class constants, pool dictionaries, and class instance variables."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArray)
				classConstants: anArrayOfAssociations;
				beVariable;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

variableByteSubclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"Create or modify the class named, classSymbol, to be a variable-byte subclass (has indexable byte-size nonpointer variables) of the receiver with the specified class pool, and pool dictionaries, and class instance variables. Note that variable byte classes cannot have any named instance variables, and therefore the instVarString must be empty."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArray)
				classConstants: anArrayOfAssociations;
				beBytes;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass! !

!ClassBuilder methodsFor!

sharedPools
	^#()!

imports: anArrayOfBindingReferences
	self assert: [anArrayOfBindingReferences isEmpty]! !

!UndefinedObject methodsFor!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"If aClassSymbol is not an existing class then create and answer a new fixed-pointer subclass,  otherwise modify the class with name aClassSymbol to have the indicated features and answer it. Subclasses of nil are root classes, like Object, and special care is needed in their definition.  It is also the case that many modifications of Object are illegal (it cannot have named instance variables for example)."

	| subclass |
	subclass := (ClassBuilder new
				className: aClassSymbol;
				instanceVariableString: instVarString;
				classVariableString: classVarString;
				imports: anArray;
				yourself)
				classConstants: anArrayOfAssociations;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass! !
	
| tempMethod |
tempMethod := Class>>#sharedPoolNames.
tempMethod sourceDescriptor: tempMethod getSource!
Class instanceVariableString: 'subclasses name classPool imports environment comment classCategories _guid'!
Class allClasses do: [:each | each imports: each imports]!
