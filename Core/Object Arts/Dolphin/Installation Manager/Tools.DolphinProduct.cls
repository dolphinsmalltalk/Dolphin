"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.DolphinProduct'
	instanceVariableNames: 'versionMask encryptedClasses'
	classVariableNames: 'Current EditionsMap'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DolphinProduct guid: (Core.GUID fromString: '{0bcc007b-10ed-40ce-940e-83882e2f70d8}')!
Tools.DolphinProduct isNonInstantiable: true!
Tools.DolphinProduct comment: ''!
!Tools.DolphinProduct categoriesForClass!System-Support! !
!Tools.DolphinProduct methodsFor!

allPackages
	"Answer an <OrderedCollection> of Packages associated with the receiver. This includes
	all of the prerequisite packages that are required by the named packages
	of the receiver"

	| set |
	set := IdentitySet new.
	self packages do: [:each | each addAllPrerequisitesTo: set].
	^set asOrderedCollection!

basicLoad
	"Private - Loads the required packages into the image for the receiver. 
	Does not remove any packages that should not be present"

	"Inform the development system of it's new product state"

	| packageManager |
	self installProductDetails.
	packageManager := Package manager.
	self packagePaths do: 
			[:each |
			| name |
			name := File splitStemFrom: each.
			packageManager packageNamed: name
				ifNone: 
					[[packageManager install: each] on: packageManager prerequisiteNotFoundSignal
						do: [:ex | ex resume: (File splitPathFrom: each)]]].
	Smalltalk developmentSystem beNotChanged!

beCurrent
	"Sets the singleton instance which represents the current product level of this image
	to the receiver"

	Current := self!

boot
	self loadShrinkAndCompress.
	self installSystemFolderOptions.
	self installSplash

!

calcSystemFolderExtentFor: aPoint
	"Answer a system folder extent that will yield the specified extent for the folder list view. Just a guess at this level."

	^aPoint + (20 @ 85)!

contents
	"Answer the list of package contents associated with the receiver. Each content item is a
	three element array containing the package path, a <Symbol> describing the encryption mode
	and a <Symbol> describing whether the package normally resides in the image or on disk after
	installation."

	| answer |
	answer := OrderedCollection new.
	"Some loaded by boot part 2 script"
	answer
		add: #('Core\Object Arts\Dolphin\Base\Dolphin.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Base (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Message Box.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Source Fileout.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\STON\Dolphin STON-Core.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Source Package Fileout.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Conformant Array Fields.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Legacy Date & Time.pax' #plain #imageBase);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Base (Deprecated).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Anonymous Classes.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Command-line Parser.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Compiler\Smalltalk Parser.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin SizeIs Fields.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Filer\Dolphin Literal Filer.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Registry\Dolphin Registry Access.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Base64\Dolphin Base64.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Compiler\Smalltalk Parser (Old Names).pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Compiler\Smalltalk Compiler.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Recent\Dolphin Recent Menu.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Deprecated\Dolphin Legacy Package Support.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Models\Value\Dolphin Value Models.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Type Converters\Dolphin Type Converters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\System\Random\Dolphin Random Stream.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin Basic Geometry.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Base\Dolphin MVP Base.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Dialogs.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Common\Dolphin Common Print Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Text\Dolphin Text Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\Base\Dolphin Additional Sort Algorithms.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\List\Dolphin List Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Models\List\Dolphin List Models.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Choice\Dolphin Choice Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Scrollbars\Dolphin Scrollbars.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Number\Dolphin Number Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Shell\Dolphin Document Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Shell\Dolphin Legacy Document Presenter.pax' #plain #imageBased);
		yourself.
	answer
		add: #('Core\Object Arts\Dolphin\MVP\Models\Tree\Dolphin Tree Models.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Tree\Dolphin Tree Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Boolean\Dolphin Boolean Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Common Controls\Dolphin Common Controls.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Control Bars\Dolphin Control Bars.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Styled Views\Dolphin Styled Views.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Collection\Dolphin Collection Presenters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Folder\Dolphin Folder Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Tree\Dolphin Tree List Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Accelerator\Dolphin Accelerator Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Font\Dolphin Font Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Image\Dolphin Image Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\MoenTree\Dolphin MoenTree View.pax' #plain #imageBased);
		yourself.
	"These views have to be loaded before the development system because they have #publishedAspects, etc, methods"
	answer
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Date Time\Dolphin Date Time Presenters.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Radio\Dolphin Radio Buttons.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Date Time\Dolphin Date Time Controls.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Slider\Dolphin Slider Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\SpinButton\Dolphin SpinButton Control.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Tooltips\Dolphin Tooltips.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Cards\Dolphin Card Containers.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Presenters\Color\Dolphin Color Presenter.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Scintilla\Dolphin Scintilla View.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Find\Dolphin Find Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\MVP\Views\Sliding Tray\Dolphin Slidey-Inney-Outey Thing.pax' #plain #imageBased);
		yourself.

	"Load up the Transcript"
	answer
		add: #('Core\Object Arts\Dolphin\MVP\Dialogs\Progress\Dolphin Progress Dialog.pax' #plain #imageBased);
		add: #('Core\Object Arts\Dolphin\IDE\Base\Dolphin Transcript.pax' #plain #imageBased);
		yourself.

	answer
		add: #('Core\Object Arts\Internal\Installation Manager\Dolphin Products.pax' #plain #imageBased);
		yourself.
	^answer!

defaultSystemFolderColor
	^self subclassResponsibility!

defaultSystemFolderExtent
	^self subclassResponsibility!

diskBasedPackages
	"Private - Answer the list of package names associated with the receiver that are intended to be disk based"

	| paths |
	paths := self contents reject: [:each | (each at: 3) == #imageBased].
	^paths collect: [:each | File splitStemFrom: (each at: 1)]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self fullName;
		space;
		display: self version!

encryptedClasses
	"Answer classes owned by the receiver that will be encrypted in the deployed executable."

	encryptedClasses isNil
		ifTrue: 
			[| packages classes |
			packages := self encryptedPackageNames collect: [:each | Package manager packageNamed: each].
			classes := Set new.
			packages do: [:each | classes addAll: each classes].
			classes := classes asArray select: [:each | self isSafeToEncrypt: each].
			self shouldEncryptMetaclasses
				ifTrue: [classes := classes , (classes collect: [:each | each class])].
			encryptedClasses := classes asSortedCollection: [:a :b | a name <==> b name <= 0]].
	^encryptedClasses!

encryptedClasses: aCollectionOfClasses
	"Private - Record which classes we should encrypt during deployment (this is called
	from #initialise with a list of classes derived from #encryptedPackageNames)."

	encryptedClasses := aCollectionOfClasses.!

encryptedPackageNames
	"Answer a <Set> of Package names associated with the receiver that must be encrypted
	when the receiver is installed"

	| encrypted |
	encrypted := self contents select: [:each | (each at: 2) == #encrypted].
	^encrypted collect: [:each | File splitStemFrom: (each at: 1)]!

foldLiterals
	Class foldLiteralStrings!

fullName
	"Answer the full product name associated with the receiver"

	^self subclassResponsibility!

imageLevel
	"Answer the <Integer> imageLevel for this product in this version of Dolphin"

	^(self versionMask << 8) | self class productMask!

installProductDetails
	"Private - Informs the development system of the details of the receiver"

	SessionManager current productDetails: self productDetails!

installProductSounds
	"Private - Installs the sounds scheme for the receiver"

	Sound clearRegistry!

installSplash
	"Use the default"!

installSystemFolderOptions
	#{SmalltalkSystemShell} ifDefined: [:systemFolder | self installSystemFolderOptions: systemFolder]!

installSystemFolderOptions: systemFolder
	systemFolder
		defaultExtent: (self calcSystemFolderExtentFor: self defaultSystemFolderExtent);
		backcolor: self defaultSystemFolderColor!

isSafeToEncrypt: aClass
	"Private -- Answer whether it is safe to encrypt the given class.
	Classes that must not be encrypted are this session manager's
	class, our serial number class, and our product protection class.
	This list is not intended to be exhaustive but just to catch the
	cases that occur easily if some attempts to product protect
	the package containing the protected session manager."

	^ (aClass respondsTo: #isSafeToEncryptWithProductProtection)
		ifTrue: [aClass isSafeToEncryptWithProductProtection]
		ifFalse: ["presumably its OK" ^ true].!

load
	"Loads the required packages into the image for the receiver. Does not remove any
	packages that should not be present"

	self basicLoad.
	SessionManager current saveImage!

loadAndShrink
	"Loads the required packages into the image for the receiver. Also shrinks the image
	to remove packages that should not be present but does not compress the sources or save the image."

	self
		basicLoad;
		removeUnlistedPackages!

loadShrinkAndCompress
	"Loads the required packages into the image for the receiver. Also shrinks the image
	to remove packages that should not be present. Finishes up with a compress sources."

	self
		basicLoad;
		shrink.
	SourceManager default compressSources!

majorVersion
	"Answer the receiver's major version <Integer>"

	^versionMask >> 4!

minorVersion
	"Answer the receiver's minor version <Integer>"

	^versionMask bitAnd: 16r0F!

name
	"Answer the product name associated with the receiver"

	^self class productName!

packageNames
	"Answer the list of package names associated with the receiver"

	^self packagePaths collect: [:each | File splitStemFrom: each]!

packagePaths
	"Answer the list of package path names associated with the receiver"

	^self contents collect: [:each | each at: 1 ]!

packages
	"Answer the list of package associated with the receiver"

	^self packageNames collect: [:each | Package manager packageNamed: each]!

preShrink
	"Private - Perform any pre-shrinkage actions"!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self name;
		nextPut: $,;
		print: self version;
		nextPut: $)!

productDetails
	"Answers the product details for the receiver"

	| array |
	array := VMLibrary default defaultProductDetails.
	8 < array size ifTrue: [array := array , (Array new: 8) copyFrom: 1 to: 8].
	^array
		at: 1 put: self fullName;
		at: 2 put: self name;
		at: 3 put: self version;
		at: 6 put: self shortProductName;
		at: 7 put: nil;
		at: 8 put: nil;
		yourself!

productLevel
	"Answer the <Integer> productLevel for the receiver"

	^self class productLevel!

removeUnlistedPackages
	"Private - Removes the non-required packages from the image for the receiver. "

	| unwanted |
	unwanted := Package manager packages difference: self packages.
	unwanted do: [:each | self uninstallPackage: each]!

resizeSymbolTable
	Symbol resizeTable	"Resize the symbol table to suit the size of the development product."!

shortProductName
	"Answer the abbreviated product name"
	
	^self class shortProductName!

shouldEncryptMetaclasses
	"Answer whether we should encrypt the class-side methods of our protected classes."

	^false!

shrink
	"Removes the non-required packages from the image for the receiver. "

	self preShrink.
	self warnOfUnlistedContent.
	self removeUnlistedPackages.
	self shrinkEventsRegister.
	self shrinkHashedCollections.
	self foldLiterals.
	"Resize the symbol table to suit the size of the development product."
	self resizeSymbolTable!

shrinkEventsRegister
	_EventsRegister keys do: [:each | each setEvents: each getEvents shrink]!

shrinkHashedCollections
	Set primAllSubinstances do: [:each | each shrink]!

uninstallPackage: each 
	^each uninstall!

unlistedContentException
	^Error!

unlistedPrerequisites
	| all listed |
	all := self allPackages.
	listed := self packages.
	^all difference: listed!

unwantedClasses
	"Answer a collection of the names of classes that are (or might) be in the distributed packages, but which we don't
	want included in the actual distributions."

	^#(#BootSessionManager #DolphinOAEdition)!

version
	"Answer the receiver's version <Float>"

	^(self majorVersion + (self minorVersion / 10)) asFloat!

versionMask
	"Private - Answer the receiver's version mask"

	^versionMask!

versionMask: anInteger
	"Private - Initialise the receiver from anInteger version mask"

	versionMask := anInteger!

warnOfUnlistedContent
! !
!Tools.DolphinProduct categoriesFor: #allPackages!accessing!public! !
!Tools.DolphinProduct categoriesFor: #basicLoad!operations!private! !
!Tools.DolphinProduct categoriesFor: #beCurrent!operations!public! !
!Tools.DolphinProduct categoriesFor: #boot!operations!private! !
!Tools.DolphinProduct categoriesFor: #calcSystemFolderExtentFor:!helpers!private! !
!Tools.DolphinProduct categoriesFor: #contents!accessing!public! !
!Tools.DolphinProduct categoriesFor: #defaultSystemFolderColor!constants!private! !
!Tools.DolphinProduct categoriesFor: #defaultSystemFolderExtent!constants!private! !
!Tools.DolphinProduct categoriesFor: #diskBasedPackages!accessing!private! !
!Tools.DolphinProduct categoriesFor: #displayOn:!printing!public! !
!Tools.DolphinProduct categoriesFor: #encryptedClasses!accessing!public! !
!Tools.DolphinProduct categoriesFor: #encryptedClasses:!accessing!private! !
!Tools.DolphinProduct categoriesFor: #encryptedPackageNames!accessing!public! !
!Tools.DolphinProduct categoriesFor: #foldLiterals!private! !
!Tools.DolphinProduct categoriesFor: #fullName!accessing!public! !
!Tools.DolphinProduct categoriesFor: #imageLevel!constants!public! !
!Tools.DolphinProduct categoriesFor: #installProductDetails!operations!private! !
!Tools.DolphinProduct categoriesFor: #installProductSounds!operations!private! !
!Tools.DolphinProduct categoriesFor: #installSplash!private! !
!Tools.DolphinProduct categoriesFor: #installSystemFolderOptions!operations!private! !
!Tools.DolphinProduct categoriesFor: #installSystemFolderOptions:!private! !
!Tools.DolphinProduct categoriesFor: #isSafeToEncrypt:!operations!public! !
!Tools.DolphinProduct categoriesFor: #load!operations!public! !
!Tools.DolphinProduct categoriesFor: #loadAndShrink!operations!public! !
!Tools.DolphinProduct categoriesFor: #loadShrinkAndCompress!operations!public! !
!Tools.DolphinProduct categoriesFor: #majorVersion!accessing!public! !
!Tools.DolphinProduct categoriesFor: #minorVersion!accessing!public! !
!Tools.DolphinProduct categoriesFor: #name!accessing!public! !
!Tools.DolphinProduct categoriesFor: #packageNames!accessing!public! !
!Tools.DolphinProduct categoriesFor: #packagePaths!accessing!public! !
!Tools.DolphinProduct categoriesFor: #packages!accessing!public! !
!Tools.DolphinProduct categoriesFor: #preShrink!private! !
!Tools.DolphinProduct categoriesFor: #printOn:!printing!public! !
!Tools.DolphinProduct categoriesFor: #productDetails!accessing!public! !
!Tools.DolphinProduct categoriesFor: #productLevel!constants!public! !
!Tools.DolphinProduct categoriesFor: #removeUnlistedPackages!operations!private! !
!Tools.DolphinProduct categoriesFor: #resizeSymbolTable!operations!public! !
!Tools.DolphinProduct categoriesFor: #shortProductName!accessing!public! !
!Tools.DolphinProduct categoriesFor: #shouldEncryptMetaclasses!constants!public!testing! !
!Tools.DolphinProduct categoriesFor: #shrink!operations!public! !
!Tools.DolphinProduct categoriesFor: #shrinkEventsRegister!operations!private! !
!Tools.DolphinProduct categoriesFor: #shrinkHashedCollections!operations!private! !
!Tools.DolphinProduct categoriesFor: #uninstallPackage:!operations!private! !
!Tools.DolphinProduct categoriesFor: #unlistedContentException!operations!public! !
!Tools.DolphinProduct categoriesFor: #unlistedPrerequisites!public! !
!Tools.DolphinProduct categoriesFor: #unwantedClasses!constants!public! !
!Tools.DolphinProduct categoriesFor: #version!accessing!public! !
!Tools.DolphinProduct categoriesFor: #versionMask!accessing!private! !
!Tools.DolphinProduct categoriesFor: #versionMask:!accessing!initializing!private! !
!Tools.DolphinProduct categoriesFor: #warnOfUnlistedContent!operations!private! !

!Tools.DolphinProduct class methodsFor!

boot
	"Loads an instance of the receiver"

	self new boot!

current
	"Answer the singleton instance which represents the current product level of this image"

	^Current!

errorInvalidProductDescription: aString
	^self error: 'Invalid product description: ', aString!

fromString: aString
	"Answer an instance of the subclass from the <readableString> description, aString"

	| stm version sub |
	(aString beginsWith: self productPrefix) ifFalse: [self errorInvalidProductDescription: aString].
	stm := aString readStream.
	stm position: self productPrefix size + 1.
	version := Float readFrom: stm.
	version = 0.0 ifTrue: [self errorInvalidProductDescription: aString].
	stm skipSeparators.
	sub := stm upToEnd.
	^(EditionsMap at: sub) version: version!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	EditionsMap := LookupTable new.
	DolphinBaseProduct allSubclasses do: [:p | EditionsMap at: p productName put: p].
	EditionsMap shrink!

loadAndShrink
	"Makes the image an instance of the receiver"

	self new loadAndShrink!

new
	"Answers an instance of the receiver for this version of Dolphin"

	^self version: SessionManager current productVersion!

ofImageLevel: imageLevel
	| versionMask productMask |
	productMask := imageLevel bitAnd: 255.
	versionMask := imageLevel >> 8.
	^(self allSubclasses detect: [:each | each productMask = productMask]) 
		versionMask: versionMask!

ofSerialNumber: serialNo
	"Private - Answers an instance of the receiver that pertains to <DolphinSerialNumber> serialNo."

	^self ofImageLevel: serialNo imageLevel!

packages: wildcard under: directory encrypted: aBoolean
	| base answer |
	answer := OrderedCollection new.
	base := SessionManager current imageBase.
	File
		forAll: wildcard
		in: (File composePath: base subPath: directory)
		do: 
			[:each |
			answer add: {File relativePathOf: each path to: base.
						aBoolean ifTrue: [#encrypted] ifFalse: [#plain].
						#imageBased}].
	^answer!

pacsUnder: directory encrypted: aBoolean 
	"Note that the order won't be right, but this doesn't really matter since the package loaders prerequisites
	mechanism will load things in the right order anyway."

	^self 
		packages: '*.pac'
		under: directory
		encrypted: aBoolean!

paxesUnder: directory encrypted: aBoolean 
	"Note that the order won't be right, but this doesn't really matter since the package loaders prerequisites
	mechanism will load things in the right order anyway."

	^self 
		packages: '*.pax'
		under: directory
		encrypted: aBoolean!

productLevel
	"Private - Answer the product ID for the receiver"

	self subclassResponsibility!

productMask
	"Private - Answer the <byte> mask product for the receiver"

	^self productLevel << 4!

productName
	"Answer the product name"
	
	^self subclassResponsibility!

productPrefix
	"Answer the prefix common to all product names."

	^'Dolphin Smalltalk'!

release
	"Release an instance of the receiver"

	self new release!

shortProductName
	"Answer the abbreviated product name"
	
	^self subclassResponsibility!

version: version
	"Answers an instance of the receiver  with <Float> version"

	| versionMask |
	versionMask := (version floor << 4) |  (version fractionPart * 10) asInteger.
	^self versionMask: versionMask
!

versionMask: versionMask 
	"Private - Answers an instance of the receiver with <Integer> versionMask"

	^(super new)
		versionMask: versionMask;
		yourself! !
!Tools.DolphinProduct class categoriesFor: #boot!operations!public! !
!Tools.DolphinProduct class categoriesFor: #current!accessing!public! !
!Tools.DolphinProduct class categoriesFor: #errorInvalidProductDescription:!exceptions!public! !
!Tools.DolphinProduct class categoriesFor: #fromString:!instance creation!public! !
!Tools.DolphinProduct class categoriesFor: #icon!constants!public! !
!Tools.DolphinProduct class categoriesFor: #initialize!initializing!private! !
!Tools.DolphinProduct class categoriesFor: #loadAndShrink!operations!public! !
!Tools.DolphinProduct class categoriesFor: #new!instance creation!public! !
!Tools.DolphinProduct class categoriesFor: #ofImageLevel:!instance creation!private! !
!Tools.DolphinProduct class categoriesFor: #ofSerialNumber:!instance creation!private! !
!Tools.DolphinProduct class categoriesFor: #packages:under:encrypted:!private! !
!Tools.DolphinProduct class categoriesFor: #pacsUnder:encrypted:!private! !
!Tools.DolphinProduct class categoriesFor: #paxesUnder:encrypted:!private! !
!Tools.DolphinProduct class categoriesFor: #productLevel!constants!private! !
!Tools.DolphinProduct class categoriesFor: #productMask!accessing!private! !
!Tools.DolphinProduct class categoriesFor: #productName!accessing!public! !
!Tools.DolphinProduct class categoriesFor: #productPrefix!instance creation!public! !
!Tools.DolphinProduct class categoriesFor: #release!operations!public! !
!Tools.DolphinProduct class categoriesFor: #shortProductName!accessing!public! !
!Tools.DolphinProduct class categoriesFor: #version:!instance creation!public! !
!Tools.DolphinProduct class categoriesFor: #versionMask:!instance creation!private! !

