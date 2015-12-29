"Filed out from Dolphin Smalltalk X6.1"!

OLEFinalizableStructure subclass: #STGMEDIUM
	instanceVariableNames: 'value'
	classVariableNames: 'GetSelectors'
	poolDictionaries: 'OLEPersistConstants'
	classInstanceVariableNames: ''!
STGMEDIUM guid: (GUID fromString: '{CC17569A-49C6-475D-A47C-86EAAE187D18}')!
STGMEDIUM comment: 'Note: It might be preferable to apply the conditional elimination refactoring and employ different STGMEDIUM subclasses to represent the different types, but as we frequently don''t get to create the STGMEDIUM, we''d need some kind of downcast. I''m thinking about it though. At least we can use ReleaseStgMedium() to avoid the need for a switch on release.
'!
!STGMEDIUM categoriesForClass!No category! !
!STGMEDIUM methodsFor!

bitmap
	"Answer the bitmap handle stored in the receiver.
	Only send this if you are sure the receiver contains an HBITMAP
	(otherwise use #value)."

	self assert: [self tymed == TYMED_GDI].
	^(Smalltalk at: #Bitmap) fromHandle: self handle
	
!

bitmap: aBitmap
	"Set the data stored in the receiver to be an HBITMAP."

	self handle: aBitmap asParameter.
	self tymed: TYMED_GDI
!

enhancedMetafile
	"Answer the metafile picture handle stored in the receiver.
	Only send this if you are sure the receiver contains a handle
	(otherwise use #value)."

	self assert: [self tymed == TYMED_ENHMF].
	^self handle

	
!

enhancedMetafile: metafile
	"Set the data stored in the receiver to be an enhanced meta file."

	self handle: metafile asParameter.
	self tymed: TYMED_ENHMF
!

free
	"Free external resources referenced by the receiver. This is relevant
	only if those resources were obtained from an external party."

	(self isPointer and: [self handle notNull]) ifTrue: [
		self basicFree.
		self null: nil]!

globalMemory
	"Answer the global memory handle stored in the receiver.
	Only send this if you are sure the receiver contains an HGLOBAL
	(otherwise use #value).
	If pUnkForRelease is null, then the memory should be released
	with GlobalFree() when no longer required."

	self assert: [self tymed == TYMED_HGLOBAL].
	^self handle
	
!

globalMemory: mem
	"Set the data stored in the receiver to be an HGLOBAL.
	aHandle should be a global memory handle allocated with GMEM_SHARE.
	If pUnkForRelease is null, the destination will GlobalFree() it when
	no longer required."

	self handle: mem detach.
	self tymed: TYMED_HGLOBAL
!

handle
	"Answer the receiver's handle field as a Smalltalk object."

	^(bytes uintPtrAtOffset: 4) asExternalHandle!

handle: anObject 
	"Set the receiver's handle field to the value of anObject."

	bytes uintPtrAtOffset: 4 put: anObject!

lpszFileName
	"Answer the receiver's lpszFileName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 4)!

lpszFileName: anObject 
	"Set the receiver's lpszFileName field to the value of anObject."

	bytes uintPtrAtOffset: 4 put: anObject yourAddress!

metafile
	"Answer the metafile picture handle stored in the receiver.
	Only send this if you are sure the receiver contains a handle
	(otherwise use #value)."

	self assert: [self tymed == TYMED_MFPICT].
	^self handle

	
!

metafile: metafile
	"Set the data stored in the receiver to be a meta file."

	self handle: metafile asParameter.
	self tymed: TYMED_MFPICT
!

null
	"Answer the 'null' data stored in the receiver.
	Only send this if you are sure the receiver contains no data (i.e. the tymed field is
	TYMED_NULL) (otherwise use #value)."

	^nil	
!

null: ignored
	"Set the data stored in the receiver to be NULL."

	self tymed: TYMED_NULL
!

path
	"Answer a the path name stored in the receiver.
	Only send this if you are sure the receiver contains an file name
	(otherwise use #value)."

	self assert: [self tymed == TYMED_FILE].
	^self lpszFileName asString	
!

path: path
	"Set a the path into the receiver."

	self tymed: TYMED_FILE.
	value := path asUnicodeString.
	^self lpszFileName: value
!

printOn: aStream
	"Append a textual representation of the receiver to aStream.
	We use the template definition to do this in a generic way for all correctly 
	defined subclasses. Fields are printed in the order of their offset"

	| tymed |
	tymed := GetSelectors at: self tymed.
	aStream
		basicPrint: self;
		nextPut: $(;
		nextPutAll: tymed; nextPutAll: ': ';
		print: (self perform: tymed);
		nextPut: $)!

pstg
	"Answer the receiver's pstg field as a Smalltalk object."

	^IStorage fromAddress: (bytes intPtrAtOffset: 4)!

pstg: anObject 
	"Set the receiver's pstg field to the value of anObject."

	bytes uintPtrAtOffset: 4 put: anObject yourAddress!

pstm
	"Answer the receiver's pstm field as a Smalltalk object."

	^IStream fromAddress: (bytes intPtrAtOffset: 4)!

pstm: anObject 
	"Set the receiver's pstm field to the value of anObject."

	bytes uintPtrAtOffset: 4 put: anObject yourAddress!

pUnkForRelease
	"Answer the receiver's pUnkForRelease field as a Smalltalk object."

	^IUnknown fromAddress: (bytes intPtrAtOffset: 8)!

pUnkForRelease: anObject 
	"Set the receiver's pUnkForRelease field to the value of anObject."

	bytes uintPtrAtOffset: 8 put: anObject yourAddress!

tymed
	"Answer the receiver's tymed field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

tymed: anObject
	"Set the receiver's tymed field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

value
	"Answer the 'value' currently contained in the receiver (which
	is a tag discriminated union)."

	^self perform: (GetSelectors at: self tymed)! !
!STGMEDIUM categoriesFor: #bitmap!accessing!public! !
!STGMEDIUM categoriesFor: #bitmap:!accessing!public! !
!STGMEDIUM categoriesFor: #enhancedMetafile!accessing!public! !
!STGMEDIUM categoriesFor: #enhancedMetafile:!accessing!public! !
!STGMEDIUM categoriesFor: #free!public!realizing/unrealizing! !
!STGMEDIUM categoriesFor: #globalMemory!accessing!public! !
!STGMEDIUM categoriesFor: #globalMemory:!accessing!public! !
!STGMEDIUM categoriesFor: #handle!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #handle:!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #lpszFileName!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #lpszFileName:!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #metafile!accessing!public! !
!STGMEDIUM categoriesFor: #metafile:!accessing!public! !
!STGMEDIUM categoriesFor: #null!accessing!public! !
!STGMEDIUM categoriesFor: #null:!accessing!public! !
!STGMEDIUM categoriesFor: #path!accessing!public! !
!STGMEDIUM categoriesFor: #path:!accessing!public! !
!STGMEDIUM categoriesFor: #printOn:!printing!public! !
!STGMEDIUM categoriesFor: #pstg!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #pstg:!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #pstm!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #pstm:!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #pUnkForRelease!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #pUnkForRelease:!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #tymed!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #tymed:!**compiled accessors**!public! !
!STGMEDIUM categoriesFor: #value!accessing!public! !

!STGMEDIUM class methodsFor!

clear: addressOrBytes
	"Free external resources referenced by STGMEDIUM
	structure at the specified address."

	OLELibrary default releaseStgMedium: addressOrBytes!

defineFields
	"Define the fields of the OLE COM STGMEDIUM structure.
	N.B. Originally auto-generated from typelibrary, with union later inserted in-line.

		STGMEDIUM compileDefinition.

		typedef struct tagSTGMEDIUM  
		{ 
		    DWORD tymed; 
		    [switch_type(DWORD), switch_is((DWORD) tymed)] 
		    union { 
		        [case(TYMED_GDI)]      HBITMAP        hBitmap; 
		        [case(TYMED_MFPICT)]   HMETAFILEPICT  hMetafilePict; 
		        [case(TYMED_ENHMF)]    HENHMETAFILE   hEnhMetaFile; 
		        [case(TYMED_HGLOBAL)]  HGLOBAL        hGlobal; 
		        [case(TYMED_FILE)]     LPWSTR         lpszFileName; 
		        [case(TYMED_ISTREAM)]  IStream        *pstm; 
		        [case(TYMED_ISTORAGE)] IStorage       *pstg; 
		        [default] ; 
		    }; 
		    [unique] IUnknown *pUnkForRelease; 
		}STGMEDIUM; 
	"

	"Anonymous union at handle field"

	self
		defineField: #tymed type: DWORDField new;
		defineField: #handle type: HANDLEField new;
		defineField: #pUnkForRelease type: (PointerField type: IUnknown).

	"Other union fields"
	self
		defineField: #lpszFileName
			type: (PointerField type: UnicodeString)
			offset: 4;
		defineField: #pstm
			type: (PointerField type: IStream)
			offset: 4;
		defineField: #pstg
			type: (PointerField type: IStorage)
			offset: 4!

initialize
	"Private - Initialize the class variables of the receiver.

		STGMEDIUM initialize
	"

	self initializeMessageMap!

initializeMessageMap
	"Private - Initialize the table that maps media types to the corresponding accessor
	method selector.
	N.B. This method must not be stripped because otherwise there is a danger that the accessor methods
	will be stripped."

	GetSelectors := 
		LookupTable new
			at: TYMED_GDI 		put: #bitmap;
			at: TYMED_MFPICT	put: #metafile;
			at: TYMED_ENHMF	put: #enhancedMetafile;
			at: TYMED_HGLOBAL	put: #globalHandle;
			at: TYMED_FILE		put: #path;
			at: TYMED_ISTREAM	put: #pstm;
			at: TYMED_ISTORAGE	put: #pstg;
			at: TYMED_NULL		put: #null;
			shrink;
			yourself! !
!STGMEDIUM class categoriesFor: #clear:!public!realizing/unrealizing! !
!STGMEDIUM class categoriesFor: #defineFields!initializing!public! !
!STGMEDIUM class categoriesFor: #initialize!initializing!private! !
!STGMEDIUM class categoriesFor: #initializeMessageMap!initializing!must not strip!private! !

