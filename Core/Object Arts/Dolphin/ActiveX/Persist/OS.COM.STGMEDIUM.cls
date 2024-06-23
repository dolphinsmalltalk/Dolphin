"Filed out from Dolphin Smalltalk"!

External.FinalizableStructure
	subclass: #'OS.COM.STGMEDIUM'
	instanceVariableNames: 'value'
	classVariableNames: 'GetSelectors'
	imports: #(#{OS.COM.PersistConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_handle' -> 16r4.
			'_OffsetOf_lpszFileName' -> 16r4.
			'_OffsetOf_pstg' -> 16r4.
			'_OffsetOf_pstm' -> 16r4.
			'_OffsetOf_pUnkForRelease' -> 16r8.
			'_OffsetOf_tymed' -> 16r0.
			'_STGMEDIUM_Size' -> 16rC
		}!

OS.COM.STGMEDIUM guid: (Core.GUID fromString: '{cc17569a-49c6-475d-a47c-86eaae187d18}')!

OS.COM.STGMEDIUM comment: 'Note: It might be preferable to apply the conditional elimination refactoring and employ different STGMEDIUM subclasses to represent the different types, but as we frequently don''t get to create the STGMEDIUM, we''d need some kind of downcast. I''m thinking about it though. At least we can use ReleaseStgMedium() to avoid the need for a switch on release.
'!

!OS.COM.STGMEDIUM categoriesForClass!No category! !

!OS.COM.STGMEDIUM methodsFor!

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
	"Answer the <ExternalHandle> value of the receiver's 'handle' field."

	^(bytes uintPtrAtOffset: _OffsetOf_handle) asExternalHandle!

handle: anExternalHandle
	"Set the receiver's 'handle' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_handle put: anExternalHandle!

lpszFileName
	"Answer the <Utf16String> value of the receiver's 'lpszFileName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpszFileName)!

lpszFileName: anUtf16String
	"Set the receiver's 'lpszFileName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszFileName put: anUtf16String yourAddress!

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
	value := path asUtf16String.
	^self lpszFileName: value!

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
	"Answer the <IStorage> value of the receiver's 'pstg' field."

	^IStorage fromAddress: (bytes intPtrAtOffset: _OffsetOf_pstg)!

pstg: anIStorage
	"Set the receiver's 'pstg' field to the value of the argument, anIStorage"

	bytes uintPtrAtOffset: _OffsetOf_pstg put: anIStorage yourAddress!

pstm
	"Answer the <IStream> value of the receiver's 'pstm' field."

	^IStream fromAddress: (bytes intPtrAtOffset: _OffsetOf_pstm)!

pstm: anIStream
	"Set the receiver's 'pstm' field to the value of the argument, anIStream"

	bytes uintPtrAtOffset: _OffsetOf_pstm put: anIStream yourAddress!

pUnkForRelease
	"Answer the <IUnknown> value of the receiver's 'pUnkForRelease' field."

	^IUnknown fromAddress: (bytes intPtrAtOffset: _OffsetOf_pUnkForRelease)!

pUnkForRelease: anIUnknown
	"Set the receiver's 'pUnkForRelease' field to the value of the argument, anIUnknown"

	bytes uintPtrAtOffset: _OffsetOf_pUnkForRelease put: anIUnknown yourAddress!

tymed
	"Answer the <Integer> value of the receiver's 'tymed' field."

	^bytes uint32AtOffset: _OffsetOf_tymed!

tymed: anInteger
	"Set the receiver's 'tymed' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_tymed put: anInteger!

value
	"Answer the 'value' currently contained in the receiver (which is a tag discriminated union)."

	^self perform: (GetSelectors at: self tymed)! !

!OS.COM.STGMEDIUM categoriesForMethods!
bitmap!accessing!public! !
bitmap:!accessing!public! !
enhancedMetafile!accessing!public! !
enhancedMetafile:!accessing!public! !
free!public!realizing/unrealizing! !
globalMemory!accessing!public! !
globalMemory:!accessing!public! !
handle!**compiled accessors**!public! !
handle:!**compiled accessors**!public! !
lpszFileName!**compiled accessors**!public! !
lpszFileName:!**compiled accessors**!public! !
metafile!accessing!public! !
metafile:!accessing!public! !
null!accessing!public! !
null:!accessing!public! !
path!accessing!public! !
path:!accessing!public! !
printOn:!printing!public! !
pstg!**compiled accessors**!public! !
pstg:!**compiled accessors**!public! !
pstm!**compiled accessors**!public! !
pstm:!**compiled accessors**!public! !
pUnkForRelease!**compiled accessors**!public! !
pUnkForRelease:!**compiled accessors**!public! !
tymed!**compiled accessors**!public! !
tymed:!**compiled accessors**!public! !
value!accessing!public! !
!

!OS.COM.STGMEDIUM class methodsFor!

clear: addressOrBytes
	"Free external resources referenced by STGMEDIUM
	structure at the specified address."

	Ole32 releaseStgMedium: addressOrBytes!

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
		defineField: #tymed type: UInt32Field new;
		defineField: #handle type: HANDLEField new;
		defineField: #pUnkForRelease type: (PointerField type: IUnknown).

	"Other union fields"
	self
		defineField: #lpszFileName
			type: (PointerField type: Utf16String)
			offset: 4;
		defineField: #pstm
			type: (PointerField type: IStream)
			offset: 4;
		defineField: #pstg
			type: (PointerField type: IStorage)
			offset: 4!

getFieldNames
	^#(#tymed #handle #lpszFileName #pstg #pstm #pUnkForRelease)!

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

	GetSelectors := LookupTable withAll: {TYMED_GDI -> #bitmap.
						TYMED_MFPICT -> #metafile.
						TYMED_ENHMF -> #enhancedMetafile.
						TYMED_HGLOBAL -> #globalHandle.
						TYMED_FILE -> #path.
						TYMED_ISTREAM -> #pstm.
						TYMED_ISTORAGE -> #pstg.
						TYMED_NULL -> #null}! !

!OS.COM.STGMEDIUM class categoriesForMethods!
clear:!public!realizing/unrealizing! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!initializing!private! !
initializeMessageMap!initializing!must not strip!private! !
!

