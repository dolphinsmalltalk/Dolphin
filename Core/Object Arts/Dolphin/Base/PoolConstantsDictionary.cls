"Filed out from Dolphin Smalltalk 7"!

LookupTable variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolConstantsDictionary guid: (GUID fromString: '{87b4c52e-026e-11d3-9fd7-00a0cc3e4a32}')!
PoolConstantsDictionary comment: ''!
!PoolConstantsDictionary categoriesForClass!Collections-Unordered!System-Support! !
!PoolConstantsDictionary methodsFor!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."
	
	^VariableBinding!

at: key ifAbsentPut: operation 
	"Answer the value of the receiver keyed by the <Object> argument, key.
	If key is not one of the receiver's keys, then add the result of evaluating 
	the <niladicValuable>, operation, at key, and answer that result."

	^super at: key asString
		ifAbsentPut: 
			[self isChanged: true.
			operation value]!

at: key put: anObject 
	"Store the argument anObject with the external key, aKey,
	in the receiver. Answer anObject. Ensure the key is a String.
	If the key already exists in the receiver, raise an exception
	because the receiver is supposed to contain constants."

	| value keyString |
	keyString := self keyString: key.
	value := self at: keyString
				ifAbsent: 
					["New element added"
					self isChanged: true.
					^super at: keyString put: anObject].
	^value = anObject 
		ifTrue: [anObject	"No attempt was made to change the value"]
		ifFalse: [self errorModify: keyString value: anObject]!

canFileOut
	"Answer true if the receiver can be filed out. At this stage we just check to ensure that
	the file out file is writeable"

	^File isWriteable: self  fileOutName!

classesReferencing
	^self environment allClasses select: [:c | c allSharedPools includes: self]!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	self name displayOn: aStream
!

environment
	"Answer the receiver's controlling name space."

	^Smalltalk
!

errorModify: key value: value
	"Private - An attempt was made to modify the value of the constant named, key."

	| recompile |
	recompile := ConfirmationRequiredWarning
				signal: ('Would you like to recompile references to <1p><n>to reflect the new value <2d> (currently <3d>)'
						expandMacrosWith: key
						with: value
						with: (self at: key)).
	recompile isNil ifTrue: [^self].
	super at: key put: value.
	self isChanged: true.
	recompile ifTrue: [self recompileReferencesToVarNamed: key]!

fileOut
	"File out the receiver to <name>.st"

	self class sourceManager fileOut: self.
	self isChanged: false!

fileOutName
	"Answer the receiver's default file name for file outs (<name>.st)."

	| path package |
	path := File composeStem: self name extension: Package sourceGlobalExtension.
	package := Package manager packageOfGlobalNamed: self name asSymbol.
	package notNil ifTrue: [
		path := File replacePath:  path with: package path ].
	^path!

fileOutOn: aSourceFiler
	aSourceFiler fileOutPoolDictionary: self!

findKeyOrNil: anObject 
	"Private - Answer the index of the given key in the receiver, or, if not found,
	the index of the first empty slot including and after that to which 
	the key hashes."

	"Implementation Note: By overriding this to convert the key to a string we
	can avoid the need to override all the key lookup methods such as #at:ifAbsent:,
	#includesKey:, etc ."

	^super findKeyOrNil: anObject asString!

isChanged
	"Answer true if the receiver or any of it's contents have been changed since
	their changed flag was last reset."

	^self propertyAt: #isChanged ifAbsent: [false]!

isChanged: aBoolean
	"Flag the receiver as changed or not changed, according to the value 
	of the <Boolean> argument. If the receiver is marked as changed, then
	its owning package (if any) is also so marked."

	"Note that we don't test the existing value of the change flag here, because
	 we want to inform the package regardless (in case it isn't currently changed
	 for some reason)"
	aBoolean 
		ifTrue: [ | package |
			self propertyAt: #isChanged put: true.
			(package := self owningPackage) notNil ifTrue: [
				package isChanged: true]]
		ifFalse: [self removePropertyAt: #isChanged ifAbsent: []]!

isValidKey: aString 
	| initial |
	initial := true.
	^aString notEmpty and: 
			[aString allSatisfy: 
					[:each | 
					initial 
						ifTrue: 
							[initial := false.
							each == $_ or: [each isLetter]]
						ifFalse: [each == $_ or: [each isAlphaNumeric]]]]!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

name
	"Answer the receiver's name."

	^name ifNil: [self environment keyAtValue: self ifAbsent: ['Anon']]!

name: aSymbol 
	name := aSymbol asSymbol!

newAssociation: keyObject value: valueObject 
	^(super newAssociation: keyObject value: valueObject)
		isImmutable: true;
		yourself!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned
	by any package"

	^Package manager packageOfGlobalNamed: self name!

owningPackage: aPackage
	"Set the receiver's <Package> to be the argument. Any current package association is lost."

	aPackage addGlobalNamed: self name!

preResize: newMe 
	"Private - This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	search policy."

	name isNil ifFalse: [newMe name: name]!

recompileReferencesToVarNamed: keyString
	"Private - Recompile any methods which references the named key, assumed to
	be a variable name from the receiver."

	Notification
		signal: ('Recompiling references to <1p> in <2s>' expandMacrosWith: keyString with: self name).
	(self environment allClasses select: [:c | c allSharedPools includes: self]) do: 
			[:c |
			c recompileReferencesToVarNamed: keyString.
			c class recompileReferencesToVarNamed: keyString.
			self]!

referencesTo: keyString 
	"Answer the collection of any methods which references the named key, assumed to
	be a variable name from the receiver."

	| refs |
	refs := OrderedCollection new.
	self classesReferencing do: 
			[:c | 
			c methodDictionary do: [:m | (m containsSource: keyString) ifTrue: [refs add: m]].
			c class methodDictionary do: [:m | (m containsSource: keyString) ifTrue: [refs add: m]]].
	^refs!

removeIndex: anInteger
	"Private - Remove the element at index, anInteger, in the receiver. Does not
	check that the element is empty."

	super removeIndex: anInteger.
	self isChanged: true! !
!PoolConstantsDictionary categoriesFor: #associationClass!constants!private! !
!PoolConstantsDictionary categoriesFor: #at:ifAbsentPut:!accessing!development!public! !
!PoolConstantsDictionary categoriesFor: #at:put:!adding!development!public! !
!PoolConstantsDictionary categoriesFor: #canFileOut!development!public!source filing! !
!PoolConstantsDictionary categoriesFor: #classesReferencing!development!private! !
!PoolConstantsDictionary categoriesFor: #displayOn:!displaying!public! !
!PoolConstantsDictionary categoriesFor: #environment!constants!public! !
!PoolConstantsDictionary categoriesFor: #errorModify:value:!development!exceptions!private! !
!PoolConstantsDictionary categoriesFor: #fileOut!development!public!source filing! !
!PoolConstantsDictionary categoriesFor: #fileOutName!development!public!source filing! !
!PoolConstantsDictionary categoriesFor: #fileOutOn:!development!public! !
!PoolConstantsDictionary categoriesFor: #findKeyOrNil:!private!searching! !
!PoolConstantsDictionary categoriesFor: #isChanged!development!public!source filing!testing! !
!PoolConstantsDictionary categoriesFor: #isChanged:!development!public!source filing! !
!PoolConstantsDictionary categoriesFor: #isValidKey:!adding!development!private! !
!PoolConstantsDictionary categoriesFor: #keyString:!adding!development!private! !
!PoolConstantsDictionary categoriesFor: #name!accessing!public! !
!PoolConstantsDictionary categoriesFor: #name:!accessing!private! !
!PoolConstantsDictionary categoriesFor: #newAssociation:value:!helpers!private! !
!PoolConstantsDictionary categoriesFor: #owningPackage!development!public!source filing! !
!PoolConstantsDictionary categoriesFor: #owningPackage:!accessing!development!public! !
!PoolConstantsDictionary categoriesFor: #preResize:!adding!private! !
!PoolConstantsDictionary categoriesFor: #recompileReferencesToVarNamed:!development!private! !
!PoolConstantsDictionary categoriesFor: #referencesTo:!development!private! !
!PoolConstantsDictionary categoriesFor: #removeIndex:!development!private!removing! !

PoolConstantsDictionary methodProtocol: #sourceObject attributes: #() selectors: #(#canFileOut #fileOut #fileOutName #isChanged #isChanged: #owningPackage)!

!PoolConstantsDictionary class methodsFor!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!PoolConstantsDictionary class categoriesFor: #named:!instance creation!public! !

