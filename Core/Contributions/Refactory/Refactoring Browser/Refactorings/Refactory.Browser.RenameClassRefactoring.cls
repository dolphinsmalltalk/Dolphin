"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassRefactoring subclass: #'Refactory.Browser.RenameClassRefactoring'
	instanceVariableNames: 'newName class newClassReference oldUnqualified classBinding'
	classVariableNames: ''
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RenameClassRefactoring guid: (Core.GUID fromString: '{b0780f17-9017-4316-92eb-789b160450c5}')!
Refactory.Browser.RenameClassRefactoring comment: '`RenameClassRefactoring` is based on the original Refactory implementation, but is is Namespace aware.

Renaming classes with namespaces and qualified names is considerably more complicated than renames in traditional Smalltalk with a single global namespace, because binding resolution is much more than just a single dictionary lookup. There are multiple ways to refer to the same class using unqualified, partially-qualified and fully-qualified names. The same unqualified and partially-qualified names may bind to different variables in different contexts. Ambiguous references are possible for partially-qualified and unqualified names, so whether a particular identifier needs to be renamed depends on its binding context, i.e. whether it actually would have bound to the class being renamed prior to the rename. Given the need to consider binding context, setting up specific static searches in advance is not terribly useful, as we''ll still need to check the actual binding resolution for each candidate match to see if it really is a match. This means we need to perform a much broader match against variable references in methods that are referencing the renamed class, and then decide individually whether to rename them. We also need to consider the binding context when deciding how to rename them. Although we could always rename to a fully qualified name, this will make the code more verbose than it may need to be (a bit like using someone''s full name every time one refers to them). Therefore the refactoring attempts to use the least qualified variant of the new name that will still bind to the same (renamed) class. _Maybe minimising previously fully-qualified names should be an option, TBD_.

The original `RenameClassRefactoring` renamed references in code that were direct references to the class in question, but also symbolic references using the (unqualified) class name. The renaming of symbolic references has always been a bit questionable from a _refactorings must preserve behaviour_ perspective since it is possible that another `Symbol` used for another purpose just happens to be the name of a class being renamed. This was fairly unlikely, but the assumption that all `Symbol`s that look like class names and match a class name, must be class names, is not guaranteed to be true. We now have `BindingReference`s, so the former use of plain `Symbol`s for the purpose of late bound lookups has been superseded. We know that the name components of a `BindingReference`  must be the names of program objects (actually static variables) since this is the explicit purpose of `BindingReference`s. In Dolphin `Namespace`s are just classes, so all but the final component of a `BindingReference` path must be class names. The final component of the name is usually a class name, but may also refer to other static variables in the namespace referred to by the path up to that terminal component. As the non-terminal components of a qualified `BindingReference` must be classes, then these are candidates to rename if they would have bound to the class being renamed at some point along the path. 

The renaming of `Symbol`s is no longer performed. In order to assist migrating code into namespaces, which will typically involve renaming classes out of Smalltalk and into some other namespace, any symbolic lookups of the renamed class in the `Smalltalk` "dictionary" are first refactored into literal `BindingReferences`. Not all such lookups can be readily identified, so some symbolic references may remain. Where this is the case a refactoring option is used to warn the user and allow them to choose how to proceed.

Renaming a class in Dolphin can change any of the components (and any number of them) of the fully qualified name of a class. Unless it is only the leaf identifier (aka the short name, or unqualified name) that is changed, then the class is effectively moved to a different `Namespace`. When moving a class to a new `Namespace` it is entirely possible that unqualified and partially qualified names in the methods of the class itself will either no longer bind at all, or will bind to different static variables (where there is ambiguity and some part of the name is not globally unique). This means we must also rewrite the renamed class'' own methods, updating any variable references as required to maintain the previous binding. As with the references to the class being renamed, the references in the class being renamed should also have a minimal form after renaming.

Renaming a class in such a way as to change its `Namespace` can result in ambiguous references that cannot be resolved. This is regarded as a refactoring error that will fail the refactoring abandoning any changes.
'!
!Refactory.Browser.RenameClassRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.RenameClassRefactoring methodsFor!

buildVariableReferenceRewriter
	| rewriter |
	rewriter := ParseTreeRewriter new.
	"Any real references to the variable will need to be rewritten using a form that still binds to the same (renamed) variable."
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | self rewriteVariable: variableNode]
		when: 
			[:variableNode |
			"We rewrite any variable reference that needs change (or more qualification), or which is currently qualified but could be shortened."
			variableNode isBindingChanged or: 
					[variableNode hasQualifiedName
						and: [(self shortestNameForStaticVariable: variableNode) ~= variableNode name]]].
	"We rewrite any BindingReferences that bind to class before it is renamed, even if embedded in literal arrays. Symbols are not renamed."
	rewriter
		replace: '`#literal'
		withValueFrom: [:literalNode | self rewriteLiteral: literalNode]
		when: [:literalNode | self isImpactedLiteral: literalNode].
	^rewriter!

checkForSymbolicReferences
	| symbolicRefs |
	symbolicRefs := model allReferencesTo: oldUnqualified.
	symbolicRefs isEmpty ifFalse: [
		self shouldIgnoreRemainingSymbolicReferences: symbolicRefs]!

className: oldString newName: newString
	self className: oldString.
	newName := newString.
	class := self model classNamed: oldString.
	oldUnqualified := class unqualifiedName.
	classBinding := class globalScope fullBindingFor: oldString environment: class environment.
	newName := (BindingReference isQualifiedName: newString)
				ifTrue: [newString]
				ifFalse: 
					["The new name is unqualified, so the class should be moved to its base environment."
					class baseEnvironment fullNameFor: newString].
	newClassReference := BindingReference pathString: newName!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPutAll: 'Rename class ';
		display: className;
		nextPutAll: ' to ';
		nextPutAll: newName!

isImpactedLiteral: aStLiteralNode
	aStLiteralNode isLiteralArray
		ifTrue: 
			[^aStLiteralNode contents
				anySatisfy: [:each | each isLiteralNode and: [self isImpactedLiteral: each]]].
	aStLiteralNode isQualifiedReference
		ifTrue: 
			[| binding |
			binding := aStLiteralNode binding.
			^binding == classBinding or: 
					["Any qualified reference that now binds differently is impacted and needs rewriting. This "
					aStLiteralNode resolveBinding ~~ binding]].
	^false!

preconditions
	^(RBCondition withBlock: [class notNil and: [class isMeta not]]
		errorString: self className , ' is <1?:not >an existing class')
			& (RBCondition isValidClassName: newName) & (RBCondition hasNamespace: newName)
		& (RBCondition isStatic: newName in: self model) not
			& (RBCondition withBlock: [(ClassBuilder isFixedName: class) not]
					errorString: 'The <1s> namespace can%<1?:not> be renamed' << self className)!

renameImports
	"Private - Update any imports of the class. Imports should always be fully-qualified, non-meta references, but they can be private."

	| classPath |
	classPath := className path.
	self model allClassesDo: 
			[:eachClass |
			eachClass imports do: 
					[:each |
					| path |
					path := each path.
					(path beginsWith: classPath)
						ifTrue: 
							[| newImport |
							newImport := FullBindingReference
										pathString: nil
										path: newClassReference path , (path copyFrom: classPath size + 1 to: path size)
										private: each isPrivate.
							eachClass replaceImport: each with: newImport]]]!

rewriteLiteral: aStLiteralNode
	aStLiteralNode isLiteralArray ifTrue: [^self rewriteLiteralArray: aStLiteralNode].
	aStLiteralNode isQualifiedReference ifTrue: [^self rewriteQualifiedReference: aStLiteralNode].
	^aStLiteralNode copy!

rewriteLiteralArray: aStLiteralArrayNode
	^StLiteralArrayNode
		contents: (aStLiteralArrayNode contents collect: [:each | self rewriteLiteral: each])!

rewriteQualifiedReference: aQualifiedReferenceNode
	| binding pathString path i methodNode fullName |
	aQualifiedReferenceNode isRelative
		ifFalse: 
			["Previous fully qualified reference, just answer the new fully-qualifed reference"
			^aQualifiedReferenceNode copy
				pathString: aQualifiedReferenceNode binding fullName;
				clearPositions;
				yourself].

	"A relative binding, but it may not actually need to be changed (we might only be here because this ref is inside a literal array with other refs that have changed)"
	aQualifiedReferenceNode isBindingChanged ifFalse: [^aQualifiedReferenceNode copy].
	"We have a changed relative binding reference, so need to find the shortest new relative path that will bind to the same variable"
	binding := aQualifiedReferenceNode binding.
	methodNode := aQualifiedReferenceNode methodNode.
	fullName := binding fullName.
	path := BindingReference.PathSeparator split: fullName.
	i := path size.
	pathString := ''.
	
	[pathString := (path at: i) , pathString.
	(methodNode fullBindingFor: pathString) == binding
		ifTrue: 
			[^aQualifiedReferenceNode copy
				pathString: (i == path size ifTrue: [pathString] ifFalse: ['_.' , pathString]);
				clearPositions;
				yourself].
	i > 2]
			whileTrue: 
				[i := i - 1.
				pathString := BindingReference.PathSeparatorString , pathString].
	^aQualifiedReferenceNode copy
		pathString: fullName;
		isRelative: false;
		clearPositions;
		yourself!

rewriteSymbolicReferencesToClass
	"Private - If renaming a class that is currently in Smalltalk into another Namespace, we first rewrite any definite symbolic references to the class into literal binding references."

	| rewriteClassNames symbolicRefs |
	(classBinding environment == self model smalltalkNamespace
		and: [newClassReference environment ~~ classBinding environment])
			ifTrue: 
				[rewriteClassNames := Tools.ClassNameToBindingReferenceRefactoring model: model
							replaceSymbolicReferencesTo: class.
				self performComponentRefactoring: rewriteClassNames].
	symbolicRefs := model allReferencesTo: oldUnqualified.
	symbolicRefs isEmpty
		ifFalse: 
			[(self shouldIgnoreRemainingSymbolicReferences: symbolicRefs) ifFalse: [self refactoringAborted]]!

rewriteVariable: aVariableNode
	"Private - Rewrite a variable reference that refers to one of the renamed classes."

	^aVariableNode copy
		name: ((aVariableNode parent isAnnotation and: [aVariableNode parent selector == #namespace:])
					ifTrue: 
						["If a namespace annotation, the full name should always be used"
						aVariableNode binding fullName]
					ifFalse: [self shortestNameForStaticVariable: aVariableNode]);
		clearPositions;
		yourself!

shouldIgnoreRemainingSymbolicReferences: aCollection
	^(self lookupOption: #ignoreSymbolicClassReferences) cull: self cull: aCollection!

storeOn: aStream
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' rename: '.
	class storeOn: aStream.
	aStream
		nextPutAll: ' to: ';
		print: newName;
		nextPut: $)!

transform
	self rewriteSymbolicReferencesToClass.
	self model
		renameClass: class
		to: newName
		around: 
			[:methods |
			| rewriter |
			self renameImports.
			rewriter := self buildVariableReferenceRewriter.
			methods do: 
					[:method |
					method parseTree classScope clearVariableCache.
					self convertMethod: method using: rewriter]]! !
!Refactory.Browser.RenameClassRefactoring categoriesForMethods!
buildVariableReferenceRewriter!private!transforming! !
checkForSymbolicReferences!private!transforming! !
className:newName:!initializing!private! !
displayOn:!displaying!public! !
isImpactedLiteral:!helpers!private! !
preconditions!accessing!public! !
renameImports!private!transforming! !
rewriteLiteral:!private!transforming! !
rewriteLiteralArray:!private!transforming! !
rewriteQualifiedReference:!private!transforming! !
rewriteSymbolicReferencesToClass!private!transforming! !
rewriteVariable:!private!transforming! !
shouldIgnoreRemainingSymbolicReferences:!options!private! !
storeOn:!printing!public! !
transform!public!transforming! !
!

!Refactory.Browser.RenameClassRefactoring class methodsFor!

model: aRBModel rename: aClass to: aNewName
	^self new
		model: aRBModel;
		className: aClass fullName newName: aNewName;
		yourself!

rename: aClass to: aNewName
	^self new className: aClass fullName newName: aNewName! !
!Refactory.Browser.RenameClassRefactoring class categoriesForMethods!
model:rename:to:!instance creation!public! !
rename:to:!instance creation!public! !
!

