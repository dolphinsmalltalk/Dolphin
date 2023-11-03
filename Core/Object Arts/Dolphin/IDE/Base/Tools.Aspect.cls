"Filed out from Dolphin Smalltalk"!

Kernel.AttributeDescriptor
	subclass: #'Tools.Aspect'
	instanceVariableNames: 'name presenterBlock editBlock immediateActionBlock category getBlock putBlock type icon defaultValue'
	classVariableNames: 'DefaultPresenterBlock'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'EditInPlaceMask' -> 16r80000.
			'MultilineValueMask' -> 16r40000.
			'ReadOnlyPresenterBlockMask' -> 16r10000.
			'ValueWorkspaceEditorMask' -> 16r20000
		}!
Tools.Aspect guid: (Core.GUID fromString: '{87b4c4d7-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.Aspect comment: 'Part of the PublishedAspectorInspector framework.

<Aspect>s are used to describe the published aspects of various objects. An Aspect descriptor can be combined with a particular object to create an <AspectAccessor> that can be used to access the subject object with the value/value> protocol. The <AspectAccessor> uses the aspect name to construct accessor messages (e.g. #myAspect and #myAspect:) for getting and setting the value. An Aspect instance also holds a presenter block (a <dyadicValuable>) which, when evaluated, will create a presenter suitable for editing the aspect as its model.

All objects understand the #publishedAspects message, which is used to answer a <LookupTable> (keyed on aspect name) of all the Aspect descriptors that are published by the object. This additional meta-information is used by the development tools (in particular the <PublishedAspectInspector>) to easily allow user interface editing of various objects. Classes wishing allow such editing must publish aspects for their instances, and should do this by overriding the #publishedAspectsOfInstances method to add appropriate Aspects to this table.

Instance Variables:
	name		<Symbol> identifying the aspect.
	presenterBlock	<dyadicValuable> to be evaluated to bring up a presenter on the aspect
	editBlock		<monadicValue> to be evaluated to edit the aspect
	isMutable		<Boolean> specifying whether the aspect can be modified in-place'!
!Tools.Aspect categoriesForClass!Attribute-Definition! !
!Tools.Aspect methodsFor!

<= anAspect
	"Answer whether the receiver is 'less than' anAspect..
	By implementing this method, we enable Aspect objects to be stored
	in a SortedCollection with the default sort block."

	^(self species == anAspect species) 
		ifTrue: [self name <= anAspect name]
		ifFalse: [ self species <= anAspect species]!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self == comperand or: [self species == comperand species and: [self name == comperand name]]!

accessorClass
	^AspectAccessor!

accessorFor: anObject 
	"Answers an AspectAccessor value adaptor for the receiver on anObject"

	^self accessorClass subject: anObject aspect: self!

beEditedInPlace
	"Set that aspect editor should be displayed in-place."

	flags := flags bitOr: EditInPlaceMask!

beImmediateActionIsEdit
	"Some aspects can use their edit block to perform an immediate action. Set this here"

	immediateActionBlock := editBlock!

beMultilineValue
	"Set that receiver's value may require multiple lines of text to display/edit."

	flags := flags maskSet: MultilineValueMask!

bePresenterBlockReadOnly
	"Informs the receiver that the presenterBlock is only capable of reading aspect values and
	not setting them. This is used by the PropertyEditor in particular to swap out a
	presenterBlock for the default block when the provided block is read only."

	flags := flags bitOr: ##(ReadOnlyPresenterBlockMask | ValueWorkspaceEditorMask)!

canEdit
	"Answer true if the receiver can be edited; that is, it has an edit block
	defined for it"

	^self editBlock notNil!

canGenerateAccessors
	"Private - Answer true if instances of the receiver can generate code for attribute
	accessor methods. Aspects accessors cannot be generated"

	^false!

canImmediateAction
	"Answer true if the receiver can be actioned immediately; that is, it has an immediateAction block
	defined for it"

	^self immediateActionBlock notNil!

canReadFrom: anObject
	^self isReadable and: [getBlock notNil or: [anObject respondsTo: self getSelector]]!

canWriteInto: anObject
	^self isWriteable and: [putBlock notNil or: [anObject respondsTo: self putSelector]]!

category
	^category!

category: aSymbol 
	category := aSymbol!

defaultFlags
	^##(WriteableMask | ReadableMask | MutableMask | NullableMask)!

defaultValue
	"Answer the default value of the aspect, or nil if no default value is specified."

	^defaultValue!

defaultValue: aNiladicValuable
	"Set the default value of the aspect. If the default is nil, then the aspect is assumed to be nullable. If the default is not nil, then the aspect is assumed to be non-nullable."

	flags := flags mask: NullableMask set: (defaultValue := aNiladicValuable) isNil!

displayAspectInfoOf: anObject on: aStream 
	self displayAspectValueOf: anObject on: aStream!

displayAspectNameOf: anObject on: aStream 
	self name == #yourself ifTrue: [aStream nextPutAll: 'self' ] ifFalse: [aStream display: self]!

displayAspectText: anObject on: aStream 
	self name == #yourself 
		ifFalse: 
			[self displayAspectNameOf: anObject on: aStream.
			"Note that the #yourself aspect must be readable"
			self isBrowsable ifFalse: [^self].
			aStream nextPut: $=].
	self displayAspectValueOf: anObject on: aStream!

displayAspectValueOf: anObject on: aStream
	[(self readFrom: anObject) aspectDisplayOn: aStream] on: Error do: [:ex | ex displayOn: aStream]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream display: self name!

editablePresenterBlock
	"Answer the presenter block that can definitely be used to display AND edit the receiver's aspect"

	^self isPresenterBlockReadOnly 
		ifTrue: [DefaultPresenterBlock]
		ifFalse: [self presenterBlock]!

editablePresenterFor: aValueModel in: aCompositePresenter 
	"Answer a new <Presenter> to edit the aspect accessed by the <AspectAccessor> argument
	within the <CompositePresenter> argument. If the presenterBlock installed in the receiver is
	readonly then we use the defaultPresenterBlock instead."

	^self editablePresenterBlock value: aCompositePresenter value: aValueModel!

editBlock
	"Answer the <monadicValuable> that can be used to edit the receiver's aspect."

	^editBlock!

editBlock: anObject
	editBlock := anObject!

getBlock: aMonadicValuable
	getBlock := aMonadicValuable!

getSelector
	"Private - Answers the selector used for getting the aspect value from the subject if the getBlock is not set."

	^name
!

hasDefault
	"Answer whether the receiver has a default value (other than nil)."

	^defaultValue notNil!

hash
	"Answer the <Integer> hash value for the receiver."

	^self name hash!

icon
	"Answer an icon to be displayed alongside the aspect to give the user an indication of the type of object that it should contain (which may be more general than the type object Object currently assigned)."

	^icon ifNil: [type ifNotNil: [type icon]]!

icon: anIcon
	icon := anIcon!

immediateActionBlock
	"Private - Answer the <monadicValuable> that can be used to immediately action the receiver's aspect."

	^immediateActionBlock!

immediateActionBlock: anObject
	immediateActionBlock := anObject!

isEditedInPlace
	"Answer whether the aspect should be edited in-place if possible."

	^flags anyMask: EditInPlaceMask!

isEditedWithValueWorkspace
	"Answer true if we will use a ValueWorkspace presenter for editing the receiver"

	^flags anyMask: ValueWorkspaceEditorMask!

isMultilineValue
	"Answer whether the receiver's value may require multiple lines of text to display/edit."

	^flags anyMask: MultilineValueMask!

isPresenterBlockReadOnly
	"Answers true if the presenterBlock is only capable of reading aspect values and
	not setting them. This is used by the PropertyEditor in particular to swap out a
	presenterBlock for the default block when the priovided block is read only."

	^flags anyMask: ReadOnlyPresenterBlockMask!

key
	"Private - Answer the lookup key of the receiver when it is to appear as an
	association (Aspects can be stored directly in Dictionaries)"

	^self name!

name
	"Answer the aspect name <Symbol> of the receiver"

	^name!

name: aSymbol presenterBlock: aDyadicValuableOrNil editBlock: aMonadicValuable
	"Private - Initialize the receiver"

	flags := self defaultFlags.
	name := aSymbol.
	aDyadicValuableOrNil == DefaultPresenterBlock
		ifTrue: 
			["If no presenter block is specified, then the default ValueWorkspace presentation should be used."
			flags := flags bitOr: ValueWorkspaceEditorMask]
		ifFalse: [presenterBlock := aDyadicValuableOrNil].
	editBlock := aMonadicValuable!

nameIn: anObject
	"Private - Answer the 'name' of the aspect of the <Object> argument described by the receiver."

	^name!

objectRefName: anObject
	^self name!

presenterBlock
	"Answer the <dyadicValuable> capable of creating a presenter for the receiver's
	 aspect name"

	^presenterBlock ?? DefaultPresenterBlock!

presenterFor: aValueModel in: aCompositePresenter
	"Answer a new <Presenter> to display (and possibly edit) the aspect
	accessed by the <AspectAccessor> argument within the <CompositePresenter>
	argument."

	^self presenterBlock value: aCompositePresenter value: aValueModel!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self name; nextPut: $)!

putBlock: aDyadicValuable
	putBlock := aDyadicValuable!

putSelector
	^(self getSelector , ':') asSymbol!

readFrom: anObject
	^getBlock ifNil: [anObject perform: self getSelector] ifNotNil: [getBlock value: anObject]!

type
	"The class of object that is expected to be associated with this aspect. Can be nil for unspecified."

	^type!

type: aClass
	"The class of object that is expected to be associated with this aspect. Can be nil for anything."

	type := aClass!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	putBlock
		ifNil: [subjectObject perform: self putSelector with: valueObject]
		ifNotNil: [putBlock value: subjectObject value: valueObject]! !
!Tools.Aspect categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
accessorClass!constants!private! !
accessorFor:!accessing!public! !
beEditedInPlace!public! !
beImmediateActionIsEdit!accessing!public! !
beMultilineValue!public!testing! !
bePresenterBlockReadOnly!accessing!public! !
canEdit!public!testing! !
canGenerateAccessors!private!testing! !
canImmediateAction!public!testing! !
canReadFrom:!private!testing! !
canWriteInto:!private!testing! !
category!public! !
category:!public! !
defaultFlags!initializing!private! !
defaultValue!accessing!public! !
defaultValue:!accessing!public! !
displayAspectInfoOf:on:!displaying!private! !
displayAspectNameOf:on:!displaying!private! !
displayAspectText:on:!displaying!private! !
displayAspectValueOf:on:!displaying!private! !
displayOn:!displaying!public! !
editablePresenterBlock!enquiries!public! !
editablePresenterFor:in:!enquiries!public! !
editBlock!accessing!public! !
editBlock:!initializing!public! !
getBlock:!accessing!public! !
getSelector!accessing!private! !
hasDefault!public!testing! !
hash!comparing!public! !
icon!accessing!public! !
icon:!initializing!public! !
immediateActionBlock!accessing!private! !
immediateActionBlock:!initializing!private! !
isEditedInPlace!public!testing! !
isEditedWithValueWorkspace!public!testing! !
isMultilineValue!public!testing! !
isPresenterBlockReadOnly!accessing!public! !
key!accessing!private! !
name!accessing!public! !
name:presenterBlock:editBlock:!initializing!private! !
nameIn:!accessing!private! !
objectRefName:!helpers!private! !
presenterBlock!accessing!public! !
presenterFor:in:!enquiries!public! !
printOn:!printing!public! !
putBlock:!accessing!public! !
putSelector!accessing!public! !
readFrom:!indirect accessing!private! !
type!initializing!public! !
type:!initializing!public! !
writeInto:value:!indirect accessing!private! !
!

!Tools.Aspect class methodsFor!

autostring: aStringAspectSymbol
	"Answer an instance of the receiver for aStringAspectSymbol.
	The aspect is editable using a TextPresenter with a single line editor view
	that updates on each character"

	^(self name: aStringAspectSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			presenter := TextPresenter createIn: p on: m.
			presenter view
				updateMode: #perChar;
				selectAllIfSingleLine.
			presenter])
		type: String;
		beEditedInPlace;
		yourself!

bitmap: aBitmapAspectSymbol
	"Answer an instance of the receiver for aBitmapAspectSymbol.
	The aspect is viewable using an ImagePresenter with a 'Basic image' view
	and editable using a FileDialog"

	^self image: aBitmapAspectSymbol type: DIBSection!

block: anAspectSymbol
	"Answer an instance of the receiver for anAspectSymbol, which is the accessor
	for some kind of <valuable> (not necessarily a block).
	The aspect is editable using a <ValueWorkspace> presenter."

	^(self name: anAspectSymbol presenterBlock: DefaultPresenterBlock)
		type: BlockClosure;
		beMultilineValue;
		yourself!

boolean: aBooleanAspectSymbol
	"Answer an instance of the receiver for aBooleanAspectSymbol. The aspect is viewable using a
	<BooleanPresenter> and can be edited by toggling the aspect value. By default boolean aspects
	are not nullable, but see #nullableBoolean."

	| editBlock |
	editBlock := [:p | p value: p value not].
	^self basicNew
		name: aBooleanAspectSymbol
			presenterBlock: 
				[:p :m |
				BooleanPresenter
					create: 'CheckBox view'
					in: p
					on: m]
			editBlock: editBlock;
		flags: ##(WriteableMask | ReadableMask | MutableMask);
		immediateActionBlock: editBlock;
		type: Boolean;
		defaultValue: false;
		yourself!

choice: aChoiceAspectSymbol choiceBlock: aMonadicValuable
	"Answer an instance of the receiver for aChoiceAspectSymbol.
	The possible choices can be taken from from anArray"

	^(self name: aChoiceAspectSymbol
		presenterBlock: 
			[:p :m |
			(ChoicePresenter createIn: p on: m)
				choices: (aMonadicValuable value: m);
				yourself])
		beNonNullable;
		yourself!

choice: aChoiceAspectSymbol evaluationFrom: aNiladicValuable
	"Answer an instance of the receiver for aChoiceAspectSymbol.
	The possible choices can be taken from evaluations of the strings in anArrayOfEvaluableStrings"

	^(self name: aChoiceAspectSymbol
		presenterBlock: 
			[:p :m |
			| evaluatorModel |
			evaluatorModel := ValueConverter subject: m typeConverter: EvaluationConverter new inverted.
			(ChoicePresenter createIn: p on: evaluatorModel)
				choices: aNiladicValuable value;
				yourself])
		beNonNullable;
		yourself!

choice: aChoiceAspectSymbol from: choicesValuable
	"Answer an instance of the receiver for aChoiceAspectSymbol. The possible choices can be taken from the value of choicesValuable, normally a <sequenceableCollection>."

	^self
		choice: aChoiceAspectSymbol
		from: choicesValuable
		type: nil!

choice: aChoiceAspectSymbol from: choicesValuable andNil: nilChoice
	"Answer an instance of the receiver for aChoiceAspectSymbol.
	The possible choices can be taken from from anArray together with a choice
	which represents nil"

	^self name: aChoiceAspectSymbol
		presenterBlock: 
			[:p :m |
			| values count choices |
			values := choicesValuable value.
			count := values size + 1.
			choices := (Array new: count)
						at: 1 put: nilChoice;
						replaceFrom: 2
							to: count
							with: values
							startingAt: 1;
						yourself.
			(ChoicePresenter createIn: p on: m)
				nilChoice: nilChoice;
				choices: choices;
				yourself]!

choice: aChoiceAspectSymbol from: choicesValuable type: aClass
	"Answer an instance of the receiver for aChoiceAspectSymbol. The possible choices can be taken from from aSequenceableCollection and are expected to be (sub)instances of the class, aClass.
	The aspect is not nullable (i.e. cannot be assigned `nil`)"

	^(self
		name: aChoiceAspectSymbol
		presenterBlock: 
			[:p :m |
			(ChoicePresenter createIn: p on: m)
				choices: choicesValuable value;
				yourself]
		editBlock: nil)
		beNonNullable;
		type: aClass;
		yourself!

choice: aSymbol fromMap: mapValuable nullValue: anObject
	"Answer an instance of the receiver for an aspect named by the
	<Symbol> argument. The possible choices can be taken from 
	the <LookupTable> argument, whose keys are the display values, 
	for user presentation, and whose values are the actual value choices for 
	the aspect."

	^self name: aSymbol
		presenterBlock: 
			[:parent :model |
			| map |
			map := mapValuable value.
			(ChoicePresenter createIn: parent
				on: (ValueConverter subject: model
						typeConverter: ((MappingConverter rightToLeft: map)
								leftNullValue: anObject;
								yourself)))
				choices: map keys asSortedCollection;
				yourself]!

collection: aSymbol 
	"Answer an instance of the receiver for aCollectionAspectSymbol .
	The aspect is displayed using a CollectionPresenter"

	^self collection: aSymbol presenterClass: CollectionPresenter!

collection: aSymbol addEvaluationFrom: anArrayOfStrings
	"Answer an instance of the receiver for aCollectionAspectSymbol.
	The aspect is displayed using a CollectionPresenter and may have new items added
	by choosing an appropriate evaluation from anArrayOfStrings"

	^self 
		collection: aSymbol
		presenterClass: CollectionPresenter
		addEvaluationFrom: anArrayOfStrings!

collection: aCollectionAspectSymbol addFrom: anArray
	"Answer an instance of the receiver for aCollectionAspectSymbol.
	The aspect is displayed using a CollectionPresenter and may have new items added
	by choosing an appropriate object from anArray"

	^self 
		collection: aCollectionAspectSymbol
		presenterClass: CollectionPresenter
		addFrom: anArray!

collection: aSymbol presenterClass: aClass
	^(self
		name: aSymbol
		presenterBlock: 
			[:p :m |
			(aClass createIn: p on: m)
				setAddItemBlock: [Smalltalk developmentSystem promptForExpression: 'Evaluate:' caption: 'Add Item'];
				yourself]
		editBlock: self defaultCollectionEditBlock)
		type: Collection;
		yourself!

collection: aSymbol presenterClass: collectionPresenterClass addEvaluationFrom: evalChoicesValuable
	^self
		name: aSymbol
		presenterBlock: 
			[:p :m |
			| choices |
			choices := evalChoicesValuable value.
			(collectionPresenterClass createIn: p on: m) setAddItemBlock: 
					[| choice |
					choice := choices size > 1
								ifTrue: [ChoicePrompter choices: choices caption: 'Add an Evaluation']
								ifFalse: [choices first].
					choice notNil ifTrue: [Compiler evaluate: choice]]]
		editBlock: self defaultCollectionEditBlock!

collection: aCollectionAspectSymbol presenterClass: collectionPresenterClass addFrom: choicesValuable
	^self
		name: aCollectionAspectSymbol
		presenterBlock: 
			[:p :m |
			| choices |
			choices := choicesValuable value.
			(collectionPresenterClass createIn: p on: m) setAddItemBlock: 
					[choices size ~~ 1
						ifTrue: [ChoicePrompter choices: choices caption: 'Add…']
						ifFalse: [choices first]]]
		editBlock: self defaultCollectionEditBlock!

color: aColorAspectSymbol
	"Answer an instance of the receiver for aColorAspectSymbol. The aspect is viewable using a
	ColorPresenter and editable using a ColorDialog, or editable in-place with a single-line
	ValueWorkspace."

	^(self
		name: aColorAspectSymbol
		presenterBlock: [:p :m | ColorPresenter createIn: p on: m]
		editBlock: [:p | ColorDialog showModalOn: p model])
		type: Color;
		flags: ##(WriteableMask | ReadableMask | NullableMask | ReadOnlyPresenterBlockMask
					| ValueWorkspaceEditorMask | EditInPlaceMask);
		yourself!

date: aSymbol
	"Answer an instance of the receiver for accessing a <Date> aspect
	of an object with accessor, aSymbol.
	The aspect is viewable and editable using a DatePresenter."

	^(self name: aSymbol presenterBlock: [:p :m | DatePresenter createIn: p on: m])
		type: Date;
		yourself!

defaultCollectionEditBlock
	^nil!

defaultPresenterBlock
	"Private - Answers a valuable suitable for displaying an aspect in a
	<ValueWorkspace>."

	^[:p :m | ValueWorkspace createIn: p on: m]!

dictionary: aSymbol
	"Answer an instance of the receiver for the <Dictionary> aspect named by the <Symbol> 
	argument . The aspect is displayed using a DictionaryPresenter"

	^(self
		name: aSymbol
		presenterBlock: 
			[:p :m |
			(DictionaryPresenter createIn: p on: m)
				setAddItemBlock: 
						[Smalltalk developmentSystem promptForKeyValuePair: 'Enter key and value expressions:'
							caption: 'Add to Dictionary…'];
				yourself]
		editBlock: self defaultCollectionEditBlock)
		type: Dictionary;
		yourself!

duration: aSymbol
	"Answer an instance of the receiver for anAspectSymbol, which is expected to hold instances `Duration`."

	^self name: aSymbol type: Duration!

extent: aSymbol
	"Answer an instance of the receiver for editing a <Point> extent aspect of an 
	object. See #point:"

	^(self point: aSymbol)
		icon: External.SIZE icon;
		yourself!

fileOpen: aFilenameAspectSymbol 
	"Answer an instance of the receiver for aFilenameAspectSymbol.
	The aspect is viewable using a ValueWorkspace and editable using a FileSaveDialog"

	^self name: aFilenameAspectSymbol editBlock: [:p | FileOpenDialog showModalOn: p model]!

fileSave: aFilenameAspectSymbol 
	"Answer an instance of the receiver for aFilenameAspectSymbol.
	The aspect is viewable using a ValueWorkspace and editable using a FileSaveDialog"

	^self name: aFilenameAspectSymbol editBlock: [:p | FileSaveDialog showModalOn: p model]!

float: aSymbol
	"Answer an instance of the receiver for the <Float> aspect, aSymbol.
	The aspect is editable using a NumberPresenter."

	^(self number: aSymbol)
		type: Float;
		yourself!

folder: aFolderAspectSymbol
	"Answer an instance of the receiver for aFolderAspectSymbol.
	The aspect is viewable using a ValueWorkspace and editable using a BrowseFolderDialog"

	^self name: aFolderAspectSymbol
		editBlock: (#{BrowseFolderDialog} ifDefined: [:dialog | [:p | dialog showModalOn: p model]])!

font: aFontAspectSymbol
	"Answer an instance of the receiver for aFontAspectSymbol. The aspect is viewable using a
	FontPresenter and editable using a FontDialog, or in-place with a single line value
	workspace."

	^(self
		name: aFontAspectSymbol
		presenterBlock: [:p :m | FontPresenter createIn: p on: m]
		editBlock: [:p | FontDialog showModalOn: p model])
		flags: ##(WriteableMask | ReadableMask | MutableMask | NullableMask | EditInPlaceMask
					| ReadOnlyPresenterBlockMask | ValueWorkspaceEditorMask);
		type: Font;
		yourself!

hotkey: aHotKeyAspectSymbol
	"Answer an instance of the receiver for aHotKeyAspectSymbol.
	The aspect is editable using a HotKey control."

	^(self name: aHotKeyAspectSymbol presenterBlock: [:p :m | AcceleratorPresenter createIn: p on: m])
		type: HotKey;
		yourself!

icon: anIconAspectSymbol
	"Answer an instance of the receiver for anIconAspectSymbol.
	The aspect is viewable using an ImagePresenter with a 'Basic image' view
	and editable using a FileDialog, or edited in-place with a single line ValueWorkspace."

	^(self image: anIconAspectSymbol type: Icon)
		icon: Image icon;
		yourself!

image: aSymbol type: imageClass
	"Answer an instance of the receiver for aBitmapAspectSymbol.
	The aspect is viewable using an ImagePresenter with a 'Basic image' view
	and editable using a FileDialog"

	^(self
		name: aSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			presenter := ImagePresenter
						create: 'Basic image'
						in: p
						on: m.
			presenter view
				viewMode: #scaleBestFit;
				isWholeBackgroundErased: true.
			m value
				ifNotNil: 
					[:image |
					presenter view viewMode: (image isPersistent ifTrue: [#scaleToFit] ifFalse: [#scaleBestFit])].
			presenter]
		editBlock: [:p | imageClass choose ifNotNil: [:choice | p value: choice]])
		type: imageClass;
		bePresenterBlockReadOnly;
		yourself!

imageList: anImageListAspectSymbol
	^(self name: anImageListAspectSymbol
		presenterBlock: 
			[:p :m |
			ImagePresenter
				create: 'ImageList view'
				in: p
				on: m])
		type: ImageList;
		yourself!

initialize
	self addClassConstant: 'DefaultPresenterBlock' value: [:p :m | ValueWorkspace createIn: p on: m]!

inspector: anAspectSymbol
	"Answer an instance of the receiver for anAspectSymbol.
	The aspect is editable using an appropriate inspector"

	^self name: anAspectSymbol
		presenterBlock: 
			[:p :m | 
			(m inspectorClass createIn: p)
				object: m;
				yourself]!

integer: aSymbol
	"Answer an instance of the receiver for aSymbol.
	The aspect is editable using a NumberPresenter"

	^(self name: aSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			"Would be nice to use TextEdit in numeric mode, but it won't accept the minus sign, so no use for negative integers"
			presenter := NumberPresenter createIn: p.
			presenter view
				typeconverter: (IntegerToText new
							leftNullValue: 0;
							yourself);
				selectAllIfSingleLine.
			presenter model: m.
			presenter])
		beEditedInPlace;
		type: Integer;
		yourself!

key: aKey
	"Answers an instance of KeyedAspect on aKey"

	^KeyedAspect key: aKey!

list: aListAspectSymbol
	"Answer an instance of the receiver for aListAspectSymbol.
	The aspect is displayed using a CollectionPresenter"

	#deprecated. "Use #collection:"

	^self collection: aListAspectSymbol
!

list: aListAspectSymbol addEvaluationFrom: anArrayOfStrings
	#deprecated.
	^self sequenceableCollection: aListAspectSymbol addEvaluationFrom: anArrayOfStrings!

list: aListAspectSymbol addFrom: anArray
	#deprecated.
	^self sequenceableCollection: aListAspectSymbol addFrom: anArray!

maxDisplayCharacters
	^40!

menu: aMenuAspectSymbol
	"Answer an instance of the receiver for aMenuAspectSymbol.
	The aspect is editable using a MenuComposer"

	^(self
		name: aMenuAspectSymbol
		presenterBlock: nil
		editBlock: [:p | MenuComposer showModalOn: p model])
		type: Menu;
		yourself!

menuBar: aMenuAspectSymbol
	"Answer an instance of the receiver for aMenuAspectSymbol.
	The aspect is editable using a MenuComposer"

	^(self name: aMenuAspectSymbol editBlock: [:p | MenuBarComposer showModalOn: p model])
		type: MenuBar;
		yourself!

multilineString: aStringAspectSymbol
	"Answer an instance of the receiver for aStringAspectSymbol.
	The aspect is editable using a TextPresenter with a multiline editor view
	that updates on each character"

	^(self name: aStringAspectSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			presenter := TextPresenter
						create: 'Multiline text'
						in: p
						on: m.
			presenter view
				updateMode: #perChar;
				tabWidth: 4.
			presenter])
		type: String;
		yourself!

name: aSymbol
	"Answer an instance of the receiver for anAspectSymbol.
	The aspect is editable using the default ValueWorkspace presenter"

	^self
		name: aSymbol
		presenterBlock: DefaultPresenterBlock
		editBlock: nil!

name: aSymbol chooseFrom: anArrayOEvaluableStrings 
	"Answer an instance of the receiver for anAspectSymbol.
	The aspect is editable using a choice presenter fdialog filled with potential evaluations
	listed in anArrayOfStrings"

	"^self choice: aSymbol evaluationFrom: anArrayOEvaluableStrings."

	"Old code follows"

	^self name: aSymbol
		editBlock: 
			[:p | 
			| choice |
			choice := ChoicePrompter choices: anArrayOEvaluableStrings caption: 'Set ' , aSymbol , ' to:'.
			choice notNil ifTrue: [p value: (Compiler evaluate: choice)]]!

name: aSymbol editBlock: aOneArgEditBlock 
	"Answer an instance of the receiver for anAspectSymbol.
	The aspect is editable using the default ValueWorkspace presenter and may be additionally
	edited by evaluating aOneArgEditBlock whose parameter is the presenter viewing
	the aspect. Note that ValueWorkspace is a development class and this is therefore a
	development method."

	^self 
		name: aSymbol
		presenterBlock: DefaultPresenterBlock
		editBlock: aOneArgEditBlock!

name: aSymbol presenterBlock: aTwoArgPresenterBlock
	"Answer an instance of the receiver for anAspectSymbol.
	The aspect is editable using the presenter answered by aTwoArgOPresenterBlock
	the first parameter to which is the parent presenter to host the editor and the
	second is the model being edited."

	^self 
		name: aSymbol
		presenterBlock: aTwoArgPresenterBlock
		editBlock: nil!

name: aSymbol presenterBlock: aTwoArgPresenterBlock editBlock: aOneArgEditBlock
	"Answer an instance of the receiver for anAspectSymbol.
	The aspect will be made visible using the presenter answered by aTwoArgPresenterBlock
	the first parameter to which is the parent presenter to host it and the second is the model
	being edited. The aspect may be additionally edited by evaluating aOneArgEditBlock
	whose parameter is the presenter viewing the aspect."

	^self basicNew
		name: aSymbol
		presenterBlock: aTwoArgPresenterBlock
		editBlock: aOneArgEditBlock!

name: aSymbol type: aClass
	"Answer an instance of the receiver for anAspectSymbol, which is expected to hold (sub)instances of the class, aClass.
	The aspect is editable using the default ValueWorkspace presenter"

	^(self name: aSymbol presenterBlock: DefaultPresenterBlock )
		type: aClass;
		yourself!

new
	"Private - Use #name:presenterClass:"

	^self shouldNotImplement!

nullableBoolean: aBooleanAspectSymbol
	"Answer an instance of the receiver for aBooleanAspectSymbol. The aspect is viewable using a <BooleanPresenter> three-state view and can be edited by toggling the aspect value, cycling between nil, true and false values."

	| editBlock |
	editBlock := [:p | p value: (p value ifNil: [false] ifNotNil: [:value | value ifFalse: [true]])].
	^self basicNew
		name: aBooleanAspectSymbol
			presenterBlock: 
				[:p :m |
				BooleanPresenter
					create: 'Three state view'
					in: p
					on: m]
			editBlock: editBlock;
		flags: ##(WriteableMask | ReadableMask | MutableMask | NullableMask);
		immediateActionBlock: editBlock;
		type: Boolean;
		yourself!

number: aSymbol
	"Answer an instance of the receiver for the <Number> aspect, aSymbol.
	The aspect is editable using a NumberPresenter."

	^(self name: aSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			presenter := NumberPresenter createIn: p on: m.
			presenter view typeconverter leftNullValue: 0.
			presenter view selectAllIfSingleLine.
			presenter])
		type: Number;
		beEditedInPlace;
		yourself!

point: aSymbol
	"Answer an instance of the receiver for editing a <Point> aspect of an object. The aspect is
	editable and viewable using a single-line ValueWorkspace as we don't have any other more
	specialised editor at present. Point aspects are immutable, so if their x or y values are
	changed the whole Point is replaced."

	^(self name: aSymbol type: Point)
		flags: ##(WriteableMask | ReadableMask | NullableMask | EditInPlaceMask);
		yourself!

position: aSymbol
	"Answer an instance of the receiver for editing a <Point> position aspect of an 
	object. See #point:"

	^self point: aSymbol!

rectangle: aSymbol
	"Answer an instance of the receiver for editing a <Rectangle> aspect of an 
	object. The aspect is editable and viewable using a single-line ValueWorkspace as we
	don't have any other more specialised editor at present."

	^(self name: aSymbol)
		type: Rectangle;
		beImmutable;
		beEditedInPlace;
		yourself!

richText: aRichTextAspectSymbol
	"Answer an instance of the receiver for aTextAspectSymbol.
	The aspect is editable using a RichTextPresenter"

	^(self name: aRichTextAspectSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			presenter := RichTextPresenter createIn: p on: m.
			presenter view updateMode: #perChar.
			presenter])
		type: RichText;
		yourself!

sequenceableCollection: aSymbol
	"Answer an instance of the receiver for the <SequenceableCollection> aspect named
	by the <Symbol> argument."

	^(self collection: aSymbol presenterClass: SequenceableCollectionPresenter)
		type: SequenceableCollection;
		yourself!

sequenceableCollection: aSymbol addEvaluationFrom: anArray
	"Answer an instance of the receiver for an aspect named by the <Symbol>, aSymbol.
	The aspect is displayed using a SequenceableCollectionPresenter and may have new 
	items added by choosing an appropriate appropriate evaluation from the <Array>
	of <String>s, anArray."

	^(self
		collection: aSymbol
		presenterClass: SequenceableCollectionPresenter
		addEvaluationFrom: anArray)
		type: SequenceableCollection;
		yourself!

sequenceableCollection: aSymbol addFrom: choicesValuable
	"Answer an instance of the receiver for an aspect named by the <Symbol>, aSymbol.
	The aspect is displayed using a SequenceableCollectionPresenter and may have new 
	items added by choosing an appropriate object from the <Array>, anArray."

	^(self
		collection: aSymbol
		presenterClass: SequenceableCollectionPresenter
		addFrom: choicesValuable)
		type: SequenceableCollection;
		yourself!

set: aSymbol
	"Answer an instance of the receiver for the <Set> aspect named by the <Symbol> 
	argument . The aspect is displayed using a HashedCollectionPresenter"

	^(self collection: aSymbol presenterClass: HashedCollectionPresenter)
		type: Set;
		yourself!

string: aStringAspectSymbol
	"Answer an instance of the receiver for aStringAspectSymbol.
	The aspect is editable using a TextPresenter with a single editor view
	that updates on Enter or kill focus"

	^(self name: aStringAspectSymbol
		presenterBlock: 
			[:p :m |
			| presenter |
			presenter := TextPresenter createIn: p on: m.
			presenter view selectAllIfSingleLine.
			presenter])
		type: String;
		yourself!

symbol: aChoiceAspectSymbol from: anArray
	"Answer an instance of the receiver for aChoiceAspectSymbol.
	The possible choices can be taken from from anArray"

	^self
		choice: aChoiceAspectSymbol
		from: anArray
		type: Symbol!

time: aSymbol
	"Answer an instance of the receiver for accessing a <Time> aspect
	of an object with accessor, aSymbol.
	The aspect is viewable and editable using a TimePresenter."

	^(self name: aSymbol presenterBlock: [:p :m | TimePresenter createIn: p on: m])
		type: Time;
		yourself! !
!Tools.Aspect class categoriesForMethods!
autostring:!instance creation!public! !
bitmap:!instance creation!public! !
block:!instance creation!public! !
boolean:!instance creation!public! !
choice:choiceBlock:!instance creation!public! !
choice:evaluationFrom:!instance creation!public! !
choice:from:!instance creation!public! !
choice:from:andNil:!instance creation!public! !
choice:from:type:!instance creation!public! !
choice:fromMap:nullValue:!instance creation!public! !
collection:!instance creation!public! !
collection:addEvaluationFrom:!instance creation!public! !
collection:addFrom:!instance creation!public! !
collection:presenterClass:!instance creation!private! !
collection:presenterClass:addEvaluationFrom:!instance creation!private! !
collection:presenterClass:addFrom:!instance creation!private! !
color:!instance creation!public! !
date:!instance creation!public! !
defaultCollectionEditBlock!constants!private! !
defaultPresenterBlock!constants!private! !
dictionary:!instance creation!public! !
duration:!instance creation!public! !
extent:!instance creation!public! !
fileOpen:!instance creation!public! !
fileSave:!instance creation!public! !
float:!instance creation!public! !
folder:!instance creation!public! !
font:!instance creation!public! !
hotkey:!instance creation!public! !
icon:!instance creation!public! !
image:type:!instance creation!public! !
imageList:!instance creation!public! !
initialize!constants!private! !
inspector:!instance creation!public! !
integer:!instance creation!public! !
key:!instance creation!public! !
list:!instance creation!public! !
list:addEvaluationFrom:!instance creation!public! !
list:addFrom:!instance creation!public! !
maxDisplayCharacters!constants!public! !
menu:!instance creation!must strip!public! !
menuBar:!instance creation!must strip!public! !
multilineString:!instance creation!public! !
name:!instance creation!public! !
name:chooseFrom:!instance creation!public! !
name:editBlock:!instance creation!public! !
name:presenterBlock:!instance creation!public! !
name:presenterBlock:editBlock:!instance creation!public! !
name:type:!instance creation!public! !
new!instance creation!private! !
nullableBoolean:!instance creation!public! !
number:!instance creation!public! !
point:!instance creation!public! !
position:!instance creation!public! !
rectangle:!instance creation!public! !
richText:!instance creation!public! !
sequenceableCollection:!instance creation!public! !
sequenceableCollection:addEvaluationFrom:!instance creation!public! !
sequenceableCollection:addFrom:!instance creation!public! !
set:!instance creation!public! !
string:!instance creation!public! !
symbol:from:!instance creation!public! !
time:!instance creation!public! !
!

