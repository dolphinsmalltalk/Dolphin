"Filed out from Dolphin Smalltalk X6"!

SourceFiler subclass: #AMLSourceFiler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AMLSourceFiler guid: (GUID fromString: '{58381B84-9B0B-4F4C-AC05-3E90B5838045}')!
AMLSourceFiler comment: ''!
!AMLSourceFiler categoriesForClass!Unclassified! !
!AMLSourceFiler methodsFor!

emitCategoriesOfClass: aClass 
	"Private - Emit a chunk to source stream to reclassify the <Class>, aClass, in all its existing 
	categories."

	self shouldNotImplement!

emitCategoriesOfMethod: aCompiledMethod 
	"Private - Append an entry to the source stream to reclassify the <CompiledMethod>, 
	aCompiledMethod, in all its current method categories."

	stream nextPutAll: '<Method categories for '; 
		print: aCompiledMethod; 
		nextPutAll: ' would go here if I knew how to emit them>'; cr
!

emitCategoriesOfMethods: methods 
	"Emit source that associates the <CompiledMethod>s in the <collection>, methods, with their
	current categories."

	"Do nothing - the categories are output with the rest of the method definition in AML"!

emitCommentOfClass: aClass 
	"Private - Emit a chunk which defines the comment for the <Class>, aClass, to source stream."

	| comment |
	comment := aClass comment.
	comment isEmpty ifTrue: [^self].
	stream 
		nextPut: $".
	(comment identityIncludes: $") 
		ifTrue: 
			[comment do: 
					[:character | 
					stream nextPut: character.
					"Double up embedded chunk markers"
					character == $" ifTrue: [stream nextPut: $"]]]
		ifFalse: [stream nextPutAll: comment].
	stream nextPut: $"!

emitFooterForMethodsOf: aClass 
	"Private - Ends the method definition chunks for aClass onto
	the source stream."

	"Nothing to do"!

emitGUIDOfClass: aClass 
	"Private - Emit a GUID definition chunk for the <Class>, aClass, to the source stream."

	self shouldNotImplement!

emitHeaderForMethodsOf: aClass 
	"Private - Emits a category header for the class, aClass, to the source stream."

	"Nothing to do"!

emitMethod: aCompiledMethod 
	"Private - File out the source of the single <CompiledMethod>, aCompiledMethod, to the source stream."

	| methodClass categories |
	methodClass := aCompiledMethod methodClass.
	methodClass isMeta ifTrue: [stream nextPutAll: 'class-'].
	stream nextPutAll: 'method class: ';
		print: methodClass instanceClass.
	categories := aCompiledMethod categories.
	stream crtab; nextPutAll: 'categories: '''.
	categories do: [:each | stream nextPutAll: each name] separatedBy: [stream nextPutAll: ', '].
	stream nextPut: $'.
	stream
		nextPutAll: ' ['; cr;
		nextPutAll: aCompiledMethod getSource.
	self endBlock!

emitSetBehaviorFlag: flagName forClass: aClass 
	"Private - Emit an attribute for the <Class>, aClass, to define its special behaviour flag named by
	the <Symbol>, flagName."

	stream nextPutAll: '<Class special behaviour flags emitted here>'; cr!

endBlock
	stream
		nextPutAll: '].';
		cr!

fileOutAttributesOfClass: aClass 
	"File-out any attributes of the aClass (e.g. the comment, GUID, etc) not included in the basic
	aClass definition, onto the source stream."

	"Entire definition emitted at once"
	self emitSpecialBehaviourAttributesOfClass: aClass.
	self emitCommentOfClass: aClass.!

fileOutBasicDefinitionOfClass: aClass 
	"Print a definition of the <Class>, aClass, to the source stream."

	| instVars classVars poolVars categories guid |
	stream
		nextPutAll: 'Class name: '.
	guid := aClass guid.
	guid notNull 
		ifTrue: 
			[stream
				nextPut: ${;
				print: aClass;
				nextPut: $:;
				nextPutAll: guid idlString;
				nextPut: $}]
		ifFalse: [stream print: aClass].
	aClass superclass notNil 
		ifTrue: 
			[stream
				crtab;
				nextPutAll: 'extends: ';
				print: aClass superclass].
	instVars := aClass instVarNames.
	instVars notEmpty 
		ifTrue: 
			[stream
				crtab;
				nextPutAll: 'inst-vars: '''.
			instVars do: [:each | stream nextPutAll: each]
				separatedBy: [stream nextPutAll: ', '].
			stream nextPut: $'].
	classVars := aClass classVarNames.
	classVars notEmpty 
		ifTrue: 
			[stream
				crtab;
				nextPutAll: 'class-vars: '''.
			classVars do: [:each | stream nextPutAll: each]
				separatedBy: [stream nextPutAll: ', '].
			stream nextPut: $'].
	poolVars := aClass sharedPoolNames.
	poolVars notEmpty 
		ifTrue: 
			[stream
				crtab;
				nextPutAll: 'pool-vars: '''.
			poolVars do: [:each | stream nextPutAll: each]
				separatedBy: [stream nextPutAll: ', '].
			stream nextPut: $'].
	categories := aClass categories.
	stream
		crtab;
		nextPutAll: 'categories: '''.
	categories do: [:each | stream nextPutAll: each name]
		separatedBy: [stream nextPutAll: ', '].
	stream nextPut: $'.

	stream nextPut: $.; cr!

fileOutProtocols: aCollection ofBehavior: aClassDescription 
	"File out the <MethodProtocol>s in the <collection>, aCollection, to the source stream,
	associating them with the <ClassDescription>, aClassDescription."

	stream
		nextPutAll: 'Class ref-name: ';
		print: aClassDescription ; crtab;
		nextPutAll: 'protocols: '''.

	aCollection do: [:each | stream nextPutAll: each] separatedBy: [stream nextPutAll: ', '].
	stream nextPut: $'.

	stream nextPut: $.; cr
! !
!AMLSourceFiler categoriesFor: #emitCategoriesOfClass:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitCategoriesOfMethod:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitCategoriesOfMethods:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitCommentOfClass:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitFooterForMethodsOf:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitGUIDOfClass:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitHeaderForMethodsOf:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitMethod:!private!source filing! !
!AMLSourceFiler categoriesFor: #emitSetBehaviorFlag:forClass:!private!source filing! !
!AMLSourceFiler categoriesFor: #endBlock!private!source filing! !
!AMLSourceFiler categoriesFor: #fileOutAttributesOfClass:!public!source filing! !
!AMLSourceFiler categoriesFor: #fileOutBasicDefinitionOfClass:!public!source filing! !
!AMLSourceFiler categoriesFor: #fileOutProtocols:ofBehavior:!public!source filing! !

