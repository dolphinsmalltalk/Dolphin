"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SourceFiler
	instanceVariableNames: 'stream evaluationContext isSourceOnly '
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SourceFiler guid: (GUID fromString: '{847F25F1-CD60-490C-817F-3F0F2CEFD567}')!
SourceFiler comment: ''!
!SourceFiler categoriesForClass!Development!System-Support! !
!SourceFiler methodsFor!

atEnd
	"Answer whether the receiver is at the end of its source stream."

	^stream atEnd!

close
	"Close the source stream"

	stream close!

cr
	"Emit a line-delimiter to the source stream"

	stream cr!

emitCategoriesOfClass: aClass 
	"Private - Emit a chunk to source stream to reclassify the <Class>, aClass, in all its existing 
	categories."

	^self subclassResponsibility!

emitCategoriesOfMethod: aCompiledMethod 
	"Private - Append an entry to the source stream to reclassify the <CompiledMethod>, 
	aCompiledMethod, in all its current method categories."

	^self subclassResponsibility!

emitCategoriesOfMethods: methods 
	"Emit source that associates the <CompiledMethod>s in the <collection>, methods, with their
	current categories."

	methods do: [:m | self emitCategoriesOfMethod: m]!

emitClassPoolOfClass: aClass
	"Private - Emit initialization expressions for each of the literal constants in the class pool of aClass."

	| literalConstants |
	literalConstants := aClass classPool associations
				select: [:each | each isImmutable and: [each value isLiteral]].
	literalConstants asSortedCollection
		do: [:each | self emitDeclarationForClass: aClass variable: each]!

emitComment: aString 
	"Private - Record aString to the source stream.
	N.B. Logging requests should be directed through the SessionManager."

	^self subclassResponsibility!

emitCommentOfClass: aClass 
	"Private - Emit a chunk which defines the comment for the <Class>, aClass, to source stream."

	^self subclassResponsibility!

emitDeclarationForClass: aClass variable: each
	^self subclassResponsibility!

emitFooterForMethodsOf: aClass 
	"Private - Ends the method definition chunks for aClass onto
	the source stream."

	^self subclassResponsibility!

emitGUIDOfClass: aClass 
	"Private - Emit a GUID definition chunk for the <Class>, aClass, to the source stream."

	^self subclassResponsibility!

emitHeaderForMethodsOf: aClass 
	"Private - Emits a category header for the class, aClass, to the source stream."

	^self subclassResponsibility!

emitMessages: aClass ofBehavior: selectors 
	| methods sortedSelectors |
	sortedSelectors := selectors 
				asSortedCollection: SortedCollection caseSensitiveSortBlock.
	methods := sortedSelectors asArray collect: 
					[:selector | 
					| method |
					self
						cr;
						cr.
					method := aClass compiledMethodAt: selector.
					self emitMethod: method.
					method].
	^methods!

emitMethod: aCompiledMethod 
	"Private - File out the source of the single <CompiledMethod>, aCompiledMethod, to the source stream."

	^self subclassResponsibility!

emitSetBehaviorFlag: flagName forClass: aClass 
	"Private - Emit an attribute for the <Class>, aClass, to define its special behaviour flag named by
	the <Symbol>, flagName."

	^self subclassResponsibility!

emitSpecialBehaviourAttributesOfClass: aClass 
	"Private - Emit attributes for the <Class>, aClass, to define its special behaviour flags."

	#(#isIndirection #isNullTerminated) do: 
			[:flagName | 
			(aClass perform: flagName) 
				ifTrue: [self emitSetBehaviorFlag: flagName forClass: aClass]]!

evaluationContext
	^evaluationContext!

evaluationContext: anObject
	evaluationContext := anObject!

fileIn
	"File in the expressions/definitions from receiver's source stream, which is
	expected to be in the receiver's format. Any methods that fail to compile are stubbed 
	with instances of <CompileFailedMethod> and errors are logged to the Transcript."

	^self subclassResponsibility!

fileOutAllMethodsOfBehavior: aClassDescription 
	"Emit definitions of all methods in the <ClassDescription> argument, aClassDescription,
	to the source stream."

	self fileOutMessages: aClassDescription selectors ofBehavior: aClassDescription.
	self isSourceOnly 
		ifFalse: [self fileOutProtocols: aClassDescription protocols ofBehavior: aClassDescription]!

fileOutAttributesOfClass: aClass
	"File-out any attributes of the aClass (e.g. the comment, GUID, etc) not included in the basic
	aClass definition, onto the source stream."

	self emitGUIDOfClass: aClass.
	self emitSpecialBehaviourAttributesOfClass: aClass.
	self emitClassPoolOfClass: aClass.
	self emitCommentOfClass: aClass.
	self emitCategoriesOfClass: aClass.
!

fileOutBasicDefinitionOfClass: aClass 
	"Print a definition of the <Class>, aClass, to the source stream."

	^self subclassResponsibility!

fileOutBinaryGlobal: anAssociation 
	"File out the text representation of the non-<sourceObject>
	which is the value of the <Association>, anAssociation, to the
	source stream. The key of the association is the global name."

	^self subclassResponsibility!

fileOutClass: aClass 
	"File out a full definition of the <ClassDescription>, aClass, to the source stream
	including all methods, categories and protocols. This includes all methods of the
	class, including any loose methods that may belong to packages other than the
	owning package of the class."

	self
		fileOutDefinitionOfClass: aClass;
		fileOutAllMethodsOfBehavior: aClass;
		fileOutAllMethodsOfBehavior: aClass class!

fileOutDefinitionOfClass: aClass 
	"File-out a definition of the <Class> to the source stream."

	self
		fileOutBasicDefinitionOfClass: aClass;
		fileOutAttributesOfClass: aClass!

fileOutExpression: aString
	"Append an immediate expression evaluation to the the source stream."

	^self subclassResponsibility!

fileOutMessages: selectors ofBehavior: aClass 
	"Append the definitions of the methods of the <ClassDescription>, aClassDescription,
	whose names match the selectors in the <collection> of <Symbol>, aCollection, to the source 
	stream. Any method category settings are included."

	| methods |
	selectors isEmpty ifTrue: [^self].
	self emitHeaderForMethodsOf: aClass.
	methods := self emitMessages: aClass ofBehavior: selectors.
	self emitFooterForMethodsOf: aClass.
	self isSourceOnly ifFalse: [self emitCategoriesOfMethods: methods].
	self cr!

fileOutMethods: aCollection 
	"Append the definitions of the methods in the <collection> argument to the source stream,
	ordered by class. Any method category settings are included."

	| methodsByClass |
	methodsByClass := Dictionary new.
	aCollection do: 
			[:each | 
			"Note that the selectors will be filed out in sorted order, so we don't need to sort them"
			(methodsByClass at: each methodClass ifAbsentPut: [OrderedCollection new]) add: each selector].
	(methodsByClass associations 
		asSortedCollection: [:a :b | (a key name trueCompare: b key name) <= 0]) 
			do: [:each | self fileOutMessages: each value ofBehavior: each key]!

fileOutPoolDictionary: aPoolDictionary 
	"Append a definition of the <PoolDictionary> (or <PoolConstantsDictionary>, aPoolDictionary,
	to the source stream. The definition should be sufficient to recreate a copy  of the dictionary."

	^self subclassResponsibility!

fileOutProtocols: aCollection ofBehavior: aClassDescription 
	"File out the <MethodProtocol>s in the <collection>, aCollection, to the source stream,
	associating them with the <ClassDescription>, aClassDescription."

	^self subclassResponsibility!

fileOutResource: aResourceIdentifier 
	"Append a definition of the resource identified by the <ResourceIdentifier>, aResourceIdentifer,
	to the source stream. The definition should be sufficient to recreate a copy  of the resource."

	^self subclassResponsibility!

flush
	"Flush the source stream."

	stream flush!

getSourceFromDescriptor: sourceDescriptor
	"Answer the <readableString> source corresponding to the specified <integer> 
	descriptor, sourceDescriptor, from the receiver's source stream."

	^self subclassResponsibility!

isSourceOnly
	^isSourceOnly!

isSourceOnly: aBoolean 
	isSourceOnly := aBoolean!

setStream: aPuttableStream 
	stream := aPuttableStream.
	self isSourceOnly: false!

setToEnd
	"Seek to the end of the source stream."

	stream setToEnd!

sourcePositionFromDescriptor: sourceObject
	"Private - Answer the offset from the start of the source file at which the chunk containing
	the source code whose location is described by, sourceDescriptor, can be found.
	If sourceObject is not an Integer, then an error will result."

	^sourceObject bitShift: -4!

storeCommentString: aString forClass: aClass
	"Save the <readableString>, aString, as the comment text for the 
	<Class>, aClass, to the receiver's source stream encoding the position and 
	index into the class' source descriptor so that the comment may be retrieved later."

	^self subclassResponsibility!

storeCommentString: aString forPackage: aPackage
	"Save the <readableString>, aString, as the comment text for the <Package>, aPackage, to the
	receiver's source stream encoding the position and index into the package's source
	descriptor so that the comment may be retrieved later."

	^self subclassResponsibility!

storeSource: aString for: aSourceObject
	"Private - Store the <readableString>, aString, as the source text for the <sourceObject>,
	aSourceObject, updating its source descriptor."

	^self subclassResponsibility!

storeSourceString: aString forMethod: aCompiledMethod 
	"Save the <readableString>, aString, as the source text for the 
	<CompiledMethod>, aCompiledMethod, to the receiver's source stream
	encoding the position and index into the methods source descriptor so that 
	the source may be retrieved later."

	^self subclassResponsibility!

stream
	"Private - Answer the value of the receiver's ''stream'' instance variable."

	^stream! !
!SourceFiler categoriesFor: #atEnd!public!testing! !
!SourceFiler categoriesFor: #close!operations!public! !
!SourceFiler categoriesFor: #cr!accessing!public! !
!SourceFiler categoriesFor: #emitCategoriesOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitCategoriesOfMethod:!private!source filing! !
!SourceFiler categoriesFor: #emitCategoriesOfMethods:!private!source filing! !
!SourceFiler categoriesFor: #emitClassPoolOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitComment:!operations-logging!private! !
!SourceFiler categoriesFor: #emitCommentOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitDeclarationForClass:variable:!private!source filing! !
!SourceFiler categoriesFor: #emitFooterForMethodsOf:!private!source filing! !
!SourceFiler categoriesFor: #emitGUIDOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitHeaderForMethodsOf:!private!source filing! !
!SourceFiler categoriesFor: #emitMessages:ofBehavior:!private!source filing! !
!SourceFiler categoriesFor: #emitMethod:!private!source filing! !
!SourceFiler categoriesFor: #emitSetBehaviorFlag:forClass:!private!source filing! !
!SourceFiler categoriesFor: #emitSpecialBehaviourAttributesOfClass:!private!source filing! !
!SourceFiler categoriesFor: #evaluationContext!accessing!public! !
!SourceFiler categoriesFor: #evaluationContext:!accessing!public! !
!SourceFiler categoriesFor: #fileIn!public!source filing! !
!SourceFiler categoriesFor: #fileOutAllMethodsOfBehavior:!public!source filing! !
!SourceFiler categoriesFor: #fileOutAttributesOfClass:!public!source filing! !
!SourceFiler categoriesFor: #fileOutBasicDefinitionOfClass:!public!source filing! !
!SourceFiler categoriesFor: #fileOutBinaryGlobal:!public!source filing! !
!SourceFiler categoriesFor: #fileOutClass:!public!source filing! !
!SourceFiler categoriesFor: #fileOutDefinitionOfClass:!public!source filing! !
!SourceFiler categoriesFor: #fileOutExpression:!public!source filing! !
!SourceFiler categoriesFor: #fileOutMessages:ofBehavior:!public!source filing! !
!SourceFiler categoriesFor: #fileOutMethods:!public!source filing! !
!SourceFiler categoriesFor: #fileOutPoolDictionary:!public!source filing! !
!SourceFiler categoriesFor: #fileOutProtocols:ofBehavior:!public!source filing! !
!SourceFiler categoriesFor: #fileOutResource:!public!source filing! !
!SourceFiler categoriesFor: #flush!operations!public! !
!SourceFiler categoriesFor: #getSourceFromDescriptor:!public!source filing! !
!SourceFiler categoriesFor: #isSourceOnly!accessing!public! !
!SourceFiler categoriesFor: #isSourceOnly:!accessing!public! !
!SourceFiler categoriesFor: #setStream:!initializing!private! !
!SourceFiler categoriesFor: #setToEnd!positioning!public! !
!SourceFiler categoriesFor: #sourcePositionFromDescriptor:!private!source filing! !
!SourceFiler categoriesFor: #storeCommentString:forClass:!public!source filing! !
!SourceFiler categoriesFor: #storeCommentString:forPackage:!public!source filing! !
!SourceFiler categoriesFor: #storeSource:for:!private!source filing! !
!SourceFiler categoriesFor: #storeSourceString:forMethod:!public!source filing! !
!SourceFiler categoriesFor: #stream!accessing!private! !

SourceFiler methodProtocol: #sourceFiler attributes: #(#readOnly) selectors: #(#atEnd #close #cr #fileIn #fileOutAllMethodsOfBehavior: #fileOutAttributesOfClass: #fileOutBasicDefinitionOfClass: #fileOutBinaryGlobal: #fileOutClass: #fileOutDefinitionOfClass: #fileOutExpression: #fileOutMessages:ofBehavior: #fileOutPoolDictionary: #fileOutProtocols:ofBehavior: #fileOutResource: #flush #getSourceFromDescriptor: #setToEnd #storeCommentString:forClass: #storeCommentString:forPackage: #storeSourceString:forMethod:)!

!SourceFiler class methodsFor!

on: aWriteStream 
	"Answer a new instance of the receiver for filing out source code onto the 
	<puttableStream> argument."

	^(self new)
		setStream: aWriteStream;
		yourself! !
!SourceFiler class categoriesFor: #on:!instance creation!public! !

