"Filed out from Dolphin Smalltalk 7"!

Dictionary variableSubclass: #PoolDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolDictionary guid: (GUID fromString: '{87b4c52a-026e-11d3-9fd7-00a0cc3e4a32}')!
PoolDictionary comment: ''!
!PoolDictionary categoriesForClass!Collections-Unordered!System-Support! !
!PoolDictionary methodsFor!

add: anAssociation
	"Add anAssociation to the receiver. Answer anAssociation.
	Although very similar to at:put:, we store the actual association passed
	as an argument here in order to maintain its references.
	The keys of associations stored in pool dictionaries must be strings."

	(anAssociation key isString and: [anAssociation key isSymbol not])
		ifFalse: [self error: 'Pools are keyed with Strings'].
	^super add: anAssociation!

associationClass
	"Private - Answer the class of association to be used for holding
	key-value pairs in the receiver. Must respond to the Association protocol."
	
	^VariableBinding!

at: key ifAbsent: exceptionHandler
	"Answer the value named by the argument, key.  If key is not found,
	answer the result of evaluating the niladic valuable, exceptionHandler.
	The keys of pools are Strings."

	^super at: key asString ifAbsent: exceptionHandler
!

at: key put: anObject
	"Store the argument anObject with the external key, aKey,
	in the receiver. Answer anObject. Ensure the key is a String."

	^super at: key asString put: anObject!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	self name displayOn: aStream
!

environment
	"Answer the receiver's controlling name space."

	^Smalltalk
!

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

includesKey: key
	"Answer whether the receiver has a key equal to the argument, key.
	Override superclass to permit symbolic/string keys."

	^super includesKey: key asString!

initializerFor: aString 
	"Answer a chunk reader to read and evaluate an initializer for the receiver's named variable"

	^ChunkReader 
		do: 
			[:chunkString | 
			(self bindingFor: aString) 
				ifNil: 
					[Warning signal: ('Ignoring initializer for undefined variable <1S>.<2S>: <3S>' 
								expandMacrosWith: self
								with: aString
								with: chunkString)]
				ifNotNil: 
					[:var | 
					| value |
					(Compiler compileExpression: chunkString in: UndefinedObject) 
						ifNotNil: 
							[:expr | 
							value := [expr method value] on: Error
										do: 
											[:ex | 
											ex resignalAsWarning.
											nil].
							var whileMutableDo: [var value: value]]]]
		inContext: self
		atEnd: []!

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

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver."

	^super lookup: keyObject asString!

name
	"Answer the receiver's name."

	^self environment keyAtValue: self ifAbsent: ['Anon']!

name: aSymbol 
	!

owningPackage
	"Answers the package that owns the receiver or nil if it is not yet owned
	by any package"

	^Package manager packageOfGlobalNamed: self name!

owningPackage: aPackage
	"Set the receiver's <Package> to be the argument. Any current package association is lost."

	aPackage addGlobalNamed: self name!

removeKey: key ifAbsent: exceptionHandler
	"Remove the key (and its associated value), from the receiver. If key is
	not in the receiver, answer the result of evaluating the niladic valuable,
	exceptionHandler. Otherwise, answer the value named by key.
	Override in order to accept Symbols/Strings."

	^super removeKey: key asString ifAbsent: exceptionHandler! !
!PoolDictionary categoriesFor: #add:!adding!development!public! !
!PoolDictionary categoriesFor: #associationClass!constants!private! !
!PoolDictionary categoriesFor: #at:ifAbsent:!accessing!public! !
!PoolDictionary categoriesFor: #at:put:!accessing!public! !
!PoolDictionary categoriesFor: #displayOn:!displaying!public! !
!PoolDictionary categoriesFor: #environment!constants!public! !
!PoolDictionary categoriesFor: #fileOutName!development!public!source filing! !
!PoolDictionary categoriesFor: #fileOutOn:!development!public! !
!PoolDictionary categoriesFor: #includesKey:!public!searching! !
!PoolDictionary categoriesFor: #initializerFor:!public!source filing-sif! !
!PoolDictionary categoriesFor: #isChanged!development!public!source filing!testing! !
!PoolDictionary categoriesFor: #isChanged:!development!public!source filing! !
!PoolDictionary categoriesFor: #lookup:!accessing!public! !
!PoolDictionary categoriesFor: #name!accessing!public! !
!PoolDictionary categoriesFor: #name:!accessing!private! !
!PoolDictionary categoriesFor: #owningPackage!development!public!source filing! !
!PoolDictionary categoriesFor: #owningPackage:!accessing!development!public! !
!PoolDictionary categoriesFor: #removeKey:ifAbsent:!public!removing! !

!PoolDictionary class methodsFor!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!PoolDictionary class categoriesFor: #named:!instance creation!public! !

