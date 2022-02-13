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

buildInboundReferenceRewriter
	| newUnqualified rewriter |
	rewriter := ParseTreeRewriter new.
	"Any real references to the variable will need to be rewritten using a form that still binds to the same (renamed) variable."
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | self rewriteInboundVariable: variableNode]
		when: [:variableNode | variableNode isBindingChanged].
	"We rewrite any BindingReferences that bind to class before it is renamed, even if embedded in literal arrays. Symbols are not renamed."
	rewriter
		replace: '`#literal'
		withValueFrom: [:literalNode | self rewriteLiteral: literalNode]
		when: [:literalNode | self isImpactedLiteral: literalNode].
	newUnqualified := newClassReference unqualifiedName.
	rewriter replaceArgument: newUnqualified
		withValueFrom: 
			[:aNode |
			self refactoringError: '<1s> already exists within the reference scope' << newUnqualified].
	^rewriter!

buildOutboundReferenceRewriter
	| rewriter |
	rewriter := ParseTreeRewriter new.
	"Any real references to the variable will need to be rewritten using a form that still binds to the same (renamed) variable."
	rewriter
		replace: '`identifier'
		withValueFrom: [:variableNode | self rewriteOutboundVariable: variableNode]
		when: 
			[:variableNode |
			variableNode isStaticVariable and: 
					["A class' own variables should not ever need rewriting, unless the reference is qualified and must be changed, or could be shortened."
					variableNode isBindingChanged or: 
							[variableNode hasQualifiedName
								and: [(self shortestNameForVariable: variableNode) ~= variableNode name]]]].
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
	"If the new name is unqualified, preserve the original namespace of the class."

	self className: oldString.
	newClassReference := (BindingReference isQualifiedName: newString)
				ifTrue: [BindingReference pathString: newString]
				ifFalse: 
					[| parts |
					parts := className path shallowCopy.
					parts at: parts size put: newString.
					BindingReference path: parts].
	newName := newClassReference pathString.
	class := self model classNamed: oldString.
	oldUnqualified := class unqualifiedName.
	classBinding := class globalScope fullBindingFor: oldString environment: class environment!

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

renameInboundReferences: aCollectionOfRBMethods
	"Private - Rename references to the classes/namespaces with names being changed by the refactoring. When renaming a namespace, this will include any references to any of the classes nested directly or indirectly within the namespace. Any imports of any of the affected classes/namespaces will also be updated."

	"Note that renaming a class will no longer rename any Symbols that happen to be the name of the class, whether directly held literals or embedded in literal arrays. This was never strictly a refactoring as Symbols are not necessarily the names of program objects, so one cannot be certain that an arbitrary Symbol in a method that happens to be the same as a class name in scope in the method is actually intended for use as the name of that class. This is one good reason to use qualified references (aka BindingReferences) instead, since these are intended as references to classes so if they bind using the original class name before the refactoring, we can be certain that they should also be renamed. "

	| rewriter |
	rewriter := self buildInboundReferenceRewriter.
	self renameImports.
	aCollectionOfRBMethods do: [:method | self convertMethod: method using: rewriter]!

renameOutboundReferences: aCollectionOfRBMethods
	"Private - Rename any static variables/binding references in the methods of the classes/namespaces with names being changed by the refactoring, as necessary to maintain the same bindings as before the refactoring. Typically this will involve changing the qualification of a reference to a class; for example a reference may need to be made fully qualified because the rename is moving a class to a new namespace where the referenced class is not visible using just its unqualified name. It may also be possible to shorten references by removing qualification that is no longer required. A corner case that is also accounted for is where the rename causes ambiguity, for example by shadowing another static variable that was previously visible using an unqualified or partially qualified name, but which now requires more qualification."

	| rewriter |
	rewriter := self buildOutboundReferenceRewriter.
	aCollectionOfRBMethods do: [:method | self convertMethod: method using: rewriter]!

rewriteInboundVariable: aStVariableNode
	"Private - Rewrite a variable reference that refers to one of the renamed classes."

	^aStVariableNode copy
		name: ((aStVariableNode parent isAnnotation and: [aStVariableNode parent selector == #namespace:])
					ifTrue: 
						["If a namespace annotation, the full name should always be used"
						aStVariableNode binding fullName]
					ifFalse: [self shortestNameForVariable: aStVariableNode]);
		yourself!

rewriteLiteral: aStLiteralNode
	aStLiteralNode isLiteralArray ifTrue: [^self rewriteLiteralArray: aStLiteralNode].
	aStLiteralNode isQualifiedReference ifTrue: [^self rewriteQualifiedReference: aStLiteralNode].
	^aStLiteralNode copy!

rewriteLiteralArray: aStLiteralArrayNode
	^StLiteralArrayNode
		contents: (aStLiteralArrayNode contents collect: [:each | self rewriteLiteral: each])!

rewriteOutboundVariable: aStVariableNode
	"Private - Rewrite a variable reference in a method of one of the renamed classes."

	^aStVariableNode copy
		name: (self shortestNameForVariable: aStVariableNode);
		yourself!

rewriteQualifiedReference: aStQualifiedReferenceNode
	| binding pathString path i methodNode fullName |
	aStQualifiedReferenceNode isRelative
		ifFalse: 
			["Previous fully qualified reference, just answer the new fully-qualifed reference"
			^aStQualifiedReferenceNode copy
				pathString: aStQualifiedReferenceNode binding fullName;
				yourself].

	"A relative binding, but it may not actually need to be changed (we might only be here because this ref is inside a literal array with other refs that have changed)"
	aStQualifiedReferenceNode isBindingChanged ifFalse: [^aStQualifiedReferenceNode copy].
	"We have a changed relative binding reference, so need to find the shortest new relative path that will bind to the same variable"
	binding := aStQualifiedReferenceNode binding.
	methodNode := aStQualifiedReferenceNode methodNode.
	fullName := binding fullName.
	path := BindingReference.PathSeparator split: fullName.
	i := path size.
	pathString := ''.
	
	[pathString := (path at: i) , pathString.
	(methodNode fullBindingFor: pathString) == binding
		ifTrue: 
			[^aStQualifiedReferenceNode copy
				pathString: (i == path size ifTrue: [pathString] ifFalse: ['_.' , pathString]);
				yourself].
	i > 2]
			whileTrue: 
				[i := i - 1.
				pathString := BindingReference.PathSeparatorString , pathString].
	^aStQualifiedReferenceNode copy
		pathString: fullName;
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
	"self halt."
	symbolicRefs := model allReferencesTo: oldUnqualified.
	symbolicRefs isEmpty
		ifFalse: 
			[(self shouldIgnoreRemainingSymbolicReferences: symbolicRefs) ifFalse: [self refactoringAborted]]!

shortestNameForVariable: aStVariableNode
	"Private - Determine and answer the least qualified name for the specified variable reference that will still bind to the original variable with the current state of the refactoring model. This relies on the node in question having been passed through a semantic analyser before the model's state was updated for the rename, i.e. the AST needs to have been 'bound'."

	| pathString current originalBinding methodNode root |
	originalBinding := aStVariableNode binding.
	pathString := originalBinding unqualifiedName.
	current := originalBinding.
	root := model rootNamespace.
	methodNode := aStVariableNode methodNode.
	"Keep adding qualification until the name can be bound to the original binding"
	
	[(methodNode fullBindingFor: pathString) == originalBinding ifTrue: [^pathString].
	(current := current environment) == root]
			whileFalse: [pathString := current unqualifiedName , BindingReference.PathSeparatorString , pathString].
	"Nothing but the fully-qualified name will do"
	^originalBinding fullName!

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
			[:inbound :outbound |
			self renameInboundReferences: inbound.
			self renameOutboundReferences: outbound]! !
!Refactory.Browser.RenameClassRefactoring categoriesForMethods!
buildInboundReferenceRewriter!private!transforming! !
buildOutboundReferenceRewriter!private!transforming! !
checkForSymbolicReferences!private!transforming! !
className:newName:!initializing!private! !
displayOn:!displaying!public! !
isImpactedLiteral:!helpers!private! !
preconditions!accessing!public! !
renameImports!private!transforming! !
renameInboundReferences:!private!transforming! !
renameOutboundReferences:!private!transforming! !
rewriteInboundVariable:!private!transforming! !
rewriteLiteral:!private!transforming! !
rewriteLiteralArray:!private!transforming! !
rewriteOutboundVariable:!private!transforming! !
rewriteQualifiedReference:!private!transforming! !
rewriteSymbolicReferencesToClass!private!transforming! !
shortestNameForVariable:!helpers!private! !
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

